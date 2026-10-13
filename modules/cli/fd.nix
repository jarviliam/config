{ ... }: {
  programs.fd = {
    enable = true;
    extraOptions = [
      "--follow"
      "--hyperlink=auto"
      "--one-file-system"
    ];

    hidden = true;

    ignores = [
      "build-results/"
      "Cargo.lock"
      "flake.lock"
      ".git/"
      "node_modules/"
      "package-lock.json"
      "target/"
      "uv.lock"
      "vendor/"
      ".venv/"
      "yarn.lock"
    ];
  };
}
