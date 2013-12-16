{include file="addons/affiliate/common/affiliate_menu.tpl"}
{if $runtime.mode == "add"}
{literal}
<script type="text/javascript">
    //<![CDATA[
    var payout_amounts = new Array();
    var _payout_amounts = new Array();
    var action_amounts = new Array();

    function fn_replace_payment_amount(partner_id, action_id, check_status)
    {
        if (typeof(payout_amounts[partner_id]) != 'undefined' && typeof(action_amounts[action_id]) != 'undefined') {
            payout_amounts[partner_id] += (check_status)?action_amounts[action_id]:-action_amounts[action_id];
            Tygh.$('#id_td_amount_'+partner_id).html(Tygh.$.formatNum(payout_amounts[partner_id] / currencies.secondary.coefficient, 2, false));
        }
    }
    //]]>
</script>
{/literal}
{/if}

{if $payouts}
{foreach from=$payouts key="user_id" item="payout" name="for_payouts"}

{if $runtime.mode == "add"}
<script type="text/javascript">
    //<![CDATA[
    payout_amounts[{$user_id}] = {$payout.amount};
    _payout_amounts[{$user_id}] = {$payout.amount};
    //]]>
</script>
<form action="{""|fn_url}" method="POST" name="payout_{$user_id}_form">
{/if}

<div class="clearfix affiliate-plan-block payout-info">
    <div class="affiliate-plan float-left">
        <dl class="clearfix">
            <dt class="no-border">{__("affiliate")}:</dt>
            <dd class="no-border">{$payout.partner.firstname} {$payout.partner.lastname}</dd>

            <dt>{__("email")}:</dt>
            <dd>{$payout.partner.email}</dd>

            {if $payout.plan && $runtime.mode=="add"}
                <dt>{__("affiliate_plan")}:</dt>
                <dd><a href="affiliate_plans.manage">{$payout.plan.name}</a></dd>

                <dt>{__("minimum_commission_payment")}:</dt>
                <dd>{include file="common/price.tpl" value=$payout.plan.min_payment}</dd>
            {/if}

            <dt>{__("chart_period")}:</dt>
            <dd>{$payout.date_range.min|date_format:$settings.Appearance.date_format} - {$payout.date_range.max|date_format:$settings.Appearance.date_format}</dd>

            <dt>{__("amount")}:</dt>
            <dd>{include file="common/price.tpl" value=$payout.amount}</dd>
        </dl>
    </div>
</div>

{include file="common/subheader.tpl" title=__("actions")}

{include file="common/pagination.tpl"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{if $search.sort_order_rev == "asc"}
{assign var="sort_sign" value="<i class=\"icon-down-dir\"></i>"}
{else}
{assign var="sort_sign" value="<i class=\"icon-up-dir\"></i>"}
{/if}
{if !$config.tweaks.disable_dhtml}
    {assign var="ajax_class" value="cm-ajax"}
{/if}

<table class="table table-width">
<tr>
    {if $runtime.mode=="add"}
    <td style="width: 1%">
        <input type="checkbox" name="check_all" value="Y" onclick="payout_amounts[{$user_id}] = (this.checked) ? _payout_amounts[{$user_id}] : 0.00; Tygh.$('#id_td_amount_{$user_id}').html(Tygh.$.formatNum(payout_amounts[{$user_id}], 2, true));" title="{__("check_uncheck_all")}" checked="checked" class="checkbox cm-check-items"/></td>
    {/if}
    <th><a class="{$ajax_class}" href="{"`$c_url`&sort_by=action&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("action")}</a>{if $search.sort_by == "action"}{$sort_sign nofilter}{/if}</th>
    <th><a class="{$ajax_class}" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}</a>{if $search.sort_by == "date"}{$sort_sign nofilter}{/if}</th>
    <th><a class="{$ajax_class}" href="{"`$c_url`&sort_by=cost&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("cost")}</a>{if $search.sort_by == "cost"}{$sort_sign nofilter}{/if}</th>
    <th>{__("customer")}</th>
    <th><a class="{$ajax_class}" href="{"`$c_url`&sort_by=banner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("banner")}</a>{if $search.sort_by == "banner"}{$sort_sign nofilter}{/if}</th>
    <th>{__("additional_data")}</th>
    <th>{__("status")}</th>
</tr>
{foreach from=$payout.actions key="action_id" item="action"}
<tr {cycle values=",class=\"table-row\""}>
    {if $runtime.mode=="add"}
    <td>
        <script type="text/javascript">
            //<![CDATA[
            action_amounts[{$action_id}]={$action.amount};
            //]]>
        </script>
           <input type="checkbox" name="action_ids[{$user_id}][{$action_id}]" value="Y" onclick="fn_replace_payment_amount({$user_id}, {$action_id}, this.checked);" checked="checked" class="check-item"/></td>
       {/if}
    <td class="strong">&nbsp;{$action.title}</td>
    <td>{$action.date|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
    <td>{include file="common/price.tpl" value=$action.amount|round:2}</td>
    <td>
        {if $action.customer_firstname || $action.customer_lastname}{$action.customer_firstname} {$action.customer_lastname}{/if}</td>
    <td>{if $action.banner}{$action.banner}{else}&nbsp;&nbsp;---&nbsp;{/if}</td>
    <td>
        {include file="addons/affiliate/views/aff_statistics/components/additional_data.tpl" data=$action.data}</td>
    <td>{if $action.payout_id}{__("paidup")}{elseif $action.approved=="Y"}{__("approved")}{else}&nbsp;&nbsp;---&nbsp;{/if}</td>
</tr>
{foreachelse}
<tr>
    <td colspan="8"><p class="no-items">{__("text_aff_no_actions_found")}</p></td>
</tr>
{/foreach}
</table>

{include file="common/pagination.tpl"}

{if $runtime.mode=="add"}
    <div class="buttons-container">
    {include file="buttons/button.tpl" but_text=__("affiliate_add_payout") but_name="dispatch[payouts.do_m_add_payouts]" but_meta="cm-process-items" but_role="action"}
    </div>
</form>
{/if}
{if !$smarty.foreach.for_payouts.last}<hr />{/if}
{/foreach}

{/if}

{capture name="mainbox_title"}{__("payout")}{/capture}
