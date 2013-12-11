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

$schema['affiliate_plans'] = array(
    'controller' => 'affiliate_plans',
    'mode' => 'update',
    'type' => 'tpl_tabs',
    'params' => array(
        'object_id' => '@plan_id',
        'object' => 'affiliate_plans'
    ),
    'table' => array(
        'name' => 'affiliate_plans',
        'key_field' => 'plan_id',
    ),
    'request_object' => 'affiliate_plan',
    'have_owner' => true,
);

return $schema;
