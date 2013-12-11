{** text_banners section **}

{capture name="mainbox"}

{capture name="tabsbox"}

<div id="content_{$link_to}">

<form action="{""|fn_url}" method="post" name="manage_banners_form_{$link_to}">
<input type="hidden" name="page" value="{$smarty.request.page}" />
<input type="hidden" name="banner_type" value="{$banner_type}" />
<input type="hidden" name="link_to" value="{$link_to}" />
{if $banners}
<table width="100%" class="table table-middle">
<thead>
<tr>
    <th class="left" width="1%">
        {include file="common/check_items.tpl"}</th>
    <th>{__("title")}</th>
    {if $banner_type == "T"}
    <th width="15%">{__("show_title")}</th>
    {/if}
    {if $banner_type == "T" || $banner_type == "P"}
    <th>{__("width")}</th>
    <th>{__("height")}</th>
    {/if}
    {if $banner_type != "P"}
    <th width="30%">{if $link_to == "G"}{__("product_groups")}{elseif $link_to == "C"}{__("categories")}{elseif $link_to == "P"}{__("products")}{else}{__("url")}{/if}</th>
    {/if}
    <th class="center" width="15%">{__("new_window")}</th>
    {if $banner_type == "P"}
    <th width="15%" class="center">{__("add_to_cart")}</th>
    {/if}
    <th>&nbsp;</th>
    <th class="right" width="10%">{__("status")}</th>
</tr>
</thead>
{foreach from=$banners item=c_banner}
<tr class="cm-row-status-{$c_banner.status|lower}">
    <td class="left">
           <input type="checkbox" name="banner_ids[]" value="{$c_banner.banner_id}" class="cm-item" /></td>
    <td class="nowrap">
        <a href="{"banners_manager.update?banner_id=`$c_banner.banner_id`&banner_type=`$banner_type`&link_to=`$link_to`"|fn_url}" title="{$c_banner.title}" class="row-status">{$c_banner.title|truncate:30}</a></td>
    {if $banner_type == "T"}
    <td class="center">
        <input type="hidden" name="banners_data[{$c_banner.banner_id}][show_title]" value="N" />
        <input type="checkbox" name="banners_data[{$c_banner.banner_id}][show_title]" {if $c_banner.show_title == "Y"}checked="checked"{/if} value="Y" /></td>
    {/if}
    {if $banner_type == "T" || $banner_type == "P"}
       <td>
           <input type="text" name="banners_data[{$c_banner.banner_id}][width]" value="{$c_banner.width}" size="10" class="input-mini input-hidden" /></td>
       <td>
           <input type="text" name="banners_data[{$c_banner.banner_id}][height]" value="{$c_banner.height}" size="10" class="input-mini input-hidden" /></td>
    {/if}

    {if $banner_type != "P"}
    <td>
           {if $link_to == "C"}
               {foreach from=$c_banner.categories key="item_id" item="item_name" name="fe"}
               <a href="{"categories.update?category_id=`$item_id`"|fn_url}" class="row-status">{$item_name}</a>{if !$smarty.foreach.fe.last}, {/if}
               {/foreach}

        {elseif $link_to == "P"}
               {foreach from=$c_banner.product_ids item="item_id" name="fe"}
               <a href="{"products.update?product_id=`$item_id`"|fn_url}" class="row-status">{$item_id|fn_get_product_name}</a>{if !$smarty.foreach.fe.last}, {/if}
               {/foreach}

           {elseif $link_to == "G"}
               <a href="{"product_groups.update?group_id=`$c_banner.group_id`"|fn_url}" class="row-status">{$c_banner.group_name}</a>

           {else}
               <a href="{$c_banner.url|fn_url}" title="{$c_banner.url}" class="row-status">{$c_banner.url|truncate:50}</a>
           {/if}
       </td>
    {/if}
    <td class="center">
        <input type="hidden" name="banners_data[{$c_banner.banner_id}][new_window]" value="N" />
           <input type="checkbox" name="banners_data[{$c_banner.banner_id}][new_window]" {if $c_banner.new_window == "Y"}checked="checked"{/if} value="Y"/></td>
    {if $banner_type == "P"}
    <td class="center">
        <input type="hidden" name="banners_data[{$c_banner.banner_id}][to_cart]" value="N" />
           <input type="checkbox" name="banners_data[{$c_banner.banner_id}][to_cart]" {if $c_banner.to_cart == "Y"}checked="checked"{/if} value="Y"/></td>
    {/if}
    <td class="nowrap right">
    {capture name="tools_list"}
        {hook name="affiliate:banners_extra_links"}
            <li>{btn type="list" text=__("edit") href="banners_manager.update?banner_id=`$c_banner.banner_id`"}</li>
            <li>{btn type="list" class="cm-confirm" text=__("delete") href="banners_manager.delete?banner_id=`$c_banner.banner_id`&banner_type=`$banner_type`&link_to=`$link_to`"}</li>
        {/hook}
    {/capture}
    <div class="hidden-tools">
        {dropdown content=$smarty.capture.tools_list}
    </div>
    </td>
    <td class="right">
        {include file="common/select_popup.tpl" id=$c_banner.banner_id status=$c_banner.status hidden="" object_id_name="banner_id" table="aff_banners"}
    </td>
</tr>
{/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}
</form>
<!--content_{$link_to}--></div>

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$link_to}

{/capture}

{if $banner_type == "T"}
    {assign var="title" value=__("text_banners")}
{elseif $banner_type == "G"}
    {assign var="title" value=__("graphic_banners")}
{else}
    {assign var="title" value=__("product_banners")}
{/if}

{capture name="adv_buttons"}
    {foreach from=$link_types key="link_type" item="link_title"}
    <span class="cm-tab-tools" id="tools_{$link_type}_adv_buttons">
    {if $link_type == $link_to}
        {include file="common/tools.tpl" tool_id="add_banner_{$link_type}" tool_href="banners_manager.add?banner_type=`$banner_type`&link_to=`$link_to`" prefix="top" hide_tools="true" title=__("add_banner") icon="icon-plus"}
    {/if}
    <!--tools_{$link_type}_adv_buttons--></span>
    {/foreach}
{/capture}

{capture name="sidebar"}
    <div class="sidebar-row">
        <h6>{__("menu")}</h6>
        <ul class="nav nav-list">
            <li><a href="{"addons.manage#groupaffiliate"|fn_url}">{__("affiliate_settings")}</a></li>
            <li><a href="{"partners.tree"|fn_url}">{__("affiliate_tiers_tree")}</a></li>
        </ul>
    </div>
{/capture}

{capture name="buttons"}
    {foreach from=$link_types key="link_type" item="link_title"}
    <div class="cm-tab-tools pull-right shift-left" id="tools_{$link_type}_buttons">
    {capture name="tools_list"}
        {if !$banners}
            {$disabled_class="cm-disabled"}
        {/if}
        <li {if !$banners}class="disabled"{/if}>{btn type="delete_selected" class=$disabled_class dispatch="dispatch[banners_manager.m_delete]" form="manage_banners_form_`$link_to`"}</li>
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
    {if $link_type == $link_to}
        {if $banners}
            <div class="btn-group">
                {include file="buttons/save.tpl" but_name="dispatch[banners_manager.m_update]" but_role="submit-link" but_target_form="manage_banners_form_{$link_to}"}
            </div>
        {/if}
    {/if}
    <!--tools_{$link_type}_buttons--></div>
    {/foreach}
{/capture}

{include file="common/mainbox.tpl" title="{__("banners")}: `$title`"  content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar}

{** text_banners section **}
