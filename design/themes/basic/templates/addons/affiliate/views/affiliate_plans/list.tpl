{include file="addons/affiliate/common/affiliate_menu.tpl"}
<div class="affiliate">
    {if $affiliate_plan}
        <div class="clearfix affiliate-plan-block">
            <div class="affiliate-plan float-left">
                {include file="common/subheader.tpl" title=__("affiliate_plan")}
                <dl class="clearfix">
                    {if $affiliate_plan.description}
                        <dt class="no-border">{$affiliate_plan.description nofilter}:</dt>
                        <dd class="no-border">{$affiliate_plan.name}</dd>
                    {/if}

                    <dt>{__("aff_cookie_expiration")}:</dt>
                    <dd>{$affiliate_plan.cookie_expiration|default:0}</dd>

                    {if $affiliate_plan.payout_types.init_balance.value}
                        <dt>{__("set_initial_balance")}:</dt>
                        <dd>{include file="common/price.tpl" value=$affiliate_plan.payout_types.init_balance.value}</dd>
                    {/if}

                    {if $affiliate_plan.min_payment}
                        <dt>{__("minimum_commission_payment")}:</dt>
                        <dd>{include file="common/price.tpl" value=$affiliate_plan.min_payment}</dd>
                    {/if}
                </dl>
            </div>

            {if $affiliate_plan.payout_types}
                <div class="affiliate-rates float-left">
                    {include file="common/subheader.tpl" title=__("commission_rates")}
                    <dl class="clearfix">
                        {foreach from=$payout_types key="payout_id" item=payout_data name=payout_type}
                            {if $payout_data.default=="Y" && $affiliate_plan.payout_types.$payout_id.value}
                                {assign var="lang_var" value=$payout_data.title}
                                <dt {if $smarty.foreach.payout_type.first}class="no-border"{/if}>{__($lang_var)}:</dt>
                                <dd {if $smarty.foreach.payout_type.first}class="no-border"{/if}>{include file="common/modifier.tpl" mod_value=$affiliate_plan.payout_types.$payout_id.value mod_type=$affiliate_plan.payout_types.$payout_id.value_type}</dd>
                            {/if}
                        {/foreach}
                    </dl>
                </div>
            {/if}
        </div>

    {if $linked_products}
        {include file="common/subheader.tpl" title=__("linked_products")}
        <table class="table table-width">
        <tr>
            <th style="width: 70%">{__("product_name")}</th>
            <th style="width: 30%">{__("sales_commission")}</th>
        </tr>
        {foreach from=$linked_products item=product}
        <tr {cycle values=" ,class=\"table-row\""}>
            <td>
                {include file="common/popupbox.tpl" id="product_`$product.product_id`" link_text=$product.product text=__("product") href="banner_products.view?product_id=`$product.product_id`" content=""}</td>
            <td>{include file="common/modifier.tpl" mod_value=$product.sale.value mod_type=$product.sale.value_type}</td>
        </tr>
        {/foreach}
        </table>
    {/if}

    {if $linked_categories}
        {include file="common/subheader.tpl" title=__("linked_categories")}
        <table class="table table-width">
        <tr>
            <th style="width: 70%">{__("category_name")}</th>
            <th style="width: 30%">{__("sales_commission")}</th>
        </tr>
        {foreach from=$linked_categories item=category}
        <tr {cycle values=" ,class=\"table-row\""}>
            <td>
                <a href="{"categories.view?category_id=`$category.category_id`"|fn_url}" class="manage-root-item" target="_blank">{$category.category}</a></td>
            <td>
                {include file="common/modifier.tpl" mod_value=$category.sale.value mod_type=$category.sale.value_type}</td>
        </tr>
        {/foreach}
        </table>
    {/if}

    {if $coupons}
        {include file="common/subheader.tpl" title=__("coupons")}
        <table class="table table-width">
        <tr>
            <th style="width: 35%">{__("coupon_code")}</th>
            <th style="width: 15%">{__("valid")}</th>
            <th style="width: 30%">{__("use_coupons_commission")}</th>
        </tr>
        {foreach from=$coupons item=coupon}
        <tr {cycle values=" ,class=\"table-row\""}>
            <td>{$coupon.coupon_code}</td>
            <td class="nowrap{if (($coupon.from_date <= $coupon.current_date)&&($coupon.to_date>=$coupon.current_date))} strong{/if}">
                {$coupon.from_date|date_format:"`$settings.Appearance.date_format`"} - {$coupon.to_date|date_format:"`$settings.Appearance.date_format`"}</td>
            <td>
                {include file="common/modifier.tpl" mod_value=$coupon.use_coupon.value mod_type=$coupon.use_coupon.value_type}</td>
        </tr>
        {/foreach}
        </table>
    {/if}

    {if $affiliate_plan.commissions}
        {include file="common/subheader.tpl" title=__("commissions")}
        <table class="table table-width">
        <tr>
            <th style="width: 70%">{__("multi_tier_affiliates")}</th>
            <th style="width: 30%">{__("commission")}</th>
        </tr>
        {foreach from=$affiliate_plan.commissions key="com_id" item="commission"}
        <tr {cycle values=" ,class=\"table-row\""}>
            <td>
                {__("level")} {$com_id+1}</td>
            <td>
                {include file="common/modifier.tpl" mod_value=$commission mod_type="P"}</td>
        </tr>
        {/foreach}
        </table>
    {/if}
    {else}
        <p>{__("text_no_affiliate_assigned")}.</p>

    {/if}

    <div class="buttons-container">
        {__("link_new_affiliate")}: <a href="{"profiles.add?aff_id=`$auth.user_id`"|fn_url:'C':'http'}" onclick="return false;">{"profiles.add?aff_id=`$auth.user_id`"|fn_url:'C':'http'}</a>
    </div>
</div>

{capture name="mainbox_title"}
    {__(affiliate)} <span class="subtitle">/ {__("affiliate_plan")}</span>
{/capture}