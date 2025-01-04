{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      prompt = "Search ...";
      width = "50%";
      height = "40%";
    };
  };
}
