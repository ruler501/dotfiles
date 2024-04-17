{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    secrets.url = "git+ssh://git@github.com/ruler501/dotfiles-private.git";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nonicons = {
      url = "github:yamatsum/nonicons";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { home-manager, nixpkgs, nonicons, secrets, nixpkgs-stable, stylix, ... }:
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
      nixpkgs-stable = pkgs-stable;
      nixpkgs-unstable = pkgs-unstable;
    };
    configuration = hostname: nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // { inherit hostname; };
      modules = [
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        (./configuration.nix)
        (./systemPackages.nix)
        (./cockroachdb.nix)
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            users.devon = import ./home.nix;
            extraSpecialArgs = specialArgs // { inherit hostname; };
          };
        }
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
