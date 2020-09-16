{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
  buildInputs = [
    llvmPackages.libclang
    openssl
    pkg-config
  ];

  LIBCLANG_PATH = llvmPackages.libclang.lib + "/lib";
  
  shellHook = ''
    export LIBCLANG_PATH
    echo LIBCLANG_PATH=$LIBCLANG_PATH

    export MAKEFLAGS="j$(nproc) l$(nproc)";
    export CARGO_BUILD_JOBS=$(nproc);
  '';
}
