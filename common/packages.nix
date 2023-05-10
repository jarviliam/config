{ pkgs, cfg }:
with pkgs; [
  awscli2
  bat
  btop
  coreutils
  delta
  exa
  fd
  fzf
  font-awesome
  gcc
  gh
  go
  gopls
  home-manager
  htop
  iftop
  jetbrains-mono
  jq
  killall
  neofetch
  nodePackages.npm
  nodejs
  openssh
  python311
  python311Packages.virtualenv
  poetry
  nodePackages_latest.pyright
  ripgrep
  tfenv
  terraform-ls
  tflint
  tree
  tmux
  unrar
  unzip
  wget
  yq
  zip
] ++ optionals cfg.isWork [
  docker
  docker-compose
  slack
  insomnia
] ++ optionals cfg.includeFonts [
  nerdfonts
  noto-fonts
  noto-fonts-emoji
]
++ optionals (!cfg.useNeovim) [
  vim
]
