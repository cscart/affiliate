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

if (Registry::get('addons.affiliate.show_affiliate_code') == 'Y' && !empty($_SESSION['partner_data']) && !empty($_SESSION['partner_data']['partner_id'])) {
    Registry::get('view')->assign('partner_code', fn_dec2any($_SESSION['partner_data']['partner_id']));
}

if (empty($auth['is_affiliate']) && in_array(Registry::get('runtime.controller'), Registry::get('affiliate_controllers'))) {
    return array(CONTROLLER_STATUS_REDIRECT, fn_url());
}
