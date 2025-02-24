{
  description = "Neve is a Neovim configuration built with Nixvim, enabling Nix-based plugin management.";

  inputs = {
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixvim, flake-utils, ... }@inputs:
    let
      config = import ./config;  # Neovim module configuration
      nixpkgsConfig = { allowUnfree = true; };
    in
    {
      # ✅ Home Manager module export (fixes previous issue)
      homeManagerModules.default = config;

      # ✅ Nixvim module export (for NixOS & flake builds)
      nixvimModule = config;

      # ✅ System-wide outputs for `nix build` and `nix run`
      packages = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs { inherit system; config = nixpkgsConfig; };
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = config;
            extraSpecialArgs = { inherit self; };
          };
        in
        {
          checks.default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "Neve";
          };

          packages.default = nvim;

          formatter = pkgs.nixfmt-rfc-style;
        }
      );
    };
}
