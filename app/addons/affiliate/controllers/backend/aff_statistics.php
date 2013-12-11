<?php
/***************************************************************************
*                                                                          *
*   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
*                                                                          *
* This  is  commercial  software,  only  users  who have purchased a valid *
* license  and  accept  to the terms of the  License Agreement can install *
* and use this program.                                                    *
*                                                                          *
****************************************************************************
* PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
* "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
****************************************************************************/

use Tygh\Registry;
use Tygh\Navigation\LastView;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $suffix = '';

    if ($mode == 'm_approve') {
        if (!empty($_REQUEST['action_ids'])) {
            fn_approve_commissions($_REQUEST['action_ids']);
        }

        $suffix = ".approve";
    }

    if ($mode == 'm_disapprove') {
        if (!empty($_REQUEST['action_ids'])) {
            fn_approve_commissions($_REQUEST['action_ids'], 'N');
        }

        $suffix = ".approve";
    }

    if ($mode == 'm_delete') {
        if (!empty($_REQUEST['action_ids'])) {
            fn_delete_affiliate_actions($_REQUEST['action_ids']);
        }

        $suffix = ".approve";
    }

    return array(CONTROLLER_STATUS_OK, "aff_statistics$suffix");
}

if ($mode == 'view') {

    list($action_data, $search) = fn_get_affiliate_actions($_REQUEST);
    if (!empty($action_data)) {
        $action_data = reset($action_data);
        if (!empty($action_data['parent_action_id'])) {
            list($p_action) = fn_get_affiliate_actions(array('action_id' => $action_data['parent_action_id']));
            if (!empty($p_action)) {
                $p_action = reset($p_action);
                if (!empty($p_action)) {
                    $action_data = $p_action;
                }
            }
        }

        if (!empty($action_data)) {

            list($action_data['related_actions']) = fn_get_affiliate_actions(array('object_type' => 'A', 'object_data' => $action_data['action_id']));
            $total_commission = $action_data['amount'];
            if (!empty($action_data['related_actions'])) {
                foreach ($action_data['related_actions'] as $ra) {
                    $total_commission += $ra['amount'];
                }
            }

            $action_data['extended_data'] = array();
            if (!empty($action_data['customer_id'])) {
                $action_data['extended_data']['customer'] = fn_get_user_info($action_data['customer_id']);
            }

            $keys_extended_data = array_keys($action_data['data']);
            if (in_array('O', $keys_extended_data)) {
                $action_data['extended_data']['order'] = fn_get_order_info($action_data['data']['O']);
            }

            if (in_array('P', $keys_extended_data)) {
                $action_data['extended_data']['product'] = fn_get_product_data($action_data['data']['P'], $auth);
                if (!empty($action_data['extended_data']['order']['items'])) {
                    foreach ($action_data['extended_data']['order']['items'] as $item) {
                        if ($item['product_id'] == $action_data['data']['P'] && !empty($item['subtotal'])) {
                            $action_data['extended_data']['product']['price'] = $item['subtotal'];
                        }
                        if ($item['product_id'] == $action_data['data']['P'] && !empty($item['amount'])) {
                            $action_data['extended_data']['product']['amount'] = $item['amount'];
                        }
                    }
                }
            }

            if (in_array('D', $keys_extended_data)) {
                $action_data['extended_data']['discount'] = fn_get_discounts('', $action_data['data']['D']);
            }

            Registry::get('view')->assign('action_data', $action_data);
            Registry::get('view')->assign('total_commission', $total_commission);
            Registry::get('view')->assign('order_status_descr', fn_get_simple_statuses(STATUSES_ORDER, true, true));

        }
    }

} elseif ($mode == 'approve') {

    $payout_options = array();
    foreach (Registry::get('payout_types') as $payout_id => $payout_data) {
        $payout_options[$payout_id] = __($payout_data['title']);
    }

    $status_options = array(
        'A' => __('approved'),
        'N' => __('awaiting_approval'),
        'P' => __('paidup'),
    );

    $list_plans = fn_get_affiliate_plans_list();

    list($partners) = fn_get_users(array('user_type' => 'P', 'status' => 'A'), $auth);
    $partner_list = array();
    foreach ($partners as $partner) {
        $partner_list[$partner['user_id']] = $partner['firstname'] . ' ' . $partner['lastname'];
    }

    // Get affiliates list to approve
    list($affiliate_commissions, $general_stats, $additional_stats, $search) = fn_get_affiliates_for_approve($_REQUEST, $auth, Registry::get('settings.Appearance.admin_elements_per_page'));

    Registry::get('view')->assign('affiliate_commissions', $affiliate_commissions);
    Registry::get('view')->assign('general_stats', $general_stats);
    Registry::get('view')->assign('additional_stats', $additional_stats);
    Registry::get('view')->assign('search', $search);

    Registry::get('view')->assign('list_plans', $list_plans);
    Registry::get('view')->assign('status_options', $status_options);
    Registry::get('view')->assign('payout_options', $payout_options);
    Registry::get('view')->assign('payout_types', Registry::get('payout_types'));
    Registry::get('view')->assign('partner_list', $partner_list);
    Registry::get('view')->assign('order_status_descr', fn_get_simple_statuses(STATUSES_ORDER, true, true));

} elseif ($mode == 'delete') {
    if (!empty($_REQUEST['action_id'])) {
        fn_delete_affiliate_actions((array) $_REQUEST['action_id']);
    }

    return array(CONTROLLER_STATUS_REDIRECT, "aff_statistics.approve");
}

