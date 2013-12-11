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

if ($mode == 'list') {
    fn_add_breadcrumb(__('affiliate'));

    list($payouts, $search, $payout_search_data) = fn_get_customer_payouts($_REQUEST, Registry::get('settings.Appearance.elements_per_page'), $auth);

    Registry::get('view')->assign('payouts', $payouts);
    Registry::get('view')->assign('search', $search);
    Registry::get('view')->assign('payout_search_data', $payout_search_data);

} elseif ($mode == 'update') {

    if (empty($_REQUEST['payout_id'])) {
        return array(CONTROLLER_STATUS_NO_PAGE);

    } else {

        $payout_data = db_get_row("SELECT * FROM ?:affiliate_payouts WHERE payout_id = ?i", $_REQUEST['payout_id']);

        if (empty($payout_data)) {
            return array(CONTROLLER_STATUS_NO_PAGE);
        } else {
            if (!empty($payout_data['partner_id'])) {
                $payout_data['partner'] = fn_get_partner_data($payout_data['partner_id']);
            }

            if (!empty($payout_data['partner']['plan_id'])) {
                $payout_data['plan'] = fn_get_affiliate_plan_data($payout_data['partner']['plan_id']);
            }

            list($payout_data['actions'], $search) = fn_get_affiliate_actions($_REQUEST, Registry::get('settings.Appearance.elements_per_page'));

            $payout_data['date_range']['min'] = db_get_field("SELECT MIN(date) FROM ?:aff_partner_actions WHERE payout_id = ?i", $_REQUEST['payout_id']);
            $payout_data['date_range']['max'] = db_get_field("SELECT MAX(date) FROM ?:aff_partner_actions WHERE payout_id = ?i", $_REQUEST['payout_id']);

            // [Breadcrumbs]
            fn_add_breadcrumb(__('payouts'), "payouts.list");
            // [/Breadcrumbs]

            Registry::get('view')->assign('affiliate_plan', fn_get_affiliate_plan_data_by_partner_id($auth['user_id']));
            Registry::get('view')->assign('payouts', array($payout_data['partner_id'] => $payout_data));
        }

        Registry::get('view')->assign('search', $search);
    }
}

/** /Body **/

function fn_get_customer_payouts($params, $items_per_page = 0, $auth, $lang_code = CART_LANGUAGE)
{
    // Set default values to input params
    $default_params = array (
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    $sortings = array (
        'username' => "user_login",
        'partner' => "CONCAT(lastname, firstname)",
        'amount' => "?:affiliate_payouts.amount",
        'date' => "?:affiliate_payouts.date",
        'status' => "?:affiliate_payouts.status",
    );

    $sorting = db_sort($params, $sortings, 'date', 'desc');

    if (!empty($params['payout_search'])) {
        $payout_search = $params['payout_search'];
        $payout_search_data = $payout_search;
        $payout_search_condition = '1';
        if (!empty($params['period']) && $params['period'] != 'A') {
            list($time_from, $time_to) = fn_create_periods($params);

            $payout_search_data['period'] = $params['period'];
            $payout_search_data['time_from'] = $time_from;
            $payout_search_data['time_to'] = $time_to;

            $payout_search_condition .= db_quote(" AND (?:affiliate_payouts.date >= ?i AND ?:affiliate_payouts.date <= ?i)", $time_from, $time_to);
        } else {
            $payout_search_data['period'] = 'A';
        }

        if (!empty($payout_search['status'])) {
            $payout_search_condition .= db_quote(" AND ?:affiliate_payouts.status = ?s ", $payout_search['status']);
        }
        $payout_search_data['amount']['from'] = floatval(@$payout_search['amount']['from']);
        if (!empty($payout_search_data['amount']['from'])) {
            $payout_search_condition .= db_quote(" AND ?:affiliate_payouts.amount >= ?d ", fn_convert_price($payout_search_data['amount']['from']));
        } else {
            $payout_search_data['amount']['from'] = '';
        }
        $payout_search_data['amount']['to'] = floatval(@$payout_search['amount']['to']);
        if (!empty($payout_search_data['amount']['to'])) {
            $payout_search_condition .= db_quote(" AND ?:affiliate_payouts.amount <= ?d ", fn_convert_price($payout_search_data['amount']['to']));
        } else {
            $payout_search_data['amount']['to'] = '';
        }
    }

    if (empty($payout_search_data)) {
        $payout_search_data = array();
    }

    if (empty($payout_search_condition)) {
        $payout_search_condition = " 1 ";
    }

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:affiliate_payouts LEFT JOIN ?:users ON ?:affiliate_payouts.partner_id = ?:users.user_id WHERE ?p AND user_id = ?i", $payout_search_condition, $auth['user_id']);
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $payouts = db_get_hash_array("SELECT ?:affiliate_payouts.*, ?:users.user_login, ?:users.firstname, ?:users.lastname FROM ?:affiliate_payouts LEFT JOIN ?:users ON ?:affiliate_payouts.partner_id=?:users.user_id WHERE ?p AND ?:users.user_id = ?i $sorting $limit", 'payout_id', $payout_search_condition, $auth['user_id']);

    return array($payouts, $params, $payout_search_data);
}
