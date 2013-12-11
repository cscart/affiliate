{if $banner_type == "iframe"}

    document.getElementById('id_example_banner').innerHTML='{$html_content}';

{elseif $banner_type == "js"}

    {if $mode == "demo"}
        var html_content = "{$html_content nofilter}";

        var div_tag = document.getElementById('id_example_banner');
        fn_aff_banner_js_demo();
    {else}
{if $banner_data.type == "T"}
<script type="text/javascript">
//<![CDATA[
if (typeof(cart_banner) == "undefined") var cart_banner = new Array();
cart_banner[{$banner_data.banner_id}] = {$ldelim}
{if $banner_data.width}
BoxWidth: '{$banner_data.width}',
{/if}
{if $banner_data.height}
BoxHeight: '{$banner_data.height}',
{/if}
OutlineColor: '{$affiliate_opts_settings.out_line_clor}',
TitleTextColor: '{$affiliate_opts_settings.title_text_color}',
{*LinkColor: '#435C74',*}
TextColor: '{$affiliate_opts_settings.text_color}',
TextBackgroundColor: '{$affiliate_opts_settings.text_background_color}',
ShowURL: '{$banner_data.show_url}' /* Y - yes; N - no*/
{$rdelim}
//]]>
</script>
{/if}
<script id="id_script_banner_{$banner_data.banner_id}" type="text/javascript" src="{$html_content nofilter}"></script>
    {/if}
{elseif $banner_type == "iframe_content"}

    {$html_content}

{elseif $banner_type == "js_content"}

    var html_content = "{$html_content nofilter}";
    var banner_id = '{$banner_data.banner_id}';
    var banner_data_type = '{$banner_data.type}';
    var banner_url = '{$banner_data.banner_url nofilter}';
    var banner_new_window_{$banner_data.banner_id} = '{$banner_data.new_window}';

    if (typeof(cart_banner) == "undefined") var cart_banner = new Array();

    fn_aff_banner_js_content(banner_id, banner_data_type, cart_banner, banner_url);

{/if}
