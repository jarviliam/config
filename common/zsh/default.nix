{ config, pkgs, lib,... }:
with lib;
{
  programs.zsh = {
  enable = true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
  enableAutosuggestions = true;
  dotDir = "~/.config/zsh";
    historySubstringSearch.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
  sessionVariables = {
    HOMEBREW_NO_ANALYTICS = 1;
  };
  };
}
