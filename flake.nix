{
  description = "I just want good TTS";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            venvDir = ".venv";
            packages =
              with pkgs;
              [
                uv
                python312
                go-task
              ]
              ++ (with pkgs.python312Packages; [
                mpv
                numpy
                sounddevice
                soundfile
              ]);
            shellHook = ''
              uv init -p 3.12;
              uv add kokoro-onnx;
              task download-model;
              printf 'RUN: export RENPY_TTS_COMMAND="$(realpath ./kokoro-read.sh)"'
            '';
          };
        }
      );
    };
}
