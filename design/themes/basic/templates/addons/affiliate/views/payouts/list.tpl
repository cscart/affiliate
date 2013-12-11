{include file="addons/affiliate/common/affiliate_menu.tpl"}
{include file="addons/affiliate/views/payouts/components/payout_search.tpl"}

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
    {if $settings.General.use_email_as_login != "Y"}
    <th><a class="{$ajax_class}" href="{"`$c_url`&sort_by=username&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("username")}</a>{if $search.sort_by == "username"}{$sort_sign nofilter}{/if}</th>
    {/if}
    <th><a class="{$ajax_class}" href="{"`$c_url`&sort_by=partner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate")}</a>{if $search.sort_by == "partner"}{$sort_sign nofilter}{/if}</th>
    <th style="width: 15%"><a class="{$ajax_class}" href="{"`$c_url`&sort_by=amount&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("amount")}</a>{if $search.sort_by == "amount"}{$sort_sign nofilter}{/if}</th>
    <th style="width: 15%"><a class="{$ajax_class}" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}</a>{if $search.sort_by == "date"}{$sort_sign nofilter}{/if}</th>
    <th style="width: 20%"><a class="{$ajax_class}" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("status")}</a>{if $search.sort_by == "status"}{$sort_sign nofilter}{/if}</th>
    <th style="width: 10%">&nbsp;</th>
</tr>
{foreach from=$payouts key="payout_id" item="payout"}
<tr {cycle values=",class=\"table-row\""}>
    {if $settings.General.use_email_as_login != "Y"}
    <td>{$payout.user_login}</td>
    {/if}
    <td>{$payout.lastname} {$payout.firstname}</td>
    <td class="right">{include file="common/price.tpl" value=$payout.amount}</td>
    <td class="center">{$payout.date|date_format:"`$settings.Appearance.date_format` `$settings.Appearance.time_format`"}</td>
    <td class="center">
            {if $payout.status=="O"}{__("open")}{else}{__("successful")}{/if}
    </td>
    <td class="right">
        {include file="buttons/button.tpl" but_text=__("details") but_href="`$runtime.controller`.update?payout_id=`$payout_id`" but_role="text"}
    </td>
</tr>
{foreachelse}
<tr>
    <td colspan="{if $settings.General.use_email_as_login != "Y"}5{else}6{/if}"><p class="no-items">{__("no_payouts_found")}</p></td>
</tr>
{/foreach}
</table>

{include file="common/pagination.tpl"}

{capture name="mainbox_title"}
    {__(affiliate)} <span class="subtitle">/ {__("payouts")}</span>
{/capture}
