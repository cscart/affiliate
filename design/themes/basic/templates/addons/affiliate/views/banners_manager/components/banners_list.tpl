<form action="{""|fn_url}" method="post" name="manage_{$prefix}_banners_form">
<input type="hidden" name="selected_section" id="id_selected_section" value="" />
<input type="hidden" name="page" value="{$smarty.request.page}" />

{if $banners.$prefix}
    {foreach from=$banners.$prefix item=c_banner name="banner"}
        <div class="affiliate-block aff-block-{$c_banner.banner_id}{if $smarty.foreach.banner.last} last{/if}">
            {assign var="banner_id" value=$c_banner.banner_id}
            <h4 class="affiliate-title">
                {$c_banner.title}
                {if $smarty.request.banner_type != "G"}
                    {if $c_banner.width && $c_banner.height}
                        <span>({$c_banner.width} &times; {$c_banner.height})</span>
                    {/if}
                {else}
                    {if $c_banner.icon.image_x || $c_banner.icon.image_y}
                        <span>({$c_banner.icon.image_x} &times; {$c_banner.icon.image_y})</span>
                    {/if}
                {/if}
            </h4>

            <div class="affiliate-content">
                <div class="affiliate-text">{$js_banners.$banner_id.code nofilter}</div>
                {if $smarty.request.banner_type == "P"}
                    <a class="affiliate-link" href="{"banners_manager.select_product?banner_id=`$banner_id`"|fn_url}">{__("banner_code_for_some_products")}</a>
                {/if}
            </div>

            {capture name="prefix"}
                {include file="addons/affiliate/views/banners_manager/components/`$prefix`_list.tpl" list_data=$c_banner.$prefix}
            {/capture}

            <div>
                <a class="link-dashed affiliate-tab-link" data-tab-content-id="banner_code_{$banner_id}">
                    {__("banner_code")}
                    <span class="caret-info hidden"><span class="caret-outer"></span><span class="caret-inner"></span></span>
                </a>
                {if $smarty.request.banner_type != "P" && $smarty.capture.prefix|trim}
                    <a class="link-dashed affiliate-tab-link" data-tab-content-id="{$prefix}_{$banner_id}">
                        {__($prefix)}
                        <span class="caret-info hidden"><span class="caret-outer"></span><span class="caret-inner"></span></span>
                    </a>
                {/if}
            </div>

            <div class="affiliate-wrap">
                <div class="info-block hidden" id="banner_code_{$banner_id}">
                    <pre>{$js_banners.$banner_id.code}</pre>
                </div>

                {if $smarty.request.banner_type != "P" && $smarty.capture.prefix|trim}
                    <div class="info-block hidden" id="{$prefix}_{$banner_id}">
                        {$smarty.capture.prefix nofilter}
                    </div>
                {/if}
            </div>
        </div>
        <script>
            //<![CDATA[
                (function(_, $) {
                    var elm = $('.aff-block-{$c_banner.banner_id} .affiliate-wrap .info-block');
                    var link = $('.aff-block-{$c_banner.banner_id} .affiliate-tab-link');
                    link.on('click', function() {
                        _this = $(this);
                        if (_this.hasClass('on')) {
                            _this.removeClass('on');
                        } else {
                            _this.addClass('on');
                        }
                        _this.siblings('.affiliate-tab-link').removeClass('on');
                        elm.filter('#' + _this.data('tab-content-id')).toggle().siblings(':visible').hide();
                        return false;
                    });
                }(Tygh, Tygh.$));
            //]]>
        </script>
    {/foreach}
{else}
    <p class="no-items">{__("text_no_banners_found")}</p>
{/if}
</form>