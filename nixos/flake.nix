{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.05";
    secrets.url = "git+ssh://git@github.com/ruler501/dotfiles-private.git";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs-old";
      };
    };
    nonicons = {
      url = "github:yamatsum/nonicons";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs-old";
        home-manager.follows = "home-manager";
      };
    };
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs-old";
      };
    };
  };

  outputs = { home-manager, nixpkgs, nonicons, secrets, nixpkgs-stable, stylix, nixCats, ... }@inputs:
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
      inherit nixCats;
      nixpkgs-stable = pkgs-stable;
      nixpkgs-unstable = pkgs-unstable;
    };
    configuration = hostname: nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // { inherit hostname; };
      modules = [
        (./configuration.nix)
        (./systemPackages.nix)
        (./cockroachdb.nix)
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
