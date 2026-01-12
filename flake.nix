{
  description = "LeonOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };



    # Google Antigravity (IDE)
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,

    nix-flatpak,
    alejandra,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "leon"; # Helper variable

    # Function to build a config
    # We now pass 'hostName' and 'gpuProfile' as arguments
    mkNixosConfig = hostName: gpuProfile:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = hostName;
          profile = gpuProfile;
        };
        modules = [
          ./modules/core/system/overlays.nix
          ./profiles/${gpuProfile} # Loads profiles/main or profiles/laptop
          nix-flatpak.nixosModules.nix-flatpak
          inputs.sops-nix.nixosModules.sops
        ];
      };
  in {
    nixosConfigurations = {
      # My Desktop
      desktop = mkNixosConfig "desktop" "desktop";

      # My Laptop
      laptop = mkNixosConfig "laptop" "laptop";
    };

    formatter.x86_64-linux = inputs.alejandra.packages.x86_64-linux.default;
  };
}
