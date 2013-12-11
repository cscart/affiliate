<div id="content_linked_products">
<a name="linked_products"></a>

{if $linked_products}
<form action="{""|fn_url}" method="post" name="linked_products_form">
<input type="hidden" name="banner_id" value="{$banner_id}" />
{/if}

<table class="table margin-top table-width">
<tr>
    <th><input type="checkbox" name="check_all" value="Y" title="{__("check_uncheck_all")}" class="checkbox cm-check-items" /></th>
    <th style="width: 100%">{__("product_name")}</th>
    <th>{__("url")}</th>
</tr>
{foreach from=$linked_products item=product}
    <tr {cycle values=",class=\"table-row\""}>
        <td><input type="checkbox" class="checkbox cm-item" name="delete[]" value="{$product.product_id}" /></td>
        <td>
            {include file="common/popupbox.tpl" id="product_`$product.product_id`" link_text=$product.product text=__("product") href="banner_products.view?product_id=`$product.product_id`" content=""}</td>
        <td>
            {$product.url}</td>
    </tr>
{foreachelse}
    <tr>
        <td colspan="3"><p class="no-items">{__("text_all_items_included", ["[items]" => __("products")])}</p></td>
    </tr>
{/foreach}
</table>

{if $linked_products}
<div class="buttons-container">
    {include file="buttons/button.tpl" but_name="dispatch[banners_manager.do_delete_linked]" but_text=__("delete_selected")}
</div>
</form>
{/if}

{include file="pickers/products/picker.tpl" view_mode="button" but_text=__("add_products_to_section") extra_var="banners_manager.do_add_linked?banner_id=`$banner_id`" display="affiliate" data_id="linked_products_list"}
</div>