function fn_delete_affiliate_actions($action_ids)
{
    $tmp_amounts = db_get_array("SELECT partner_id, amount, action_id, approved FROM ?:aff_partner_actions WHERE action_id IN (?n)", $action_ids);
    foreach ($tmp_amounts as $action_data) {
        if (!empty($action_data['partner_id']) && !empty($action_data['action_id'])) {
            $_amount = floatval($action_data['amount']);
            if ($action_data['approved'] == 'Y' && !empty($_amount)) {
                if (fn_update_partner_balance($action_data['partner_id'], $action_data['amount'], '-')) {
                    db_query("DELETE FROM ?:aff_partner_actions WHERE action_id = ?i", $action_data['action_id']);
                    db_query("DELETE FROM ?:aff_action_links WHERE action_id = ?i", $action_data['action_id']);
                }
            } else {
                db_query("DELETE FROM ?:aff_partner_actions WHERE action_id = ?i", $action_data['action_id']);
                db_query("DELETE FROM ?:aff_action_links WHERE action_id = ?i", $action_data['action_id']);
            }
        }
    }
}

function fn_approve_commissions($action_ids, $value = 'Y')
{
    $tmp_amounts = db_get_array("SELECT partner_id, amount, action_id, approved FROM ?:aff_partner_actions WHERE action_id IN (?n)", $action_ids);
    if (!empty($tmp_amounts)) {
        foreach ($tmp_amounts as $action_data) {
            if (!empty($action_data['partner_id']) && !empty($action_data['amount']) && !empty($action_data['action_id']) && (empty($action_data['approved']) || $action_data['approved'] != $value) && fn_update_partner_balance($action_data['partner_id'], $action_data['amount'], $value == 'Y' ? '+' : '-')) {
                db_query("UPDATE ?:aff_partner_actions SET ?u WHERE action_id = ?i", array('approved' => $value), $action_data['action_id']);
            }
        }
    }
}

