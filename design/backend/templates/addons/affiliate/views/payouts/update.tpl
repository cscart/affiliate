{capture name="mainbox"}

{if $runtime.mode == "add"}
{literal}
<script type="text/javascript">
    //<![CDATA[
    var payout_amounts = new Array();
    var _payout_amounts = new Array();
    var action_amounts = new Array();
    var currencies_symbol = '';

    function fn_replace_payment_amount(partner_id, action_id, check_status)
    {
        if (typeof(payout_amounts[partner_id]) != 'undefined' && typeof(action_amounts[action_id]) != 'undefined') {
            payout_amounts[partner_id] += (check_status) ? action_amounts[action_id] : -action_amounts[action_id];
            Tygh.$('#id_td_amount_'+partner_id).html(currencies_symbol + Tygh.$.formatNum(payout_amounts[partner_id] / Tygh.currencies.secondary.coefficient, 2, false));
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
    currencies_symbol = "{$currencies.$secondary_currency.symbol nofilter}";
    //]]>
</script>
<form action="{""|fn_url}" method="POST" name="payout_{$user_id}_form">
{/if}

{include file="common/pagination.tpl"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

<table class="table table-middle">
<thead>
<tr>
    {if $runtime.mode == "add"}
    <th class="center">
        {include file="common/check_items.tpl" check_onclick="payout_amounts[`$user_id`] = (this.checked) ? _payout_amounts[`$user_id`] : 0.00; Tygh.$('#id_td_amount_`$user_id`').html(currencies_symbol + Tygh.$.formatNum(payout_amounts[`$user_id`], 2, true))"}</th>
    {/if}
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=action&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("action")}{if $search.sort_by == "action"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="10%" class="nowrap"><a class="cm-ajax" href="{"`$c_url`&sort_by=cost&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("cost")}{if $search.sort_by == "cost"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="20%">
    {__("customer")} / ({__("ip_address")})
    </th>
    <th width="10%"><a class="cm-ajax{if $search.sort_by == "banner"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=banner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("banner")}</a></th>
    <th width="25%">{__("additional_data")}</th>
    <th width="15%" class="right">{__("status")}</th>
</tr>
</thead>
{if $payout.actions}
{foreach from=$payout.actions key="action_id" item="action"}
<tr>
    {if $runtime.mode == "add"}
    <td>
        <script type="text/javascript">
            //<![CDATA[
            action_amounts[{$action_id}]={$action.amount};
            //]]>
        </script>
           <input type="checkbox" name="action_ids[{$user_id}][{$action_id}]" value="Y" onclick="fn_replace_payment_amount({$user_id}, {$action_id}, this.checked);" checked="checked" class="checkbox cm-item" /></td>
       {/if}
    <td>&nbsp;<span>{$action.title}</span></td>
    <td>{$action.date|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
    <td>{include file="common/price.tpl" value=$action.amount|round:2}</td>
    <td>
        <ul class="unstyled">
            {if $action.customer_firstname || $action.customer_lastname}
                <li><a href="{"profiles.update?user_id=`$action.customer_id`"|fn_url}">{$action.customer_firstname} {$action.customer_lastname}</a></li>{/if}
            {if $action.ip}<li><em>({$action.ip})</em></li>{/if}
        </ul></td>
    <td>{if $action.banner}<a href={"banners_manager.update?banner_id=`$action.banner_id`"|fn_url}>{$action.banner}</a>{else}&nbsp;&nbsp;---&nbsp;{/if}</td>
    <td>
        {include file="addons/affiliate/views/payouts/components/additional_data.tpl" data=$action.data assign="additional_data"}{if $additional_data|trim}{$additional_data nofilter}{else}&nbsp;&nbsp;---&nbsp;{/if}</td>
    </td>
    <td class="right">{if $action.payout_id}{__("paidup")}{elseif $action.approved == "Y"}{__("approved")}{else}&nbsp;&nbsp;---&nbsp;{/if}</td>
</tr>
{/foreach}
{else}
<tr class="no-items">
    <td colspan="{if $runtime.mode == "add"}8{else}7{/if}"><p>{__("no_items")}</p></td>
</tr>
{/if}
</table>

{include file="common/pagination.tpl"}

{capture name="buttons"}
    {if $runtime.mode == "add"}    
        {include file="buttons/save_cancel.tpl" but_text=__("add_payout") hide_second_button=true but_name="dispatch[payouts.m_add_payouts]" but_role="submit-link" but_target_form="payout_`$user_id`_form"}
    {/if}
    {if $runtime.mode != "add"}
        {include file="common/view_tools.tpl" url="payouts.update?payout_id="}
    {/if}
{/capture}

{capture name="sidebar"}
<div class="sidebar-row">
<h6>{__("information")}</h6>
<dl>
    <dt>{__("affiliate")}</dt>
    <dd><a href="{"partners.update?user_id=`$user_id`"|fn_url}">{$payout.partner.firstname} {$payout.partner.lastname}</a></dd>
    <dt>{__("email")}</dt>
    <dd>{$payout.partner.email}</dd>
    <dt>{__("plan")}</dt>
    <dd><a href="{"affiliate_plans.update?plan_id=`$payout.plan.plan_id`"|fn_url}">{$payout.plan.name}</a></dd>
    {if $payout.plan && $runtime.mode == "add"}
        <dt>{__("minimum_commission_payment")}</dt>
        <dd>{include file="common/price.tpl" value=$payout.plan.min_payment}</dd>
    {/if}
    <dt>{__("chart_period")}</dt>
    <dd>{$payout.date_range.min|date_format:$settings.Appearance.date_format}&nbsp;-&nbsp;{$payout.date_range.max|date_format:$settings.Appearance.date_format}</dd>
    <dt>{__("amount")}</dt>
    <dd><span id="id_td_amount_{$user_id}">{include file="common/price.tpl" value=$payout.amount}</span></dd>
</dl>
</div>
<hr>
{/capture}

</form>

{if !$smarty.foreach.for_payouts.last}<hr />{/if}
{/foreach}

{/if}
{/capture}

{include file="common/mainbox.tpl" title=__("payout") content=$smarty.capture.mainbox sidebar=$smarty.capture.sidebar buttons=$smarty.capture.buttons}