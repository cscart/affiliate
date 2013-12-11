<div class="sidebar-row">
<h6>{__("search")}</h6>
<form name="partner_search_form" action="{""|fn_url}" method="get">

{capture name="simple_search"}
<div class="sidebar-field">
    <label for="elm_name">{__("name")}:</label>
    <input type="text" name="name" id="elm_name" value="{$search.name}" />
</div>
<div class="sidebar-field">
    <label for="elm_company">{__("company")}:</label>
    <input type="text" name="company" id="elm_company" value="{$search.company}" />
</div>
<div class="sidebar-field">
    <label for="elm_email">{__("email")}:</label>
    <input type="text" name="email" id="elm_email" value="{$search.email}" />
</div>
{/capture}

{capture name="advanced_search"}

<div class="row-fluid">
<div class="group form-horizontal span6">
{if $settings.General.use_email_as_login != "Y"}
<div class="control-group">
    <label class="control-label" for="elm_user_login">{__("username")}:</label>
    div.controls
    <input type="text" name="user_login" id="elm_user_login" value="{$search.user_login}" />
</div>
{/if}

    <div class="control-group">
        <label class="control-label" for="elm_address">{__("address")}:</label>
        <div class="controls">
            <input type="text" name="address" id="elm_address" value="{$search.address}" />
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="elm_city">{__("city")}:</label>
        <div class="controls">
            <input type="text" name="city" id="elm_city" value="{$search.city}" />
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="elm_zipcode">{__("zip_postal_code")}:</label>
        <div class="controls">
            <input type="text" name="zipcode" id="elm_zipcode" value="{$search.zipcode}" />
        </div>
    </div>
    
    <div class="control-group">
        <label class="control-label" for="srch_country">{__("country")}:</label>
        <div class="controls">
            <select id="srch_country" name="country" class="cm-country cm-location-search">
            <option value="">- {__("select_country")} -</option>
                {foreach from=$countries item=country key="code"}
                    <option value="{$code}" {if $smarty.request.country == $code}selected="selected"{/if}>{$country}</option>
                {/foreach}
            </select>
        </div>
    </div>
</div>

<div class="group form-horizontal span6">

    <div class="control-group">
        <label for="srch_state" class="control-label">{__("state")}:</label>
        <div class="controls">
        <select class="cm-state cm-location-search" id="srch_state" name="state">
            <option value="">- {__("select_state")} -</option>
        </select>
        <input type="text" id="srch_state_d" name="state" maxlength="64" value="{$search.state}" disabled="disabled" class="cm-state cm-location-search hidden" />
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="elm_approved">{__("status")}:</label>
        <div class="controls">
            <select name="approved" id="elm_approved">
                <option value="0" {if $search.approved == "0"}selected="selected"{/if}> -- </option>
                <option value="N" {if $search.approved == "N"}selected="selected"{/if}>{__("awaiting_approval")}</option>
                <option value="A" {if $search.approved == "A"}selected="selected"{/if}>{__("approved")}</option>
                <option value="D" {if $search.approved == "D"}selected="selected"{/if}>{__("Declined")}</option>
            </select>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="elm_plan_id">{__("plan")}:</label>
        <div class="controls">
            <select name="plan_id" id="elm_plan_id">
                <option value="0" {if $search.plan_id == "0"}selected="selected"{/if}> -- </option>
                <option value="-1" {if $search.plan_id == "-1"}selected="selected"{/if}>{__("without_plan")}</option>
                {if $affiliate_plans}{html_options options=$affiliate_plans selected=$search.plan_id}{/if}
            </select>
        </div>
    </div>
    </div>
</div>
{/capture}

{include file="common/advanced_search.tpl" content=$smarty.capture.advanced_search simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch=$dispatch view_type="affiliates"}

</form>
</div>