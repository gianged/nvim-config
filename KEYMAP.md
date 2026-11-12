# Keymap

Leader: `<Space>`. Local leader: `\`.

**Source** column:
- **custom**: defined in this config; the file is named.
- **override**: replaces a Neovim built-in.
- **nvim** / **blink**: a default that the config relies on, not defined here.

New to Neovim: run `:Tutor` once (about 30 minutes), then use this file as a lookup.

## Normal mode

### Editor

| Key | Action | Source |
|---|---|---|
| `Esc` | Clear search highlight | custom `config/keymaps.lua` |
| `Ctrl+h` | Focus left window | override `config/keymaps.lua` (built-in: same as `h`) |
| `Ctrl+j` | Focus lower window | override `config/keymaps.lua` (built-in: same as `j`) |
| `Ctrl+k` | Focus upper window | custom `config/keymaps.lua` |
| `Ctrl+l` | Focus right window | override `config/keymaps.lua` (built-in: redraw, clear search highlight) |

### Help

| Key | Action | Source |
|---|---|---|
| `:Tutor` | Interactive tutorial for the basics | nvim |
| `:h {topic}` | Help, e.g. `:h gq`, `:h i_CTRL-R` | nvim |
| `Ctrl+]` / `Ctrl+o` | In a help page: follow link / go back | nvim |
| `:h index` | Every built-in key, by mode | nvim |
| `:nmap <leader>` / `:nmap <leader>g` | All leader mappings / one leader group (`:xmap` for Visual) | nvim |
| `:verbose nmap {key}` | What a key does and which file set it | nvim |
| `:messages` | Show recent messages and errors again | nvim |
| `:checkhealth` | Diagnose setup problems (missing tools, broken plugins) | nvim |
| `:Lazy` / `:Mason` | Plugin manager / language server installer UI | lazy.nvim / mason |

### Files and buffers

Find a file: `<leader>pf`. Create from the tree: `a`. Everything else below is built-in.

| Key | Action | Source |
|---|---|---|
| `:w` / `:wa` | Save / save all | nvim |
| `:q` / `:qa` / `:q!` | Close window / quit all / quit discarding changes | nvim |
| `ZZ` / `ZQ` | Save and close / close discarding changes | nvim |
| `:e path` | Open file; a new path is created on `:w` | nvim |
| `:w ++p` | Save, creating missing parent directories | nvim |
| `:e %:h/name` | New file next to the current file (`%:h` = its folder) | nvim |
| `:!mkdir -p path` | Create a folder only | nvim |
| `:e!` | Reload file from disk, discarding changes | nvim |
| `Ctrl+^` | Toggle to previous (alternate) buffer | nvim |
| `]b` / `[b` | Next / previous buffer | nvim |
| `]B` / `[B` | Last / first buffer | nvim |
| `:ls` | List open buffers with numbers | nvim |
| `:b name<Tab>` / `:b N` | Switch to buffer by partial name / number | nvim |
| `:bd` | Close buffer | nvim |
| `Ctrl+g` | Show file name, line count, position | nvim |
| `:pwd` / `:cd path` | Show / change working directory | nvim |
| `gf` | Open file path under cursor | nvim |
| `gx` | Open path or URL under cursor with system handler | nvim |

### Move and jump

| Key | Action | Source |
|---|---|---|
| `:{N}` / `{N}G` | Go to line N | nvim |
| `gg` / `G` | First / last line | nvim |
| `0` / `^` / `$` | Line start / first non-blank / line end | nvim |
| `w` / `b` / `e` | Next word / previous word / end of word (`W` `B` `E`: whitespace-separated) | nvim |
| `f{c}` / `t{c}` | Jump to / before char `c` in line; `;` / `,` repeat forward / back | nvim |
| `%` | Matching bracket (and `if`/`end` pairs via matchit) | nvim |
| `[{` / `]}` | Enclosing `{` / `}` from anywhere inside the block (`[(` / `])` for parens) | nvim |
| `{` / `}` | Previous / next blank-line block | nvim |
| `H` / `M` / `L` | Top / middle / bottom of screen | nvim |
| `Ctrl+d` / `Ctrl+u` | Half page down / up | nvim |
| `Ctrl+f` / `Ctrl+b` | Full page down / up | nvim |
| `Ctrl+e` / `Ctrl+y` | Scroll one line down / up, cursor stays | nvim |
| `zz` / `zt` / `zb` | Scroll cursor line to center / top / bottom | nvim |
| `Ctrl+o` / `Ctrl+i` | Jump back / forward (e.g. after `G`, `/search`, `%`) | nvim |
| `g;` / `g,` | Older / newer change position | nvim |
| `gi` | Back to where you last typed, in Insert mode | nvim |
| `m{a-z}` / `'{a-z}` | Set mark / jump to mark (`A-Z`: across files) | nvim |

### Search and replace

`ignorecase` + `smartcase`: case-insensitive unless the pattern has an uppercase letter.

| Key | Action | Source |
|---|---|---|
| `/text` / `?text` | Search forward / backward; `n` / `N` next / previous match | nvim |
| `*` / `#` | Search word under cursor forward / backward | nvim |
| `cgn` then `.` | Change next match, `.` repeats on the following one (search with `*` first) | nvim |
| `:%s/old/new/g` | Replace in file; add `c` flag to confirm each | nvim |
| `:%s//new/g` | Replace using the last search pattern | nvim |
| `&` | Repeat last `:s` on current line | nvim |
| `:s/old/new/g` | Replace in Visual selection (press `:` with selection active) | nvim |
| `:g/pat/d` / `:v/pat/d` | Delete lines matching / not matching `pat` | nvim |
| `:cdo s/old/new/g \| update` | Replace across project: `<leader>pg`, `Ctrl+q` to quickfix, then this | nvim |

### Edit

Yank, delete, and put use the system clipboard (`clipboard=unnamedplus`).

| Key | Action | Source |
|---|---|---|
| `i` / `a` / `I` / `A` | Insert before cursor / after cursor / line start / line end | nvim |
| `o` / `O` | New line below / above | nvim |
| `]<Space>` / `[<Space>` | Blank line below / above, stay in Normal | nvim |
| `u` / `Ctrl+r` | Undo / redo (undo persists across sessions) | nvim |
| `.` | Repeat last change | nvim |
| `dd` / `yy` / `cc` | Delete / yank / change line | nvim |
| `D` / `C` / `Y` | Delete / change / yank to line end | nvim |
| `p` / `P` | Put after / before cursor | nvim |
| `"0p` | Put last yank (not overwritten by deletes) | nvim |
| `"_d{motion}` | Delete without touching the clipboard | nvim |
| `:reg` | Show register contents | nvim |
| `{op}i{obj}` / `{op}a{obj}` | Text object inside / around, e.g. `ciw`, `di"`, `ya(`, `dap` | nvim |
| `x` / `r{c}` / `~` | Delete char / replace char / toggle case | nvim |
| `R` | Replace mode: overwrite as you type | nvim |
| `gu{motion}` / `gU{motion}` | Lowercase / uppercase, e.g. `guiw` | nvim |
| `>>` / `<<` | Indent / unindent line | nvim |
| `==` / `gg=G` | Reindent line / whole file | nvim |
| `J` | Join line below | nvim |
| `gcc` / `gc{motion}` | Toggle comment line / motion | nvim |
| `Ctrl+a` / `Ctrl+x` | Increment / decrement number | nvim |
| `q{a-z}` ... `q` | Record macro into register | nvim |
| `@{a-z}` / `@@` | Play macro / replay last | nvim |

### Windows and tabs

| Key | Action | Source |
|---|---|---|
| `Ctrl+w v` / `Ctrl+w s` | Split vertical / horizontal (`:vs path` / `:sp path` with a file) | nvim |
| `Ctrl+w w` | Focus next window | nvim |
| `Ctrl+w q` / `Ctrl+w o` | Close window / close all others | nvim |
| `Ctrl+w =` | Equalize window sizes | nvim |
| `Ctrl+w _` / `Ctrl+w \|` | Maximize height / width | nvim |
| `Ctrl+w <` / `>` / `+` / `-` | Narrower / wider / taller / shorter | nvim |
| `Ctrl+w H` / `J` / `K` / `L` | Move window to far left / bottom / top / right | nvim |
| `Ctrl+w T` | Move window to a new tab | nvim |
| `gt` / `gT` | Next / previous tab (Neogit, codediff open in tabs) | nvim |
| `:tabnew` / `:tabclose` | Open / close tab | nvim |

### Quickfix list

The quickfix list holds positions (grep results, references, diagnostics). The location list is the same, per window.

| Key | Action | Source |
|---|---|---|
| `]q` / `[q` | Next / previous entry | nvim |
| `[Q` / `]Q` | First / last entry | nvim |
| `:cc N` | Jump to entry N | nvim |
| `:copen` / `:cclose` | Open / close quickfix window | nvim |
| `:colder` / `:cnewer` | Previous / next quickfix list | nvim |
| `:cdo {cmd}` / `:cfdo {cmd}` | Run command on each entry / once per file | nvim |
| `]l` / `[l`, `:lopen` | Location list: next / previous, open | nvim |

### Formatting

| Key | Action | Source |
|---|---|---|
| `<leader>ff` | Format file: organize imports, then format (any filetype, even with format on save off) | custom `plugins/format.lua` |
| `Alt+f` | Format file (same as `<leader>ff`) | custom `plugins/format.lua` |
| `<leader>ft` | Toggle format on save (session) | custom `plugins/format.lua` |
| `gq{motion}` | Format range: stylua for Lua, clang-format for C/C++, LSP elsewhere | nvim; `formatexpr` from `plugins/format.lua` |

### LSP (buffers with a language server)

| Key | Action | Source |
|---|---|---|
| `gd` | Go to definition in the peek window (right vsplit, one per tab, reused); several results → quickfix list | override `plugins/lsp.lua` (built-in: local declaration search) |
| `Ctrl+]` | Go to definition in the peek window (same as `gd`) | override `plugins/lsp.lua` (built-in: tag jump via tagfunc) |
| `gri` | Go to implementation in the peek window; several results → quickfix list | override `plugins/lsp.lua` |
| `grt` | Go to type definition in the peek window; several results → quickfix list | override `plugins/lsp.lua` |
| `grr` | References, without import lines or the declaration → quickfix list (`Enter` opens in peek) | override `plugins/lsp.lua` |
| `Alt+]` | References (same as `grr`) | custom `plugins/lsp.lua` |
| `<leader>wp` | Pin peek: move its file and view into the window `gd` came from, close peek | custom `plugins/lsp.lua` |
| `Ctrl+p` | Pin peek (same as `<leader>wp`) | override `plugins/lsp.lua` (built-in: same as `k`) |
| `Alt+[` | Previous peek location (peek history, any window); no-op when empty | custom `plugins/lsp.lua` |
| `grn` | Rename symbol | nvim |
| `gra` | Code action (also Visual mode) | nvim |
| `grx` | Run code lens | nvim |
| `gO` | Document symbols | nvim |
| `K` | Hover docs | nvim |
| `[d` / `]d` | Previous / next diagnostic | nvim |
| `[D` / `]D` | First / last diagnostic | nvim |
| `Ctrl+w d` | Show diagnostic under cursor in a float | nvim |
| `<leader>q` | All diagnostics → quickfix list | custom `plugins/lsp.lua` |
| `<leader>uh` | Toggle inlay hints in current buffer (on by default) | custom `plugins/lsp.lua` |
| `:checkhealth vim.lsp` | Which servers are attached, and why one is not | nvim |

### Picker

Keys inside the picker: [Picker window](#picker-window-snackspicker-default-keys-insert-and-normal).

| Key | Action | Source |
|---|---|---|
| `<leader>pf` | Find files (hidden included, `.gitignore` respected) | custom `plugins/picker.lua` |
| `Alt+t` | Find files (same as `<leader>pf`) | custom `plugins/picker.lua` |
| `<leader>pg` | Grep project (hidden included, `.gitignore` respected) | custom `plugins/picker.lua` |
| `<leader>pb` | Open buffers | custom `plugins/picker.lua` |
| `<leader>pr` | Resume last picker | custom `plugins/picker.lua` |

### File tree

Keys inside the tree: [File tree buffer](#file-tree-buffer-nvim-tree-default-keys).

| Key | Action | Source |
|---|---|---|
| `<leader>e` | Toggle tree, revealing the current file | custom `plugins/tree.lua` |
| `Alt+e` | Toggle tree (same as `<leader>e`) | custom `plugins/tree.lua` |

### Git

Keys inside the panels: [Git panel](#git-panel-neogit-default-keys), [Diff view](#diff-view-codediff-default-keys).

| Key | Action | Source |
|---|---|---|
| `<leader>gg` | Git panel (Neogit, own tab): stage, commit, push | custom `plugins/git.lua` |
| `<leader>gd` | Diff view (codediff): changed files + side-by-side diff | custom `plugins/git.lua` |
| `<leader>gh` | History of current file (codediff) | custom `plugins/git.lua` |
| `]c` / `[c` | Next / previous git hunk; built-in diff jump in diff mode (file buffers) | custom `plugins/git.lua` (gitsigns) |
| `<leader>gp` | Preview hunk under cursor (file buffers) | custom `plugins/git.lua` (gitsigns) |
| `<leader>gb` | Blame line, full commit message (file buffers) | custom `plugins/git.lua` (gitsigns) |
| `<leader>gB` | Toggle end-of-line blame (file buffers) | custom `plugins/git.lua` (gitsigns) |
| `<leader>gq` | All hunks in repo → quickfix list (file buffers) | custom `plugins/git.lua` (gitsigns) |

### Claude Code

| Key | Action | Source |
|---|---|---|
| `<leader>ac` | Toggle Claude split (starts `claude` if not running) | custom `plugins/claude.lua` |
| `<leader>aC` | Start Claude with `--continue` | custom `plugins/claude.lua` |
| `<leader>af` | Focus Claude (open if hidden) | custom `plugins/claude.lua` |
| `<leader>as` | Send current line as `@file#Ln`; in nvim-tree, the file under cursor | custom `plugins/claude.lua` |
| `<leader>aa` | Accept Claude diff (same as `:w` in the proposed buffer) | custom `plugins/claude.lua` |
| `<leader>ad` | Reject Claude diff (same as `:q` in the proposed buffer) | custom `plugins/claude.lua` |

## Visual mode

| Key | Action | Source |
|---|---|---|
| `J` | Move selection down | override `config/keymaps.lua` (built-in: join lines) |
| `K` | Move selection up | override `config/keymaps.lua` (built-in: keyword lookup) |
| `<` | Indent left, keep selection | override `config/keymaps.lua` |
| `>` | Indent right, keep selection | override `config/keymaps.lua` |

### Selection

| Key | Action | Source |
|---|---|---|
| `v` / `V` / `Ctrl+v` | Start charwise / linewise / block Visual (from Normal) | nvim |
| `gv` | Reselect last selection (from Normal) | nvim |
| `o` | Jump to other end of selection | nvim |
| `an` / `in` | Grow / shrink selection by syntax node (treesitter) | nvim |
| `Ctrl+v` ... `I` / `A` | Block: insert / append on every line, applied on `Esc` | nvim |
| `y` / `d` / `c` | Yank / delete / change selection | nvim |
| `p` | Replace selection with clipboard | nvim |
| `u` / `U` | Lowercase / uppercase selection | nvim |
| `=` | Reindent selection | nvim |
| `:` | Run a command on the selected lines, e.g. `:s/a/b/g`, `:norm A;` | nvim |
| `gc` | Toggle comment | nvim |
| `<leader>ff` / `Alt+f` | Format selection (no import changes) | custom `plugins/format.lua` |

### Claude Code

| Key | Action | Source |
|---|---|---|
| `<leader>as` | Send selection as `@file#Lx-y` | custom `plugins/claude.lua` |

### Git

| Key | Action | Source |
|---|---|---|
| `<leader>gh` | History of selected lines (codediff) | custom `plugins/git.lua` |
| `ih` | Select git hunk (file buffers) | custom `plugins/git.lua` (gitsigns) |

## Operator-pending mode

After an operator (`d`, `y`, `c`, `gu`, ...), before its motion.

| Key | Action | Source |
|---|---|---|
| `ih` | Git hunk text object, e.g. `yih`, `dih` (file buffers) | custom `plugins/git.lua` (gitsigns) |

## Insert mode

### Editing

| Key | Action | Source |
|---|---|---|
| `Ctrl+o` | Run one Normal command, then back to Insert | nvim |
| `Ctrl+r {reg}` | Insert register, e.g. `Ctrl+r +` clipboard, `Ctrl+r 0` last yank | nvim |
| `Ctrl+w` / `Ctrl+u` | Delete word / to line start before cursor | nvim |
| `Ctrl+t` / `Ctrl+d` | Indent / unindent line | nvim |
| `Ctrl+v {key}` | Insert the key literally, e.g. a real `Tab` | nvim |

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

## Terminal mode

| Key | Action | Source |
|---|---|---|
| `:terminal` | Open a shell in the current window (from Normal) | nvim |
| `i` | Enter terminal mode (from Normal, in a terminal buffer) | nvim |
| `Ctrl+\ Ctrl+n` | Leave terminal mode (`Esc` goes to Claude: interrupt, `Esc Esc` rewind) | nvim; snacks `Esc Esc` off in `plugins/claude.lua` |
| `Shift+Enter` | New line in Claude prompt | claudecode |

## Command-line mode

| Key / command | Action | Source |
|---|---|---|
| `Ctrl+r Ctrl+w` | Insert word under cursor, e.g. into `:%s/` | nvim |
| `Up` / `Down` | History matching typed prefix | nvim |
| `Tab` | Complete command, path, option | nvim |
| `Ctrl+f` | Open the command history window while typing | nvim |
| `q:` | Command history window, editable (from Normal) | nvim |
| `@:` | Repeat last command (from Normal) | nvim |
| `:{range}{cmd}` | Run on lines, e.g. `:10,20d`, `:.,+3y`, `:%norm A;` | nvim |
| `:!{cmd}` | Run shell command; `%` is the current file, e.g. `:!python3 %` | nvim |
| `:r !{cmd}` | Insert shell command output below cursor | nvim |
| `:claude [args]` | Expands to `:ClaudeCode [args]` (only as the whole command) | custom `plugins/claude.lua` |

## Panels

Keys that only work inside a panel's own window.

### File tree buffer (nvim-tree default keys)

| Key | Action | Source |
|---|---|---|
| `Enter` / `o` | Open in the window you came from; never the peek window (goes to its origin) | nvim-tree; target from `plugins/tree.lua` |
| `Ctrl+v` / `Ctrl+x` | Open in vertical / horizontal split | nvim-tree |
| `Tab` | Preview | nvim-tree |
| `a` | Create file or folder (end with `/` for a folder; `a/b/c.rs` creates the folders too) | nvim-tree |
| `r` / `e` | Rename / rename basename | nvim-tree |
| `d` / `D` | Delete / trash | nvim-tree |
| `x` / `c` / `p` | Cut / copy / paste | nvim-tree |
| `y` / `Y` / `gy` | Copy name / relative path / absolute path | nvim-tree |
| `[c` / `]c` | Previous / next git change | nvim-tree |
| `[e` / `]e` | Previous / next diagnostic | nvim-tree |
| `H` / `I` | Toggle dotfiles / git-ignored filter | nvim-tree |
| `f` / `F` | Live filter start / clear | nvim-tree |
| `Ctrl+]` | Make folder under cursor the root; `:lcd` into it (tree window only) | nvim-tree |
| `-` / `P` / `Backspace` | Root up / go to parent / close folder | nvim-tree |
| `E` / `W` | Expand all / collapse all | nvim-tree |
| `S` | Search | nvim-tree |
| `R` | Refresh | nvim-tree |
| `q` | Close tree | nvim-tree |
| `g?` | Show all tree keys | nvim-tree |

### Git panel (Neogit default keys)

| Key | Action | Source |
|---|---|---|
| `Tab` | Expand / fold a file's inline diff | neogit |
| `s` / `u` / `x` | Stage / unstage / discard: file, hunk (on `@@`), or Visual lines | neogit |
| `S` / `Ctrl+s` | Stage all modified / stage all incl. untracked | neogit |
| `Enter` | Open file | neogit |
| `c` | Commit menu (`c` commit, `a` amend, `w` reword) | neogit |
| `Ctrl+c Ctrl+c` / `Ctrl+c Ctrl+k` | Commit message buffer: submit / abort | neogit |
| `P` | Push menu (`p` push remote, `u` upstream) | neogit |
| `p` | Pull menu | neogit |
| `b` / `l` / `Z` | Branch / log / stash menu | neogit |
| `d` | Diff menu → codediff | neogit |
| `?` | Show all keys | neogit |
| `q` | Close | neogit |

### Diff view (codediff default keys)

| Key | Action | Source |
|---|---|---|
| `]c` / `[c` | Next / previous hunk | codediff |
| `]f` / `[f` | Next / previous file | codediff |
| `-` | Stage / unstage file | codediff |
| `do` / `dp` | Get / put change from other side | codediff |
| `t` / `gc` | Toggle inline layout / compact (fold unchanged) | codediff |
| `gS` | Swap staged / unstaged view of file | codediff |
| `gf` | Open file in previous tab | codediff |
| `<leader>e` / `<leader>b` | Focus / toggle file list (diff tab only) | codediff |
| `Enter` / `R` | File list: open / refresh | codediff |
| `S` / `U` / `X` | File list: stage all / unstage all / restore file | codediff |
| `i` | File list: toggle list / tree view | codediff |
| `g?` | Show all keys | codediff |
| `q` | Close diff tab | codediff |
| `<leader>gct` / `gco` / `gcb` / `gcx` | Merge view: accept incoming / current / both, or discard (this conflict) | custom `plugins/git.lua` |
| `<leader>gcT` / `gcO` / `gcB` / `gcX` | Merge view: same, whole file | custom `plugins/git.lua` |
| `]x` / `[x` | Merge view: next / previous conflict | codediff |

Hunk staging keys are off in the diff view; stage hunks in the Git panel.

### Picker window (snacks.picker default keys, Insert and Normal)

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
| `Ctrl+x` | Delete buffer (buffers picker, `<leader>pb`) | snacks |

### Quickfix window

| Key | Action | Source |
|---|---|---|
| `Enter` | Open entry; in the peek window for LSP lists (`gd`, `gri`, `grt`, `grr`), default elsewhere | override `after/ftplugin/qf.lua` |
| `Ctrl+w Enter` | Open entry in a new split | nvim |
