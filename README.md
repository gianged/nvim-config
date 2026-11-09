# nvim-config

## Install
```sh
git clone <repo> ~/my-projects/nvim-config
rsync -a --delete ~/my-projects/nvim-config/nvim/ ~/.config/nvim/
nvim   # lazy.nvim bootstraps, Mason installs servers
```

## Packages (Arch names)
| Purpose | Packages |
|---|---|
| Core | `neovim` (>= 0.12), `git`, `curl`, `tar`, `unzip`, `rsync`, `ripgrep`, `fd` |
| Treesitter | `tree-sitter-cli` (>= 0.26.1, not npm), `base-devel` (C compiler) |
| Font | `ttf-firacode-nerd` (set it as terminal font) |
| Clipboard | `wl-clipboard` (Wayland) or `xclip` (X11) |
| Rust | `rustup` -> `rustup component add rust-analyzer` |
| C / C++ | `clang` (clangd) |
| Go | `go` |
| Java | `jdk-openjdk` (jdtls via Mason) |
| Python | `python`, `python-pip` |
| TypeScript | `nodejs`, `npm` |
| Lua lint | `stylua` |
| Claude Code | `claude` CLI on `PATH` |
| Git / Docker UI | `lazygit`, `lazydocker` |

Mason needs the language runtimes above to build servers.
After install: `:checkhealth`, `:Mason`, `:TSUpdate`.
