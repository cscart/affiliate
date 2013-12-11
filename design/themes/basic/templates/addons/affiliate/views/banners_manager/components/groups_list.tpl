{if $list_data}
    {if $list_data.link_to == "P"}
        <span class="product-details-title">{__("products")}</span>
        {include file="addons/affiliate/views/banners_manager/components/products_list.tpl" list_data=$list_data.products}
    {elseif $list_data.link_to == "C"}
        <span class="product-details-title">{__("categories")}</span>
        {include file="addons/affiliate/views/banners_manager/components/categories_list.tpl" list_data=$list_data.categories}
    {elseif $list_data.link_to == "U"}
        <span class="product-details-title">{__("url")}</span>
        {include file="addons/affiliate/views/banners_manager/components/url_list.tpl" list_data=$list_data.url}
    {/if}
{/if}