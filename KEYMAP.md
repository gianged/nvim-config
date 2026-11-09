# Keymap

Leader: `<Space>`. Local leader: `\`.

**Source** column:
- **custom**: defined in this config; the file is named.
- **override**: replaces a Neovim built-in.
- **nvim** / **blink**: a default that the config relies on, not defined here.

## Normal mode

### Editor

| Key | Action | Source |
|---|---|---|
| `Esc` | Clear search highlight | custom `config/keymaps.lua` |
| `Alt+u` | Focus upper window | custom `config/keymaps.lua` |
| `Alt+h` | Focus left window | custom `config/keymaps.lua` |
| `Alt+j` | Focus lower window | custom `config/keymaps.lua` |
| `Alt+k` | Focus right window | custom `config/keymaps.lua` |

### Formatting

| Key | Action | Source |
|---|---|---|
| `<leader>uf` | Toggle format on save (session) | custom `plugins/format.lua` |
| `gq{motion}` | Format range: stylua for Lua, LSP elsewhere | nvim; `formatexpr` from `plugins/format.lua` |

### LSP (buffers with a language server)

| Key | Action | Source |
|---|---|---|
| `gd` | Go to definition | override `plugins/lsp.lua` (built-in: local declaration search) |
| `grr` | References, without import lines or the declaration | override `plugins/lsp.lua` |
| `grn` | Rename symbol | nvim |
| `gra` | Code action (also Visual mode) | nvim |
| `gri` | Go to implementation | nvim |
| `grt` | Go to type definition | nvim |
| `grx` | Run code lens | nvim |
| `gO` | Document symbols | nvim |
| `K` | Hover docs | nvim |
| `Ctrl+]` | Go to definition (via tagfunc) | nvim |
| `[d` / `]d` | Previous / next diagnostic | nvim |
| `<leader>uh` | Toggle inlay hints in current buffer (on by default) | custom `plugins/lsp.lua` |
| `<leader>q` | All diagnostics → quickfix list | custom `plugins/lsp.lua` |

## Visual mode

| Key | Action | Source |
|---|---|---|
| `J` | Move selection down | override `config/keymaps.lua` (built-in: join lines) |
| `K` | Move selection up | override `config/keymaps.lua` (built-in: keyword lookup) |
| `<` | Indent left, keep selection | override `config/keymaps.lua` |
| `>` | Indent right, keep selection | override `config/keymaps.lua` |

## Insert mode

### Completion (blink.cmp `default` preset, `plugins/completion.lua`)

| Key | Action | Source |
|---|---|---|
| `Ctrl+y` | Accept highlighted item | blink |
| `Up` / `Down`, `Ctrl+p` / `Ctrl+n` | Previous / next item | blink |
| `Ctrl+e` | Close menu | blink |
| `Ctrl+Space` | Open menu / toggle docs popup | blink |
| `Ctrl+b` / `Ctrl+f` | Scroll docs popup | blink |
| `Tab` / `Shift+Tab` | Next / previous snippet placeholder | blink |

### LSP

| Key | Action | Source |
|---|---|---|
| `Ctrl+s` | Signature help; press again to cycle overloads | nvim |
