{
  description = "Zed MCP Extension for llm-rules (dev shell)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "mcp-server-llm-rules-dev";
        buildInputs = [
          pkgs.nodejs_20
          pkgs.rustc
          pkgs.rust-analyzer
          pkgs.rustup
          pkgs.cargo
          pkgs.direnv
          pkgs.nil
          pkgs.gcc
        ];
      };
    };
}
