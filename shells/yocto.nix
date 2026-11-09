# FHS environment for Yocto/BitBake builds.
# Yocto expects a conventional Linux host (/usr/bin, /bin/sh, glibc locales),
# so plain mkShell doesn't cut it on NixOS.
#
#   nix develop ~/dotfiles#yocto
{ pkgs }:
(pkgs.buildFHSEnv {
  name = "yocto";

  targetPkgs =
    p: with p; [
      # Yocto host requirements (see "Required Packages for the Build Host")
      gawk
      wget
      git
      diffstat
      unzip
      texinfo
      gcc
      gnumake
      chrpath
      socat
      cpio
      file
      which
      hostname
      zsh
      iputils
      zstd
      lz4
      xz
      bzip2
      gzip
      patch
      perl
      rpcsvc-proto
      ncurses # menuconfig
      acl
      openssl
      glibcLocales
      (python3.withPackages (
        ps: with ps; [
          pip
          pexpect
          gitpython
          jinja2
          subunit
          websockets
        ]
      ))

      # tooling
      (callPackage ../pkgs/language-server-bitbake { })
      kas
      nodejs
      minicom
    ];

  profile = ''
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
  '';

  runScript = "zsh";
}).env
