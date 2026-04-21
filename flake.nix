{
  description = "rshell - An Axtremely customizable shell by Axenide";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rctl = {
      url = "github:Axenide/rctl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rctl, ... }:
    let
      rshellLib = import ./nix/lib.nix { inherit nixpkgs; };
    in {
      nixosModules.default = { pkgs, lib, ... }: {
        imports = [ ./nix/modules ];
        programs.rshell.enable = lib.mkDefault true;
        programs.rshell.package = lib.mkDefault self.packages.${pkgs.system}.default;
      };

      packages = rshellLib.forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          lib = nixpkgs.lib;

          rshell = import ./nix/packages {
            inherit pkgs lib self system rctl;
          };
        in {
          default = rshell;
          rshell = rshell;
        }
      );

      devShells = rshellLib.forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          rshell = self.packages.${system}.default;
        in {
          default = pkgs.mkShell {
            packages = [ rshell ];
            shellHook = ''
              export QML2_IMPORT_PATH="${rshell}/lib/qt-6/qml:$QML2_IMPORT_PATH"
              export QML_IMPORT_PATH="$QML2_IMPORT_PATH"
              echo "rshell dev environment loaded."
            '';
          };
        }
      );

      apps = rshellLib.forAllSystems (system:
        let
          rshell = self.packages.${system}.default;
        in {
          default = {
            type = "app";
            program = "${rshell}/bin/rshell";
          };
        }
      );
    };
}
