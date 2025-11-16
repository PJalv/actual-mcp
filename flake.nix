{
  description = "Actual Budget MCP Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "actual-mcp";
        version = "1.5.0";
        src = self;
        buildInputs = [ pkgs.bun ];
        buildPhase = ''
          set -x
          bun install
          bunx tsc --verbose -p tsconfig.build.json
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp -r . $out
          chmod +x $out/build/index.js
          ln -s $out/build/index.js $out/bin/actual-mcp
        '';
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/actual-mcp";
      };
    };
}