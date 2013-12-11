{if $order_info.affiliate.commissions}
    {include file="common/subheader.tpl" title=__("affiliate_commissions")}
    <table  class="table">
    {foreach from=$order_info.affiliate.commissions item=comm}
    {if $comm.action_id}
    <tr>
        <td><a href="{"aff_statistics.view?action_id=`$comm.action_id`"|fn_url}">#{$comm.action_id} {$comm.title}</a></td>
        <td>{$comm.firstname} {$comm.lastname}</td>
        <td>{include file="common/price.tpl" value=$comm.amount}</td>
    </tr>
    {/if}
    {/foreach}
    </table>
{/if}