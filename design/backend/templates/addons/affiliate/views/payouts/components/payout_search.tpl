<div class="sidebar-row">
<h6>{__("search")}</h6>

<form name="payout_search_form" action="{""|fn_url}" method="get">
{capture name="simple_search"}
<div class="sidebar-field">
    <label for="elm_partner_id">{__("affiliate")}:</label>
    <select name="partner_id" id="elm_partner_id">
        <option value="0" {if !$search.partner_id}selected="selected"{/if}> -- </option>
        {html_options options=$partner_list selected=$search.partner_id}
    </select>
</div>
<div class="sidebar-field">
    <label for="elm_status">{__("status")}:</label>
    <select name="status" id="elm_status">
        <option value=""> -- </option>
        <option value="O" {if $search.status == "O"}selected="selected"{/if}>{__("open")}</option>
        <option value="S" {if $search.status == "S"}selected="selected"{/if}>{__("successful")}</option>
    </select>
</div>
<div class="sidebar-field">
    <label for="amount_from">{__("amount")} ({$currencies.$primary_currency.symbol nofilter}):</label>
    <input type="text" name="amount_from" size="7" value="{$search.amount_from}" class="input-small" id="amount_from" /> &ndash; <input type="text" name="amount_to" size="7" value="{$search.amount_to}" class="input-small" />
</div>
{/capture}

{capture name="advanced_search"}
<div class="control-group group">
    {include file="common/period_selector.tpl" period=$search.period form_name="payout_search_form" time_from=$search.time_from  time_to=$search.time_to display="form"}
</div>
{/capture}

{include file="common/advanced_search.tpl" dispatch="payouts.manage" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search view_type="payouts"}

</form>
</div>