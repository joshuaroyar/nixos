{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # User account
  home = {
    username = "joshua";
    homeDirectory = "/home/joshua";

    stateVersion = "26.05";
  };

  # Git configuration
  programs.git = {
    enable = true;

    settings = {
      user.name = "joshua";
      user.email = "joshuaroyar@gmail.com";

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # User packages
  home.packages = with pkgs; [
    # Terminal
    kitty
    xdg-terminal-exec

    # Shells
    fish
    nushell
    starship

    # Editor
    helix
    zed-editor
    (writeShellScriptBin "zed" ''
        exec ${nixgl.nixVulkanIntel}/bin/nixVulkanIntel ${zed-editor}/bin/zed "$@"
    '')

    #  Browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Desktop
    eww
    vicinae
    swaylock
    swayidle
    mako
    awww

    # File manager
    yazi

    # Basic utilities
    unzip
    zip
    wget
    curl
    wl-clipboard

    # Players
    mpv
    vlc

    # Search
    ripgrep
    fd
    fzf

    # File utilities
    bat
    eza

    # Data
    jq
    yq

    # Git
    lazygit

    # System
    btop
    dust
    duf
    procs

    # Development
    git
    gh
    gnumake
    pkg-config

    # Rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

    # Python
    python3
    basedpyright
    ruff

    # Nix
    nixd
    nixfmt
    statix
    deadnix

    # Web
    nodejs
    typescript
    typescript-language-server

    # Java
    jdk
    jdt-language-server
    google-java-format

    # C/C++
    clang
    clang-tools

    # Office
    libreoffice
  ];

  # Configure default terminal for apps
  xdg.configFile."xdg-terminals.list".text = ''
    	kitty.desktop
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = [ "kitty.desktop" ];
    };
  };

  # Mpv
  programs.mpv.enable = true;
  
  # Fish
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      			# Disable fish greeting
      			set -g fish_greeting ""

      			# Navigation
      			alias c "cd"
      			alias .. "cd .."
      			alias ... "cd ../.."
      			
      			alias projects "cd /projects"

      			# Better UNIX tools
      			alias ls "eza"
      			alias ll "eza -lah"
      			alias la "eza -la"

      			alias cat "bat"
      			alias grep "rg"

      			# Git
      			alias lg "lazygit"

      			# NixOS
      			alias nixos-rebuild \
      				"sudo nixos-rebuild switch --flake /etc/nixos#nixos"
      			alias nixos-test \
      				"sudo nixos-rebuild test --flake /etc/nixos#nixos"
      			alias nixos-boot \
      				"sudo nixos-rebuild boot --flake /etc/nixos#nixos"

      			# Podman
      			alias p "podman"
      			alias pc "podman compose"
      		'';
  };

  # Nushell
  programs.nushell = {
    enable = true;

    extraConfig = ''
      			$env.config = {
      				show_banner: false
      				edit_mode: vi
      			};
      		'';
  };

  # Starship
  programs.starship = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      add_newline = true;

      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";

      directory = {
        truncation_length = 3;
      };

      character = {
        success_symbol = ">";
        error_symbol = "X";
      };
    };
  };

  # Kitty
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      size = 11;
    };

    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      cursor_blink_interval = 0;
      scrollback_lines = 10000;

      linux_display_server = "wayland";

      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";

      background_opacity = "0.8";
    };
  };

  # Zellij
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      # General
      default_mode = "normal";
      pane_frames = false;
      mouse_mode = true;
      scroll_buffer_size = 10000;

      # Wayland clipboard
      copy_clipboard = "system";
      copy_command = "wl-copy";

      # Session persistence
      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 10000;

      # Keybindings
      keybinds = {
        normal._children = [
          # Pane navigation
          {
            bind = {
              _args = [ "Alt h" ];
              _children = [
                { MoveFocusOrTab._args = [ "left" ]; }
              ];
            };
          }

          {
            bind = {
              _args = [ "Alt j" ];
              _children = [
                { MoveFocus._args = [ "down" ]; }
              ];
            };
          }

          {
            bind = {
              _args = [ "Alt k" ];
              _children = [
                { MoveFocus._args = [ "up" ]; }
              ];
            };
          }

          {
            bind = {
              _args = [ "Alt l" ];
              _children = [
                { MoveFocusOrTab._args = [ "right" ]; }
              ];
            };
          }

          # New Fish pane
          {
            bind = {
              _args = [ "Alt f" ];
              _children = [
                {
                  Run._args = [ "fish" ];
                }
              ];
            };
          }

          # New Nushell pane
          {
            bind = {
              _args = [ "Alt n" ];
              _children = [
                {
                   Run._args = [ "nu" ];
                }
              ];
            };
          }

          # New tab
          {
            bind = {
              _args = [ "Alt t" ];
              _children = [
                { NewTab = { }; }
              ];
            };
          }

          # Previous tab
          {
            bind = {
              _args = [ "Alt [" ];
              _children = [
                { GoToPreviousTab = { }; }
              ];
            };
          }

          # Next tab
          {
            bind = {
              _args = [ "Alt ]" ];
              _children = [
                { GoToNextTab = { }; }
              ];
            };
          }

          # Toggle fullscreen pane
          {
            bind = {
              _args = [ "Alt Enter" ];
              _children = [
                { ToggleFocusFullscreen = { }; }
              ];
            };
          }

          # Toggle floating panes
          {
            bind = {
              _args = [ "Alt Space" ];
              _children = [
                { ToggleFloatingPanes = { }; }
              ];
            };
          }

          # Detach
          {
            bind = {
              _args = [ "Alt d" ];
              _children = [
                { Detach = { }; }
              ];
            };
          }
        ];

        # Dedicated resize mode
        resize._children = [
          {
            bind = {
              _args = [ "h" ];
              _children = [
                { Resize = [ "left" ]; }
              ];
            };
          }

          {
            bind = {
              _args = [ "j" ];
              _children = [
                { Resize = [ "down" ]; }
              ];
            };
          }

          {
            bind = {
              _args = [ "k" ];
              _children = [
                { Resize = [ "up" ]; }
              ];
            };
          }

          {
            bind = {
              _args = [ "l" ];
              _children = [
                { Resize = [ "right" ]; }
              ];
            };
          }
        ];
      };
    };
  };

  # Helix
  programs.helix = {
    enable = true;

    settings = {
      theme = "base16_transparent";

      editor = {
        line-number = "relative";

        cursorline = true;

        true-color = true;

        color-modes = true;

        bufferline = "multiple";

        rulers = [
          80
          120
        ];

        indent-guides = {
          render = true;
          character = "|";
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        inline-diagnostics = {
          cursor-line = "warning";
        };

        auto-format = true;

        completion-trigger-len = 1;

        completion-timeout = 5;

        statusline = {
          left = [
            "mode"
            "spinner"
            "read-only-indicator"
            "file-name"
          ];

          center = [
            "version-control"
          ];

          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
        };
      };

      keys.normal = {
        space = {
          w = ":write";
          q = ":quit";
          x = ":write-quit";
          f = "file_picker";
          b = "buffer_picker";
          g = "global_search";
          r = "rename_symbol";
          a = "code_action";
        };

        "C-s" = ":write";

        "C-q" = ":quit";

        "C-/" = "toggle_comments";
      };
    };

    languages = {
      language = [
        {
          name = "rust";

          auto-format = true;

          language-servers = [
            "rust-analyzer"
          ];

          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
          };
        }

        {
          name = "python";

          auto-format = true;

          language-servers = [
            "basedpyright"
            "ruff"
          ];

          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "-"
            ];
          };
        }

        {
          name = "nix";

          auto-format = true;

          language-servers = [
            "nixd"
          ];

          formatter = {
            command = "${pkgs.nixfmt}/bin/nixfmt";
          };
        }

        {
          name = "typescript";

          auto-format = true;

          language-servers = [
            "typescript-language-server"
          ];

          formatter = {
            command = "${pkgs.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }

        {
          name = "javascript";

          language-servers = [
            "typescript-language-server"
          ];
        }

        {
          name = "c";

          language-servers = [
            "clangd"
          ];

          formatter = {
            command = "${pkgs.clang-tools}/bin/clang-format";
          };
        }

        {
          name = "cpp";

          language-servers = [
            "clangd"
          ];

          formatter = {
            command = "${pkgs.clang-tools}/bin/clang-format";
          };
        }

        {
          name = "java";

          language-servers = [
            "jdtls"
          ];

          formatter = {
            command = "${pkgs.google-java-format}/bin/google-java-format";
            args = [ "-" ];
          };
        }

        {
          name = "sql";

          language-servers = [
            "sqls"
          ];
        }

        {
          name = "fish";

          language-servers = [
            "fish-lsp"
          ];
        }
      ];

      language-server = {
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
        basedpyright = {
          command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
          args = [ "--stdio" ];
        };
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
        };
        jdtls = {
          command = "${pkgs.jdt-language-server}/bin/jdtls";
        };
        sqls = {
          command = "${pkgs.sqls}/bin/sqls";
        };
        fish-lsp = {
          command = "${pkgs.fish-lsp}/bin/fish-lsp";
        };
      };
    };
  };

  # Zed
  programs.zed-editor = {
    enable = true;
  };

  # Vicinae
  programs.vicinae = {
    enable = true;

    systemd = {
      enable = true;
      autoStart = true;
    };
  };

  # Swaylock
  programs.swaylock = {
    enable = true;

    settings = {
      color = "1a1b26";
      font-size = 24;
      ignore-empty-password = true;
      show-failed-attempts = true;
      indicator = true;
      indicator-radius = 100;
      indicator-idle-visible = false;
      clock = true;
      timestr = "%H:%M";
      datestr = "%A, %d %B";
    };
  };

  # Swayidle
  services.swayidle = {
    enable = true;

    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };

    timeouts = [
      {
        timeout = 900;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }

      {
        timeout = 960;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }

      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  # Notifications
  services.mako = {
    enable = true;

    settings = {
      font = "JetBrains Mono 10";
      background-color = "#16161e";
      text-color = "#c0caf5";
      border-color = "#7aa2f7";
      border-radius = 2;
      padding = "12";
      default-timeout = 5000;
    };
  };

  # Niri - provided in config.kdl

  # Eww - provided in eww.yuck
}
