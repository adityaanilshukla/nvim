# macOS Setup

Companion to `readme.md`, which is Arch-flavored. Everything below uses [Homebrew](https://brew.sh/).

---

## TL;DR — Fresh Mac

```bash
# Core runtimes
brew install git node python jdk

# Treesitter: library AND CLI are separate formulas
brew install tree-sitter tree-sitter-cli

# LSPs
brew install lua-language-server typescript-language-server pyright \
  llvm bash-language-server marksman jdtls

# Formatters
brew install stylua black isort shfmt taplo clang-format
npm i -g prettier

# Linters
brew install luacheck ruff shellcheck yamllint checkstyle
npm i -g eslint eslint_d

# DAP
brew install python-debugpy llvm
```

Restart Neovim after installing `tree-sitter-cli`. The first launch compiles parsers and blocks once with a notification; subsequent launches are no-ops.

---

## Treesitter — the gotcha

`nvim-treesitter` runs on the `main` branch (the legacy `master` was archived May 2025). On `main`, parsers are built by invoking the **`tree-sitter` CLI** — a C compiler alone is not enough.

Homebrew splits this into two formulas:

| Formula            | What it gives you                      |
| ------------------ | -------------------------------------- |
| `tree-sitter`      | Just the runtime library (`libtree-sitter.dylib`) — **no CLI binary** |
| `tree-sitter-cli`  | The `tree-sitter` command-line tool nvim-treesitter shells out to |

Symptoms of installing only `tree-sitter`:

```
[nvim-treesitter/install/*] error: Error during "tree-sitter build":
  vim/_core/system.lua:0: ENOENT: no such file or directory (cmd): 'tree-sitter'
```

Fix:

```bash
brew install tree-sitter-cli
which tree-sitter   # should print /opt/homebrew/bin/tree-sitter
```

Then **fully quit and relaunch Neovim** — an already-running nvim inherits the old `PATH` and won't see the new binary.

Edit the `parsers` list in `user/plugin_config/treesitter.lua` to add or remove languages, then restart or run `:TSUpdate`.

---

## Python provider

Some plugins (e.g. UltiSnips) need Neovim's Python 3 provider:

```bash
brew install python pipx
pipx install pynvim
pipx install neovim-remote   # nvr, for inverse search
```

`pip install --user pynvim` also works if you prefer not to use pipx.

---

## LaTeX

Easiest path: full MacTeX (~4 GB).

```bash
brew install --cask mactex-no-gui
```

Minimal alt (similar to `tectonic` on Arch):

```bash
brew install tectonic
```

Plus tools the readme references:

```bash
brew install pandoc weasyprint biber
```

---

## DAP notes

- `lldb` ships with Xcode Command Line Tools (`xcode-select --install`); if you also install `brew install llvm`, the brewed lldb has more features but isn't on PATH by default — see `brew info llvm` for the symlink command.
- `gdb` on Apple Silicon is painful (codesigning, no native arm64 support for some targets). Stick with `lldb` unless you really need `gdb`.

---

## Quick Sanity Checks

```bash
# LSP
which lua-language-server clangd pyright typescript-language-server \
  bash-language-server jdtls marksman

# Formatters
stylua --version && black --version && isort --version
shfmt -version && shellcheck --version
prettier -v && eslint_d -v
taplo --version && clang-format --version

# Linters
ruff --version && yamllint --version && luacheck --version

# Treesitter CLI
tree-sitter --version

# DAP
python3 -c "import debugpy,sys;print('debugpy ok',sys.version)"
lldb --version
```

---

## PATH gotchas

- Homebrew on Apple Silicon installs to `/opt/homebrew`; on Intel Macs it's `/usr/local`. Make sure your shell rc sources `brew shellenv` so `/opt/homebrew/bin` is on `PATH`.
- GUI-launched Neovim (e.g. via Spotlight or a `.app` wrapper) may not inherit your shell `PATH`. If LSPs/formatters/treesitter can't be found from a GUI launch but work from the terminal, that's why — launch nvim from a terminal, or set `vim.env.PATH` in `init.lua`.
