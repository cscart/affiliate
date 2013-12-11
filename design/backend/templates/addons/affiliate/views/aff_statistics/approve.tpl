{capture name="mainbox"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

<form action="{""|fn_url}" method="post" name="commissions_approve_form">

<div id="aff_stats_list">
{include file="common/pagination.tpl"}

{if $affiliate_commissions}
<table class="table table-middle">
<thead>
<tr>
    <th width="1%" class="left">
        {include file="common/check_items.tpl"}
    </th>
    {if $row_stats.extra_data || $additional_data|trim}
    <th width="1%">
        <span name="plus_minus" id="on_st" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combinations-commissions"> <span class="exicon-expand"></span> </span><span name="minus_plus" id="off_st" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combinations-commissions"> <span class="exicon-collapse"></span> </span>
    </th>
    {/if}
    <th width="15%">
    <a class="cm-ajax" href="{"`$c_url`&sort_by=action&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("action")}{if $search.sort_by == "action"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=cost&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("cost")}{if $search.sort_by == "cost"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=customer&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("customer")}{if $search.sort_by == "customer"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=partner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate")}{if $search.sort_by == "partner"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=banner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("banner")}{if $search.sort_by == "banner"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    <th>&nbsp;</th>
    <th width="15%" class="right"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}{__("status")}</a></th>
</tr>
</thead>

    {foreach from=$affiliate_commissions item="row_stats" name="commissions"}
    <tbody class="hover">
    {include file="addons/affiliate/views/payouts/components/additional_data.tpl" data=$row_stats.data assign="additional_data"}
    <tr>
        <td>
            <input type="checkbox" name="action_ids[]" value="{$row_stats.action_id}" {if $row_stats.payout_id}disabled="disabled"{/if} class="checkbox cm-item" /></td>
        <td>
            {if $row_stats.extra_data || $additional_data|trim}
                <div class="pull-left">
                    <span name="plus_minus" id="on_commission_{$smarty.foreach.commissions.iteration}" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combination-commissions"><span class="exicon-expand"></span></span><span name="minus_plus" id="off_commission_{$smarty.foreach.commissions.iteration}" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combination-commissions"><span class="exicon-collapse"></span></span><a id="sw_commission_{$smarty.foreach.commissions.iteration}" class="cm-combination-commissions"></a>
                </div>            
            {/if}
            <span>{$row_stats.title}{$action_title}</span>

            {if $row_stats.related_actions}
            <p>{__("related_actions")}:</p>
            {foreach from=$row_stats.related_actions item="r_action"}
                <p>{$r_action.title}, {include file="common/price.tpl" value=$r_action.amount|round:2}, {if $r_action.payout_id}{__("paidup")}{elseif $r_action.approved == "Y"}{__("approved")}{else}&nbsp;&nbsp;---&nbsp;{/if}</p>
            {/foreach}
            {/if}
        </td>
        <td>{$row_stats.date|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
        <td>{include file="common/price.tpl" value=$row_stats.amount|round:2}{$action_amount}</td>
        <td>
            {if $row_stats.customer_firstname || $row_stats.customer_lastname}
                <a href="{"profiles.update?user_id=`$row_stats.customer_id`"|fn_url}">{$row_stats.customer_firstname} {$row_stats.customer_lastname}</a>
            {/if}&nbsp;{if $row_stats.ip}<em>({$row_stats.ip})</em>{/if}
        </td>
        <td>{if $row_stats.partner_firstname || $row_stats.partner_lastname}<a href="{"partners.update?user_id=`$row_stats.partner_id`"|fn_url}">{$row_stats.partner_firstname} {$row_stats.partner_lastname}</a>{else}&nbsp;&nbsp;---&nbsp;{/if}
        {if $row_stats.plan}<em>(<a href="{"affiliate_plans.update?plan_id=`$row_stats.plan_id`"|fn_url}">{$row_stats.plan}</a>)</em>{/if}
        {$action_partner}</td>
        <td>{if $row_stats.banner}
            <a href="{"banners_manager.update?banner_id=`$row_stats.banner_id`"|fn_url}">{$row_stats.banner}</a>
            {else}&nbsp;&nbsp;---&nbsp;{/if}
        </td>
        <td class="nowrap">
            {capture name="tools_list"}
            {if !$row_stats.payout_id}
                <li>{btn type="list" class="cm-confirm" text=__("delete") href="aff_statistics.delete?action_id=`$row_stats.action_id`"}</li>
            {/if}
            {/capture}
            <div class="hidden-tools">
                {dropdown content=$smarty.capture.tools_list}
            </div>
        </td>
        <td class="right">
            {if $row_stats.payout_id}{__("paidup")}{elseif $row_stats.approved == "Y"}{__("approved")}{else}&nbsp;&nbsp;---&nbsp;{/if}
        </td>
    </tr>
    {if $row_stats.extra_data || $additional_data|trim}
    <tr id="commission_{$smarty.foreach.commissions.iteration}" class="hidden">
        <td colspan="9">
            {if $row_stats.extra_data}
            <table width="100%" class="table table-middle">
                <thead>
                <tr>
                    <th width="25%">{__("action")}</th>
                    <th width="10%">{__("cost")}</th>
                    <th>{__("affiliate")}</th>
                </tr>
                </thead>
            {foreach from=$row_stats.extra_data item="r_action" name="related_action"}
                <tr>
                    <td>{if $r_action.action_id == $row_stats.action_id}<span>{/if}{$r_action.title}{if $r_action.tier} ({$r_action.tier} {__("tier_account")}){/if}{if $r_action.action_id == $row_stats.action_id}</span>{/if}</td>
                    <td>{include file="common/price.tpl" value=$r_action.amount|round:2}</td>
                    <td>{if $r_action.firstname || $r_action.lastname} <a href="{"profiles.update?user_id=`$r_action.partner_id`"|fn_url}">{$r_action.firstname} {$r_action.lastname}</a>{/if}</td>
                <tr>
            {/foreach}
            </table>
            {/if}
            {if $additional_data|trim}
                {__("additional_data")}: {$additional_data nofilter}
            {/if}
        </td>
    </tr>
    {/if}
    </tbody>
    {/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="addons/affiliate/views/aff_statistics/components/general_statistics.tpl"}

{include file="common/pagination.tpl"}

{capture name="buttons"}
    {if $affiliate_commissions}
        {capture name="tools_list"}
            <li>{btn type="list" text=__("disapprove_commissions") dispatch="dispatch[aff_statistics.m_disapprove]" form="commissions_approve_form"}</li>
            <li>{btn type="list" text=__("delete_commissions") dispatch="dispatch[aff_statistics.m_delete]" class="cm-confirm" form="commissions_approve_form"}</li>
        {/capture}
        {dropdown content=$smarty.capture.tools_list}

        {include file="buttons/button.tpl" but_meta="cm-process-items" but_text=__("approve_commissions") but_name="dispatch[aff_statistics.m_approve]" but_role="submit-link" but_target_form="commissions_approve_form"}
    {/if}
{/capture}
<!--aff_stats_list--></div>
</form>
{/capture}

{capture name="sidebar"}
    {include file="common/saved_search.tpl" dispatch="products.manage" view_type="aff_stats"}
    {include file="addons/affiliate/views/aff_statistics/components/stat_search_form.tpl" dispatch="aff_statistics.approve"}
{/capture}

{include file="common/mainbox.tpl" title=__("approve_commissions") content=$smarty.capture.mainbox sidebar=$smarty.capture.sidebar buttons=$smarty.capture.buttons}