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

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'commissions') {
    fn_add_breadcrumb(__('affiliate'));

    $payout_types = Registry::get('payout_types');

    Registry::get('view')->assign('payout_types', $payout_types);
    $payout_options = array();
    foreach ($payout_types as $payout_id => $payout_data) {
        $payout_options[$payout_id] = __($payout_data['title']);
    }
    Registry::get('view')->assign('payout_options', $payout_options);

    $status_options = array(
        'A' => __('approved'),
        'N' => __('awaiting_approval'),
        'P' => __('paidup'),
    );
    Registry::get('view')->assign('status_options', $status_options);

    $_SESSION['statistic_conditions'] = empty($_SESSION['statistic_conditions']) ? array() : $_SESSION['statistic_conditions'];
    $statistic_conditions = & $_SESSION['statistic_conditions'];

    $_SESSION['statistic_search_data'] = empty($_SESSION['statistic_search_data']) ? array() : $_SESSION['statistic_search_data'];
    $statistic_search_data = & $_SESSION['statistic_search_data'];

    if ($action == 'reset_search' || empty($statistic_conditions)) {
        $statistic_conditions = " (amount != 0) ";
        $statistic_search_data = array();
    }

    $statistic_conditions = '1';
    if (empty($_REQUEST['statistic_search'])) {
        $statistic_search = array();
    } else {
        $statistic_search = $_REQUEST['statistic_search'];
    }

    $statistic_search_data = (empty($search_type) || $search_type != 'add') ? $statistic_search : fn_array_merge($statistic_search_data, $statistic_search);

    if (AREA == 'C') {
        $statistic_conditions .= db_quote(" AND (actions.partner_id = ?i)", $auth['user_id']);
    } elseif (!empty($statistic_search_data['partner_id'])) {
        $statistic_conditions .= db_quote(" AND (actions.partner_id = ?i)", $statistic_search_data['partner_id']);
    }
    if (!empty($_REQUEST['period']) && $_REQUEST['period'] != 'A') {
        list($_REQUEST['time_from'], $_REQUEST['time_to']) = fn_create_periods($_REQUEST);
        $statistic_search_data['period'] = $_REQUEST['period'];
        if ($_REQUEST['period'] == 'C') {
            $statistic_search_data['start_date'] = $_REQUEST['time_from'];
            $statistic_search_data['end_date'] = $_REQUEST['time_to'];
        }

        $statistic_conditions .= db_quote(" AND (actions.date >= ?i AND actions.date <= ?i)", $_REQUEST['time_from'], $_REQUEST['time_to']); // FIXME
    } else {
        $statistic_search_data['period'] = 'A';
    }

    if (!empty($statistic_search_data['plan_id'])) {
        $statistic_conditions .= db_quote(" AND (actions.plan_id = ?i) ", $statistic_search_data['plan_id']);
    }
    if (!empty($statistic_search_data['payout_id'])) {
        $_conditions = '';
        foreach ($statistic_search_data['payout_id'] as $_act) {
            $_conditions .= (empty($_conditions) ? '' : 'OR') . db_quote(" (actions.action = ?s) ", $_act);
        }
        $statistic_conditions .= " AND ($_conditions) ";
    }
    if (!empty($statistic_search_data['status'])) {
        $_conditions = '';
        foreach ($statistic_search_data['status'] as $_status) {
            $_conditions .= empty($_conditions) ? '' : 'OR';
            if ($_status == 'P') {
                $_conditions .= " (actions.payout_id != 0) ";
            } elseif ($_status == 'A') {
                $_conditions .= " (actions.payout_id = 0 AND actions.approved = 'Y') ";
            } else {
                $_conditions .= " (actions.approved = 'N' AND payout_id = 0) ";
            }
        }
        $statistic_conditions .= " AND ($_conditions) ";
    }
    if (!empty($statistic_search_data['zero_actions']) && $statistic_search_data['zero_actions'] == 'Y' && AREA != 'C') {
        $statistic_conditions .= " AND (actions.amount = 0) ";
    } elseif (empty($statistic_search_data['zero_actions']) || AREA == 'C') {
        $statistic_conditions .= " AND (actions.amount != 0) ";
    }
    $statistic_search_data['amount_from'] = empty($statistic_search_data['amount_from']) ? 0 : floatval($statistic_search_data['amount_from']);
    if (!empty($statistic_search_data['amount_from'])) {
        $statistic_conditions .= db_quote(" AND (actions.amount >= ?d) ", fn_convert_price($statistic_search_data['amount_from']));
    }
    $statistic_search_data['amount_to'] = empty($statistic_search_data['amount_to']) ? 0 : floatval($statistic_search_data['amount_to']);
    if (!empty($statistic_search_data['amount_to'])) {
        $statistic_conditions .= db_quote(" AND (actions.amount <= ?d) ", fn_convert_price($statistic_search_data['amount_to']));
    }

    Registry::get('view')->assign('statistic_search', $statistic_search_data);

    $general_stats = db_get_hash_array("SELECT action, COUNT(action) as count, SUM(amount) as sum, AVG(amount) as avg, COUNT(distinct partner_id) as partners FROM ?:aff_partner_actions as actions WHERE $statistic_conditions GROUP BY action", 'action');

    $general_stats['total'] = db_get_row("SELECT 'total' as action, COUNT(action) as count, SUM(amount) as sum, AVG(amount) as avg, COUNT(distinct partner_id) as partners FROM ?:aff_partner_actions as actions WHERE $statistic_conditions");

    Registry::get('view')->assign('general_stats', $general_stats);
    $additional_stats = array();
    $additional_stats['click_vs_show'] = empty($general_stats['show']['count']) ? '---' : (empty($general_stats['click']['count']) ? '0' : round($general_stats['click']['count'] / $general_stats['show']['count'] * 100, 1) . '% (' . intval($general_stats['click']['count']) . '/' . intval($general_stats['show']['count']) . ')');
    $additional_stats['sale_vs_click'] = empty($general_stats['click']['count']) ? '---' : (empty($general_stats['sale']['count']) ? '0' : round($general_stats['sale']['count'] / $general_stats['click']['count'] * 100, 1) . '% (' . intval($general_stats['sale']['count']) . '/' . intval($general_stats['click']['count']) . ')');
    Registry::get('view')->assign('additional_stats', $additional_stats);

    $list_plans = fn_get_affiliate_plans_list();
    Registry::get('view')->assign('list_plans', $list_plans);
    Registry::get('view')->assign('affiliate_plan', fn_get_affiliate_plan_data_by_partner_id($auth['user_id']));

    $params = $_REQUEST;
    $params['condition'] = $_SESSION['statistic_conditions'];
    list($list_stats, $search) = fn_get_affiliate_actions($params, Registry::get('settings.Appearance.elements_per_page'));

    Registry::get('view')->assign('search', $search);
    Registry::get('view')->assign('list_stats', $list_stats);

    $order_status_descr = fn_get_simple_statuses(STATUSES_ORDER, true, true);
    Registry::get('view')->assign('order_status_descr', $order_status_descr);
}
