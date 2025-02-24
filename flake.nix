{
  description = "Neve is a Neovim configuration built with Nixvim, enabling Nix-based plugin management.";

  inputs = {
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixvim, flake-utils, ... }@inputs:
    let
      config = import ./config;
      nixpkgsConfig = { allowUnfree = true; };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        nixvimLib = nixvim.lib.${system};
        pkgs = import nixpkgs { inherit system; config = nixpkgsConfig; };
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = config;
        };
      in
      {
        checks.default = nixvimLib.check.mkTestDerivationFromNvim {
          inherit nvim;
          name = "Neve";
        };

        packages.default = nvim;

        formatter = pkgs.nixfmt-rfc-style;

        #  New: Home Manager Module (Only Addition)
        homeManagerModules.default = config;

        nixvimModule = config;
      }
    );
}

