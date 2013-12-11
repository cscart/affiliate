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
use Tygh\Settings;
use Tygh\Navigation\LastView;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    fn_trusted_vars('payout_data', 'payouts', 'delete');
    $suffix = '';
    if ($mode == 'm_delete') {
        if (!empty($_REQUEST['payout_ids'])) {
            foreach ($_REQUEST['payout_ids'] as $payout_id) {
                fn_delete_affiliate_payout($payout_id);
            }
        }

        $suffix = '.manage';
    }

    if ($mode == 'do_m_pay_affiliates') {
        if (!empty($_REQUEST['partner_ids'])) {
            $new_payouts = array();

            $_SESSION['pay_filter'] = empty($_SESSION['pay_filter']) ? array() : $_SESSION['pay_filter'];
            $pay_filter = & $_SESSION['pay_filter'];

            $_date_condition = !empty($pay_filter['last_payout']) ? db_quote(" AND date < ?i", fn_parse_date(fn_get_date_of_payment_period(), true)) : '';

            foreach ($_REQUEST['partner_ids'] as $_partner_id) {
                $_where_condition = db_quote("approved = 'Y' AND payout_id = 0 AND partner_id = ?i $_date_condition", $_partner_id);
                $new_payouts[$_partner_id]['amount'] = db_get_field("SELECT SUM(amount) FROM ?:aff_partner_actions WHERE $_where_condition");
                if (empty($new_payouts[$_partner_id]['amount'])) {
                    unset($new_payouts[$_partner_id]);
                }
            }

            if (!empty($new_payouts)) {
                foreach ($new_payouts as $user_id => $new_payout_data) {
                    if (!empty($user_id)) {
                        $_where_condition = db_quote("approved = 'Y' AND payout_id = 0 AND partner_id = ?i $_date_condition", $user_id);
                        $amount = floatval($new_payout_data['amount']);
                        if (!empty($amount)) {
                            if (fn_update_partner_balance($user_id, $amount, '-')) {
                                $payout_id = db_query('INSERT INTO ?:affiliate_payouts ?e', array('partner_id' => $user_id, 'amount' => $amount, 'status' => 'O', 'date' => TIME));
                                if (!empty($payout_id)) {
                                    db_query("UPDATE ?:aff_partner_actions SET ?u WHERE $_where_condition", array('payout_id' => $payout_id));
                                }
                            }
                        }
                    }
                }
            }
        }

        $suffix = '.manage';
    }

    if ($mode == 'm_add_payouts') {
        if (!empty($_REQUEST['action_ids']) && is_array($_REQUEST['action_ids'])) {
            foreach ($_REQUEST['action_ids'] as $user_id => $actions) {
                if (!empty($user_id) && !empty($actions) && is_array($actions)) {
                    $amount = db_get_field("SELECT SUM(amount) FROM ?:aff_partner_actions WHERE partner_id = ?i AND approved = 'Y' AND payout_id = 0 AND action_id IN (?n)", $user_id, array_keys($actions));

                    $amount = floatval($amount);
                    if (!empty($amount)) {
                        if (fn_update_partner_balance($user_id, $amount, '-')) {
                            $payout_id = db_query('INSERT INTO ?:affiliate_payouts ?e', array('partner_id' => $user_id, 'amount' => $amount, 'status' => 'O', 'date' => TIME));
                            if (!empty($payout_id)) {
                                db_query("UPDATE ?:aff_partner_actions SET ?u WHERE partner_id = ?i AND approved = 'Y' AND payout_id = 0 AND action_id IN (?n)", array('payout_id' => $payout_id), $user_id, array_keys($actions));
                            }
                        }
                    }
                }
            }
        }

        if (!empty($payout_id)) {
            $suffix = ".update?payout_id=$payout_id";
        } else {
            $suffix = ".manage";
        }
    }

    return array(CONTROLLER_STATUS_OK, "payouts$suffix");
}

