{** groups section **}

{capture name="mainbox"}

{capture name="tabsbox"}

<div id="content_{$link_to}">

<form action="{""|fn_url}" method="post" name="manage_groups_form_{$link_to}">
<input type="hidden" name="link_to" value="{$link_to}" />

{include file="common/pagination.tpl" div_id="pagination_contents_$link_to"}

{if $groups}
<table width="100%" class="table table-middle">
<thead>
    <tr>
        <th class="left" width="1%">
            {include file="common/check_items.tpl"}</th>
        <th width="20%">{__("name")}</th>
        <th width="35%">{if $link_to == "C"}{__("categories")}{elseif $link_to == "P"}{__("products")}{else}{__("url")}{/if}</th>
        <th width="5%">&nbsp;</th>
        <th width="10%" class="right">{__("status")}</th>
    </tr>
</thead>
{foreach from=$groups item=c_group}
<tr class="cm-row-status-{$c_group.status|lower}">
    <td class="left" width="1%">
           <input type="checkbox" name="group_ids[]" value="{$c_group.group_id}" class="cm-item" /></td>
    <td>
        <a href="{"product_groups.update?group_id=`$c_group.group_id`&link_to=`$link_to`"|fn_url}" class="row-status">{$c_group.name}</a></td>
       <td>
           {if $link_to == "C"}
               {foreach from=$c_group.categories key="item_id" item="item_name" name="fe"}
               <a href="{"categories.update?category_id=`$item_id`"|fn_url}" class="row-status">{$item_name}</a>{if !$smarty.foreach.fe.last}, {/if}
               {/foreach}

        {elseif $link_to == "P"}
               {foreach from=$c_group.product_ids item="item_id" name="fe"}
               <a href="{"products.update?product_id=`$item_id`"|fn_url}" class="row-status">{$item_id|fn_get_product_name}</a>{if !$smarty.foreach.fe.last}, {/if}
               {/foreach}

        {else}
               <a href="{$c_group.url|fn_url}" class="row-status">{$c_group.url}</a>
           {/if}
       </td>
    <td class="nowrap right">
        {capture name="tools_list"}
            <li>{btn type="list" text=__("edit") href="product_groups.update?group_id=`$c_group.group_id`"}</li>
            <li>{btn type="list" text=__("delete") class="cm-confirm" href="product_groups.delete?group_id=`$c_group.group_id`"}</li>
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
    <td class="right">
        {include file="common/select_popup.tpl" id=$c_group.group_id status=$c_group.status hidden="" object_id_name="group_id" table="aff_groups"}
    </td>
</tr>
{/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_contents_$link_type"}

{if $link_to == "C"}
    {assign var="link_text" value=__("add_group_for_categories")}
{elseif $link_to == "P"}
    {assign var="link_text" value=__("add_group_for_products")}
{elseif $link_to == "U"}
    {assign var="link_text" value=__("add_url_group")}
{/if}

</form>

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="product_groups.add?link_to=$link_to" prefix="bottom" hide_tools="true" title=$link_text link_text="" icon="icon-plus"}
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        {if $groups}
            <li>{btn type="delete_selected" dispatch="dispatch[product_groups.m_delete]" form="manage_groups_form_`$link_to`"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
{/capture}

<!--content_{$link_to}--></div>

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$link_to}

{/capture}
{include file="common/mainbox.tpl" title=__("product_groups") content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons buttons=$smarty.capture.buttons}

{** groups section **}