{include file="views/profiles/components/profiles_scripts.tpl"}

{capture name="mainbox"}
<form action="{""|fn_url}" method="post" enctype="multipart/form-data" name="partnerlist_form">
<input type="hidden" name="fake" value="1" />

{include file="common/pagination.tpl" save_current_page=true save_current_url=true}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

{if $partners}
<table width="100%" class="table table-middle">
<thead>
<tr>
    <th class="left" width="1%">
        {include file="common/check_items.tpl"}</th>
    <th width="7%"><a class="cm-ajax" href="{"`$c_url`&sort_by=id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("id")}{if $search.sort_by == "id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    {if $settings.General.use_email_as_login == "Y"}
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=email&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("email")}{if $search.sort_by == "email"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    {else}
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=username&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("username")}{if $search.sort_by == "username"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    {/if}
    <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("name")}{if $search.sort_by == "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%" class="nowrap"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("registered")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("status")}{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=plan&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("plan")}{if $search.sort_by == "plan"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th>&nbsp;</th>
</tr>
</thead>
{foreach from=$partners item=user}
<tr>
    <td class="left"><input type="checkbox" name="partner_ids[]" value="{$user.user_id}" {*if $user.approved == "A" || $user.approved == "D"}disabled="disabled"{/if*} class="cm-item" /></td>
    <td><a href="{"partners.update?user_id=`$user.user_id`"|fn_url}">{$user.user_id}</a></td>
    {if $settings.General.use_email_as_login == "Y"}
    <td><a href="{"partners.update?user_id=`$user.user_id`"|fn_url}">{$user.email}</a></td>
    {else}
    <td><a href="{"partners.update?user_id=`$user.user_id`"|fn_url}">{$user.user_login}</a></td>
    {/if}
    <td><a href="{"partners.update?user_id=`$user.user_id`"|fn_url}">{$user.lastname} {$user.firstname}</a></td>
    <td>{$user.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
    <td>
        {if $user.approved == "A"}
            {__("approved")}
        {elseif $user.approved == "D"}
            {__("declined")}
        {else}
            <span class="required-field-mark">{__("awaiting_approval")}</span>
        {/if}
    </td>
    {if $user.approved == "A" || ($user.approved == "D" && $user.plan_id)}
    <td>
        <select name="update_data[{$user.user_id}][plan_id]" id="id_select_plan_{$user.user_id}" {if $user.approved == "D"}disabled="disabled"{/if} class="span3">
            <option value="0" {if !$user.plan_id}selected="selected"{/if}> -- </option>
            {if $affiliate_plans}{html_options options=$affiliate_plans selected=$user.plan_id}{/if}
        </select>
    </td>
    {else}
    <td width="20%" class="nowrap">- {__("no")} -</td>
    {/if}
    {*<td>{include file="common/price.tpl" value=$user.balance}</td>*}
    <td class="nowrap">
        <div class="hidden-tools">
            {capture name="tools_list"}
                <li>{btn type="list" text=__("edit") href="partners.update?user_id=`$user.user_id`"}</li>
            {/capture}
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
</tr>
{/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl"}

{if $partners}
    {capture name="approve_selected"}
        {include file="addons/affiliate/views/partners/components/reason_container.tpl" name="action_reason_approved"}
        <div class="buttons-container">
            {include file="buttons/save_cancel.tpl" but_text=__("proceed") but_name="dispatch[partners.m_approve]" cancel_action="close" but_meta="cm-process-items"}
        </div>
    {/capture}
    {include file="common/popupbox.tpl" id="approve_selected" text=__("approve_selected") content=$smarty.capture.approve_selected}
    
    {capture name="decline_selected"}
        {include file="addons/affiliate/views/partners/components/reason_container.tpl" name="action_reason_declined"}
        <div class="buttons-container">
            {include file="buttons/save_cancel.tpl" but_text=__("proceed") but_name="dispatch[partners.m_decline]" cancel_action="close" but_meta="cm-process-items"}
        </div>
    {/capture}
    {include file="common/popupbox.tpl" id="decline_selected" text=__("decline_selected") content=$smarty.capture.decline_selected}
{/if}
</form>

{/capture}

{capture name="sidebar"}
    <div class="sidebar-row">
        <h6>{__("menu")}</h6>
        <ul class="nav nav-list">
            <li><a href="{"addons.manage#groupaffiliate"|fn_url}">{__("affiliate_settings")}</a></li>
            <li><a href="{"partners.tree"|fn_url}">{__("affiliate_tiers_tree")}</a></li>
        </ul>
    </div>
    <hr>
    {include file="common/saved_search.tpl" view_type="affiliates" dispatch="partners.manage"}
    {include file="addons/affiliate/views/partners/components/partner_search.tpl" dispatch="partners.manage"}
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        <li>{btn type="dialog" text=__("approve_selected") target_id="content_approve_selected" form="partnerlist_form"}</li>
        <li>{btn type="dialog" text=__("decline_selected") target_id="content_decline_selected" form="partnerlist_form"}</li>
    {/capture}
    {if $partners}
        {dropdown content=$smarty.capture.tools_list}
    {/if}

    {if $user.approved == "A" || ($user.approved == "D" && $user.plan_id)}
        {include file="buttons/save.tpl" but_name="dispatch[partners.m_update]" but_role="submit-link" but_target_form="partnerlist_form"}
    {/if}
{/capture}

{include file="common/mainbox.tpl" title=__("affiliates") content=$smarty.capture.mainbox sidebar=$smarty.capture.sidebar buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons}
