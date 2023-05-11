{ config
, ...
}:

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
  };
}
