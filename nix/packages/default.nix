# Main rshell package
{ pkgs, lib, self, system, rctl }:

let
  quickshellPkg = pkgs.quickshell;
  rctlPkg = rctl.packages.${system}.default;

  # Import sub-packages
  ttf-phosphor-icons = import ./phosphor-icons.nix { inherit pkgs; };

  # Import modular package lists
  corePkgs = import ./core.nix { inherit pkgs quickshellPkg; };
  toolsPkgs = import ./tools.nix { inherit pkgs; };
  mediaPkgs = import ./media.nix { inherit pkgs; };
  appsPkgs = import ./apps.nix { inherit pkgs; };
  fontsPkgs = import ./fonts.nix { inherit pkgs ttf-phosphor-icons; };
  tesseractPkgs = import ./tesseract.nix { inherit pkgs; };

  # Combine all packages (NixOS-specific deps handled by the module)
  baseEnv = corePkgs
    ++ [ rctlPkg ]
    ++ toolsPkgs
    ++ mediaPkgs
    ++ appsPkgs
    ++ fontsPkgs
    ++ tesseractPkgs;

  envrshell = pkgs.buildEnv {
    name = "rshell-env";
    paths = baseEnv;
  };

  # Create fontconfig configuration to find bundled fonts
  fontconfigConf = pkgs.writeTextDir "etc/fonts/conf.d/99-rshell-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>${envrshell}/share/fonts</dir>
    </fontconfig>
  '';

  # Copy shell sources to the Nix store
  shellSrc = pkgs.stdenv.mkDerivation {
    pname = "rshell-shell";
    version = lib.removeSuffix "\n" (builtins.readFile ../../version);
    src = lib.cleanSource self;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  launcher = pkgs.writeShellScriptBin "rshell" ''
    export RSHELL_QS="${quickshellPkg}/bin/qs"
    export PATH="${envrshell}/bin:$PATH"

    # Set QML2_IMPORT_PATH to include modules from envrshell (like syntax-highlighting)
    export QML2_IMPORT_PATH="${envrshell}/lib/qt-6/qml:$QML2_IMPORT_PATH"
    export QML_IMPORT_PATH="$QML2_IMPORT_PATH"

    # Make bundled fonts available to fontconfig
    export FONTCONFIG_PATH="${fontconfigConf}/etc/fonts:''${FONTCONFIG_PATH:-}"

    # Delegate execution to CLI (now in the Nix store)
    exec ${shellSrc}/cli.sh "$@"
  '';

in pkgs.buildEnv {
  name = "rshell";
  paths = [ envrshell launcher ];
  meta.mainProgram = "rshell";
}
