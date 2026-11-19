# My Neovim Config

This is my personal Neovim setup.

---

## Core Files

- **`init.lua`**  
  Entry point. Loads plugins first, then core settings, keymaps, plugin configs, LSP, DAP, and finally autocmds.

- **`user/plugins.lua`**  
  Declares all plugins using `vim.pack.add`.

- **`user/options.lua`**  
  All my Vim options. Stuff like line numbers, clipboard, tabstop, spellcheck, transparency, etc.

- **`user/keymaps.lua`**  
  Central place for keybindings (except plugin-specific ones that need to live inside plugin configs).

- **`user/utils.lua`**  
  Utility functions:
  - `lazygit_toggle()` → floating LazyGit terminal
  - `toggle_neotree_focus()` → jump between Neo-tree and last buffer

- **`user/autocmds.lua`**  
  Currently an empty placeholder -- it holds a commented-out example and
  nothing else. `init.lua` loads it through `pcall`, so it is safe to leave
  empty or delete outright.

---

## Plugin Configs

Each plugin gets its own file under `user/plugin_config/`. Most follow the
pattern:

```lua
local ok, plugin = pcall(require, "plugin-name")
if not ok then return end

plugin.setup({...})
```

The one-liners (`devicons`, `comment`, `render-markdown`) wrap the whole call
in `pcall(function() ... end)` instead, and `utilsnips` only sets `vim.g`
variables, which cannot fail. Either way a missing plugin does not crash
startup.

Notable configs:

- **theme.lua** → colorscheme (default: `carbonfox`, fallback: `kanagawa`)
- **neo-tree.lua** → includes my custom `Y` keybinding to copy paths
- **toggleterm.lua** → full-screen terminal in a new tab, toggled with `<F7>`
- **auto-session.lua** → auto session save/restore
- **render-markdown.lua** → renders Markdown previews inline

### Python support for Neovim

Some plugins (e.g. UltiSnips) depend on Neovim’s Python 3 provider. Without it, you’ll see errors like `E319: No "python3" provider found`.

```sh
sudo pacman -S python-pynvim
paru -S neovim-remote # needed for inverse search (nvr)

```

---

### LaTeX support

```sh
sudo pacman -S --needed texlive-bin texlive-basic texlive-latex texlive-latexrecommended \
  texlive-latexextra texlive-fontsextra texlive-bibtexextra texlive-pictures biber

sudo pacman -S --needed texlive-binextra python-weasyprint

sudo pacman -S --needed tectonic # minimal alt

paru -S --needed pandoc-bin
```

### Treesitter

`nvim-treesitter` runs on the `main` branch; the legacy `master` was archived
in May 2025 and breaks on recent Neovim.

On `main`, parsers are built by shelling out to the **`tree-sitter` CLI** — a
C compiler alone is not enough, so `base-devel` does not cover this:

```bash
sudo pacman -S --needed tree-sitter-cli
which tree-sitter   # should print /usr/bin/tree-sitter
```

On a fresh machine the first launch then downloads and compiles parsers from
source, which also needs network access. Startup blocks once with a
notification while they install; subsequent launches are no-ops. See
`readme.macos.md` for the same trap on Homebrew, where the library and the CLI
are two separate formulas.

Edit the `parsers` list in `user/plugin_config/treesitter.lua` to add or remove languages, then restart or run `:TSUpdate`.

## LSP

All language server config is modular under `user/lsp/`:

- **`capabilities.lua`**  
  Gets LSP client capabilities from Blink.cmp (completion).

- **`servers.lua`**  
  Table of all servers I use + any server-specific settings.  
  Example: `lua_ls` ignores `vim` as an undefined global.

- **`init.lua`**  
  Applies the shared capabilities with `vim.lsp.config("*", ...)`, merges each
  per-server table from `servers.lua` over its upstream defaults, then enables
  them with `vim.lsp.enable`.

  `nvim-lspconfig` is only a data package here: it ships one `lsp/<name>.lua`
  per server on the runtimepath and Neovim reads those directly. The older
  `lspconfig[name].setup()` framework path is deprecated upstream and is no
  longer used.

To add a new language server, just edit `servers.lua`.

---

## DAP (Debugging)

All debugging lives in `user/dap/`:

- **`init.lua`**  
  Sets up `nvim-dap` + `dap-ui`, attaches listeners, and defines debug keymaps (`<F5>` etc.).

- **`python.lua`**  
  Configures `dap-python`. Automatically detects `venv`/`.venv` or falls back to `python3`.

---

## Language Specific Settings

Per-language tweaks go in `after/ftplugin/{lang}.lua`, which Neovim loads
automatically when editing that filetype. None exist at the moment -- add one
when a language actually needs its own options.

---

## System Setup (LSP + Linters + Formatters + DAP)

Everything installed via **pacman** (official repos) + **paru** (AUR).  
This is the minimal checklist to make everything fully work.

### Core Runtimes

```bash
sudo pacman -S --needed git base-devel nodejs npm python jre-openjdk
```

### LSPs

```bash
sudo pacman -S --needed lua-language-server typescript-language-server pyright clang bash-language-server marksman
paru -S jdtls
paru -S ltex-ls-plus-bin   #grammar checker for Markdown/LaTeX
```

### Formatters

```bash
sudo pacman -S --needed stylua python-black python-isort shfmt taplo clang
sudo npm i -g prettier
```

### Linters

```bash
sudo pacman -S --needed luacheck ruff shellcheck yamllint
sudo npm i -g eslint eslint_d
sudo pacman -S checkstyle
```

### DAP

```bash
sudo pacman -S --needed python-debugpy lldb gdb
```

---

## Quick Sanity Checks

### LSP

```bash
which lua-language-server clangd pyright typescript-language-server bash-language-server jdtls marksman ltex-ls-plus-bin
```

### Formatters

```bash
stylua --version && black --version && isort --version
shfmt -version && shellcheck --version
prettier -v && eslint_d -v
taplo --version && clang-format --version
```

### Linters

```bash
ruff --version && yamllint --version && luacheck --version
```

### DAP

```bash
python -c "import debugpy,sys;print('debugpy ok',sys.version)"
lldb --version && gdb --version
```

---

## Adding Something New

- **New plugin?** Add it to `plugins.lua`, then create a config file under `plugin_config/` (optional if it needs no config).
- **New language server?** Add to `servers.lua`.
- **New keymap?** Put it in `keymaps.lua` unless it’s plugin-specific.
- **New language tweak?** Add an `after/ftplugin/{lang}.lua` file.

---

## Notes for Future Me

- Statusline is transparent. Note it is currently patched in BOTH `theme.lua`
  and `options.lua`, with identical lines; `theme.lua` wins by load order.
- Default colorscheme is `carbonfox`. If it’s missing, falls back to `kanagawa`.
- Sessions auto-save except in `$HOME`.
- Spell checking is enabled (`en_us`), with `sc` or `gs` mapped to suggestions.
- Plugin configs are `pcall`-guarded so a missing plugin cannot crash startup
  (see the note under Plugin Configs for the two shapes this takes).
