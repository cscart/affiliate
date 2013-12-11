
{include file="common/subheader.tpl" title=__("general_statistics") target="#acc_general_statistics"}

<div id="acc_general_statistics" class="in collapse">

<table width="100%" class="table table-middle">
<thead>
<tr>
    <th width="40%">{__("action")}</th>
    <th width="15%" class="right">{__("count")}</th>
    <th class="right" width="15%">{__("sum")}</th>
    <th class="right" width="15%">{__("avg")}</th>
    <th class="right" width="15%">{__("affiliates")}</th>
</tr>
</thead>
{if $general_stats}
{foreach from=$payout_types key="payout_id" item="a"}
    {assign var="payout" value=$general_stats.$payout_id}
    {assign var="payout_var" value=$a.title}
<tr>
    <td><span>{__($payout_var)}</span></td>
    <td class="right">{$payout.count|default:"0"}</td>
    <td class="right">{include file="common/price.tpl" value=$payout.sum|round:2}</td>
    <td class="right">{include file="common/price.tpl" value=$payout.avg|round:2}</td>
    <td class="right">{$payout.partners|default:"0"}</td>
</tr>
{/foreach}
{if $general_stats.total}
    {assign var="payout" value=$general_stats.total}
<tr class="manage-root-row strong">
    <td>{__("total")}</td>
    <td class="right">{$payout.count|default:"0"}</td>
    <td class="right">{include file="common/price.tpl" value=$payout.sum|round:2}</td>
    <td class="right">{include file="common/price.tpl" value=$payout.avg|round:2}</td>
    <td class="right">{$payout.partners|default:"0"}</td>
</tr>
{/if}
{else}
<tr class="no-items">
    <td colspan="5"><p>{__("no_items")}</p></td>
</tr>
{/if}
</table>

{if $additional_stats}
    {foreach from=$additional_stats key="a_stats_name" item="a_stats_value"}
    <div class="form-horizontal form-edit">
        <div class="control-group">
            <label class="control-label"><strong>{__($a_stats_name)}</strong></label>
            <div class="controls">
                {$a_stats_value}
            </div>
        </div>        
    </div>
    {/foreach}
{/if}

</div>
