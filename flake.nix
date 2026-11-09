{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkHost =
        {
          username,
          modules,
          homeModules,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = modules ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs username; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username}.imports = [
                ./home
                ./home/desktop.nix
              ]
              ++ homeModules;
            }
          ];
        };
    in
    {
      nixosConfigurations.laptop = mkHost {
        username = "taylor";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen3
          ./hosts/laptop
        ];
        homeModules = [ ./home/personal.nix ];
      };

      nixosConfigurations.work-desktop = mkHost {
        username = "sebastian";
        modules = [ ./hosts/work-desktop ];
        homeModules = [ ./home/work.nix ];
      };

      nixosConfigurations.work-laptop = mkHost {
        username = "sebastian";
        modules = [ ./hosts/work-laptop ];
        homeModules = [ ./home/work.nix ];
      };

      devShells.${system}.yocto = import ./shells/yocto.nix {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
