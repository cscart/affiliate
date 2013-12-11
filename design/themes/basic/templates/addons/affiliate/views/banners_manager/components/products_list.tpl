{if $list_data}

<ul class="bullets-list">
{foreach from=$list_data key=product_id item=product_name}
    <li>{include file="common/popupbox.tpl" id="product_`$product_id`" link_text=$product_name text=__("product") href="banner_products.view?product_id=`$product_id`"}</li>
{/foreach}
</ul>
{/if}