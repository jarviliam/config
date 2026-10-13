{ ... }: {
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;

      config = {
        global = {
          hide_env_diff = true;
          load_dotenv = true;
          strict_env = true;
          warn_timeout = "10s";
        };
      };

      nix-direnv = {
        enable = true;
      };
    };
  };
}
