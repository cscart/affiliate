{capture name="mainbox"}
    <form action="{""|fn_url}" method="post" name="manage_affiliate_plans_form">

        {include file="common/pagination.tpl"}

        {if $affiliate_plans}
        <table width="100%" class="table table-middle">
            <thead>
            <tr>
                <th class="left" width="1%">
                    {include file="common/check_items.tpl"}</th>
                <th width="35%">{__("name")}</th>
                <th class="center">{__("affiliates")}</th>
                <th>&nbsp;</th>
                <th width="10%" class="right">{__("status")}</th>
            </tr>
            </thead>

            {foreach from=$affiliate_plans item="aff_plan"}

                {$allow_save = $aff_plan|fn_allow_save_object:"affiliate_plans"}
                <tr>
                    <td class="left">
                        <input type="checkbox" name="plan_ids[]" value="{$aff_plan.plan_id}" class="cm-item"/></td>
                    <td>
                        <a href="{"`$runtime.controller`.update?plan_id=`$aff_plan.plan_id`"|fn_url}">{$aff_plan.name}</a>
                        {include file="views/companies/components/company_name.tpl" object=$aff_plan}
                    </td>
                    <td class="center">{$aff_plan.count_partners}</td>
                    <td class="nowrap right">
                        {capture name="tools_list"}
                            <li>{btn type="list" text=__("edit") href="affiliate_plans.update?plan_id=`$aff_plan.plan_id`"}</li>
                            {if "ULTIMATE"|fn_allowed_for}
                                {if $allow_save}
                                    <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?plan_id=`$aff_plan.plan_id`"}</li>
                                {/if}
                            {else}
                                <li>{btn type="list" class="cm-confirm" text=__("delete") href="affiliate_plans.delete?plan_id=`$aff_plan.plan_id`"}</li>
                            {/if}
                        {/capture}
                        <div class="hidden-tools">
                            {dropdown content=$smarty.capture.tools_list}
                        </div>
                    </td>
                    <td class="right">
                        {if "ULTIMATE"|fn_allowed_for}
                            {if $allow_save}
                                {include file="common/select_popup.tpl" id=$aff_plan.plan_id status=$aff_plan.status hidden="" object_id_name="plan_id" table="affiliate_plans"}
                            {/if}
                        {else}
                            {include file="common/select_popup.tpl" id=$aff_plan.plan_id status=$aff_plan.status hidden="" object_id_name="plan_id" table="affiliate_plans"}
                        {/if}
                    </td>
                </tr>
            {/foreach}
        </table>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        {include file="common/pagination.tpl"}

        {capture name="sidebar"}
            <div class="sidebar-row">
                <h6>{__("menu")}</h6>
                <ul class="nav nav-list">
                    <li><a href="{"addons.manage#groupaffiliate"|fn_url}">{__("affiliate_settings")}</a></li>
                </ul>
            </div>
        {/capture}

        {capture name="adv_buttons"}
            {btn type="add" title=__("affiliate_add_plan") href="affiliate_plans.add"}
        {/capture}

        {capture name="buttons"}
            {capture name="tools_list"}
                {if $affiliate_plans}
                    <li>{btn type="delete_selected" dispatch="dispatch[affiliate_plans.m_delete]" form="manage_affiliate_plans_form"}</li>
                {/if}
            {/capture}
            {dropdown content=$smarty.capture.tools_list}
        {/capture}

    </form>

{/capture}
{include file="common/mainbox.tpl" title=__("plans") content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar}
