{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
  buildInputs = [
    autoconf
    automake
    pkg-config
    libtool
  ];

  # These don't seem to work for some build stages
  enableParallelBuilding = true;
  enableParallelChecking = true;
  
  shellHook = ''
    # These seem to be required, even though zcashd downloads its own Rust
    export CARGO=$(which cargo);
    export RUSTC=$(which rustc);
    
    export MAKEFLAGS="j$(nproc) l$(nproc)";
    export CARGO_BUILD_JOBS=$(nproc);

    echo Run zcutil/build.sh
    echo To clean, run zcutil/clean.sh or zcutil/distclean.sh
  '';
}
