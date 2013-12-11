<div class="sidebar-row">
<h6>{__("search")}</h6>
<form action="{""|fn_url}" name="general_stats_search_form" method="get">
{capture name="simple_search"}
<div class="sidebar-field">
    <label for="partner_id">{__("affiliate")}:</label>
    <select name="partner_id" id="partner_id">
        <option value="0" {if !$search.partner_id}selected="selected"{/if}> -- </option>
        {html_options options=$partner_list selected=$search.partner_id}
    </select>
</div>
<div class="sidebar-field">
    <label for="plan_id">{__("plan")}:</label>
    <select name="plan_id" id="plan_id">
        <option value="0" {if !$search.plan_id}selected="selected"{/if}> -- </option>
        {html_options options=$list_plans selected=$search.plan_id}
    </select>
</div>
<div class="sidebar-field">
    <label for="amount_from">{__("amount")} ({$currencies.$primary_currency.symbol nofilter}):</label>
    <input type="text" name="amount_from" id="amount_from" value="{$search.amount_from}" size="6" class="input-small" /> - <input type="text" name="amount_to" value="{$search.amount_to}" size="6" class="input-small"/>
</div>
{/capture}
{capture name="advanced_search"}

<div class="group form-horizontal">
<div class="control-group">
    {include file="common/period_selector.tpl" period=$search.period form_name="general_stats_search_form" time_from=$search.start_date time_to=$search.end_date display="form"}
</div>
</div>

<div class="group form-horizontal">
<div class="control-group">
    <label class="control-label">{__("action")}:</label>
    <div class="controls checkbox-list">
        {html_checkboxes options=$payout_options name="action" selected=$search.action columns=4}
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="zero_actions">{__("show_zero_actions")}:</label>
    <div class="controls">
    <select name="zero_actions" id="zero_actions">
        <option value="0" {if !$search.zero_actions}selected="selected"{/if}>{__("not_show")}</option>
        <option value="S" {if $search.zero_actions == "S"}selected="selected"{/if}>{__("show")}</option>
        <option value="Y" {if $search.zero_actions == "Y"}selected="selected"{/if}>{__("only_zero_actions")}</option>
    </select>
    </div>
</div>
</div>

<div class="group form-horizontal">
<div class="control-group">
    <label class="control-label">{__("status")}:</label>
    <div class="controls checkbox-list">
        {html_checkboxes options=$status_options name="status" selected=$search.status columns=3}
    </div>
</div>
</div>
{/capture}

{include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch=$dispatch view_type="aff_stats"}

</form>
</div>