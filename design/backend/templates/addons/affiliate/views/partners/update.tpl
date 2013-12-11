{capture name="mainbox"}
<table cellpadding="6" width="100%">
<tr valign="top">
    <td width="50%">
    {include file="common/subheader.tpl" title=__("personal_information")}
    
    <div class="well">
        <dl class="dl-horizontal">
            <dt>{__("active")}:</dt>
            <dd><p>{if $partner.status == "A"}{__("yes")}{else}{__("no")}{/if}</p></dd>
       
        {if $settings.General.use_email_as_login != "Y"}
            <dt>{__("username")}:</dt>
            <dd><p>{$partner.user_login}</p></dd>
        {/if}
        
            <dt>{__("first_name")}:</dt>
            <dd><p>{$partner.firstname}</p></dd>
        
            <dt>{__("last_name")}:</dt>
            <dd><p>{$partner.lastname}</p></dd>
        
        {if $partner.company}
            <dt>{__("company")}:</dt>
            <dd><p>{$partner.company}</p></dd>
        {/if}
        
        {if $partner.email}
            <dt>{__("email")}:</dt>
            <dd><p><a href="mailto:{$partner.email|escape:url}" class="strong">{$partner.email}</a></p></dd>    
        {/if}
        
        {if $partner.phone}
            <dt>{__("phone")}:</dt>
            <dd><p>{$partner.phone}</p></dd>
        {/if}
        
        {if $partner.fax}
            <dt>{__("fax")}:</dt>
            <dd><p>{$partner.fax}</p></dd>
        {/if}
    </dl>
    </div>
    
    {include file="common/subheader.tpl" title=__("affiliate_information")}

    {if $settings.General.use_email_as_login != "Y"}
        {assign var="user_login_query" value="&user_login=`$partner.user_login`"}
    {/if}
    
    <div class="well">
        <dl class="dl-horizontal">

            {assign var="partner_email" value=$partner.email|escape:url}
            <dt>{__("status")}:</dt>
            <dd><p>{if $partner.approved == "A"}{__("approved")}{elseif $partner.approved == "D"}{__("declined")}{else}{__("awaiting_approval")}{/if}
            (<a href="{"partners.manage?user_type=P&name=`$partner.firstname``$user_login_query`&email=`$partner_email`"|fn_url}">{__("change")}</a>)
            </p></dd>

        {if $addons.affiliate.show_affiliate_code == "Y"}
            <dt>{__("affiliate_code")}:</dt>
            <dd><p>{$partner.user_id|fn_dec2any}</p></dd>
        {/if}
        
        {if $partner.plan}
            <dt>{__("plan")}:</dt>
            <dd><p><a href="{"affiliate_plans.update?plan_id=`$partner.plan_id`"|fn_url}" class="strong">{$partner.plan}</a> (<a href="{"partners.manage.reset_search?user_type=P&name=`$partner.firstname``$user_login_query`&email=`$partner_email`"|fn_url}">{__("change")}</a>)</p></dd>
        {/if}
        
            <dt>{__("balance_account")}:</dt>
            <dd><p>{include file="common/price.tpl" value=$partner.balance}</p></dd>
        
            <dt>{__("total_payouts")}:</dt>
            <dd>
            <form action="{""|fn_url}" method="POST" name="partner_payouts_form">
                <input type="hidden" name="payout_search[partner_id]" value="{$partner.user_id}" />
                <p>{include file="common/price.tpl" value=$partner.total_payouts}{if $partner.total_payouts} (<a href="{"payouts.manage?partner_id=`$partner.user_id`&period=A"|fn_url}">{__("view")}</a>)</p>{/if}
            </form>
            </dd>
        
        </dl>
    </div>
    </td>
    <td class="details-block-container" width="50%">
    
    {include file="common/subheader.tpl" title=__("commissions_of_last_periods")}
    <div class="well">
    <table cellpadding="4" cellspacing="1" border="0">
        {foreach from=$last_payouts item=period}
        <tr>
            <td>
            {assign var="time_from" value=$period.range.start|date_format:"`$settings.Appearance.date_format`"|escape:url}
            {assign var="time_to" value=$period.range.end|date_format:"`$settings.Appearance.date_format`"|escape:url}
            {if $period.amount > 0}<a href="{"aff_statistics.approve?partner_id=`$partner.user_id`&plan_id=`$partner.plan_id`&period=C&time_from=`$time_from`&time_to=`$time_to`"|fn_url}">{/if}{$period.range.start|date_format:$settings.Appearance.date_format}{if $period.amount > 0}</a>{/if}</td>
            <td class="progress-small">{include file="views/sales_reports/components/graph_bar.tpl" bar_width="300px" value_width=$period.amount/$max_amount*100|round}</td>
            <td align="right">{include file="common/price.tpl" value=$period.amount}</td>
        </tr>
        {/foreach}
        <tr>
            <td colspan="3" align="right"><p>{__("total_commissions")}:&nbsp;<span>{include file="common/price.tpl" value=$total_commissions}</span></p></td>
        </tr>
    </table>
    </td>
</tr>
</table>

{include file="common/subheader.tpl" title=__("affiliate_tree")}
<div class="items-container multi-level">
{include file="addons/affiliate/views/partners/components/partner_tree.tpl" partners=$partners header=1 level=0}
</div>
{/capture}

{capture name="buttons"}
    {include file="common/view_tools.tpl" url="partners.update?user_id="}
    <a href="{"profiles.update?user_id=`$partner.user_id`"|fn_url}" class="btn btn-primary">{__("edit_affiliate")}</a>
{/capture}

{include file="common/mainbox.tpl" title="{__("viewing_affiliate")}: `$partner.firstname` `$partner.lastname`" content=$smarty.capture.mainbox extra_tools=$smarty.capture.extra_tools buttons=$smarty.capture.buttons}

</form>