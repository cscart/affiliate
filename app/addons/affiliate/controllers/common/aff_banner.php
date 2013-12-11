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

if (!defined('BOOTSTRAP')) { die('Access denied'); }

ob_start();

if ($mode == 'view') {
    $type = empty($_REQUEST['type']) ? 'js_content' : $_REQUEST['type'];
    $aff_id = empty($_REQUEST['aff_id']) ? 0 : $_REQUEST['aff_id'];

    if (!empty($_REQUEST['bid'])) {
        $banner_data = fn_get_aff_banner_data($_REQUEST['bid'], CART_LANGUAGE, true);
        $banner_data['product_ids'] = empty($_REQUEST['product_ids']) ? '' : $_REQUEST['product_ids'];
        $banner_data['new_window'] = empty($_REQUEST['force_new_window']) ? $banner_data['new_window'] : $_REQUEST['force_new_window'];
        $_mode = 'view'; // FIXME
    } else {
        $banner_data = array(
            'type' => 'P',
            'banner_id' => '',
            'align' => empty($_REQUEST['align']) ? 'center' : $_REQUEST['align'],
            'image' => empty($_REQUEST['image']) ? 'N' : $_REQUEST['image'],
            'product_name' => empty($_REQUEST['product_name']) ? 'N' : $_REQUEST['product_name'],
            'short_description' => empty($_REQUEST['short_description']) ? 'N' : $_REQUEST['short_description'],
            'width' => empty($_REQUEST['width']) ? '' : abs(intval($_REQUEST['width'])),
            'height' => empty($_REQUEST['height']) ? '' : abs(intval($_REQUEST['height'])),
            'border' => empty($_REQUEST['border']) ? '' : $_REQUEST['border'],
            'to_cart' => empty($_REQUEST['to_cart']) ? '' : $_REQUEST['to_cart'],
            'new_window' => empty($_REQUEST['new_window']) ? '' : $_REQUEST['new_window'],
            'lang_code' => CART_LANGUAGE,
            'product_ids' => ''
        );
        $_mode = 'demo';
    }

    $_banner_html = fn_get_aff_banner_html($type, $banner_data, $_mode, $aff_id);
    if ($type != 'iframe_content' && $type != 'js') {
        header('Content-type: text/javascript');
        echo $_banner_html;
    } else {
        echo '<div id="id_example_banner"><script type="text/javascript" language="javascript">'. $_banner_html .'</script><!--id_example_banner--></div>';
    }
}

ob_end_flush();
exit;
