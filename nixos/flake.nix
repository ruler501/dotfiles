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
    nur.url = "github:nix-community/NUR";
    nonicons = {
      url = "github:yamatsum/nonicons";
      flake = false;
    };
  };

  outputs = { home-manager, nixpkgs, nur, nonicons, secrets, nixpkgs-stable, ... }:
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
    specialArgs = {
      inherit system;
      inherit nonicons;
      inherit secrets;
      inherit nur;
      nixpkgs-stable = pkgs-stable;
      nixpkgs-unstable = pkgs-unstable;
    };
    configuration = hostname: nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // { inherit hostname; };
      modules = [
        { nixpkgs.overlays = [ nur.overlay ]; }
        (./configuration.nix)
        (./systemPackages.nix)
        (./cockroachdb.nix)
        home-manager.nixosModules.home-manager
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
