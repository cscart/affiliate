{capture name="mainbox"}
{if $banner.code && $banner_type != "P"}
    <div class="shift-control">{$banner.code nofilter}</div>
{/if}

{if $banner_type == "T"}
    {include file="addons/affiliate/views/banners_manager/components/text_banner_update.tpl"}
{elseif $banner_type == "G"}
    {include file="addons/affiliate/views/banners_manager/components/graphic_banner_update.tpl"}
{elseif $banner_type == "P"}
    {include file="addons/affiliate/views/banners_manager/components/product_banner_update.tpl"}
{/if}

{/capture}

{if $runtime.mode == "add"}
    {include file="common/mainbox.tpl" title=__("affiliate.new_banner") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true}
{else}
    {include file="common/mainbox.tpl" title="{__("affiliate.editing_banner")}: `$banner.title`" content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=true}
{/if}
я