if ($mode == 'manage') {

    list($payouts, $search) = fn_get_payouts($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Registry::get('view')->assign('payouts', $payouts);
    Registry::get('view')->assign('search', $search);

    list($partner_list) = fn_get_users(array('user_type' => 'P', 'active' => 'Y', 'approved' => 'A'), $auth);

    $_partner_list = array();
    foreach ($partner_list as $partner_data) {
        $_partner_list[$partner_data['user_id']] = "$partner_data[firstname] $partner_data[lastname] ($partner_data[user_login])";
    }

    Registry::get('view')->assign('partner_list', $_partner_list);

} elseif ($mode == 'pay') {

    list($partner_balances, $search) = fn_pay_affiliates($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Registry::get('view')->assign('partner_balances', $partner_balances);
    Registry::get('view')->assign('search', $search);

    $payment_period_options = Settings :: instance()->getVariants('affiliate', 'payment_period');
    Registry::get('view')->assign('period_name', $payment_period_options[Registry::get('addons.affiliate.payment_period')]);

} elseif ($mode == 'add') {

    list($new_payouts, $search) = fn_add_payouts($_REQUEST);

    Registry::get('view')->assign('payouts', $new_payouts);
    Registry::get('view')->assign('search', $search);

} elseif ($mode == 'update' && !empty($_REQUEST['payout_id'])) {

    $payout_data = db_get_row("SELECT * FROM ?:affiliate_payouts WHERE payout_id = ?i", $_REQUEST['payout_id']);

    if (empty($payout_data)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    if (!empty($payout_data['partner_id'])) {
        $payout_data['partner'] = fn_get_partner_data($payout_data['partner_id']);
    }

    if (!empty($payout_data['partner']['plan_id'])) {
        $payout_data['plan'] = fn_get_affiliate_plan_data($payout_data['partner']['plan_id'], DESCR_SL);
    }

    list($payout_data['actions'], $search) = fn_get_affiliate_actions($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    $payout_data['date_range']['min'] = db_get_field("SELECT MIN(date) FROM ?:aff_partner_actions WHERE payout_id = ?i", $_REQUEST['payout_id']);
    $payout_data['date_range']['max'] = db_get_field("SELECT MAX(date) FROM ?:aff_partner_actions WHERE payout_id = ?i", $_REQUEST['payout_id']);

    Registry::get('view')->assign('payouts', array($payout_data['partner_id'] => $payout_data));
    Registry::get('view')->assign('search', $search);

} elseif ($mode == 'previous') {

    list($payouts, $search, $max_amount) = fn_get_previous_payouts($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Registry::get('view')->assign('payouts', $payouts);
    Registry::get('view')->assign('search', $search);
    Registry::get('view')->assign('max_amount', $max_amount);

} elseif ($mode == 'delete') {
    if (!empty($_REQUEST['payout_id'])) {
        fn_delete_affiliate_payout($_REQUEST['payout_id']);
    }

    return array(CONTROLLER_STATUS_REDIRECT, "payouts.manage");
}

function fn_delete_affiliate_payout($payout_id)
{
    $_payout_data = db_get_row("SELECT * FROM ?:affiliate_payouts WHERE payout_id = ?i", $payout_id);
    $_amount = floatval($_payout_data['amount']);
    $_partner = fn_get_partner_data($_payout_data['partner_id'], true);

    if (!empty($_amount) && !empty($_partner['user_id'])) {
        if (fn_update_partner_balance($_partner['user_id'], $_amount, '+')) {
            db_query("UPDATE ?:aff_partner_actions SET ?u WHERE payout_id = ?i", array('payout_id' => '0'), $payout_id);
            db_query("DELETE FROM ?:affiliate_payouts WHERE payout_id = ?i", $payout_id);
        }
    }
}

function fn_get_payouts($params, $items_per_page = 0)
{
    // Init filter
    $params = LastView::instance()->update('payouts', $params);

    // Set default values to input params
    $default_params = array (
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    // Define fields that should be retrieved
    $fields = array (
        '?:affiliate_payouts.*',
        '?:users.user_login',
        '?:users.firstname',
        '?:users.lastname',
        '?:users.email'
    );

    // Define sort fields
    $sortings = array (
        'username' => "?:users.user_login",
        'email' => '?:users.email',
        'partner' => "CONCAT(?:users.lastname, ?:users.firstname)",
        'amount' => "?:affiliate_payouts.amount",
        'date' => "?:affiliate_payouts.date",
        'status' => "?:affiliate_payouts.status",
    );

    $sorting = db_sort($params, $sortings, 'date', 'desc');

    $join = $condition = '';

    if (!empty($params['name'])) {
        $condition .= db_quote(" AND (?:users.firstname LIKE ?l OR ?:users.lastname LIKE ?l)", "%$params[name]%", "%$params[name]%");
    }

    if (!empty($params['user_login'])) {
        $condition .= db_quote(" AND ?:users.user_login LIKE ?l", "%$params[user_login]%");
    }

    if (!empty($params['email'])) {
        $condition .= db_quote(" AND ?:users.email LIKE ?l", "%$params[email]%");
    }

    if (!empty($params['partner_id'])) {
        $condition .= db_quote(" AND ?:users.user_id = ?i", $params['partner_id']);
    }

    if (!empty($params['period']) && $params['period'] != 'A') {
        list($params['time_from'], $params['time_to']) = fn_create_periods($params);

        $condition .= db_quote(" AND (?:affiliate_payouts.date >= ?i AND ?:affiliate_payouts.date <= ?i)", $params['time_from'], $params['time_to']);
    }

    if (!empty($params['status'])) {
        $condition .= db_quote(" AND ?:affiliate_payouts.status = ?s", $params['status']);
    }

    if (isset($params['amount_from']) && fn_is_numeric($params['amount_from'])) {
        $condition .= db_quote(" AND ?:affiliate_payouts.amount >= ?d", trim($params['amount_from']));
    }

    if (isset($params['amount_to']) && fn_is_numeric($params['amount_to'])) {
        $condition .= db_quote(" AND ?:affiliate_payouts.amount <= ?d", trim($params['amount_to']));
    }

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:affiliate_payouts LEFT JOIN ?:users ON ?:affiliate_payouts.partner_id = ?:users.user_id WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $payouts = db_get_hash_array("SELECT " . implode(', ', $fields) . " FROM ?:affiliate_payouts LEFT JOIN ?:users ON ?:affiliate_payouts.partner_id = ?:users.user_id WHERE 1 $condition $sorting $limit", 'payout_id');

    LastView::instance()->processResults('payouts', $payouts, $params);

    return array($payouts, $params);
}

function fn_pay_affiliates($params, $items_per_page = 0)
{
    // Init filter
    $params = LastView::instance()->update('pay_affiliates', $params);

    // Set default values to input params
    $default_params = array (
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    // Define sort fields
    $sortings = array (
        'username' => 'user_login',
        'email' => 'email',
        'partner' => 'firstname',
        'amount' => 'amount',
        'date' => 'date'
    );

    $dirs = array (
        'asc' => 'asc',
        'desc' => 'desc'
    );

    if (empty($params['sort_order']) || empty($dirs[$params['sort_order']])) {
        $sorting_direction = 'asc';
    } else {
        $sorting_direction = $dirs[$params['sort_order']];
    }

    $sorting = db_sort($params, $sortings, 'username', 'asc');

    $pay_filter = array();
    $pay_filter['min_payment'] = empty($params['min_payment']) ? '' : 'Y';
    $pay_filter['last_payout'] = empty($params['last_payout']) ? '' : 'Y';
    $pay_filter['amount_from'] = empty($params['amount_from']) ? '' : floatval($params['amount_from']);
    $pay_filter['amount_to'] = empty($params['amount_to']) ? '' : floatval($params['amount_to']);
    $_SESSION['pay_filter'] = $pay_filter;

    $join = $condition = $group = '';

    $having = array();

    if (!empty($params['min_payment'])) {
        $having[] = 'SUM(pa.amount) >= AVG(ap.min_payment)';
    }

    if (isset($params['amount_from']) && fn_is_numeric($params['amount_from'])) {
        $having[] = db_quote("SUM(pa.amount) >= ?d", $params['amount_from']);
    }

    if (isset($params['amount_to']) && fn_is_numeric($params['amount_to'])) {
        $having[] = db_quote("SUM(pa.amount) <= ?d", $params['amount_to']);
    }

    if (!empty($params['last_payout'])) {
        $condition .= db_quote(" AND pa.date < ?i", fn_parse_date(fn_get_date_of_payment_period(), true));
    }

    $group = 'GROUP BY pa.partner_id' . (empty($having) ? ' ' : ' HAVING (' . implode(') AND (', $having) . ') ');

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = count(db_get_fields("SELECT COUNT(DISTINCT(pa.partner_id)) FROM ?:aff_partner_actions as pa LEFT JOIN ?:aff_partner_profiles as pp ON pa.partner_id = pp.user_id LEFT JOIN ?:affiliate_plans as ap ON ap.plan_id = pp.plan_id WHERE pa.approved = 'Y' AND pa.payout_id = 0 ?p ?p", $condition, $group));
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $partner_balances = db_get_hash_array("SELECT pa.partner_id, u.user_login, u.firstname, u.lastname, u.email, SUM(amount) as amount FROM ?:aff_partner_actions as pa LEFT JOIN ?:users as u ON pa.partner_id = u.user_id LEFT JOIN ?:aff_partner_profiles as pp ON pa.partner_id = pp.user_id LEFT JOIN ?:affiliate_plans as ap ON ap.plan_id = pp.plan_id WHERE pa.approved = 'Y' AND payout_id = 0 ?p ?p $sorting $limit", 'partner_id', $condition, $group);

    $_partners = db_get_hash_array("SELECT pa.partner_id, SUM(amount) as amount FROM ?:aff_partner_actions as pa LEFT JOIN ?:aff_partner_profiles as pp ON pa.partner_id = pp.user_id LEFT JOIN ?:affiliate_plans as ap ON ap.plan_id = pp.plan_id WHERE pa.approved = 'N' AND payout_id = 0 GROUP BY pa.partner_id ORDER BY amount $sorting_direction", 'partner_id');

    $last_payout_dates = db_get_hash_array("SELECT partner_id, MAX(date) as date FROM ?:affiliate_payouts GROUP BY partner_id ORDER BY date $sorting_direction", 'partner_id');

    if ($params['sort_by'] != 'date' && $params['sort_by'] != 'awaiting_amount') {
        foreach ($partner_balances as $_partner_id => $_partner_data) {
            $partner_balances[$_partner_id]['awaiting_amount'] = empty($_partners[$_partner_id]['amount']) ? '' : floatval($_partners[$_partner_id]['amount']);
            $partner_balances[$_partner_id]['last_payout_date'] = @$last_payout_dates[$_partner_id]['date'];
        }
    } else {
        $temp_balances = array();
        if ($params['sort_by'] == 'awaiting_amount') {
            foreach ($_partners as $_partner_id => $_partner_data) {
                if (!empty($partner_balances[$_partner_id])) {
                    $temp_balances[$_partner_id] = $partner_balances[$_partner_id];
                    $temp_balances[$_partner_id]['awaiting_amount'] = floatval($_partner_data['amount']);
                    $temp_balances[$_partner_id]['last_payout_date'] = @$last_payout_dates[$_partner_id]['date'];
                    unset($partner_balances[$_partner_id]);
                }
            }
        } else {
            foreach ($last_payout_dates as $_partner_id => $_date) {
                if (!empty($partner_balances[$_partner_id])) {
                    $temp_balances[$_partner_id] = $partner_balances[$_partner_id];
                    $temp_balances[$_partner_id]['awaiting_amount'] = empty($_partners[$_partner_id]['amount']) ? '' : floatval($_partners[$_partner_id]['amount']);
                    $temp_balances[$_partner_id]['last_payout_date'] = $_date['date'];
                    unset($partner_balances[$_partner_id]);
                }
            }
        }
        $temp_balances2 = array();
        foreach ($partner_balances as $_partner_id => $_partner_data) {
            $temp_balances2[$_partner_id] = $_partner_data;
            $temp_balances2[$_partner_id]['awaiting_amount'] = empty($_partners[$_partner_id]['amount']) ? '' : floatval($_partners[$_partner_id]['amount']);
            $temp_balances2[$_partner_id]['last_payout_date'] = @$last_payout_dates[$_partner_id]['date'];
        }
        $partner_balances = $sorting_direction == 'desc' ? $temp_balances + $temp_balances2 : $temp_balances2 + $temp_balances;
    }

    return array($partner_balances, $params);
}

function fn_add_payouts($params, $lang_code = CART_LANGUAGE)
{
    // Init filter
    $params = LastView::instance()->update('pay_affiliates', $params);

    // Define sort fields
    $sortings = array (
        'action' => "actions.action",
        'date' => "actions.date",
        'cost' => "actions.amount",
        'banner' => "banner",
    );

    $sorting = db_sort($params, $sortings, 'date', 'desc');

    $new_payouts = array();

    if (!empty($params['partner_ids'])) {

        $date_condition = "";
        if (!empty($params['last_payout']) && !empty($params['time_from'])) {
            $date_condition = db_quote(" AND date < ?i", $params['time_from']);
        }

        foreach ($params['partner_ids'] as $_partner_id) {

            $condition = "1 " . $date_condition . db_quote(" AND approved = 'Y' AND payout_id = 0 AND partner_id = ?i", $_partner_id);

            $new_payouts[$_partner_id]['amount'] = db_get_field("SELECT SUM(amount) FROM ?:aff_partner_actions WHERE $condition");

            if (empty($new_payouts[$_partner_id]['amount'])) {
                unset($new_payouts[$_partner_id]);
            } else {

                $new_payouts[$_partner_id]['partner'] = fn_get_partner_data($_partner_id);

                if (!empty($new_payouts[$_partner_id]['partner']['plan_id'])) {
                    $new_payouts[$_partner_id]['plan'] = fn_get_affiliate_plan_data($new_payouts[$_partner_id]['partner']['plan_id'], $lang_code);
                }

                $params['condition'] = $condition;
                list($new_payouts[$_partner_id]['actions'], $params) = fn_get_affiliate_actions($params, Registry::get('settings.Appearance.admin_elements_per_page'));

                $new_payouts[$_partner_id]['date_range']['min'] = db_get_field("SELECT MIN(date) FROM ?:aff_partner_actions WHERE $condition");
                $new_payouts[$_partner_id]['date_range']['max'] = db_get_field("SELECT MAX(date) FROM ?:aff_partner_actions WHERE $condition");
            }
        }
    }

    return array($new_payouts, $params);
}

/**
 * Gets previous payouts data
 *
 * @param array  $params          Search params list
 * @param int    $items_per_page  Items per page
 * @param strging $lang_code 2-letters language code
 * @return array  Array with payouts, modified search params, max payout amount
 */
function fn_get_previous_payouts($params, $items_per_page = 0, $lang_code = DESCR_SL)
{
    // Set default values to input params
    $default_params = array (
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    $sortings = array (
        'username' => "users.user_login",
        'name' => "users.firstname",
        'avg' => "avg_amount",
        'total' => "total_amount",
        'balance' => "p_profiles.balance",
    );

    $sorting = db_sort($params, $sortings, 'username', 'asc');

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(DISTINCT(?:affiliate_payouts.partner_id)) FROM ?:affiliate_payouts LEFT JOIN ?:users ON ?:affiliate_payouts.partner_id = ?:users.user_id");
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $previous_payouts = db_get_hash_array("SELECT aff_pay.partner_id, AVG(aff_pay.amount) as avg_amount, SUM(aff_pay.amount) as total_amount, users.user_login, users.firstname, users.lastname, users.email, p_profiles.balance FROM ?:affiliate_payouts as aff_pay LEFT JOIN ?:users as users ON aff_pay.partner_id = users.user_id LEFT JOIN ?:aff_partner_profiles as p_profiles ON aff_pay.partner_id = p_profiles.user_id GROUP BY aff_pay.partner_id $sorting $limit", 'partner_id');

    $max_amount = 0;
    if (!empty($previous_payouts)) {
        $_max_dates = db_get_array("SELECT aff_pay.partner_id, MAX(aff_pay.date) as max_date FROM ?:affiliate_payouts as aff_pay GROUP BY aff_pay.partner_id");
        $last_payouts = array();
        if (!empty($_max_dates)) {
            foreach ($_max_dates as $partner_max_date) {
                $_result = db_get_field("SELECT amount FROM ?:affiliate_payouts WHERE partner_id = ?i AND date = ?i", $partner_max_date['partner_id'], $partner_max_date['max_date']);
                if (!empty($_result)) {
                    $last_payouts[$partner_max_date['partner_id']] = $_result;
                }
            }
        }

        foreach ($previous_payouts as $user_id => $v) {
            $previous_payouts[$user_id]['last_amount'] = @$last_payouts[$user_id];
            if ($max_amount < $previous_payouts[$user_id]['total_amount']) {
                $max_amount = $previous_payouts[$user_id]['total_amount'];
            }
        }
    }

    return array($previous_payouts, $params, $max_amount);
}