function fn_get_affiliates_for_approve($params, $auth, $items_per_page = 0)
{
    // Init filter
    $params = LastView::instance()->update('aff_stats', $params);

    // Set default values to input params
    $params['page'] = empty($params['page']) ? 1 : $params['page'];

    $condition = '1';

    if (!empty($params['name'])) {
        // Check if first and last names are entered
        $arr = explode(' ', $params['name']);
        if (sizeof($arr) == 2) {
            $condition .= db_quote(" AND (?:users.firstname LIKE ?l AND ?:users.lastname LIKE ?l)", "%$arr[0]%", "%$arr[1]%");
        } else {
            $condition .= db_quote(" AND (?:users.firstname LIKE ?l OR ?:users.lastname LIKE ?l)", "%$params[name]%", "%$params[name]%");
        }
    }

    if (!empty($params['user_login'])) {
        $condition .= db_quote(" AND ?:users.user_login LIKE ?l", "%$params[user_login]%");
    }

    if (!empty($params['partner_id'])) {
        $condition .= db_quote(" AND actions.partner_id = ?i", $params['partner_id']);
    }

    if (!empty($params['period']) && $params['period'] != 'A') {
        list($params['time_from'], $params['time_to']) = fn_create_periods($params);

        $condition .= db_quote(" AND (actions.date >= ?i AND actions.date <= ?i)", $params['time_from'], $params['time_to']);
    }

    if (!empty($params['plan_id'])) {
        $condition .= db_quote(" AND actions.plan_id = ?i", $params['plan_id']);
    }

    if (!empty($params['action'])) {
            $_conditions = '';
            foreach ($params['action'] as $_act) {
                $_conditions .= (empty($_conditions) ? '' : 'OR') . db_quote(" action = ?s", $_act);
            }

            $condition .= " AND ($_conditions) ";
    }

    if (!empty($params['status'])) {
        $_conditions = '';
        foreach ($params['status'] as $_status) {
            $_conditions .= empty($_conditions) ? '' : 'OR';
            if ($_status == 'P') {
                $_conditions .= " (actions.payout_id != 0) ";
            } elseif ($_status == 'A') {
                $_conditions .= " (actions.payout_id = 0 AND actions.approved = 'Y') ";
            } else {
                $_conditions .= " (actions.approved = 'N' AND actions.payout_id = 0) ";
            }
        }
        $condition .= " AND ($_conditions) ";
    }

    if (!empty($params['zero_actions']) && $params['zero_actions'] == 'Y') {
        $condition .= " AND actions.amount = 0";
    }

    if (isset($params['amount_from']) && fn_is_numeric($params['amount_from'])) {
        $condition .= db_quote(" AND actions.amount >= ?d", $params['amount_from']);
    }

    if (isset($params['amount_to']) && fn_is_numeric($params['amount_to'])) {
        $condition .= db_quote(" AND actions.amount <= ?d", $params['amount_to']);
    }

    $params['condition'] = $condition; // FIXME: dirty hack

    list($affiliate_commissions, $params) = fn_get_affiliate_actions($params, $items_per_page);

    // Get general statistics
    $general_stats = db_get_hash_array("SELECT action, COUNT(action) as count, SUM(amount) as sum, AVG(amount) as avg, COUNT(distinct partner_id) as partners FROM ?:aff_partner_actions as actions WHERE ?p GROUP BY action", 'action', $condition);
    $general_stats['total'] = db_get_row("SELECT 'total' as action, COUNT(action) as count, SUM(amount) as sum, AVG(amount) as avg, COUNT(DISTINCT partner_id) as partners FROM ?:aff_partner_actions as actions WHERE ?p", $condition);

    // Get additional statistics
    $additional_stats = array();
    $additional_stats['click_vs_show'] = empty($general_stats['show']['count']) ? '---' : (empty($general_stats['click']['count']) ? '0' : round($general_stats['click']['count'] / $general_stats['show']['count'] * 100, 1) . '% (' . intval($general_stats['click']['count']) . '/' . intval($general_stats['show']['count']) . ')');
    $additional_stats['sale_vs_click'] = empty($general_stats['click']['count']) ? '---' : (empty($general_stats['sale']['count']) ? '0' : round($general_stats['sale']['count'] / $general_stats['click']['count'] * 100, 1) . '% (' . intval($general_stats['sale']['count']) . '/' . intval($general_stats['click']['count']) . ')');

    return array($affiliate_commissions, $general_stats, $additional_stats, $params);
}
