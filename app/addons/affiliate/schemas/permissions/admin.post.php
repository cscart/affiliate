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

$schema['aff_statistics'] = array (
    'permissions' => 'manage_affiliate',
);
$schema['banners_manager'] = array (
    'permissions' => 'manage_affiliate',
);
$schema['payouts'] = array (
    'permissions' => 'manage_affiliate',
);
$schema['product_groups'] = array (
    'permissions' => 'manage_affiliate',
);
$schema['partners'] = array (
    'permissions' => 'manage_affiliate',
);
$schema['affiliate_plans'] = array (
    'permissions' => 'manage_affiliate',
);
$schema['tools']['modes']['update_status']['param_permissions']['table']['aff_groups'] = 'manage_affiliate';
$schema['tools']['modes']['update_status']['param_permissions']['table']['affiliate_plans'] = 'manage_affiliate';
$schema['tools']['modes']['update_status']['param_permissions']['table']['aff_banners'] = 'manage_affiliate';
$schema['tools']['modes']['update_status']['param_permissions']['table']['affiliate_payouts'] = 'manage_affiliate';

return $schema;
