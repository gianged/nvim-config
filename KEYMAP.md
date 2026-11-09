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
| `Ctrl+l` | Clear search highlight and redraw | nvim |
| `Ctrl+w k` | Focus upper window | nvim |
| `Ctrl+w h` | Focus left window | nvim |
| `Ctrl+w j` | Focus lower window | nvim |
| `Ctrl+w l` | Focus right window | nvim |

### Formatting

| Key | Action | Source |
|---|---|---|
| `<leader>uf` | Toggle format on save (session) | custom `plugins/format.lua` |
| `gq{motion}` | Format range: stylua for Lua, clang-format for C/C++, LSP elsewhere | nvim; `formatexpr` from `plugins/format.lua` |

### Picker

| Key | Action | Source |
|---|---|---|
| `<leader>ff` | Find files (hidden included, `.gitignore` respected) | custom `plugins/picker.lua` |
| `<leader>fg` | Grep project (hidden included, `.gitignore` respected) | custom `plugins/picker.lua` |
| `<leader>fb` | Open buffers | custom `plugins/picker.lua` |
| `<leader>fr` | Resume last picker | custom `plugins/picker.lua` |

### File tree

| Key | Action | Source |
|---|---|---|
| `<leader>e` | Toggle tree, revealing the current file | custom `plugins/tree.lua` |

## File tree buffer (nvim-tree default keys)

| Key | Action | Source |
|---|---|---|
| `Enter` / `o` | Open | nvim-tree |
| `Ctrl+v` / `Ctrl+x` | Open in vertical / horizontal split | nvim-tree |
| `Tab` | Preview | nvim-tree |
| `a` | Create file or folder (end with `/` for a folder) | nvim-tree |
| `r` / `e` | Rename / rename basename | nvim-tree |
| `d` / `D` | Delete / trash | nvim-tree |
| `x` / `c` / `p` | Cut / copy / paste | nvim-tree |
| `y` / `Y` / `gy` | Copy name / relative path / absolute path | nvim-tree |
| `[c` / `]c` | Previous / next git change | nvim-tree |
| `[e` / `]e` | Previous / next diagnostic | nvim-tree |
| `H` / `I` | Toggle dotfiles / git-ignored filter | nvim-tree |
| `f` / `F` | Live filter start / clear | nvim-tree |
| `-` / `P` / `Backspace` | Root up / go to parent / close folder | nvim-tree |
| `E` / `W` | Expand all / collapse all | nvim-tree |
| `S` | Search | nvim-tree |
| `R` | Refresh | nvim-tree |
| `q` | Close tree | nvim-tree |
| `g?` | Show all tree keys | nvim-tree |

## Picker window (snacks.picker default keys, Insert and Normal)

| Key | Action | Source |
|---|---|---|
| `Enter` | Open | snacks |
| `Esc` | Close (Insert: to Normal first) | snacks |
| `Ctrl+j` / `Ctrl+k`, `Ctrl+n` / `Ctrl+p`, `Up` / `Down` | Next / previous item | snacks |
| `Ctrl+d` / `Ctrl+u` | Scroll list | snacks |
| `Ctrl+f` / `Ctrl+b` | Scroll preview | snacks |
| `Tab` / `Shift+Tab` | Select and move | snacks |
| `Ctrl+a` | Select all | snacks |
| `Ctrl+v` / `Ctrl+s` / `Ctrl+t` | Open in vertical split / split / tab | snacks |
| `Ctrl+q` | Send to quickfix | snacks |
| `Ctrl+g` | Toggle live grep | snacks |
| `Alt+h` / `Alt+i` | Toggle hidden / ignored files | snacks |
| `Alt+p` / `Alt+m` | Toggle preview / maximize | snacks |
| `Ctrl+Up` / `Ctrl+Down` | Search history | snacks |
| `Ctrl+x` | Delete buffer (buffers picker) | snacks |

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
