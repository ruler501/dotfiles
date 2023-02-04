{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nonicons = {
      url = "github:yamatsum/nonicons";
      flake = false;
    };
  };

  outputs = { home-manager, nixpkgs, nur, nonicons, ... }:
  let
    system = "x86_64-linux";
    configuration = hostname: nixpkgs.lib.nixosSystem {
    inherit system;
      specialArgs = { inherit nonicons; inherit hostname; };
      modules = [
        {
          nixpkgs.overlays = [
            nur.overlay
          ];
        }
        (import ./configuration.nix)
        (./systemPackages.nix)
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            users.devon = import ./home.nix;
            extraSpecialArgs = { inherit nonicons; };
          };
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      devonnixosdesktop = configuration "devonnixosdesktop";
      devonnixoslaptop  = configuration "devonnixoslaptop";
    };
  };
}
