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

if ($mode == 'html_file') {
    $_tout = 5;
    if (empty($action)) {
        $action = 'partner';
    }
    $_rurl = ($action == 'partner') ? fn_url("profiles.add?aff_id=" . $auth['user_id'], 'C', 'http') : (fn_url('', 'C', 'http') . "?aff_id=$auth[user_id]");

    $_u_data = fn_get_user_info($auth['user_id']);
    $_u_name = empty($_u_data['firstname']) ? '' : $_u_data['firstname'];
    $_u_name .= (empty($_u_name) || empty($_u_data['lastname'])) ? '' : ' ';
    $_u_name .= empty($_u_data['lastname']) ? '' : $_u_data['lastname'];

    Registry::get('view')->assign('_tout', $_tout);
    Registry::get('view')->assign('_rurl', $_rurl);
    Registry::get('view')->assign('_u_name', $_u_name);
    $file_content = trim(Registry::get('view')->fetch('affiliate/redirect.tpl')); // FIX-TEMPLATE

    header("Content-type: text/html");
    header("Content-disposition: attachment; filename=$action.html");
    echo $file_content;
    exit();
}

fn_add_breadcrumb(__('affiliate'));

$affiliate_plan = fn_get_affiliate_plan_data_by_partner_id($auth['user_id']);
if (!empty($affiliate_plan['plan_id'])) {
    $affiliate_plan['min_payment'] = floatval($affiliate_plan['min_payment']);

    $linked_products = array();
    foreach ($affiliate_plan['product_ids'] as $prod_id => $sale) {
        $linked_products[$prod_id] = fn_get_product_data($prod_id, $auth);
        $linked_products[$prod_id]['sale'] = $sale;
    }
    Registry::get('view')->assign('linked_products', $linked_products);

    $linked_categories = array();
    foreach ($affiliate_plan['category_ids'] as $cat_id => $sale) {
        $linked_categories[$cat_id]['category'] = fn_get_category_name($cat_id, CART_LANGUAGE);
        $linked_categories[$cat_id]['category_id'] = $cat_id;
        $linked_categories[$cat_id]['sale'] = $sale;
    }
    Registry::get('view')->assign('linked_categories', $linked_categories);


    if (!empty($affiliate_plan['promotion_ids'])) {
        $params = array (
            'promotion_id' => array_keys($affiliate_plan['promotion_ids']),
            'expand' => true
        );
        list($coupons) = fn_get_promotions($params);

        $aff_prefix = Registry::get('addons.affiliate.coupon_prefix_delim');

        foreach ($coupons as $promotion_id => $coupon_data) {
            if (isset($affiliate_plan['promotion_ids'][$promotion_id])) {
                $coupons[$promotion_id]['use_coupon'] = $affiliate_plan['promotion_ids'][$promotion_id];
                foreach ($coupons[$promotion_id]['conditions']['conditions'] as $cnd) {
                    if ($cnd['condition'] == 'coupon_code') {
                        if (Registry::get('addons.affiliate.use_affiliate_id') == 'Y' && $aff_prefix) {
                            $coupons[$promotion_id]['coupon_code'] = $auth['user_id'] . $aff_prefix . $cnd['value'];
                        } else {
                            $coupons[$promotion_id]['coupon_code'] = fn_dec2any($auth['user_id']).  $aff_prefix . $cnd['value'];
                        }
                    }
                }
            }
        }
        Registry::get('view')->assign('coupons', $coupons);
    }

    Registry::get('view')->assign('affiliate_plan', $affiliate_plan);
    Registry::get('view')->assign('payout_types', Registry::get('payout_types'));
}
