{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils?ref=main";
  };

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        packages = (with pkgs; [
          hugo
          go
        ]);

        # HACK: <https://github.com/NixOS/nix/issues/8355#issuecomment-1551712655>
        shellHook = "unset TMPDIR";
      };
    });
}
