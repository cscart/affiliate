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

if ($_SERVER['REQUEST_METHOD']	== 'POST') {

    fn_trusted_vars('add_affiliate_plans', 'affiliate_plans_data', 'affiliate_plan', 'levels', 'commissions_ids');
    $suffix = '';

    //
    // Delete selected plans
    //
    if ($mode == 'm_delete') {
        if (fn_allowed_for('ULTIMATE')) {
            if (Registry::get('runtime.company_id')) {
                $plan_ids = !empty($_REQUEST['plan_id']) ? ((array) $_REQUEST['plan_id']) : $_REQUEST['plan_ids'];
                foreach ($plan_ids as $key => $plan_id) {
                    $plan_company_id = db_get_field("SELECT company_id FROM ?:affiliate_plans WHERE plan_id = ?i", $plan_id);
                    if ($plan_company_id != Registry::get('runtime.company_id')) {
                        fn_set_notification('E', __('error'), __('aff_object_cant_delete'));
                        if (!empty($_REQUEST['plan_id'])) {
                            unset($_REQUEST['plan_id']);
                        } else {
                            unset($_REQUEST['plan_ids'][$key]);
                        }
                    }
                }
            }
        }

        if (!empty($_REQUEST['plan_ids'])) {
            fn_delete_affiliate_plans($_REQUEST['plan_ids']);
            $suffix = '.manage';

            return array(CONTROLLER_STATUS_OK, "affiliate_plans$suffix");
        }

        if (!empty($_REQUEST['plan_id']) && !empty($_REQUEST['selected_section'])) {
            if (!empty($_REQUEST['affiliate_plan']['commission_ids']) && $_REQUEST['selected_section'] == 'multi_tier_affiliates') {
                $plan_id = fn_delete_affiliate_commissions($_REQUEST['affiliate_plan']['commission_ids'], $_REQUEST['plan_id']);
            } elseif (!empty($_REQUEST['affiliate_plan']['product_ids']) && $_REQUEST['selected_section'] == 'linked_products') {
                $plan_id = fn_delete_affiliate_products($_REQUEST['affiliate_plan']['product_ids'], $_REQUEST['plan_id']);
            } elseif (!empty($_REQUEST['affiliate_plan']['category_ids']) && $_REQUEST['selected_section'] == 'linked_categories') {
                $plan_id = fn_delete_affiliate_categories($_REQUEST['affiliate_plan']['category_ids'], $_REQUEST['plan_id']);
            } elseif (!empty($_REQUEST['affiliate_plan']['promotion_ids']) && $_REQUEST['selected_section'] == 'coupons') {
                $plan_id = fn_delete_affiliate_coupons($_REQUEST['affiliate_plan']['promotion_ids'], $_REQUEST['plan_id']);
            }
        }
        $suffix = ".update?plan_id=$_REQUEST[plan_id]";
    }

    //
    // Update/add plan
    //
    if ($mode == 'update') {
        $plan_id = fn_update_affiliate_plan($_REQUEST['affiliate_plan'], $_REQUEST['plan_id'], DESCR_SL);

        if (fn_allowed_for('ULTIMATE')) {
            fn_check_affiliate_plans_availability($_REQUEST);
        }

        $suffix = ".update?plan_id=$plan_id";
    }

    //
    // Add commissions
    //
    if ($mode == 'add_commissions') {
        if (!empty($_REQUEST['levels'])) {
            $plan_data = fn_get_affiliate_plan_data($_REQUEST['plan_id'], DESCR_SL);
            if (!empty($plan_data)) {
                foreach ($_REQUEST['levels'] as $level_data) {
                    if (!empty($level_data['commission'])) {
                        $level_data['commission'] = floatval($level_data['commission']);
                        $level_data['commission'] = ($level_data['commission'] > 100) ? 100 : (($level_data['commission']<0)?0:$level_data['commission']);
                        $plan_data['commissions'][] = $level_data['commission'];
                    }
                }
                $plan_id = fn_update_affiliate_plan($plan_data, $_REQUEST['plan_id'], DESCR_SL);
            }
        }

        $suffix = ".update?plan_id=$plan_id";
    }

    //
    // Add products
    //
    if ($mode == 'add_products') {
        if (!empty($_REQUEST['plan_id']) && !empty($_REQUEST['add_products_ids'])) {

            $plan_data = fn_get_affiliate_plan_data($_REQUEST['plan_id'], DESCR_SL);
            $products_ids = $plan_data['product_ids'];

            if (empty($products_ids)) {
                $products_ids = array();
            }

            foreach ($_REQUEST['add_products_ids'] as $prod_id) {
                if (!isset($products_ids[$prod_id])) {
                    $products_ids[$prod_id] = $plan_data['payout_types']['sale'];
                }
            }
            $plan_data['product_ids'] = $products_ids;
            $plan_id = fn_update_affiliate_plan($plan_data, $_REQUEST['plan_id'], DESCR_SL);
        }

        $suffix = ".update?plan_id=$plan_id";
    }

    //
    // Add categories
    //
    if ($mode == 'add_categories') {
        if (!empty($_REQUEST['plan_id']) && !empty($_REQUEST['categories_ids'])) {
            $plan_data = fn_get_affiliate_plan_data($_REQUEST['plan_id'], DESCR_SL);
            $categories_ids = empty($plan_data['category_ids']) ? array() : $plan_data['category_ids'];
            $add_categories_ids = array_keys($_REQUEST['categories_ids']);
            foreach ($add_categories_ids as $k => $cat_id) {
                if (!isset($categories_ids[$cat_id])) {
                    $categories_ids[$cat_id] = $plan_data['payout_types']['sale'];
                }
            }
            $plan_data['category_ids'] = $categories_ids;
            $plan_id = fn_update_affiliate_plan($plan_data, $_REQUEST['plan_id'], DESCR_SL);
        }

        $suffix = ".update?plan_id=$plan_id";
    }

    //
    // Add coupons
    //
    if ($mode == 'add_coupons') {
        if (!empty($_REQUEST['plan_id']) && !empty($_REQUEST['promotion_ids'])) {
            $plan_data = fn_get_affiliate_plan_data($_REQUEST['plan_id'], DESCR_SL);
            $promotion_ids = $plan_data['promotion_ids'];
            $add_promotion_ids = $_REQUEST['promotion_ids'];
            if (empty($promotion_ids)) {
                $promotion_ids = array();
            }
            if (empty($add_promotion_ids)) {
                $add_promotion_ids = array();
            }
            foreach ($add_promotion_ids as $promotion_id) {
                if (!isset($promotion_ids[$promotion_id])) {
                    $promotion_ids[$promotion_id] = $_REQUEST['coupons'][$promotion_id];
                } else {
                    unset($add_promotion_ids[$promotion_id]);
                }
            }
            $plan_data['promotion_ids'] = $promotion_ids;
            $plan_id = fn_update_affiliate_plan($plan_data, $_REQUEST['plan_id'], DESCR_SL);
        }

        $suffix = ".update?plan_id=$plan_id";
    }

    return array(CONTROLLER_STATUS_OK, "affiliate_plans$suffix");
}

