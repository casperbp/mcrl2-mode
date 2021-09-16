Emacs Mode for mCRL2
====================

This repository contains a rudimentary Emacs mode for [mCRL2](https://www.mcrl2.org/).

Features
--------

- Syntax highlighting
- Keybindings for `mcrl22lps`, `lps2lts`, `ltsgraph`, `ltssim`, `lps2pbes`, and `pbes2bool` (see documentation of keybindings below)


Installation
------------

To install the mode, clone this repository into your `~/.emacs.d` folder, and add these lines to your Emacs configuration (e.g., `~/.emacs.d/init.el`):

```
(load-file "~/.emacs.d/mcrl2-mode/mcrl2-mode.el")
(add-to-list 'auto-mode-alist '("\\.mcrl2\\'" . mcrl2-mode))
(add-to-list 'auto-mode-alist '("\\.mcf\\'" . mcf-mode))
```


Key Bindings
------------

The mCRL2-mode contains key bindings for compiling and visualizing mCRL2 files:

| Key binding | Description |
|-------------|-------------|
| `C-c C-l`   | Calls `mcrl22lps`. If the current file is `foo.mcrl2`, this keybinding compiles `foo.mcrl2` to `foo.mcrl2.lps`.
| `C-c C-t`   | Calls `lps2lts`. If the current file is `foo.mcrl2`, this keybinding compiles `foo.mcrl2.lps` to `foo.mcrl2.lts`. |
| `C-c C-g`   | Calls `ltsgraph`. If the current file is `foo.mcrl2`, this keybinding displays the transition system graph for `foo.mcrl2.lts`. |
| `C-c C-s`   | Calls `lpssim`. If the current file is `foo.mcrl2`, this keybinding simulates `foo.mcrl2.lps`. |

The mCF-mode contains key bindings for compiling and verifying mCF files.

| Key binding | Description |
|-------------|-------------|
| `C-c C-p`   | Calls `lps2pbes` and queries the user for a `.lps` file name. If the current file is `bar.mcf`, this keybinding compiles `bar.mcf.pbes`. |
| `C-c C-s`   | Calls `pbessolve`. If the current file is `bar.mcf`, this keybinding verifies the equations in `bar.mcf.pbes`. |
