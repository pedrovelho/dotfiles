{
  description = "flake for lenovo-nixos";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      lenovo-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          let
            nixpkgsUnfree = {
              nixpkgs = {
                system = "x86_64-linux";
                config.allowUnfree = true;
                #overlays = (import ./overlays/openfoam11.nix);
              };
            };
          in
            [
              ./configuration.nix
              nixpkgsUnfree
            ];
      };
    };
  };
}
