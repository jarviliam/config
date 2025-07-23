{
  config,
  flakePath,
  ...
}:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "bat";
  };
  programs = {
    nix-index.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg = {
      enable = true;
    };
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };
  };
  xdg.configFile."yamllint.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/yamllint.yml";
  };
}
