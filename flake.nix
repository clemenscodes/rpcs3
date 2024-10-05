{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    nix-filter = {
      url = "github:numtide/nix-filter";
    };
  };

  outputs = inputs:
    with inputs;
      flake-parts.lib.mkFlake {inherit inputs;} {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        perSystem = {system, ...}: let
          pkgs = import nixpkgs {inherit system;};
        in {
          packages = {
            default = pkgs.callPackage ./nix/package.nix {};
          };

          devShells = {
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                cmake
                pkg-config
                git
              ];
              buildInputs = with pkgs; [
                kdePackages.qtbase
                kdePackages.qtmultimedia
                kdePackages.qtwayland
                wayland
                faudio
                openal
                glew
                vulkan-headers
                vulkan-loader
                libpng
                ffmpeg
                libevdev
                zlib
                libusb1
                curl
                wolfssl
                python3
                pugixml
                SDL2
                flatbuffers
                llvm_16
                xorg.libSM
              ];
            };
          };

          formatter = pkgs.alejandra;
        };
      };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://clemenscodes.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "clemenscodes.cachix.org-1:yEwW1YgttL2xdsyfFDz/vv8zZRhRGMeDQsKKmtV1N18="
    ];
  };
}
