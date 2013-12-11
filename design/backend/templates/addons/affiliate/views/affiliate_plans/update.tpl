{if $affiliate_plan}
    {assign var="id" value=$affiliate_plan.plan_id}
{else}
    {assign var="id" value=0}
{/if}
{$allow_save=true}

{if "ULTIMATE"|fn_allowed_for}
    {$allow_save=$affiliate_plan|fn_allow_save_object:"affiliate_plans"}
{/if}

{capture name="mainbox"}

{capture name="tabsbox"}

<form action="{""|fn_url}" method="post" name="affiliate_plan_form" class="form-horizontal form-edit  {if !$allow_save}cm-hide-inputs{/if}">
<input id="selected_section" type="hidden" name="selected_section" value="" />
<input type="hidden" name="plan_id" value="{$id}" />
<div id="content_general">

<fieldset>
    <div class="control-group">
        <label for="elm_aff_plan_name" class="cm-required control-label">{__("name")}:</label>
        <div class="controls">
        <input type="text" name="affiliate_plan[name]" id="elm_aff_plan_name" value="{$affiliate_plan.name}" size="50" class="input-large" />
        </div>
    </div>
    
    <div class="control-group">
        <label for="elm_aff_plan_description" class="control-label">{__("description")}:</label>
        <div class="controls">
        <textarea name="affiliate_plan[description]" id="elm_aff_plan_description" cols="50" rows="4" class="input-large">{$affiliate_plan.description}</textarea>
        </div>
    </div>
    
    <div class="control-group">
        <label for="elm_aff_plan_cookie_expiration" class="control-label">{__("aff_cookie_expiration")}:</label>
        <div class="controls">
        <input type="text" name="affiliate_plan[cookie_expiration]" id="elm_aff_plan_cookie_expiration" value="{$affiliate_plan.cookie_expiration|default:0}" size="10" class="input-text" />
        </div>
    </div>
    
    <div class="control-group">
        <label for="elm_aff_plan_init_balance" class="control-label">{__("set_initial_balance")} ({$currencies.$primary_currency.symbol nofilter}):</label>
        <div class="controls">
        <input type="text" name="affiliate_plan[payout_types][init_balance][value]" id="elm_aff_plan_init_balance" value="{$affiliate_plan.payout_types.init_balance.value|default:"0"}" size="10" class="input-text" />
        <input type="hidden" name="affiliate_plan[payout_types][init_balance][value_type]" value="{$affiliate_plan.payout_types.init_balance.value_type|default:"A"}" />
        </div>
    </div>
    
    <div class="control-group">
        <label for="elm_aff_plan_min_payment" class="cm-required control-label">{__("minimum_commission_payment")} ({$currencies.$primary_currency.symbol nofilter}):</label>
        <div class="controls">
        <input type="text" name="affiliate_plan[min_payment]" id="elm_aff_plan_min_payment" value="{$affiliate_plan.min_payment}" size="10" class="input-text" />
        </div>
    </div>
    
    <div class="control-group">
        <label for="elm_aff_plan_method_based_selling_price" class="control-label">{__("method_based_selling_price")}:</label>
        <div class="controls">
        <input type="hidden" name="affiliate_plan[method_based_selling_price]" value="N" />
        <input type="checkbox" name="affiliate_plan[method_based_selling_price]" id="elm_aff_plan_method_based_selling_price" {if $affiliate_plan.method_based_selling_price == "Y"}checked="checked"{/if} value="Y" />
        </div>
    </div>

    <div class="control-group">
        <label for="elm_aff_plan_use_coupon_commission" class="control-label">{__("coupon_commission_overide_all")}:</label>
        <div class="controls">
        <input type="hidden" name="affiliate_plan[use_coupon_commission]" value="N" />
        <input type="checkbox" name="affiliate_plan[use_coupon_commission]" id="elm_aff_plan_use_coupon_commission" {if $affiliate_plan.use_coupon_commission == "Y" || !$affiliate_plan}checked="checked"{/if} value="Y" />
        </div>
    </div>
    {if "ULTIMATE"|fn_allowed_for}
    {include file="views/companies/components/company_field.tpl"
        name="affiliate_plan[company_id]"
        id="affiliate_plan_company_id"
        selected=$affiliate_plan.company_id
    }
    {else}
        <input type="hidden" name="affiliate_plan[company_id]" value="0">
    {/if}

    {include file="common/select_status.tpl" input_name="affiliate_plan[status]" id="elm_aff_plan_status" obj=$affiliate_plan}
