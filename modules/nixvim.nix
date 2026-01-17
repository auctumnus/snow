{
  pkgs,
  config,
  lib,
  ...
}:
let
  auto-dark-mode-repo = pkgs.fetchFromGitHub {
    owner = "f-person";
    repo = "auto-dark-mode.nvim";
    rev = "e300259";
    hash = "sha256-PhhOlq4byctWJ5rLe3cifImH56vR2+k3BZGDZdQvjng=";
  };
  auto-dark-mode = pkgs.vimUtils.buildVimPlugin {
    name = "auto-dark-mode";
    src = auto-dark-mode-repo;
  };
  dark-theme = "github_dark_default";
  light-theme = "github_light_default";
  cfg = config.snow.nixvim;
in
{
  options.snow.nixvim.enable = lib.mkEnableOption "nixvim";
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.config.allowUnfree = true;
      extraPackages = with pkgs; [
        nixfmt-rfc-style
        typstyle
        clang
      ];
      extraPlugins = with pkgs.vimPlugins; [
        auto-dark-mode
      ];
      extraConfigLua = ''
        require('auto-dark-mode').setup({
          set_dark_mode = function ()
            vim.cmd.colorscheme '${dark-theme}'
          end,
          set_light_mode = function ()
            vim.cmd.colorscheme '${light-theme}'
          end,
          update_interval = 3000,
          fallback = "dark"
        })
        if (vim.fn.system { 'dconf', 'read', '/org/gnome/desktop/interface/color-scheme' }) == 'prefer-dark' then
          vim.cmd.colorscheme '${dark-theme}'
        else
          vim.cmd.colorscheme '${light-theme}'
        end  
      '';
      colorschemes.github-theme.enable = true;
      colorscheme = "vim";
      performance = {
        #byteCompileLua = {
        #  enable = true;
        #  nvimRuntime = true;
        #  plugins = true;
        #};
        combinePlugins = {
          enable = false;
          standalonePlugins = [
            "github-nvim-theme"
            "conform.nvim"
            "nvim-treesitter"
          ];
        };
      };
      opts = {
        cmdheight = 0;
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        expandtab = true;
        smartindent = true;
      };
      keymaps = [
        {
          action = ":Neotree toggle<cr>";
          key = "<leader>t";
          mode = "n";
        }
        {
          action = ":Telescope buffers<CR>";
          key = "<leader>fb";
          mode = "n";
        }
        {
          action = ":Telescope live_grep<CR>";
          key = "<leader>ff";
          mode = "n";
        }
        {
          action = ":Telescope resume<CR>";
          key = "<leader>f<leader>";
          mode = "n";
        }
        {
          action = ":Telescope find_files<CR>";
          key = "<leader>fp";
          mode = "n";
        }
        {
          action = "<Plug>(leap)";
          key = "z";
          mode = "n";
        }
        {
          action = "<Plug>(leap-from-window)";
          key = "Z";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.hover()<cr>";
          key = "K";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.definition()<cr>";
          key = "gd";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
          key = "gD";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
          key = "gi";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
          key = "go";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.references()<cr>";
          key = "gr";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
          key = "<C-k>";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.rename()<cr>";
          key = "<F2>";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
          key = "<F4>";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.lsp.buf.range_code_action()<cr>";
          key = "<F4>";
          mode = "x";
        }
        {
          action = "<cmd>lua vim.diagnostic.open_float()<cr>";
          key = "gl";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
          key = "[d";
          mode = "n";
        }
        {
          action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
          key = "]d";
          mode = "n";
        }

      ]
      # window movement
      ++ (map
        (x: {
          action = "<C-w><${x}>";
          key = "<C-${x}>";
          mode = "n";
          options.silent = true;
        })
        [
          "Up"
          "Right"
          "Down"
          "Left"
        ]
      );
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
      };
      lsp.servers.clangd.enable = true;
      diagnostic.settings = {
        virtual_lines = {
          current_line = true;
        };
        virtual_text = true;
      };

      plugins = {
        claude-code.enable = true;
        lsp = {
          enable = true;
          servers = {
            lua_ls.enable = true;
            clangd.enable = true;
            pylsp.enable = true;
            markdown_oxide.enable = true;
            nixd.enable = true;
            bashls.enable = true;
          };
        };
        lz-n.enable = true;
        clangd-extensions.enable = true;
        # coq-nvim = {
        #   enable = true;
        #   lazyLoad.enable = false;
        #   installArtifacts = true;
        #   autoLoad = true;
        #   settings.auto_start = true;
        # };
        # coq-thirdparty.enable = true;
        blink-cmp = {
          autoLoad = true;
          enable = true;
          lazyLoad.enable = false;
          settings = {
            keymap.preset = "enter";
          };
        };
        bufferline = {
          autoLoad = true;
          enable = true;
          lazyLoad.enable = false;
        };
        lualine = {
          settings.options.disabled_filetypes = [
            "neo-tree"
          ];
          autoLoad = true;
          enable = true;
          lazyLoad.enable = false;
        };
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              nix = [ "nixfmt" ];
              # typst = [ "typstyle" ];
              # rust = [ "rustfmt" ];
            };
            format_after_save = {
              timeout_ms = 500;
              lsp_format = "fallback";
            };
          };
        };
        # floaterm = {
        #   enable = true;
        #   settings.keymap_toggle = "<F7>";
        # };
        nvim-lightbulb = {
          enable = true;
          settings.virtual_text.enabled = true;
        };
        leap.enable = true;
        gitsigns.enable = true;
        neo-tree = {
          enable = true;
          settings.close_if_last_window = true;
        };
        nvim-autopairs.enable = true;
        telescope = {
          enable = true;
          settings.extensions.fzf-native.enable = true;
        };
        treesitter = {
          enable = true;
          nixvimInjections = true;
        };
        # trouble.enable = true;
        web-devicons.enable = true;
        which-key.enable = true;
      };
    };
  };
}
