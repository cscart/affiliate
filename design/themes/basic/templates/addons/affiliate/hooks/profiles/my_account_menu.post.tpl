{if $auth.user_id && $auth.user_type == "P"}
<li><a href="{"banners_manager.manage?banner_type=T"|fn_url}" rel="nofollow" class="underlined">{__("affiliate")}</a></li>
{/if}