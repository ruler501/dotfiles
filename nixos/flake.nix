{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    secrets.url = "git+ssh://git@github.com/ruler501/dotfiles-private.git";
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

  outputs = { home-manager, nixpkgs, nur, nonicons, secrets, nixpkgs-stable, ... }:
  let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    configuration = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs.nonicons = nonicons;
      specialArgs.hostname = hostname;
      specialArgs.secrets = secrets;
      specialArgs.nixpkgs-stable = pkgs-stable;
      modules = [
        {
          nixpkgs.overlays = [
            nur.overlay
          ];
        }
        (./configuration.nix)
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
