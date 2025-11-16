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
      packages.${system}.default = pkgs.buildNpmPackage {
        pname = "actual-mcp";
        version = "1.5.0";
        src = self;
        yarnLock = ./yarn.lock;
        npmDepsHash = "sha256-gOGYTtK+gxeptT14g8ClowbEZh6iGQaJPkVyagQtfq0=";
        buildPhase = ''
          npm run build
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
        program = let
          script = pkgs.writeShellScript "actual-mcp" ''
            set -e
            npm install
            npm run build
            exec node build/index.js "$@"
          '';
        in "${script}";
      };
    };
}
