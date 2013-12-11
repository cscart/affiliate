{if $list_data}
<ul class="bullets-list">
{foreach from=$list_data key=category_id item=category_name}
    <li><a href="{"categories.view?category_id=`$category_id`"|fn_url}" target="_blank">{$category_name}</a></li>
{/foreach}
</ul>
{/if}