</fieldset>

{if $payout_types}
<fieldset>
    {foreach from=$payout_types key="payout_id" item=payout_data name="payout_types"}
    
    {if $payout_data && $smarty.foreach.payout_types.first}
    
        {include file="common/subheader.tpl" title=__("commission_rates")}
    {/if}
    
    {if $payout_data.default == "Y"}
        {assign var="payout_var" value=$payout_data.title}
        <div class="control-group">
            <label for="elm_aff_plan_payout_types_{$payout_data.id}" class="control-label">{__($payout_var)}:</label>
            <div class="controls">
            <input type="text" name="affiliate_plan[payout_types][{$payout_data.id}][value]" id="elm_aff_plan_payout_types_{$payout_data.id}" value="{$affiliate_plan.payout_types.$payout_id.value|default:"0"}" size="10" class="input-text" />&nbsp;
            <select name="affiliate_plan[payout_types][{$payout_data.id}][value_type]">
                {foreach from=$payout_data.value_types key="value_type" item="name_lang_var"}
                    <option value="{$value_type}" {if $affiliate_plan.payout_types.$payout_id.value_type==$value_type}selected="selected"{/if}>{__($name_lang_var)} {if $value_type == "A"}({$currencies.$primary_currency.symbol nofilter}){elseif $value_type == "P"}(%){/if}</option>
                {/foreach}
            </select>
            </div>
        </div>
    {/if}
    
    {/foreach}
</fieldset>
{/if}
</div>

{if $affiliate_plan}

{** Multi affiliates **}
<div id="content_multi_tier_affiliates">
{capture name="levels_m_addition_picker"}
<form action="{""|fn_url}" method="post" name="levels_m_addition_form">
<input type="hidden" name="plan_id" value="{$id}" />
<table width="100%" class="table table-middle">
<thead>
<tr class="cm-first-sibling">
    <th>{__("commission")} (%)</th>
    <th>&nbsp;</th>
</tr>
</thead>
<tr id="box_new_level">
    <td><input type="text" name="levels[0][commission]" size="10" class="input-large" /></td>
    <td width="90%" class="right">
        <div class="hidden-tools">
            {include file="buttons/multiple_buttons.tpl" item_id="new_level"}
        </div>
    </td>
</table>

<div class="buttons-container">
    {include file="buttons/save_cancel.tpl" but_name="dispatch[affiliate_plans.add_commissions]" but_text=__("add_selected") cancel_action="close"}
</div>

</form>
{/capture}

{if "ULTIMATE"|fn_allowed_for && $allow_save || !"ULTIMATE"|fn_allowed_for}
    <div class="clearfix">
        <div class="pull-right">
            {if $affiliate_plan.commissions}
                {btn type="delete_selected" icon="icon-trash" dispatch="dispatch[affiliate_plans.m_delete]" form="affiliate_plan_form"}
            {/if}

            {include file="common/popupbox.tpl" id="add_commissions" text=__("add_commissions_multi_affiliates") but_text=__("add_commissions") act="create" icon="icon-plus"}
        </div>
    </div>
{/if}

<table class="table table-middle" width="100%">
<thead>
<tr>
    <th class="center" width="1%">
        {include file="common/check_items.tpl" check_target="commission"}</th>
    <th>{__("level")}</th>
    <th>{__("commission")} (%)</th>
    <th>&nbsp;</th>
</tr>
</thead>
{if $affiliate_plan.commissions}
{foreach from=$affiliate_plan.commissions key="com_id" item="commission"}
<tr>
        <td class="center">
            <input type="checkbox" name="affiliate_plan[commission_ids][]" value="{$com_id}" class="checkbox cm-item-commission" /></td>
        <td>
        {__("level")}&nbsp;{$com_id+1}</td>
       <td>
           <input type="text" name="affiliate_plan[commissions][{$com_id}]" value="{$commission}" size="10" class="input-small" /></td>
       <td class="nowrap right">
        {capture name="tools_list"}
        {if "ULTIMATE"|fn_allowed_for && $allow_save || !"ULTIMATE"|fn_allowed_for}
            <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?commission_id=`$com_id`&plan_id=`$id`"}</li>
        {/if}
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
</tr>
{/foreach}
{else}
<tr class="no-items">
    <td colspan="4"><p>{__("no_items")}</p></td>
