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
    return;
}

if (!empty($auth['user_id'])) {

    fn_add_breadcrumb(__('affiliate'));

    $partner_data = fn_get_partner_data($auth['user_id']);

    if (!empty($partner_data)) {

        $partner_data['total_payouts'] = db_get_field("SELECT SUM(amount) FROM ?:affiliate_payouts WHERE partner_id = ?i", $auth['user_id']);
        $cnt_period = Registry::ifGet('addons.affiliate.number_last_periods', 10);
        $start_date = fn_get_date_of_payment_period($cnt_period);
        if (!empty($start_date)) {
            $last_payouts = array();
            $k = $cnt_period;
            $max_amount = 0;
            $cur_date = getdate(TIME);
            $checkpoint_1 = 1;
            $checkpoint_2 = 16;
            $checkpoint_return = ($cur_date['mday']<$checkpoint_2) ? false : true;
            while (!empty($k)) {
                switch (Registry::get('addons.affiliate.payment_period')) {
                    case '1w':
                        $end_date = $start_date + 7 * 24 * 3600;
                        break;
                    case '2w':
                        if ($checkpoint_return) {
                            $_date = getdate($start_date);
                            $end_date = mktime(0, 0, 0, $_date['mon'], $checkpoint_1, $_date['year']);
                            $end_date = strtotime('+1 month', $end_date);
                        } else {
                            $end_date = $start_date + 15 * 24 * 3600;
                        }
                        $checkpoint_return = !$checkpoint_return;
                        break;
                    case '1m':
                        $end_date = strtotime("+1 month", $start_date);
                        break;
                }
                $last_payouts[$k]['amount'] = db_get_field("SELECT SUM(amount) FROM ?:aff_partner_actions WHERE partner_id = ?i AND approved = 'Y' AND date >= ?i AND date < ?i", $auth['user_id'], $start_date, $end_date);
                if ($max_amount < $last_payouts[$k]['amount']) {
                    $max_amount = $last_payouts[$k]['amount'];
                }
                $last_payouts[$k]['range']['start'] = $start_date;
                $last_payouts[$k]['range']['end'] = $end_date - 1;
                $start_date = $end_date;
                --$k;
            }
        }
        if (empty($max_amount)) {
            $max_amount = 1;
        }
        Registry::get('view')->assign('total_commissions', db_get_field("SELECT SUM(amount) FROM ?:aff_partner_actions WHERE partner_id = ?i AND approved = 'Y'", $auth['user_id']));
        Registry::get('view')->assign('max_amount', $max_amount);
        Registry::get('view')->assign('last_payouts', $last_payouts);
        Registry::get('view')->assign('partner', $partner_data);

        $partners = array($auth['user_id'] => fn_get_partners_tree_by_partner_id($auth['user_id']));
        Registry::get('view')->assign('partners', $partners);
        Registry::get('view')->assign('affiliate_plans', fn_get_affiliate_plans_list());
    }
}
/** /Body **/
