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
    'func' => array('fn_get_affiliate_plan_name', '@plan_id'),
    'text' => 'plan'
);
$schema['product_groups.update'] = array (
    'func' => array('fn_get_group_name', '@group_id'),
    'text' => 'product_group'
);
$schema['banners_manager.update'] = array (
    'func' => array('fn_get_aff_banner_name', '@banner_id'),
    'text' => 'banner'
);

return $schema;
