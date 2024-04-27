{ pkgs, ... }:
{
  home.packages = [
    (pkgs.gitoxide.overrideAttrs (
      self: prev: {
        nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.installShellFiles ];
        preFixup = ''
          installShellCompletion --cmd gix \
            --bash <($out/bin/gix completions --shell bash) \
            --fish <($out/bin/gix completions --shell fish) \
            --zsh <($out/bin/gix completions --shell zsh)
        '';
      }
    ))
  ];
}
