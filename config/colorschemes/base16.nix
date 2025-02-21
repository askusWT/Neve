{ lib, config, ... }:
{
  options = {
    base16.enable = lib.mkEnableOption "Enable base16 module";
  };
# Always define colorschemes.base16
  config = {
    colorschemes.base16 = {
      enable = false;
      colorscheme = "mountain";
    };
  }
  // lib.mkIf config.base16.enable {
    # If user sets base16.enable = true, we override "enable = false" to true
    colorschemes.base16.enable = true;
  };
}
