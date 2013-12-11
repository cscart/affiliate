{include file="addons/affiliate/common/affiliate_menu.tpl"}

{capture name="tabsbox"}

<div id="content_{$selected_section}">
{include file="addons/affiliate/views/banners_manager/components/banners_list.tpl" prefix=$selected_section}
<!--content_{$selected_section}--></div>

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$selected_section}

{capture name="mainbox_title"}
    {__(affiliate)} <span class="subtitle">/ {$mainbox_title}</span>
{/capture}