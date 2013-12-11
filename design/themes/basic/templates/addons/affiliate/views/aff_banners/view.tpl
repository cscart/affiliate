{if $products}

    {assign var="layouts" value=""|fn_get_products_views:false:0}
    {if $layouts.$selected_layout.template}
            {include file="`$layouts.$selected_layout.template`" columns=$settings.Appearance.columns_in_products_list}
    {/if}

    {capture name="mainbox_title"}{__("products")}{/capture}
{elseif $banner_categories}
    {include file="addons/affiliate/views/aff_banners/components/categories_list.tpl"}
{/if}