</tr>
{/if}
</table>
</div>
{** /Multi affiliates **}

{** Linked products **}
<div id="content_linked_products">
{if "ULTIMATE"|fn_allowed_for && $allow_save || !"ULTIMATE"|fn_allowed_for}
<div class="clearfix">
    <div class="pull-right">
        {if $linked_products}
            {btn type="delete_selected" icon="icon-trash" dispatch="dispatch[affiliate_plans.m_delete]" form="affiliate_plan_form"}
        {/if}

        {include file="pickers/products/picker.tpl" extra_var="affiliate_plans.add_products?plan_id=`$id`&selected_section=linked_products" data_id="affiliate"}
    </div>
</div>
{/if}
<table width="100%" class="table table-middle">
<thead>
<tr>
    <th width="1%" class="left">
        {include file="common/check_items.tpl" check_target="product"}</th>
    <th width="60%">{__("product_name")}</th>
{if $payout_types}
    <th width="20%">{__("sales_commission")}</th>
    <th>&nbsp;</th>
{/if}
</thead>
</tr>
{if $linked_products}
{foreach from=$linked_products key=product_id item=product}
<tr>
    <td class="left"><input type="checkbox" name="affiliate_plan[product_ids][]" value="{$product_id}" class="cm-item-product" /></td>
    <td>
        {if !"ULTIMATE"|fn_allowed_for}
            <a href="{"products.update?product_id=`$product_id`"|fn_url}">{$product.product nofilter}</a>
        {/if}

        {if "ULTIMATE"|fn_allowed_for}
            {if $allow_save}
                <a href="{"products.update?product_id=`$product_id`"|fn_url}">{$product.product nofilter}</a>
            {else}
                {$product.product nofilter}
            {/if}
        {/if}
    </td>
{if $payout_types}
    <td class="nowrap">
        <input type="text" name="affiliate_plan[sales][{$product_id}][value]" value="{$product.sale.value}" size="10" class="input-small" />&nbsp;
        <select name="affiliate_plan[sales][{$product_id}][value_type]" class="span2">
        {foreach from=$payout_types.sale.value_types key="value_type" item="name_lang_var"}
            <option value="{$value_type}" {if $product.sale.value_type==$value_type}selected="selected"{/if}>{__($name_lang_var)} {if $value_type == "A"}({$currencies.$primary_currency.symbol nofilter}){elseif $value_type == "P"}(%){/if}</option>
        {/foreach}
        </select>
    </td>
    <td width="10%" class="nowrap right">
        {capture name="tools_list"}
            <li>{btn type="list" text=__("edit") href="products.update?product_id=`$product_id`"}</li>

            {if !"ULTIMATE"|fn_allowed_for}
                <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?product_id=`$product_id`&plan_id=`$id`"}</li>
            {/if}

            {if "ULTIMATE"|fn_allowed_for}
                {if $allow_save}
                    <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?product_id=`$product_id`&plan_id=`$id`"}</li>
                {/if}
            {/if}
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
{/if}
</tr>
{/foreach}
{else}
<tr class="no-items">
    <td colspan="{if $payout_types}4{else}2{/if}"><p>{__("no_items")}</p></td>
</tr>
{/if}
</table>
<!--content_linked_products--></div>
{** /Linked products **}

{** Linked categories **}
<div id="content_linked_categories">

{if "ULTIMATE"|fn_allowed_for && $allow_save || !"ULTIMATE"|fn_allowed_for}
    {** Form submit section **}
    <div class="clearfix">
        <div class="pull-right">
            {if $linked_categories}
                {btn type="delete_selected" icon="icon-trash" dispatch="dispatch[affiliate_plans.m_delete]" form="affiliate_plan_form"}
            {/if}

            {include file="pickers/categories/picker.tpl" extra_var="affiliate_plans.add_categories?plan_id=`$id`&selected_section=linked_categories" multiple=true pos=false}
        </div>
    </div>
    {** /Form submit section **}
{/if}

<table class="table table-middle">
<thead>
<tr>
    <th width="1%" class="left">
        {include file="common/check_items.tpl" check_target="category"}</th>
    <th width="50%">{__("category")}</th>
    <th width="20%">{__("sales_commission")}</th>
    <th>&nbsp;</th>
