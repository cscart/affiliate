{capture name="mainbox"}

{if $group}
    {assign var="link_to" value=$group.link_to}
    {assign var="id" value=$group.group_id}
{else}
    {assign var="link_to" value=$smarty.request.link_to}
    {assign var="id" value=0}
{/if}

<form action="{""|fn_url}" method="post" name="{$prefix}_group_form" class="form-horizontal form-edit ">
<input type="hidden" name="selected_section" id="selected_section" value="{$prefix}" />
<input type="hidden" name="page" id="page" value="{$current_page}" />
<input type="hidden" name="group[link_to]" value="{$link_to}" />
<input type="hidden" name="group_id" value="{$id}" />

{include file="common/subheader.tpl" title=__("general")}

<fieldset>

<div class="control-group">
    <label for="elm_product_group_name" class="control-label cm-required">{__("name")}:</label>
    <div class="controls">
        <input type="text" name="group[name]" id="elm_product_group_name" value="{$group.name}" size="50" class="input-large" />
    </div>
</div>

{include file="common/select_status.tpl" input_name="group[status]" id="group" obj=$group}

{if $link_to == "C"}
    {include file="common/subheader.tpl" title=__("categories")}
    {if $group.categories}
        {assign var="c_ids" value=$group.categories|array_keys}
    {/if}

    {include file="pickers/categories/picker.tpl" input_name="group[data]" item_ids=$c_ids multiple=true use_keys="N" but_meta="pull-right"}
    
    {assign var="_link_text" value=__("add_group_for_categories")}

{elseif $link_to == "P"}
    {include file="common/subheader.tpl" title=__("products")}

    {include file="pickers/products/picker.tpl" item_ids=$group.product_ids data_id="added_products" input_name="group[data]" type="links"}
    
    {assign var="_link_text" value=__("add_group_for_products")}

{elseif $link_to == "U"}

    <div class="control-group">
        <label for="elm_product_group_url" class="control-label cm-required">{__("url")}:</label>
        <div class="controls">
            <input type="text" name="group[data]" id="elm_product_group_url" value="{$group.url}" size="50" class="input-large" />
        </div>
    </div>
    {assign var="_link_text" value=__("add_url_group")}
{/if}

</fieldset>

</form>
{/capture}

{capture name="buttons"}
    {if !$id}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[product_groups.update]" but_role="submit-link" but_target_form="`$prefix`_group_form"}
    {else}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[product_groups.update]" save=$id but_role="submit-link" but_target_form="`$prefix`_group_form"}
    {/if}
{/capture}

{if !$id}
    {include file="common/mainbox.tpl" title=__("new_group") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons}
{else}
    {capture name="tools"}
        {include file="common/tools.tpl" tool_href="product_groups.add?link_to=`$link_to`" prefix="top" link_text=$_link_text hide_tools=true}
    {/capture}
    {include file="common/mainbox.tpl" title="{__("editing")}: `$group.name`" content=$smarty.capture.mainbox select_languages=true buttons=$smarty.capture.buttons}
{/if}