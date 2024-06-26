{
  description = "My personal NixOS and Nix Darwin configuration";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    pretty-derby = {
      url = "github:yaoshiu/pretty-derby";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      ags,
      home-manager,
      neovim-nightly-overlay,
      nil,
      nix-darwin,
      nix-vscode-extensions,
      nixos-hardware,
      nixpkgs,
      nixpkgs-darwin,
      nixpkgs-unstable,
      nixvim,
      pretty-derby,
      self,
      sops-nix,
      grub2-themes,
      nix-ld-rs,
      flake-utils,
    }:
    {
      nixosConfigurations.NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          ./NixOS

          home-manager.nixosModules.home-manager

          nixos-hardware.nixosModules.lenovo-legion-16ach6h

          sops-nix.nixosModules.sops

          grub2-themes.nixosModules.default

          {
            nixpkgs.overlays = [
              (final: prev: {
                ags = ags.packages.agsWithTypes;
                unstable = nixpkgs-unstable.legacyPackages.${prev.system};
              })
              pretty-derby.overlays.default
              neovim-nightly-overlay.overlays.default
              nil.overlays.default
              nix-vscode-extensions.overlays.default
              nix-ld-rs.overlays.default
            ];
            nix = {
              registry.nixpkgs.flake = nixpkgs;
              channel.enable = false;
            };
          }

          {
            programs.dconf.enable = true;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.yaoshiu = import ./yaoshiu;
              sharedModules = [
                ags.homeManagerModules.default
                nixvim.homeManagerModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      darwinConfigurations.FaydeMac-mini = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          {
            nixpkgs.overlays = [
              neovim-nightly-overlay.overlays.default
              nil.overlays.default
              pretty-derby.overlays.default
              nix-vscode-extensions.overlays.default
              (final: prev: { darwin-pkgs = nixpkgs-darwin.legacyPackages.${prev.system}; })
            ];
            nix = {
              nixPath = [ "nixpkgs=${nixpkgs}" ];
              registry.nixpkgs.flake = nixpkgs;
            };
          }

          ./darwin-configuration.nix

          ./FaydeMac-mini

          home-manager.darwinModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.yaoshiu = import ./yaoshiu;
              sharedModules = [
                nixvim.homeManagerModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = lib.optional stdenv.isDarwin [ darwin.libiconv ];
            nativeBuildInputs = [
              pkg-config
              luajit
            ];
          };
        formatter = pkgs.nixfmt-rfc-style;
      }
    ));
}
