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

//
// View product details
//
if (!empty($_REQUEST['product_id'])) {
    $product = fn_get_product_data($_REQUEST['product_id'], $auth, CART_LANGUAGE);

    if (empty($product)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    fn_gather_additional_product_data($product, true, true);

    Registry::get('view')->assign('product', $product);
    Registry::get('view')->display('addons/affiliate/views/banner_products/view.tpl');
    exit;
}
