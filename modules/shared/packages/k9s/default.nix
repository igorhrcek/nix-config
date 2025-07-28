{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "k9s";
  version = "0.50.9";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    sha256 = "sha256-wTQOBxJgrDPcWSiezCwHNgvfGa6oWBM+DNa7RC/9PJA=";
  };

  vendorHash = "sha256-e8qXvdpsiBh3SF4v2I56dN/PoPj/b/kWtW6KAd5Sldg=";

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
