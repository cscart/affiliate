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

$schema['affiliate_plans.update'] = array (
    array (
        'title' => 'plans',
        'link' => 'affiliate_plans.manage'
    )
);
$schema['aff_statistics.view'] = array (
    array (
        'title' => 'approve_commissions',
        'link' => 'aff_statistics.approve'
    )
);
$schema['banners_manager.update'] = array (
    array (
        'title' => 'banners',
        'link' => 'banners_manager.manage?banner_type=%BANNER_TYPE&link_to=%LINK_TO'
    )
);
$schema['partners.update'] = array (
    array (
        'type' => 'search',
        'prev_dispatch' => 'partners.manage',
        'title' => 'search_results',
        'link' => 'partners.manage.last_view'
    ),
    array (
        'title' => 'affiliates',
        'link' => 'partners.manage.reset_view'
    )
);
$schema['partners.tree'] = array (
    array (
        'title' => 'affiliates',
        'link' => 'partners.manage'
    )
);
$schema['product_groups.update'] = array (
    array (
        'title' => 'product_groups',
        'link' => 'product_groups.manage?link_to=%LINK_TO'
    )
);
$schema['payouts.add'] = array (
    array (
        'title' => 'pay_affiliates',
        'link' => 'payouts.pay'
    )
);
$schema['payouts.update'] = array (
    array (
        'type' => 'search',
        'prev_dispatch' => 'payouts.manage',
        'title' => 'search_results',
        'link' => 'payouts.manage.last_view'
    ),
    array (
        'title' => 'payouts',
        'link' => 'payouts.manage.reset_view'
    )
);

return $schema;
