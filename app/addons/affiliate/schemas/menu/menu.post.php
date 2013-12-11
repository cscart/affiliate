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

$schema['central']['customers']['items']['affiliates'] = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'profiles.manage?user_type=P',
    'position' => 350
);

$schema['central']['marketing']['items']['affiliates'] = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'partners.manage',
    'subitems' => array(
        'product_groups' => array(
            'href' => 'product_groups.manage',
            'position' => 100
        ),
        'affilate_banners_manager' => array(
            'href' => 'banners_manager.manage',
            'position' => 200,
            'subitems' => array(
                'text_banners' => array(
                    'href' => 'banners_manager.manage?banner_type=T',
                    'position' => 100,
                ),
                'graphic_banners' => array(
                    'href' => 'banners_manager.manage?banner_type=G',
                    'position' => 200,
                ),
                'product_banners' => array(
                    'href' => 'banners_manager.manage?banner_type=P',
                    'position' => 300,
                )
            )
        ),
        'plans' => array(
            'href' => 'affiliate_plans.manage',
            'position' => 300
        ),
        'affiliate_partners' => array(
            'href' => 'partners.manage',
            'position' => 400
        ),
        'approve_commissions' => array(
            'href' => 'aff_statistics.approve',
            'position' => 500
        ),
        'pay_affiliates' => array(
            'href' => 'payouts.pay',
            'position' => 600
        ),
        'payouts' => array(
            'href' => 'payouts.manage',
            'position' => 700
        ),
        'accounting_history' => array(
            'href' => 'payouts.previous',
            'position' => 800
        ),
    ),
);

return $schema;
