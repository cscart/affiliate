{if $banner}
    {assign var="id" value=$banner.banner_id}
{else}
    {assign var="id" value=0}
{/if}

<form action="{""|fn_url}" method="post" name="banner_form" class=" form-horizontal form-edit">
<input type="hidden" name="banner_id" value="{$id}" />
<input type="hidden" name="banner[type]" value="T" />
<input type="hidden" name="banner[link_to]" value="{$link_to}" />

<div class="control-group">
    <label class="control-label cm-required" for="elm_aff_banner_title">{__("title")}:</label>
    <div class="controls">
        <input type="text" name="banner[title]" id="elm_aff_banner_title" value="{$banner.title}" size="50" class="input-large" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_banner_show_title">{__("show_title")}:</label>
    <div class="controls">
        <label class="checkbox">
            <input type="hidden" name="banner[show_title]" value="N" />
            <input type="checkbox" name="banner[show_title]" id="elm_aff_banner_show_title" {if $banner.show_title == "Y" || !$banner}checked="checked"{/if} value="Y" />
        </label>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_banner_width">{__("width")}&nbsp;({__("pixels")}):</label>
    <div class="controls">
        <input type="text" name="banner[width]" id="elm_aff_banner_width" value="{$banner.width}" size="10" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_banner_height">{__("height")}&nbsp;({__("pixels")}):</label>
    <div class="controls">
        <input type="text" name="banner[height]" id="elm_aff_banner_height" value="{$banner.height}" size="10" />
    </div>
</div>

<div class="control-group">
    <label class="control-label cm-required" for="elm_aff_banner_content">{__("content")}:</label>
    <div class="controls">
        <div class="cm-field-container">
            <textarea id="elm_aff_banner_content" name="banner[content]" cols="50" rows="5" class="cm-wysiwyg input-large">{$banner.content}</textarea>
        </div>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_banner_new_window">{__("open_in_new_window")}:</label>
    <div class="controls">
        <label class="checkbox">
        <input type="hidden" name="banner[new_window]" value="N" />
        <input type="checkbox" name="banner[new_window]" id="elm_aff_banner_new_window" {if $banner.new_window == "Y"}checked="checked"{/if} value="Y" />
        </label>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_banner_show_url">{__("show_url")}:</label>
    <div class="controls">
        <label class="checkbox">
        <input type="hidden" name="banner[show_url]" value="N" />
        <input type="checkbox" name="banner[show_url]" id="elm_aff_banner_show_url" {if $banner.show_url == "Y" || !$banner}checked="checked"{/if} value="Y"/>
        </label>
    </div>
</div>

{include file="common/select_status.tpl" input_name="banner[status]" id="elm_aff_banner_status" obj=$banner}

{if $link_to == "G"}
    <div class="control-group">
        <label class="control-label" for="elm_aff_banner_group_id">{__("product_group")}:</label>
        <div class="controls">
        <select name="banner[data]" id="elm_aff_banner_group_id">
            <option    value="0">{__("none")}</option>
            {if $all_groups_list}
                {foreach from=$all_groups_list item="group"}
                    <option value="{$group.group_id}" {if $banner.group_id == $group.group_id}selected="selected"{/if}>{$group.name}</option>
                {/foreach}
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
        <label for="elm_aff_banner_url" class="cm-required control-label">{__("url")}:</label>
        <div class="controls">
            <input type="text" name="banner[data]" id="elm_aff_banner_url" value="{$banner.url}" size="50" class="input-large" />
        </div>
    </div>

{/if}

{capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_name="dispatch[banners_manager.update]" save=$id but_role="submit-link" but_target_form="banner_form"}
{/capture}
</form>