</tr>
</thead>
{if $linked_categories}
{foreach from=$linked_categories item=category}
<tr>
    <td class="left"><input type="checkbox" name="affiliate_plan[category_ids][]" value="{$category.category_id}" class="cm-item-category" /></td>
    <td>
        {if !"ULTIMATE"|fn_allowed_for}
            <a href="{"categories.update?category_id=`$category.category_id`"|fn_url}">{$category.category}</a>
        {/if}

        {if "ULTIMATE"|fn_allowed_for}
            {if $allow_save}
                <a href="{"categories.update?category_id=`$category.category_id`"|fn_url}">{$category.category}</a>
            {else}
                {$category.category}
            {/if}
        {/if}
    </td>
    <td class="nowrap">
        <input type="text" name="affiliate_plan[category_sales][{$category.category_id}][value]" value="{$category.sale.value}" size="10" class="input-small" />&nbsp;
        <select name="affiliate_plan[category_sales][{$category.category_id}][value_type]" class="span3">
        {foreach from=$payout_types.sale.value_types key="value_type" item="name_lang_var"}
            <option value="{$value_type}" {if $category.sale.value_type==$value_type}selected="selected"{/if}>{__($name_lang_var)} {if $value_type == "A"}({$currencies.$primary_currency.symbol nofilter}){elseif $value_type == "P"}(%){/if}</option>
        {/foreach}
        </select>
    </td>
    <td class="nowrap right">
        {capture name="tools_list"}
        <li>{btn type="list" text=__("edit") href="categories.update?category_id=`$category.category_id`"}</li>

        {if !"ULTIMATE"|fn_allowed_for}
            <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?category_id=`$category.category_id`&plan_id=`$id`"}</li>
        {/if}

        {if "ULTIMATE"|fn_allowed_for}
            {if $allow_save}
                <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?category_id=`$category.category_id`&plan_id=`$id`"}</li>
            {/if}
        {/if}
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
</tr>
{/foreach}
{else}
<tr class="no-items">
    <td colspan="4"><p>{__("no_items")}</p></td>
</tr>
{/if}
</table>
</div>
{** /Linked categories **}

{** Coupons **}
<div id="content_coupons">
{capture name="add_coupons_picker"}
<form action="{""|fn_url}" name="add_coupons_form" method="POST">
<input type="hidden" name="plan_id" value="{$id}" />
    <table class="table table-middle">
    <thead>
    <tr>
        <th class="center" width="1%">
            {include file="common/check_items.tpl" check_target="new-coupon"}</th>
        <th width="55%">{__("name")}</th>
        <th width="20%">{__("use_coupons_commission")}</th>
        <th width="15%">{__("valid")}</th>
    </tr>
    </thead>
    {if $coupons}
        {foreach from=$coupons item=coupon}
        <tr>
            <td class="left">
                <input type="checkbox" name="promotion_ids[]" value="{$coupon.promotion_id}" class="cm-item-new-coupon" /></td>
            <td>
                <a href="{"promotions.update?promotion_id=`$coupon.promotion_id`"|fn_url}">{$coupon.name}</a></td>
            <td class="nowrap">
                <input type="text" name="coupons[{$coupon.promotion_id}][value]" size="10" class="input-small" />&nbsp;
                <select name="coupons[{$coupon.promotion_id}][value_type]" class="span2">
                {foreach from=$payout_types.use_coupon.value_types key="value_type" item="name_lang_var"}
                    <option value="{$value_type}">{__($name_lang_var)} {if $value_type == "A"}({$currencies.$primary_currency.symbol nofilter}){elseif $value_type == "P"}(%){/if}</option>
                {/foreach}
                </select>
            </td>
            <td class="nowrap {if (($coupon.from_date <= $coupon.current_date) && ($coupon.to_date >= $coupon.current_date))}strong{/if}">
                {$coupon.from_date|date_format:"`$settings.Appearance.date_format`"} - {$coupon.to_date|date_format:"`$settings.Appearance.date_format`"}</td>
        </tr>
        {/foreach}
    {else}
        <tr class="no-items">
            <td colspan="4"><p>{__("no_items")}</p></td>
        </tr>
    {/if}
    </table>

    <div class="buttons-container">
        {include file="buttons/save_cancel.tpl" but_meta="cm-process-items" but_name="dispatch[affiliate_plans.add_coupons]" but_text=__("add_selected") cancel_action="close"}
    </div>
