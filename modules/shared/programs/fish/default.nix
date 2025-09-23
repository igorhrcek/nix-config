{pkgs, ...}: {
  catppuccin = {
    fish = {
      enable = true;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      test -f ~/.config/fish/secrets.fish && source ~/.config/fish/secrets.fish

      set -g fish_greeting

      fish_add_path "$HOME/.nix-profile/bin"
      fish_add_path "$HOME/.local/bin"
      fish_add_path "$HOME/bin"
      fish_add_path "$HOME/.npm-global/bin"
      fish_add_path "$HOME/.krew/bin"

      set -gx SOPS_AGE_KEY_FILE $HOME/.config/sops/age/keys.txt
      set -gx EDITOR code -w
      set -gx LANG en_US.UTF-8
      set -gx LC_ALL en_US.UTF-8
      set -gx HOMEBREW_NO_ANALYTICS 1
      set -gx NPM_CONFIG_PREFIX $HOME/.npm-global
      set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
      set -gx PATH $PATH $HOME/.krew/bin

      set -U __done_allow_nongraphical 1
      set -U --append __done_exclude '^htop'
      set -U --append __done_exclude '^btop'
      set -U --append __done_exclude '^vim'
      set -U --append __done_exclude '^nvim'

      set -Ux FZF_DEFAULT_OPTS '--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --height 40% --layout reverse --border'

      nix-your-shell fish | source
    '';

    plugins = [
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fisher-plugin-macos";
        src = pkgs.fetchFromGitHub {
          owner = "edheltzel";
          repo = "fisher-plugin-macos";
          rev = "5b4c5815040eca670c4f552b575a60d3f05af2ea";
          sha256 = "sha256-TiAo6YzN4aRaMlZEvXlIR9xhYkEiGMSdKYnomEnfGCk=";
        };
      }
      {
        name = "fzf-fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
    ];

    shellAliases = {
      kubectl = "kubecolor";
      k = "kubectl";
      kns = "kubectl ns";
      kubectx = "kubectl ctx";
      df-pv = "kubectl df-pv";
      browse-pvc = "kubectl browse-pvc";
      df = "df -h";
      mkdir = "mkdir -p -v";
      lg = "lazygit";
      grep = "rg";
      ping = "prettyping --nolegend";
    };

    functions = {
      psgrep = {
        argumentNames = ["process"];
        description = "greps for processes";
        body = "ps aux | rg $process | rg -v rg";
      };
      y = {
        argumentNames = ["argv"];
        description = "opens yazi file manager and changes directory on exit";
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };

      fzf_history = {
        body = ''
          set -l line (commandline)

          # tac reverses order initially, tiebreak sorts(?), -n2..,.. ignores first two fields, +m means no "--multi"
          set -l result (atuin search --cmd-only | fzf --tac "-n2..,.." --tiebreak=index "+m" --query="$line")

          set -l key $result[1]
          set -l selected $result[2]

          if test "$key" = enter
              commandline --replace $selected
              commandline -f repaint
              commandline -f execute
              return
          end

          if test -n "$selected"
              commandline -r -- $selected
          end

          commandline -f repaint
        '';
      };


      _atuin_fzf_search = {
        body = ''
          # Ensure tac is available in all environments
          if not command -v tac >/dev/null 2>&1
              alias tac='perl -e "print reverse(<>)"'
          end
          set -f commands_selected (
            atuin history list --format "{command}" |
              tail -30000 |
              tac |
              _fzf_wrapper --print0 \
                --no-sort \
                --query=(commandline) \
                --height=40% \
                --border \
                --preview-window=hidden
          )

          if test $status -eq 0
              commandline --replace -- $commands_selected
          end

          commandline --function repaint
        '';
      };

      fish_user_key_bindings = {
        body = ''
          bind \cR _atuin_fzf_search
        '';
      };
    };
  };
}
