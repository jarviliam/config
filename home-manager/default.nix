{ ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    experimental-features = "nix-command flakes";
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    neomutt = {
      enable = false;
      # vimKeys = true;
    };
    gpg = { enable = true; };
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };
  };
}
