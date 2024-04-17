let 
  named = {
    bg = "#000000";
    accentbg = "#232149";
    selectionbg = "#543096";
    subtle = "#a267cd";
    darkfg = "#955495";
    fg = "#a987ed";
    brightfg = "#f791da";
    invertbg = "#65b4d8";
    error = "#fb526c";
    constant = "#d670d1";
    type = "#b288ee";
    focus = "#07c5d6";
    string = "#8890ee";
    func = "#6b98e4";
    keyword = "#4f9ed8";
    warm = "#b3669e";
  };
in
{
  inherit named;
  base16 = {
    slug = "darkviolet";
    scheme = "Theme by ruler501";
    author = "ruler501";
    base00 = named.bg;
    base01 = named.accentbg;
    base02 = named.selectionbg;
    base03 = named.subtle;
    base04 = named.darkfg;
    base05 = named.fg;
    base06 = named.brightfg;
    base07 = named.invertbg;
    base08 = named.error;
    base09 = named.constant;
    base0A = named.type;
    base0B = named.focus;
    base0C = named.string;
    base0D = named.func;
    base0E = named.keyword;
    base0F = named.warm;
  };
}
