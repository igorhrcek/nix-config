{pkgs}: let
  customPackages = import ./packages {inherit pkgs;};
in
  with pkgs; [
    _1password-cli
    bat
    curl
    curlie
    docker
    fd
    ffmpeg_7
    fzf
    prettyping
    gettext
    gh
    git
    unixtools.ping
    inetutils
    imagemagick
    jq
    mc
    mtr
    netcat
    nmap
    openssh
    openssl
    qrencode
    pwgen
    rdap
    restic
    ripgrep
    tree
    tree-sitter
    watch
    wget

    nil
    alejandra

    php83
    php83Packages.composer

    postgresql_16
    redis

    fluxcd
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    k9s
    kubectl
    kubernetes-helm
    skaffold
    opentofu

    age
    sops

    # atuin
    direnv

    fish
    fishPlugins.puffer
    fishPlugins.done
    fishPlugins.git-abbr

    nix-your-shell
    zoxide

    lazydocker

    go
    hugo

    pre-commit
    uv
    mise

    (poetry.withPlugins
      (ps: [
        pkgs.poetryPlugins.poetry-plugin-shell
      ]))

    (python313.withPackages (ps: [
      ps.llm
      ps.pyyaml
      ps.llm-cmd
      ps.ruff
      ps.pillow
      customPackages.llm-openrouter
      ps.pipx
    ]))

    bun
    nodejs_22

    steampipe

    btop
    nixpkgs-fmt

    lua54Packages.luarocks-nix

    speedtest-go
    neofetch
    zulu

    tshark
    nixd

    ollama
    claude-code

    nextdns
    xcodegen
    cloudflared
    go-task
    talosctl
    yq
    helmfile
    kubeconform
    kustomize
    minijinja
    moreutils
    talhelper
    stern
    kubecolor
    kubecm

    timg
    mas

    rustup
    lsd

    trippy
    hadolint
    httpie
  ]
