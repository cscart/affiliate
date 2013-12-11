<div id="content_product_{$product.product_id}">

<div class="clearfix">
    <form action="{""|fn_url}" method="post" name="product_details_form_{$product.product_id}">
    {assign var="id" value=$product.product_id}
    <div class="product-image">
        {include file="views/products/components/product_images.tpl" product=$product show_detailed_link=true image_width=$settings.Thumbnails.product_details_thumbnail_width image_height=$settings.Thumbnails.product_details_thumbnail_height}
    </div>
    <div class="product-description">
        <div class="product-details-title">{$product.product nofilter}</div>
        {if $product.product_code}
        <div class="sku">{__("sku")}: {$product.product_code}</div>
        {/if}

        <div class="clearfix">
        <div class="prices-container">
        {hook name="products:prices_block"}
            {if $product.discount}     {********************** Old Price *****************}
                <span class="list-price nowrap" id="line_old_price_{$obj_id}">{__("old_price")}: {include file="common/price.tpl" value=$product.base_price span_id="old_price_`$d`" class="list-price nowrap"}</span>
            {elseif $product.list_discount}
                <span class="list-price nowrap" id="line_list_price_{$obj_id}"><span class="list-price-label">{__("list_price")}:</span> {include file="common/price.tpl" value=$product.list_price span_id="list_price_`$obj_id`" class="list-price nowrap"}</span>
            {/if}
        
            {if $capture_price}
            {capture name="price"}
            {/if}
                <p class="price">     {********************** Price *********************}
                {if $product.price || $product.zero_price_action == "A"}
                    <span class="price" id="line_discounted_price_{$obj_id}">{__("price")}: {include file="common/price.tpl" value=$product.price span_id="discounted_price_`$obj_id`" class="price"}</span>
                {elseif $product.zero_price_action == "R"}
                    <span class="no-price">{__("contact_us_for_price")}</span>
                {/if}
        
                {if $settings.Appearance.show_prices_taxed_clean == "Y" && $product.taxed_price}
                    {if $product.clean_price != $product.taxed_price && $product.included_tax}
                        <span class="list-price nowrap" id="line_product_price_{$obj_id}">({include file="common/price.tpl" value=$product.taxed_price span_id="product_price_`$obj_id`" class="list-price nowrap"} {__("inc_tax")})</span>
                    {elseif $product.clean_price != $product.taxed_price && !$product.included_tax}
                        <span class="list-price nowrap tax-include">({__("including_tax")})</span>
                    {/if}
                {/if}
                </p>
            {if $capture_price}
            {/capture}
            {/if}
        
            {if $product.discount}     {********************** You Save ******************}
                <span class="list-price nowrap" id="line_discount_value_{$obj_id}">{__("you_save")}: {include file="common/price.tpl" value=$product.discount span_id="discount_value_`$obj_id`" class="list-price nowrap"}&nbsp;(<span id="prc_discount_value_{$obj_id}" class="list-price nowrap">{$product.discount_prc}</span>%)</span>
            {elseif $product.list_discount}
                <span class="list-price nowrap" id="line_discount_value_{$obj_id}">{__("you_save")}: {include file="common/price.tpl" value=$product.list_discount span_id="discount_value_`$obj_id`" class="list-price nowrap"}&nbsp;(<span id="prc_discount_value_{$obj_id}" class="list-price nowrap">{$product.list_discount_prc}</span>%)</span>
            {/if}
        {/hook}
        </div>

        {************************************ Discount label ****************************}
        {if ($product.discount_prc || $product.list_discount_prc) && $show_price_values && !$simple}
        <ul class="discount-label" id="line_prc_discount_value_{$obj_id}">
            <li><span>-{if $product.discount}{$product.discount_prc}{else}{$product.list_discount_prc}{/if}%</span></li>
        </ul>
        {/if}
        {************************************ /Discount label ****************************}
        </div>
        
        {if $wholesale_prices}
            {include file="addons/wholesale_trade/views/products/customer_product_details.tpl"}
        {/if}

        {include file="views/products/components/product_features.tpl"}
        {include file="views/products/components/product_options.tpl" product_id=$product.product_id product_options=$product_options}

        {if $settings.General.inventory_tracking == "Y" && $product.tracking != "D" && $product.is_edp != "Y"}
        <div class="control-group">
            <label>{__("in_stock")}</strong>:</label>
            <span id="product_amount_{$product.product_id}">{$product.amount}</span>&nbsp;{__("items")}
        </div>
        {/if}
    </div>
    </form>
</div>
    
<hr />
{$product.full_description|default:$product.short_description nofilter}
    
{include file="common/previewer.tpl"}

<!--content_product_{$product.product_id}--></div>