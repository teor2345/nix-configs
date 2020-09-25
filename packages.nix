{ config, lib, pkgs, ... }:

# make sure emacsWithPackages uses emacs-nox
let
  emacsWithPackages = (pkgs.emacsPackagesGen pkgs.emacs-nox).emacsWithPackages;
in
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

  # create a custom emacs-nox with packages
  nixpkgs.config = {
    packageOverrides = pkgs: with pkgs; rec {
      emacs-config-packages = writeText "default.el" ''
;; initialize package
(require 'package)
(package-initialize)
(package-initialize 'noactivate)
(eval-when-compile
  (require 'use-package))
(eval-when-compile
  (require 'use-package-ensure))
(setq use-package-always-ensure t)

; Show column numbers
(setq-default column-number-mode t)

; Clean trailing whitespace, show it if it happens
(setq-default show-trailing-whitespace t)
(use-package ws-butler
             :ensure t)
(ws-butler-global-mode 1)

; Never use tabs to indent, show them if they happen
(setq-default indent-tabs-mode nil)
;; Draw tabs with the same color as trailing whitespace
(add-hook 'font-lock-mode-hook
    (lambda ()
        (font-lock-add-keywords
            nil
            '(("\t" 0 'trailing-whitespace prepend)))))

; Show key bindings
(use-package which-key
             :ensure t)
      '';

      emacs-nox-with-packages = emacsWithPackages (epkgs: (with epkgs; [
        (runCommand "default.el" {} ''
mkdir -p $out/share/emacs/site-lisp
cp ${emacs-config-packages} $out/share/emacs/site-lisp/default.el
        '')

        use-package
        use-package-ensure-system-package
        auto-package-update
        restart-emacs

        which-key
        ws-butler

        rust-mode
        lv
        lsp-ui
        lsp-treemacs
        lsp-mode

        flycheck
        flycheck-rust
        flycheck-inline

        company
        yasnippet-classic-snippets
      ]));
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gptfdisk
    parted

    dhcp
    wpa_supplicant

    mosh
    tmux
    lesspipe

    psmisc
    htop
    hwinfo
    file

    wget
    curl
    rsync
    netcat
    mbuffer
    pv

    emacs-nox-with-packages

    git
    jq
    #timelimit
    nix-prefetch-scripts

    gcc
    gdb
    clang
    llvm
    llvmPackages.libclang
    lld
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

    tor
    # outdated: 2.1 from March 2020
    #zcash
  ];
}
