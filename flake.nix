{
  description = "Actual Budget MCP Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    yarn2nix.url = "github:nix-community/yarn2nix";
  };

  outputs = { self, nixpkgs, yarn2nix }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      yarn2nixPkgs = yarn2nix.packages.${system};
    in {
      packages.${system}.default = yarn2nixPkgs.buildYarnPackage {
        pname = "actual-mcp";
        version = "1.5.0";
        src = self;
        yarnBuildMore = "build";
        yarnNixDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder
        buildPhase = ''
          yarn build
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