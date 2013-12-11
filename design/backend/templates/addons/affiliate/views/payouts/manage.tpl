{capture name="mainbox"}

<form action="{""|fn_url}" method="post" name="payouts_form">

{include file="common/pagination.tpl"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

{if $payouts}
<table width="100%" class="table table-middle">
<thead>
<tr>
    <th width="1%" class="center">
        {include file="common/check_items.tpl"}</th>
    <th width="55%"><a class="cm-ajax" href="{"`$c_url`&sort_by=partner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate")}{if $search.sort_by == "partner"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=amount&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("amount")}{if $search.sort_by == "amount"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th>&nbsp;</th>
    <th width="15%" class="right"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("status")}{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
</tr>
</thead>

{foreach from=$payouts key="payout_id" item="payout"}
<tr>
    <td width="1%" class="left">
    <input type="checkbox" name="payout_ids[]" value="{$payout.payout_id}" class="cm-item" /></td>
    <td><a href="{"partners.update?user_id=`$payout.partner_id`"|fn_url}">{$payout.lastname} {$payout.firstname}</a></td>
    <td><input type="hidden" name="payouts[{$payout_id}][amount]" value="{$payout.amount}" />{include file="common/price.tpl" value=$payout.amount}</td>
    <td>{$payout.date|date_format:"`$settings.Appearance.date_format` `$settings.Appearance.time_format`"}</td>
    <td class="nowrap">
        {capture name="items_list"}
            <li>{btn type="list" text=__("delete") href="payouts.delete?payout_id=`$payout.payout_id`"}</li>
            <li>{btn type="list" text=__("view") href="payouts.update?payout_id=`$payout_id`"}</li>
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.items_list}
        </div>
    </td>
    <td class="right">
        {include file="common/select_popup.tpl" id=$payout_id status=$payout.status items_status="affiliate"|fn_get_predefined_statuses object_id_name="payout_id" table="affiliate_payouts"}

    </td>
</tr>
{/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl"}
</form>
{/capture}

{capture name="buttons"}
    {capture name="items_list"}
        {if $payouts}
            <li>{btn type="delete_selected" dispatch="dispatch[payouts.m_delete]" form="payouts_form"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.items_list}
{/capture}

{capture name="sidebar"}
    {include file="common/saved_search.tpl" view_type="payouts" dispatch="payouts.manage"}
    {include file="addons/affiliate/views/payouts/components/payout_search.tpl"}
{/capture}

{include file="common/mainbox.tpl" title=__("payouts") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar}