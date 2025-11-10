{config, ...}: {
  programs.git = {
    enable = true;
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhG7HwYMOuzmgHg4IgHNR1B2M07W2hMhA9Kod/3O5vh";

    settings = {
      user = {
        email = "igor@hrcek.rs";
        name = "Igor Hrček";
      };
      
      pull.rebase = false;
      init.defaultBranch = "main";
      core.excludesFile = "${config.home.homeDirectory}/.gitignore";
      commit.gpgSign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      diff."ansible-vault".textconv = "ansible-vault view";
      push.autoSetupRemote = "true";
    };
  };
}
