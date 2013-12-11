<li class="affiliate-users">
    <span>{__("affiliates")}:</span>
    <em>{if $users_stats.total.P}<a href="{"profiles.manage?user_type=P"|fn_url}">{$users_stats.total.P}</a>{else}0{/if}</em>
</li>

{if $usergroups_type.P}
<li>
    <span>{__("not_a_member")}:</span>
    <em>{if $users_stats.not_members.P}<a href="{"profiles.manage?usergroup_id=0&user_type=P"|fn_url}">{$users_stats.not_members.P}</a>{else}0{/if}</em>
</li>
{/if}

{foreach from=$usergroups key="mem_id" item="mem_name"}
{if $mem_name.type == "P"}
<li>
    <span>{$mem_name.usergroup}:</span>
    <em>{if $users_stats.usergroup.P.$mem_id}<a href="{"profiles.manage?usergroup_id=`$mem_id`"|fn_url}">{$users_stats.usergroup.P.$mem_id}</a>{else}0{/if}</em>
</li>
{/if}
{/foreach}