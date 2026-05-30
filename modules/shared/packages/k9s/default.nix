{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "k9s";
  version = "0.50.18";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    sha256 = "sha256-WIcT4LfoIZ8BctwrUgn+mLbqwJ2NZx6Sc5sJeT9fsus=";
  };

  vendorHash = "sha256-Zd5N9YG9qBMt/v50+GauC18jk7iyYlPHYGqHeYV02DM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/derailed/k9s/cmd.version=${version}"
    "-X github.com/derailed/k9s/cmd.commit=${src.rev}"
  ];

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "k9s";
  };
}
