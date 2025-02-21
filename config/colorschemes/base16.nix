{ lib, config, ... }:
{
  options = {
    base16.enable = lib.mkEnableOption "Enable base16 module";
  };

  config = {
    colorschemes.base16 = {
      enable = true;
      colorscheme = "mountain";
    };
  };
}
