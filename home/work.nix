{ pkgs, ... }:
let
  # git remote url patterns that should use the work identity, e.g.
  #   "git@github.com:some-org/**"
  #   "https://gitlab.example.com/**"
  workRemotes = [ ];
in
{
  home.packages = with pkgs; [
    minicom
    claude-code
    teams-for-linux
  ];

  programs.git.includes = map (pattern: {
    condition = "hasconfig:remote.*.url:${pattern}";
    contents.user = {
      name = "Sebastian Francis Taylor";
      email = "sft@sky-watch.com";
    };
  }) workRemotes;
}
