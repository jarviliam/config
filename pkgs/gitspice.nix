{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  nix-update-script,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "git-spice";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ApqF5Dnx9ajwzZ2ovhtCqvmO4ZOcvke1NJazSXKJ32c=";
  };

  vendorHash = "sha256-t7nfOTHncSLounY1zR4idAmDmqj9znR2IUQA2xt0Drs=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  buildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    # timeout
    rm testdata/script/branch_submit_remote_prompt.txt
    rm testdata/script/branch_submit_multiple_pr_templates.txt
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mv $out/bin/gs $out/bin/git-spice
    installShellCompletion --cmd git-spice \
      --bash <($out/bin/git-spice shell completion bash) \
      --zsh <($out/bin/git-spice shell completion zsh) \
      --fish <($out/bin/git-spice shell completion fish)
  '';

  passthru.updateScript = nix-update-script { };
})
