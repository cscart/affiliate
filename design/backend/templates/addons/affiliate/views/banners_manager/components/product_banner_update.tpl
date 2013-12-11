{if $banner}
    {assign var="id" value=$banner.banner_id}
{else}
    {assign var="id" value=0}
{/if}

<script type="text/javascript">
//<![CDATA[
function fn_get_example_banner()
{ldelim}
    var $ = Tygh.$;
    $.ceAjax('request', '{"aff_banner.view"|fn_url:'A':'rel' nofilter}' +
        '&image=' + $('#elm_aff_product_banner_image').val() +
        '&product_name=' + $('#elm_aff_product_banner_product_name').val()+
        '&short_description=' + $('#elm_aff_product_banner_short_description').val()+
        '&width=' + $('#elm_aff_product_banner_width').val()+
        '&height=' + $('#elm_aff_product_banner_height').val()+
        '&align=' + $('#elm_aff_product_banner_align').val()+
        '&new_window=' + $('#elm_aff_product_banner_new_window').val()+
        '&border=' + ($('#elm_aff_product_banner_border').prop('checked') ? 'Y' : 'N')+
        '&to_cart=' + $('#elm_aff_product_banner_to_cart').val()+
        '&type=' + $('#elm_aff_product_banner_type').val(), {ldelim}result_ids: 'id_example_banner', force_exec: true{rdelim}
    );
{rdelim}
//]]>
</script>

{capture name="preview_banner_content"}
<div id="id_example_banner">{if $banner.code}{$banner.code nofilter}{/if}<!--id_example_banner--></div>
    <input id="id_banner_type" type="hidden" value="js" />
<p><a onclick="fn_get_example_banner(); return false;">{__("refresh_banner")}</a></p>
{/capture}
{capture name="adv_buttons"}
    {include file="common/popupbox.tpl" content=$smarty.capture.preview_banner_content act="notes" id="preview_banner" text=__("preview") link_text=__("preview") icon="exicon-preview" meta="btn"}
{/capture}

<form action="{""|fn_url}" method="post" name="product_banners_addition_form" class=" form-horizontal form-edit">
<input type="hidden" name="banner_id" value="{$id}" />
<input type="hidden" name="banner[type]" value="P" />
<input type="hidden" name="banner[link_to]" value="{$link_to}" />

<fieldset>

<div class="control-group">
    <label for="elm_aff_product_banner_title" class="control-label cm-required">{__("title")}:</label>
    <div class="controls">
    <input type="text" name="banner[title]" id="elm_aff_product_banner_title" value="{$banner.title}" size="50" class="input-large" /><input type="hidden" name="banner[show_title]" value="N" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_width">{__("width")}&nbsp;({__("pixels")}):</label>
    <div class="controls">
        <input type="text" id="elm_aff_product_banner_width" name="banner[width]" value="{$banner.width}" size="10" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_height">{__("height")}&nbsp;({__("pixels")}):</label>
    <div class="controls">
    <input type="text" id="elm_aff_product_banner_height" name="banner[height]" value="{$banner.height}" size="10" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_image">{__("image")}:</label>
    <div class="controls">
    <select name="banner[data][image]" id="elm_aff_product_banner_image">
        <option value="N" {if $banner.image == "N"}selected="selected"{/if}>{__("not_show")}</option>
        <option value="T" {if $banner.image == "T" || !$banner}selected="selected"{/if}>{__("top")}</option>
        <option value="B" {if $banner.image == "B"}selected="selected"{/if}>{__("bottom")}</option>
    </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_product_name">{__("product_name")}:</label>
    <div class="controls">
    <select name="banner[data][product_name]" id="elm_aff_product_banner_product_name">
        <option value="N" {if $banner.product_name == "N"}selected="selected"{/if}>{__("not_show")}</option>
        <option value="T" {if $banner.product_name == "T" || !$banner}selected="selected"{/if}>{__("top")}</option>
        <option value="B" {if $banner.product_name == "B"}selected="selected"{/if}>{__("bottom")}</option>
    </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_short_description">{__("short_description")}:</label>
    <div class="controls">
    <select name="banner[data][short_description]" id="elm_aff_product_banner_short_description">
        <option value="N" {if $banner.short_description == "N"}selected="selected"{/if}>{__("not_show")}</option>
        <option value="T" {if $banner.short_description == "T" || !$banner}selected="selected"{/if}>{__("top")}</option>
        <option value="B" {if $banner.short_description == "B"}selected="selected"{/if}>{__("bottom")}</option>
    </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_align">{__("align")}:</label>
    <div class="controls">
    <select name="banner[data][align]" id="elm_aff_product_banner_align">
        <option value="center" {if $banner.align == "center" || !$banner}selected="selected"{/if}>{__("center")}</option>
        <option value="left" {if $banner.align == "left"}selected="selected"{/if}>{__("left")}</option>
        <option value="right" {if $banner.align == "right"}selected="selected"{/if}>{__("right")}</option>
    </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_border">{__("show_border")}:</label>
    <div class="controls">
    <label class="control-label">
    <label class="checkbox">
        <input type="hidden" name="banner[data][border]" value="N" />
        <input type="checkbox" id="elm_aff_product_banner_border" name="banner[data][border]" {if $banner.border == "Y"}checked="checked"{/if} value="Y" />

    </label>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_to_cart">{__("add_to_cart")}:</label>
    <div class="controls">
    <label class="checkbox">
        <input type="hidden" name="banner[to_cart]" value="N" />
        <input type="checkbox" id="elm_aff_product_banner_to_cart" name="banner[to_cart]" {if $banner.to_cart == "Y"}checked="checked"{/if} value="Y" />
    </label>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_aff_product_banner_new_window">{__("open_in_new_window")}:</label>
    <div class="controls">
    <label class="checkbox">
        <input type="hidden" name="banner[new_window]" value="N" />
        <input type="checkbox" id="elm_aff_product_banner_new_window" name="banner[new_window]" {if $banner.new_window == "Y"}checked="checked"{/if} value="Y" />
    </label>
    </div>
</div>

{include file="common/select_status.tpl" input_name="banner[status]" id="elm_aff_product_banner_status" obj=$banner}
</fieldset>

{capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_name="dispatch[banners_manager.update]" save=$id but_role="submit-link" but_target_form="product_banners_addition_form"}
{/capture}

</form>
