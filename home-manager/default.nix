{
  config,
  flakePath,
  ...
}:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
      experimental-features = "nix-command flakes";
    }
  '';

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
    neomutt = {
      enable = false;
      # vimKeys = true;
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
