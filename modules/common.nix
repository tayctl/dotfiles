{ pkgs, ... }: {
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "taylor"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.taylor = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "changeme"; # change with `passwd` after first login
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.nix-ld.enable = true;
  services.openssh.enable = true;

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "flazz";
    plugins = [
      "git"
    ];
  };
  users.users.taylor.shell = pkgs.zsh;
}
