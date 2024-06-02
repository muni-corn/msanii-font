{
  description = "Msanii font";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }: let
    out =
      utils.lib.eachDefaultSystem
      (system: let
        pkgs = import nixpkgs {inherit system;};
        stdenvNoCC = pkgs.stdenvNoCC;
      in {
        # `nix build`
        defaultPackage = stdenvNoCC.mkDerivation {
          pname = "msanii-font";
          version = "0.0.1";
          src = ./fonts;
          installPhase = ''
            runHook preInstall
            install -m444 -Dt $out/share/fonts/opentype Msanii-Regular.otf
            install -m444 -Dt $out/share/fonts/truetype Msanii-Regular.ttf
            runHook postInstall
          '';
        };
      });
  in
    out
    // {
      overlay = final: prev: {
        msanii-font = self.defaultPackage.${prev.system};
      };
    };
}
