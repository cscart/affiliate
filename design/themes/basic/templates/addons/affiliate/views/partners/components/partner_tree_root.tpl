<table class="table table-width">
    <tr>
        <th><i id="on_partners" class="icon-right-dir dir-list cm-combinations" title="{__("expand_sublist_of_items")}"></i><i id="off_partners" class="icon-down-dir dir-list cm-combinations hidden" title="{__("expand_sublist_of_items")}"></i>{__("affiliate_tree")}</th>
    </tr>
    <tr>
        <td>
            {if $partners}
                <div id="id_tree">
                {foreach from=$partners item=user name="tree_root"}
                    {include file="addons/affiliate/views/partners/components/partner_tree_limb.tpl" user=$user level=0 last=$smarty.foreach.tree_root.last}
                {/foreach}
                </div>
            {else}
                <p class="no-items">{__("no_users_found")}</p>
            {/if}
        </td>
    </tr>
</table>