{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "k9s";
  version = "0.50.16";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    sha256 = "sha256-PYaVzUAQuy5LBkyJ3otWX1iRYWSkt4sD3HIvpGTOiQY=";
  };

  vendorHash = "sha256-HL+ppeKBWFecfK66ohXcpEsHbOFL2ZoGppebOwG85qs=";

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
