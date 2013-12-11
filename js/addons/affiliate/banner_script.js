
// {literal}
function fn_aff_banner_js_content(banner_id, banner_data_type, cart_banner, banner_url)
{
    if (typeof(banner_code) == "undefined") {
        var banner_code = new Array();
    }
    banner_code[banner_id] = html_content;
    if (typeof(div_tag) != "undefined") {
        div_tag.innerHTML += banner_code[banner_id];
    } else {
        document.write(banner_code[banner_id]);
    }
    if (banner_data_type == 'T') {
        if (typeof(cart_banner[banner_id]) == "undefined") {
            cart_banner[banner_id] = new Array();
        }
        eval("function cart_fn_tban_" + banner_id + "_click(evt) { if (banner_new_window_" + banner_id + " == 'Y') { window.open(banner_url); } else { window.location.href = banner_url; } return true; }");
        var cart_ban_table = document.getElementById("id_cart_" + banner_id + "_table");
        if (cart_ban_table) {
            if (typeof(cart_banner[banner_id].BoxWidth) != "undefined") {
                cart_ban_table.style.width = cart_banner[banner_id].BoxWidth + 'px';
            }
            if (typeof(cart_banner[banner_id].BoxHeight) != "undefined") {
                cart_ban_table.style.height = cart_banner[banner_id].BoxHeight + 'px';
            }
            if (typeof(cart_banner[banner_id].OutlineColor) != "undefined" && cart_banner[banner_id].OutlineColor != "") {
                cart_ban_table.style.border = cart_banner[banner_id].OutlineColor + " 1px solid";
            }
            if (typeof(cart_banner[banner_id].ShowURL) != "undefined" && cart_banner[banner_id].ShowURL == "Y") {
                var cart_ban_link = document.getElementById("id_cart_" + banner_id + "_link");
                if (cart_ban_link) {
                    cart_ban_link.innerHTML = '<a href="' + banner_url + '">' + banner_url + '</a>';
                }
                cart_ban_table.onclick = "";
            } else {
                cart_ban_table.style.cursor = "pointer";
                cart_ban_table.onclick = eval("cart_fn_tban_" + banner_id + "_click");
            }
        }
        var cart_ban_title = document.getElementById("id_cart_" + banner_id + "_title");
        if (cart_ban_title) {
            if (typeof(cart_banner[banner_id].TitleTextColor) != "undefined" && cart_banner[banner_id].TitleTextColor != "") {
                cart_ban_title.style.color = cart_banner[banner_id].TitleTextColor;
            }
        }
        var cart_ban_body = document.getElementById("id_cart_" + banner_id + "_body");
        if (cart_ban_body) {
            if (typeof(cart_banner[banner_id].TextBackgroundColor) != "undefined" && cart_banner[banner_id].TextBackgroundColor != "") {
                cart_ban_body.style.backgroundColor = cart_banner[banner_id].TextBackgroundColor;
            }
            if (typeof(cart_banner[banner_id].TextColor) != "undefined" && cart_banner[banner_id].TextColor != "") {
                cart_ban_body.style.color = cart_banner[banner_id].TextColor;
            }
        }
    }
}
function fn_aff_banner_js_demo()
{
    var script_tag_id = 'id_script_banner';
    var script_tag = document.getElementById(script_tag_id);
    if (div_tag && script_tag) {
        div_tag.removeChild(script_tag);
    }
    if (div_tag) {
        div_tag.innerHTML = ''; 
        script_tag = document.createElement('SCRIPT');
        script_tag.type = 'text/javascript';
        script_tag.language = 'javascript';
        script_tag.id = script_tag_id;
        script_tag.src = html_content;
        div_tag.appendChild(script_tag);
    } else {
        document.write('<script id="'+script_tag_id+'" type="text/javascript" language="javascript" src="'+html_content+'"></' + 'script>');
    }
}
// {/literal}