// ---------------------- GET routines ---------------------------------------

if ($mode == 'update') {
    $affiliate_plan = fn_get_affiliate_plan_data($_REQUEST['plan_id'], DESCR_SL);

    if (empty($affiliate_plan)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    // [Page sections]
    Registry::set('navigation.tabs', array (
        'general' => array (
            'title' => __('general'),
            'js' => true
        ),
        'linked_products' => array (
            'title' => __('products'),
            'js' => true
        ),
        'linked_categories' => array (
            'title' => __('categories'),
            'js' => true
        ),
        'coupons' => array (
            'title' => __('coupons'),
            'js' => true
        ),
        'multi_tier_affiliates' => array (
            'title' => __('multi_tier_affiliates'),
            'js' => true
        ),
    ));
    // [/Page sections]

    $linked_products = array();

    foreach ($affiliate_plan['product_ids'] as $prod_id => $sale) {
        $linked_products[$prod_id]['product'] = fn_get_product_name($prod_id, DESCR_SL);
        $linked_products[$prod_id]['sale'] = $sale;
    }
    Registry::get('view')->assign('linked_products', $linked_products);

    $linked_categories = array();
    foreach ($affiliate_plan['category_ids'] as $cat_id => $sale) {
        $linked_categories[$cat_id]['category'] = fn_get_category_name($cat_id, DESCR_SL);
        $linked_categories[$cat_id]['category_id'] = $cat_id;
        $linked_categories[$cat_id]['sale'] = $sale;
    }
    Registry::get('view')->assign('linked_categories', $linked_categories);

    $params = array (
        'promotion_id' => empty($affiliate_plan['promotion_ids']) ? array('0' => 0) : array_keys($affiliate_plan['promotion_ids'])
    );
    list($affiliate_plan['coupons']) = fn_get_promotions($params);

    foreach ($affiliate_plan['coupons'] as $promotion_id => $coupon_data) {
        if (isset($affiliate_plan['promotion_ids'][$promotion_id])) {
            $affiliate_plan['coupons'][$promotion_id]['use_coupon'] = $affiliate_plan['promotion_ids'][$promotion_id];
        }
    }

    $params = array (
        'coupons' => true
    );
    list($coupons) = fn_get_promotions($params);

    foreach (array_keys($affiliate_plan['promotion_ids']) as $promotion_id) {
        unset($coupons[$promotion_id]);
    }

    Registry::get('view')->assign('coupons', $coupons);

    Registry::get('view')->assign('affiliate_plan', $affiliate_plan);
    Registry::get('view')->assign('payout_types', Registry::get('payout_types'));

} elseif ($mode == 'add') {

    // [Page sections]
    Registry::set('navigation.tabs', array (
        'general' => array (
            'title' => __('general'),
            'js' => true
        )
    ));
    // [/Page sections]

    Registry::get('view')->assign('payout_types', Registry::get('payout_types'));

} elseif ($mode == 'manage') {

    list($plans, $search) = fn_get_affiliate_plans($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);

    Registry::get('view')->assign('affiliate_plans', $plans);
    Registry::get('view')->assign('search', $search);

} elseif ($mode == 'delete') {
    if (empty($_REQUEST['plan_id'])) {
        return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.manage");
    }

    if (fn_allowed_for('ULTIMATE')) {
        if (Registry::get('runtime.company_id')) {
            $plan_company_id = db_get_field("SELECT company_id FROM ?:affiliate_plans WHERE plan_id = ?i", $_REQUEST['plan_id']);
            if ($plan_company_id != Registry::get('runtime.company_id')) {
                fn_set_notification('E', __('error'), __('aff_object_cant_delete'));

                return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.manage");
            }
        }
    }

    if (isset($_REQUEST['commission_id'])) {
        $plan_id = fn_delete_affiliate_commissions((array) $_REQUEST['commission_id'], $_REQUEST['plan_id']);

        return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.update?plan_id=$plan_id&selected_section=multi_tier_affiliates");
    } elseif (isset($_REQUEST['product_id'])) {
        $plan_id = fn_delete_affiliate_products((array) $_REQUEST['product_id'], $_REQUEST['plan_id']);

        return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.update?plan_id=$plan_id&selected_section=linked_products");
    } elseif (isset($_REQUEST['category_id'])) {
        $plan_id = fn_delete_affiliate_categories((array) $_REQUEST['category_id'], $_REQUEST['plan_id']);

        return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.update?plan_id=$plan_id&selected_section=linked_categories");
    } elseif (isset($_REQUEST['promotion_id'])) {
        $plan_id = fn_delete_affiliate_coupons((array) $_REQUEST['promotion_id'], $_REQUEST['plan_id']);

        return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.update?plan_id=$plan_id&selected_section=coupons");
    } else {
        fn_delete_affiliate_plans((array) $_REQUEST['plan_id']);
    }

    return array(CONTROLLER_STATUS_REDIRECT, "affiliate_plans.manage");
}

//
// [Functions]
//

function fn_delete_affiliate_coupons($promotion_ids, $plan_id)
{
    $plan_data = fn_get_affiliate_plan_data($plan_id, DESCR_SL);
    $_promotion_ids = $plan_data['promotion_ids'];
    foreach ($_promotion_ids as $promotion_id => $prod_name) {
        if (in_array($promotion_id, $promotion_ids)) {
            unset($_promotion_ids[$promotion_id]);
        }
    }
    $plan_data['promotion_ids'] = $_promotion_ids;

    return fn_update_affiliate_plan($plan_data, $plan_id, DESCR_SL);
}

function fn_delete_affiliate_categories($category_ids, $plan_id)
{
    $plan_data = fn_get_affiliate_plan_data($plan_id, DESCR_SL);
    $_categories_ids = $plan_data['category_ids'];
    if (!empty($_categories_ids) && is_array($_categories_ids)) {
        foreach ($_categories_ids as $cat_id=>$prod_name) {
            if (in_array($cat_id, $category_ids)) {
                unset($_categories_ids[$cat_id]);
            }
        }
    }
    $plan_data['category_ids'] = $_categories_ids;

    return fn_update_affiliate_plan($plan_data, $plan_id, DESCR_SL);
}

function fn_delete_affiliate_products($product_ids, $plan_id)
{
    $plan_data = fn_get_affiliate_plan_data($plan_id, DESCR_SL);
    $_products_ids = $plan_data['product_ids'];
    if (!empty($_products_ids) && is_array($_products_ids)) {
        foreach ($_products_ids as $prod_id => $prod_name) {
            if (in_array($prod_id, $product_ids)) {
                unset($_products_ids[$prod_id]);
            }
        }
    }
    $plan_data['product_ids'] = $_products_ids;

    return fn_update_affiliate_plan($plan_data, $plan_id, DESCR_SL);
}

function fn_delete_affiliate_commissions($commission_ids, $plan_id)
{
    $plan_data = fn_get_affiliate_plan_data($plan_id, DESCR_SL);
    if (!empty($plan_data)) {
        foreach ($commission_ids as $com_id) {
            unset($plan_data['commissions'][$com_id]);
        }

        return fn_update_affiliate_plan($plan_data, $plan_id, DESCR_SL);
    }

    return $plan_id;
}

//
// Delete affiliate plans
//
function fn_delete_affiliate_plans($affiliate_plans_ids)
{
    if (!empty($affiliate_plans_ids)) {
        if (!is_array($affiliate_plans_ids)) {
            $affiliate_plans_ids = explode(',', $affiliate_plans_ids);
        }
        db_query("DELETE FROM ?:common_descriptions WHERE object_holder = 'affiliate_plans' AND object_id IN (?n)", $affiliate_plans_ids);
        db_query("DELETE FROM ?:affiliate_plans WHERE plan_id IN (?n)", $affiliate_plans_ids);

        return true;
    }

    return false;
}

//
// Update affiliate plan
//
function fn_update_affiliate_plan($data, $plan_id, $lang_code = DESCR_SL)
{
    if (isset($data['commissions'])) {
        $data['commissions'] = array_map('floatval', $data['commissions']);
        $data['commissions'] = implode(';', $data['commissions']);
    }

    if (isset($data['payout_types'])) {
        $data['payout_types'] = fn_check_payout_value($data['payout_types']);
        $data['payout_types'] = serialize($data['payout_types']);
    }

    if (isset($data['sales']) || isset($data['product_ids'])) {
        $data['product_ids'] = isset($data['sales']) ? $data['sales'] : $data['product_ids'];
        $data['product_ids'] = fn_check_payout_value($data['product_ids']);
        $data['product_ids'] = serialize($data['product_ids']);
        unset($data['sales']);
    }

    if (isset($data['category_sales']) || isset($data['category_ids'])) {
        $data['category_ids'] = isset($data['category_sales']) ? $data['category_sales'] : $data['category_ids'];
        $data['category_ids'] = fn_check_payout_value($data['category_ids']);
        $data['category_ids'] = serialize($data['category_ids']);
    }

    if (isset($data['coupons']) || isset($data['promotion_ids'])) {
        $data['promotion_ids'] = isset($data['coupons']) ? $data['coupons'] : $data['promotion_ids'];
        $data['promotion_ids'] = fn_check_payout_value($data['promotion_ids']);
        $data['promotion_ids'] = serialize($data['promotion_ids']);
    }

    if (!empty($plan_id)) {
        db_query("UPDATE ?:affiliate_plans SET ?u WHERE plan_id = ?i", $data, $plan_id);
        $data['object'] = $data['name'];
        db_query("UPDATE ?:common_descriptions SET ?u WHERE object_id = ?i AND object_holder = 'affiliate_plans' AND lang_code = ?s", $data, $plan_id, $lang_code);
    } else {
        $plan_id = $data['plan_id'] = db_query("INSERT INTO ?:affiliate_plans ?e", $data);

        if (!empty($plan_id)) {
            $_data = array(
                'object' => $data['name'],
                'description' => $data['description'],
                'object_id' => $plan_id,
                'object_holder' => 'affiliate_plans'
            );

            foreach (fn_get_translation_languages() as $_data['lang_code'] => $_ldata) {
                db_query("INSERT INTO ?:common_descriptions ?e", $_data);
            }
        }
    }

    return $plan_id;
}

//
// value can not be less than 0
// if value type is percent then value can not be greater than 100
//
function fn_check_payout_value($values)
{
    if (!empty($values) && is_array($values)) {
        foreach ($values as $key => $item) {
            $values[$key]['value'] = floatval($item['value']);
            if ($values[$key]['value'] < 0) {
                $values[$key]['value'] = 0;
            }
            if (!empty($item['value_type']) && $item['value_type'] == 'P' && $values[$key]['value'] > 100) {
                $values[$key]['value'] = 100;
            }
        }
    }

    return $values;
}

//
// Get data of affiliate plans
//
function fn_get_affiliate_plans($params, $items_per_page = 0, $lang_code = CART_LANGUAGE)
{
    $default_params = array (
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:affiliate_plans as plans LEFT JOIN ?:common_descriptions as com_descr ON object_holder = 'affiliate_plans' AND object_id = plan_id AND lang_code = ?s WHERE 1 ORDER BY object", $lang_code);
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $plans = db_get_hash_array("SELECT plans.plan_id, plans.company_id, object as name, COUNT(user_id) as count_partners, status FROM ?:affiliate_plans as plans LEFT JOIN ?:common_descriptions as com_descr ON object_holder = 'affiliate_plans' AND object_id = plans.plan_id AND lang_code = ?s LEFT JOIN ?:aff_partner_profiles ON plans.plan_id = ?:aff_partner_profiles.plan_id AND ?:aff_partner_profiles.approved = 'A' WHERE 1 GROUP BY plans.plan_id ORDER BY object $limit ", 'plan_id', $lang_code);

    return array($plans, $params);
}

function fn_check_affiliate_plans_availability($data)
{
    if (!empty($data['share_objects'])) {
        $plan_affiliates = db_get_fields("SELECT user_id FROM ?:aff_partner_profiles WHERE plan_id = ?i", $data['plan_id']);
        foreach ($plan_affiliates as $user_id) {
            $affiliates_company_id = db_get_field("SELECT company_id FROM ?:users WHERE user_id = ?i", $user_id);
            if (!in_array($affiliates_company_id, $data['share_objects']['affiliate_plans'][$data['plan_id']])) {
                db_query("UPDATE ?:aff_partner_profiles SET plan_id = 0 WHERE user_id = ?i", $user_id);
            }
        }
    }

}
