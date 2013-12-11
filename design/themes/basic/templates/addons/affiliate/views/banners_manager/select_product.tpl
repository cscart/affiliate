{include file="addons/affiliate/common/affiliate_menu.tpl"}

<div class="affiliate-block last">
    <h4 class="affiliate-title">
        {$banner.title nofilter}
            {if $banner.width && $banner.height}
                <span>({$banner.width} &times; {$banner.height})</span>
            {/if}
    </h4>

    <div class="affiliate-content">
        <div class="affiliate-text">{$banner.example nofilter}</div>
    </div>

    <div>
        <a class="link-dashed affiliate-tab-link" data-tab-content-id="banner_code_{$banner_id}">
            {__("banner_code")}
            <span class="caret-info hidden"><span class="caret-outer"></span><span class="caret-inner"></span></span>
        </a>
    </div>

    <div class="affiliate-wrap">
        <div class="info-block hidden" id="banner_code_{$banner_id}">
            <pre>{$banner.code}</pre>
        </div>
    </div>
</div>
<script>
    //<![CDATA[
        (function(_, $) {
            var elm = $('.affiliate-wrap .info-block');
            var link = $('.affiliate-tab-link');
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

{include file="addons/affiliate/views/banners_manager/components/linked_products.tpl"}

{capture name="mainbox_title"}
    {__(affiliate)} <span class="subtitle">/ {__("select_products")}</span>
{/capture}