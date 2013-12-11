{if !$user_data|fn_check_user_type_admin_area}
{assign var="u_type" value=$smarty.request.user_type|default:$user_data.user_type}
{if $runtime.controller != 'checkout'}
<div class="control-group">
    <label for="user_type">{__("account_type")}</label>
    <select id="user_type" name="user_data[user_type]" onchange="Tygh.$.redirect('{"`$runtime.controller`.`$runtime.mode`?user_type="|fn_url}' + this.value);">
        <option value="C" {if $u_type == "C"}selected="selected"{/if}>{__("customer")}</option>
        <option value="P" {if $u_type == "P"}selected="selected"{/if}>{__("affiliate")}</option>
    </select>
</div>
{/if}

{if $u_type == "P" && $u_type != $user_data.user_type}
{if $runtime.mode == "add"}{assign var="_but" value=__("register")}{else}{assign var="_but" value=__("save")}{/if}
<p id="id_affiliate_agree_notification">{__("affiliate_agree_to_terms_conditions", ["[button_name]" => $_but])}</p>
{/if}
{/if}