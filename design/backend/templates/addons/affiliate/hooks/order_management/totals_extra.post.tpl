{if $cart.affiliate.partner_id}
<div class="control-group">
    <label class="control-label">{__("affiliate")}:</label>
    <div class="controls">
    	{$cart.affiliate.firstname} {$cart.affiliate.lastname}
    </div>
</div>
{/if}

{if $addons.affiliate.show_affiliate_code == "Y" || ($cart.order_id && $cart.affiliate.is_payouts != "Y")}
<div class="control-group">
    <label class="control-label" for="affiliate_code">{__("affiliate_code")}:</label>
    <div class="controls">
    	<input type="text" name="affiliate_code" id="affiliate_code" value="{$cart.affiliate.code}" size="10" maxlength="10" />
    </div>
</div>
{/if}