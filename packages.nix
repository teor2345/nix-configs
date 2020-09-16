{ config, lib, pkgs, ... }:

{
  system.autoUpgrade.enable = true;
  # 20.09 and later
  # run between 0440 and 0540
  #system.autoUpgrade.randomizedDelaySec = "60min";

  nix.autoOptimiseStore = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 6m";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gptfdisk
    parted

    dhcp
    wpa_supplicant

    mosh
    tmux
    pv

    psmisc
    htop
    hwinfo

    wget
    curl
    netcat
    mbuffer

    emacs-nox

    git
    jq
    #timelimit
    nix-prefetch-scripts

    gcc
    gdb
    clang
    llvm
    llvmPackages.libclang
    binutils
    libtool

    autoconf
    automake
    gnumake
    pkg-config

    sccache
    ccache
    ccacheWrapper
    ccacheStdenv

    rustup
    # 20.09 and later
    #cargo-cache
    cargo-deps
    # installs cargo-{add,rm,upgrade}
    cargo-edit
    cargo-expand
    cargo-flamegraph
    cargo-graph
    cargo-inspect
    cargo-outdated
    cargo-sweep
    # outdated, install using cargo install
    #cargo-udeps
    cargo-update

    openssl

    # outdated: 2.1 from March 2020
    #zcash
  ];
}
