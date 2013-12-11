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

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    fn_trusted_vars('group', 'groups_data');
    $suffix = '';

    if ($mode == 'm_delete') {
        if (!empty($_REQUEST['group_ids'])) {
            fn_delete_affiliate_groups($_REQUEST['group_ids']);
        }

        $suffix = '.manage';
    }

    if ($mode == 'update') {

        $group_id = fn_update_affiliate_group($_REQUEST['group'], $_REQUEST['group_id'], DESCR_SL);

        $suffix = ".update?group_id=$group_id&link_to=" . $_REQUEST['group']['link_to'];
        if ($group_id === false) {
            fn_set_notification('E', __('error'), __('aff_cant_create_group'));

            return array(CONTROLLER_STATUS_REDIRECT, 'product_groups.manage');
        }
    }

    return array(CONTROLLER_STATUS_OK, "product_groups$suffix");
}

if ($mode == 'update') {
    $group = fn_get_group_data($_REQUEST['group_id'], DESCR_SL);

    if (fn_allowed_for('ULTIMATE')) {
        if (Registry::get('runtime.company_id')) {
            if ($group['company_id'] != Registry::get('runtime.company_id')) {
                unset($group);
            }
        }
    }

    if (empty($group)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    Registry::get('view')->assign('group', $group);

} elseif ($mode == 'add') {

    $link_to = empty($_REQUEST['link_to']) ? 'C' : $_REQUEST['link_to'];

    Registry::get('view')->assign('link_to', $link_to);

} elseif ($mode == 'manage') {

    Registry::set('navigation.tabs', array (
        'C' => array(
            'title' => __('group_for_category'),
            'href' => "product_groups.manage?link_to=C",
        ),
        'P' => array(
            'title' => __('group_for_product'),
            'href' => "product_groups.manage?link_to=P",
        ),
        'U' => array(
            'title' => __('url'),
            'href' => "product_groups.manage?link_to=U",
        ),
    ));
    // [/Page sections]

    list($groups, $search) = fn_get_groups($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Registry::get('view')->assign('groups', $groups);
    Registry::get('view')->assign('search', $search);
    Registry::get('view')->assign('link_to', $search['link_to']);

} elseif ($mode == 'delete') {
    if (!empty($_REQUEST['group_id'])) {
        fn_delete_affiliate_groups((array) $_REQUEST['group_id']);
    } else {
        fn_set_notification('E', __('error'), __('error_no_data'));
    }

    return array(CONTROLLER_STATUS_REDIRECT, "product_groups.manage");
}

function fn_delete_affiliate_groups($group_ids)
{
    $groups_names = array();
    $skip_record = false;
    foreach ($group_ids as $group_id) {
        if (fn_allowed_for('ULTIMATE')) {
            if (Registry::get('runtime.company_id')) {
                $group_company_id = db_get_field("SELECT company_id FROM ?:aff_groups WHERE group_id = ?i", $group_id);
                if ($group_company_id != Registry::get('runtime.company_id')) {
                    $skip_record = true;
                }
            }
        }

        if (!$skip_record) {
            $deleted_groups_names[] = fn_get_group_name($group_id, DESCR_SL);
            db_query("DELETE FROM ?:aff_group_descriptions WHERE group_id = ?i", $group_id);
            db_query("DELETE FROM ?:aff_groups WHERE group_id = ?i", $group_id);
        } else {
            $undeleted_groups_names[] = fn_get_group_name($group_id, DESCR_SL);
        }
    }

    if (!empty($deleted_groups_names)) {
        $groups_names = '&nbsp;-&nbsp;' . implode('<br />&nbsp;-&nbsp;', $deleted_groups_names);
        fn_set_notification('N', __('information'), __('deleted_product_groups') . ':<br />' . $groups_names);
    }

    if (!empty($undeleted_groups_names)) {
        $groups_names = '&nbsp;-&nbsp;' . implode('<br />&nbsp;-&nbsp;', $undeleted_groups_names);
        fn_set_notification('W', __('warning'), __('undeleted_product_groups') . ':<br />' . $groups_names);
    }
}

function fn_update_affiliate_group($data, $group_id, $lang_code = DESCR_SL)
{
    if (fn_allowed_for('ULTIMATE')) {
        if (Registry::get('runtime.company_id')) {
            $data['company_id'] = Registry::get('runtime.company_id');

            if (!empty($group_id)) {
                $group_company_id = db_get_field("SELECT company_id FROM ?:aff_groups WHERE group_id = ?i", $group_id);
                if ($group_company_id != $data['company_id']) {
                    return false;
                }
            }
        } else {
            return false;
        }
    }

    if (!empty($group_id)) {
        db_query("UPDATE ?:aff_groups SET ?u WHERE group_id = ?i", $data, $group_id);
        db_query("UPDATE ?:aff_group_descriptions SET ?u WHERE group_id = ?i AND lang_code = ?s", $data, $group_id, $lang_code);
    } else {
        $group_id = $data['group_id'] = db_query("INSERT INTO ?:aff_groups ?e", $data);

        foreach (fn_get_translation_languages() as $data['lang_code'] => $v) {
            db_query("INSERT INTO ?:aff_group_descriptions ?e", $data);
        }
    }

    return $group_id;
}

function fn_get_groups($params, $items_per_page = 0, $lang_code = DESCR_SL)
{
    // Set default values to input params
    $default_params = array (
        'link_to' => 'C',
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    $condition = '';
    if (!empty($params['link_to'])) {
        $condition .= db_quote(" AND ?:aff_groups.link_to IN (?a)", $params['link_to']);
    }

    if (!empty($params['is_avail'])) {
        $condition .= " AND ?:aff_groups.status = 'A'";
    }

    if (fn_allowed_for('ULTIMATE')) {
        if (Registry::get('runtime.company_id')) {
            $condition .= db_quote(" AND ?:aff_groups.company_id = ?i", Registry::get('runtime.company_id'));
        }
    }

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:aff_groups LEFT JOIN ?:aff_group_descriptions ON ?:aff_group_descriptions.group_id = ?:aff_groups.group_id AND ?:aff_group_descriptions.lang_code = ?s WHERE 1 ?p ORDER BY ?:aff_group_descriptions.name", $lang_code, $condition);
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $groups = db_get_hash_array("SELECT * FROM ?:aff_groups LEFT JOIN ?:aff_group_descriptions ON ?:aff_group_descriptions.group_id = ?:aff_groups.group_id AND ?:aff_group_descriptions.lang_code = ?s WHERE 1 ?p ORDER BY ?:aff_group_descriptions.name $limit", 'group_id', $lang_code, $condition);

    if (!empty($groups) && is_array($groups)) {
        foreach ($groups as $group_id => $group_data) {
            $groups[$group_id] = fn_convert_group_data($group_data);
        }
    }

    return array($groups, $params);
}

// \Functions
