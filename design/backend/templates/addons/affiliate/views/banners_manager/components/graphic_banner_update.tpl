{if $banner}
    {assign var="id" value=$banner.banner_id}
{else}
    {assign var="id" value=0}
{/if}

<form action="{""|fn_url}" method="post" name="banner_form" class=" form-horizontal form-edit" enctype="multipart/form-data">
<input type="hidden" name="banner_id" value="{$id}" />
<input type="hidden" name="banner[type]" value="G" />
<input type="hidden" name="banner[link_to]" value="{$link_to}" />

<fieldset>

<div class="control-group">
    <label class="control-label cm-required" for="elm_aff_graphic_banner_title">{__("title")}:</label>
    <div class="controls">
        <input type="text" name="banner[title]" id="elm_aff_graphic_banner_title" value="{$banner.title}" size="50" class="input-large" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_graphic_banner_content">{__("description")}:</label>
    <div class="controls">
        <input type="text" name="banner[content]" id="elm_aff_graphic_banner_content" value="{$banner.content}" size="50" class="input-large" />
    </div>
</div>

<div class="control-group">
    <label class="control-label">{__("image")}:</label>
    <div class="controls">
        {include file="common/attach_images.tpl" image_name="banner" image_object_type="common" image_pair=$banner image_object_id=$banner.banner_id hide_titles="Y"  no_detailed="Y"}    
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_graphic_banner_new_window">{__("open_in_new_window")}:</label>
    <div class="controls">
        <label class="checkbox">
        <input type="hidden" name="banner[new_window]" value="N" />
        <input type="checkbox" name="banner[new_window]" id="elm_aff_graphic_banner_new_window" {if $banner.new_window == "Y"}checked="checked"{/if} value="Y" />
        </label>
    </div>
</div>

{include file="common/select_status.tpl" input_name="banner[status]" id="elm_aff_graphic_banner_status" obj=$banner}

{if $link_to == "G"}
    <div class="control-group">
        <label class="control-label" for="elm_aff_graphic_banner_group_id">{__("product_group")}:</label>
        <div class="controls">
        <select name="banner[data]" id="elm_aff_graphic_banner_group_id">
            {if $all_groups_list}
                {foreach from=$all_groups_list item="group"}
                    <option value="{$group.group_id}" {if $banner.group_id == $group.group_id}selected="selected"{/if}>{$group.name}</option>
                {/foreach}
            {else}
                <option value="0">{__("none")}</option>
            {/if}
        </select>
        </div>
    </div>

{elseif $link_to == "C"}

    {include file="common/subheader.tpl" title=__("categories")}
    {if $banner.categories}
        {assign var="c_ids" value=$banner.categories|array_keys}
    {/if}

    {include file="pickers/categories/picker.tpl" input_name="banner[data]" item_ids=$c_ids multiple=true use_keys="N"}

{elseif $link_to == "P"}

    {include file="common/subheader.tpl" title=__("products")}

    {include file="pickers/products/picker.tpl" item_ids=$banner.data data_id="added_products" input_name="banner[data]" type="links"}

{else}
    <div class="control-group">
        <label for="elm_aff_graphic_banner_url" class="control-label cm-required">{__("url")}:</label>
        <div class="controls">
            <input type="text" name="banner[data]" id="elm_aff_graphic_banner_url" value="{$banner.url}" size="50"/>
        </div>
    </div>

{/if}
</fieldset>

{capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_name="dispatch[banners_manager.update]" save=$id but_role="submit-link" but_target_form="banner_form"}
{/capture}

</form>