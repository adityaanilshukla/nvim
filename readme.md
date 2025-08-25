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
  Utility functions. Currently houses:
  - `lazygit_toggle()` → floating LazyGit terminal  
  - `toggle_neotree_focus()` → jump between Neo-tree and last buffer

- **`user/autocmds.lua`**  
  Optional. For custom autocommands.

---

## Plugin Configs

Each plugin gets its own file under `user/plugin_config/`.  
They all follow the pattern:

```lua
local ok, plugin = pcall(require, "plugin-name")
if not ok then return end

plugin.setup({...})
````

So if a plugin is missing, Neovim won’t crash.

Notable configs:

* **theme.lua** → colorscheme (default: `carbonfox`, fallback: `kanagawa`)
* **neo-tree.lua** → includes my custom `Y` keybinding to copy paths
* **toggleterm.lua** → float terminal with `<F7>`
* **auto-session.lua** → auto session save/restore
* **render-markdown.lua** → renders Markdown previews inline

---

## LSP

All language server config is modular under `user/lsp/`:

* **`capabilities.lua`**
  Gets LSP client capabilities from Blink.cmp (completion).
* **`servers.lua`**
  Table of all servers I use + any server-specific settings.
  Example: `lua_ls` ignores `vim` as an undefined global.
* **`init.lua`**
  Iterates over servers and sets them up with `lspconfig`.

To add a new language server, just edit `servers.lua`.

---

## DAP (Debugging)

All debugging lives in `user/dap/`:

* **`init.lua`**
  Sets up `nvim-dap` + `dap-ui`, attaches listeners, and defines debug keymaps (`<F5>` etc.).
* **`python.lua`**
  Configures `dap-python`. Automatically detects `venv`/`.venv` or falls back to `python3`.

---

## Language Specific Settings

Under `after/ftplugin/` for per-language tweaks:

* `lua.lua` → Lua specific options
* `python.lua` → Python specific options
* `javascript.lua` → JavaScript specific options

Neovim automatically loads these when editing that filetype.

---

## Adding Something New

* **New plugin?** Add it to `plugins.lua`, then create a config file under `plugin_config/` (optional if it needs no config).
* **New language server?** Add to `servers.lua`.
* **New keymap?** Put it in `keymaps.lua` unless it’s plugin-specific.
* **New language tweak?** Add an `after/ftplugin/{lang}.lua` file.

---
## Notes for Future Me

* Statusline is transparent (I patched it in `theme.lua`).
* Default colorscheme is `carbonfox`. If it’s missing, falls back to `kanagawa`.
* Sessions auto-save except in `$HOME`.
* Spelling check is enabled (`en_us`), with `sc` or `gs` mapped to suggestions.
* All plugin configs are safe-loaded with `pcall` to avoid startup crashes.
---
