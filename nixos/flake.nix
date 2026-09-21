{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    secrets.url = "git+ssh://git@github.com/ruler501/dotfiles-private.git";
    direnv-instant.url = "github:Mic92/direnv-instant";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixPatch = {
      url = "git+https://codeberg.org/NicoElbers/nixPatch-nvim.git";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nonicons = {
      url = "github:yamatsum/nonicons";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    home-manager, nixpkgs, nonicons, secrets, nixpkgs-stable, stylix, nixPatch, nixos-hardware, direnv-instant, ...
  }:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    colors = import ./darkviolet.nix;
    specialArgs = {
      inherit system;
      inherit nonicons;
      inherit secrets;
      inherit colors;
      inherit stylix;
      inherit nixPatch;
      inherit nixos-hardware;
      nixpkgs-stable = pkgs-stable;
      nixpkgs-unstable = pkgs-unstable;
    };
    configuration = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // { inherit hostname; };
      modules = [
        (./configuration.nix)
        (./systemPackages.nix)
        # (./cockroachdb.nix)
        (home-manager.nixosModules.home-manager)
        ({
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = false;
            users.devon = import ./home.nix;
            extraSpecialArgs = specialArgs // { inherit hostname; };
          };
        })
        (stylix.nixosModules.stylix)
        direnv-instant.nixosModules.direnv-instant
      ];
    };
  in
  {
    nixosConfigurations = {
      devonnixosdesktop = configuration "devonnixosdesktop";
      devonnixoslaptop  = configuration "devonnixoslaptop";
      devonnixosframework16  = configuration "devonnixosframework16";
    };
  };
}
