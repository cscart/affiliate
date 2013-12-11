{counter name="tree" print=false assign="tree"}

{if $user.partners}
    {$shift = $level * 16}
{else}
    {$shift = $level * 16 + 16}
{/if}

<div class="tree-limb" style="padding-left: {$shift}px;">
    {if $user.partners}<i id="on_partners_{$tree}" class="icon-right-dir dir-list cm-combination" title="{__("expand_collapse_list")}"></i><i id="off_partners_{$tree}" class="icon-down-dir dir-list hidden cm-combination" title="{__("expand_collapse_list")}"></i>{/if}
    <i class="icon-user"></i>
    {if $settings.General.use_email_as_login != "Y"}<strong>{$user.user_login}</strong> ({/if}
    {$user.firstname} {$user.lastname}
    {if $settings.General.use_email_as_login != "Y"}){/if}
    {if $level} - {$level} {__("level")}{/if}
</div>

{if $user.partners}
    <div id="partners_{$tree}" class="hidden">
        {foreach from=$user.partners item=sub_user name=$for_name}
            {include file="addons/affiliate/views/partners/components/partner_tree_limb.tpl" user=$sub_user level=$level+1 last=$smarty.foreach.$for_name.last}
        {/foreach}
    </div>
{/if}