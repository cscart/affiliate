{include file="addons/affiliate/common/affiliate_menu.tpl"}
<div class="affiliate">
    <div class="clearfix affiliate-plan-block">
        <div class="affiliate-plan float-left">
            {include file="common/subheader.tpl" title=__("affiliate_information")}
            <dl class="clearfix">
                <dt class="no-border">{__("status")}:</dt>
                <dd class="no-border">{if $partner.approved=="A"}{__("approved")}{elseif $partner.approved=="D"}{__("declined")}{else}{__("awaiting_approval")}{/if}</dd>

                {if $partner.plan}
                    <dt>{__("affiliate_plan")}:</dt>
                    <dd><a href="{"affiliate_plans.list"|fn_url}">{$partner.plan}</a></dd>
                {/if}

                {if $partner.balance}
                    <dt>{__("balance_account")}:</dt>
                    <dd>{include file="common/price.tpl" value=$partner.balance}</dd>
                {/if}

                <dt>{__("total_payouts")}:</dt>
                <dd>{include file="common/price.tpl" value=$partner.total_payouts}{if $partner.total_payouts} (<a href="{"payouts.list"|fn_url}">{__("view")}</a>){/if}</dd>
            </dl>
        </div>

        <div class="affiliate-rates float-left">
            {include file="common/subheader.tpl" title=__("commissions_of_last_periods")}
            <dl class="clearfix">
                {foreach from=$last_payouts item=period name=last_payout}
                    <dt {if $smarty.foreach.last_payout.first}class="no-border"{/if}>
                        {if $period.amount > 0}
                        {capture name="_href"}aff_statistics.commissions?action=search&statistic_search%5Bpartner_id%5D={$partner.user_id}&statistic_search%5Bstatus%5D%5BA%5D=A&statistic_search%5Bstatus%5D%5BP%5D=P&statistic_search%5Bperiod%5D=C&time_from={$period.range.start}&time_to={$period.range.end}{/capture}
                        <a href="{$smarty.capture._href|fn_url}">{/if}{$period.range.start|date_format:$settings.Appearance.date_format}{if $period.amount > 0}</a>{/if}
                    </dt>
                    <dd {if $smarty.foreach.last_payout.first}class="no-border"{/if}>{include file="common/price.tpl" value=$period.amount}</dd>
                {/foreach}
                <dt>{__("total_commissions")}:</dt>
                <dd ><strong>{include file="common/price.tpl" value=$total_commissions}</strong></dd>
            </dl>
        </div>
    </div>

    {include file="addons/affiliate/views/partners/components/partner_tree_root.tpl" partners=$partners}

</div>
{capture name="mainbox_title"}
    {__(affiliate)} <span class="subtitle">/ {__("balance_account")}</span>
{/capture}