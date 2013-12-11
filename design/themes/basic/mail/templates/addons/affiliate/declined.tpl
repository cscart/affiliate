{include file="common/letter_header.tpl"}

{__("dear")} {$user_data.firstname},<br /><br />

{__("email_declined_notification_header")}<br /><br />

{if $reason_declined}
<b>{__("reason")}:</b><br />
{$reason_declined|nl2br}<br /><br />
{/if}

{include file="common/letter_footer.tpl"}