</form>
{/capture}
{if "ULTIMATE"|fn_allowed_for && $allow_save || !"ULTIMATE"|fn_allowed_for}
    <div class="clearfix">
        <div class="pull-right">
            {if $affiliate_plan.coupons}
                {btn type="delete_selected" icon="icon-trash" dispatch="dispatch[affiliate_plans.m_delete]" form="affiliate_plan_form"}
            {/if}

            {include file="common/popupbox.tpl" id="add_coupons" but_text=__("add_coupons") act="create" icon="icon-plus"}
        </div>
    </div>
{/if}

<table class="table table-middle" width="100%">
<thead>
<tr>
    <th width="1%" class="left">
    {include file="common/check_items.tpl" check_target="coupon"}</th>
    <th width="50%">{__("coupon")}</th>
    <th>{__("use_coupons_commission")}</th>
    <th>{__("valid")}</th>
    <th width="10%">&nbsp;</th>
</tr>
</thead>
{if $affiliate_plan.coupons}
{foreach from=$affiliate_plan.coupons item=coupon}
<tr>
    <td class="left">
        <input type="checkbox" name="affiliate_plan[promotion_ids][]" value="{$coupon.promotion_id}" class="cm-item-coupon" /></td>
    <td width="60%">
        {if $allow_save}
            <a href="{"promotions.update?promotion_id=`$coupon.promotion_id`"|fn_url}">{$coupon.name}</a>
        {else}
            {$coupon.name}
        {/if}
    </td>
    <td class="nowrap">
        <input type="text" name="affiliate_plan[coupons][{$coupon.promotion_id}][value]" value="{$coupon.use_coupon.value}" size="10" class="input-small" />&nbsp;
        <select name="affiliate_plan[coupons][{$coupon.promotion_id}][value_type]" class="span2">
        {foreach from=$payout_types.use_coupon.value_types key="value_type" item="name_lang_var"}
            <option value="{$value_type}" {if $coupon.use_coupon.value_type==$value_type}selected="selected"{/if}>{__($name_lang_var)} {if $value_type == "A"}({$currencies.$primary_currency.symbol nofilter}){elseif $value_type == "P"}(%){/if}</option>
        {/foreach}
        </select>
    </td>
    <td class="nowrap {if (($coupon.from_date <= $coupon.current_date) && ($coupon.to_date >= $coupon.current_date))} strong{/if}">
        {$coupon.from_date|date_format:"`$settings.Appearance.date_format`"} - {$coupon.to_date|date_format:"`$settings.Appearance.date_format`"}</td>
    <td class="nowrap right">
        {capture name="tools_list"}
        <li>{btn type="list" text=__("edit") href="promotions.update?promotion_id=`$coupon.promotion_id`"}</li>

        {if !"ULTIMATE"|fn_allowed_for}
            <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?promotion_id=`$coupon.promotion_id`&plan_id=`$id`"}</li>
        {/if}

        {if "ULTIMATE"|fn_allowed_for}
            {if $allow_save}
                <li>{btn type="list" text=__("delete") class="cm-confirm" class="cm-confirm" href="affiliate_plans.delete?promotion_id=`$coupon.promotion_id`&plan_id=`$id`"}</li>
            {/if}
        {/if}
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
</tr>
{/foreach}
{else}
<tr class="no-items">
    <td colspan="5"><p>{__("no_items")}</p></td>
</tr>
{/if}
</table>


</div>
{** /Coupons **}
{/if}
</form>

{include file="common/popupbox.tpl" id="add_commissions" text=__("add_commissions_multi_affiliates") content=$smarty.capture.levels_m_addition_picker act=""}
{include file="common/popupbox.tpl" id="add_coupons" text=__("add_coupons") content=$smarty.capture.add_coupons_picker}
{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}


{if !$id}
    {assign var="title" value=__("new_plan")}
{else}
    {assign var="title" value="{__("editing_plan")}: `$affiliate_plan.name`"}
{/if}

{capture name="buttons"}
    {if $allow_save}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[affiliate_plans.update]" but_role="submit-link" but_target_form="affiliate_plan_form" save=$id}
    {/if}
{/capture}

{/capture}
{include file="common/mainbox.tpl" title=$title content=$smarty.capture.mainbox select_languages=true buttons=$smarty.capture.buttons}
