# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Key commands

### Bootstrap entrypoint

The main entrypoint is `bootstrap.sh`, which orchestrates both machine setup and dotfiles installation.

General usage (from `bootstrap.sh -h`):

- Command: `bash bootstrap.sh -b <command> [options]`
- Commands:
  - `machine` – bootstrap a macOS/Fedora/ArchLinux machine
  - `dotfiles` – bootstrap dotfiles into `$HOME`
- Common options:
  - `-d` – enable debug output (passes `-x` to underlying shell scripts)
  - `-s <profile>` – profile to install (case sensitive)
    - `perso`, `work` (dotfiles profiles)
    - `normal`, `admin`, `dev_single`, `dev_multi` (machine profiles)
  - `-t <shell>` – default shell (`bash` or `zsh`, default `zsh`)
  - `-p <path>` – absolute path to the companion `dotfiles-private` repository

Run `bash bootstrap.sh -h` for full, up‑to‑date usage.

### Bootstrapping a macOS machine

The README describes a two‑step workflow: bootstrap the machine, then bootstrap configuration files.

**Machine bootstrap (macOS):**

- Standard user:
  - `git clone --recursive https://github.com/davidandreoletti/dotfiles.git`
  - `cd dotfiles`
  - `bash -x bootstrap.sh -b machine -s normal -p "$(pwd)/../dotfiles-private"`
- Administrator account:
  - Same as above, with `-s admin`
- Primary developer account (single dev machine):
  - Same, with `-s dev_single`
- Secondary developer accounts (multi‑dev machine):
  - Same, with `-s dev_multi`

**Dotfiles bootstrap (macOS, first install):**

- Install public + private dotfiles into `$HOME`:
  - `git clone --recursive https://github.com/davidandreoletti/dotfiles.git`
  - `cd dotfiles`
  - `bash bootstrap.sh -b dotfiles -s perso -t bash -p "$(pwd)/../dotfiles-private"`

**Dotfiles update (macOS and Linux):**

- Update this repo and re‑stow configuration files into `$HOME`:
  - `cd dotfiles`
  - `git pull`
  - `git submodule update --recursive --remote`
  - `bash bootstrap.sh -b dotfiles -s perso`

### Bootstrapping Fedora and ArchLinux machines

The workflows for Fedora and ArchLinux mirror the macOS flow, but rely on the native package manager and a slightly different set of OS‑specific scripts.

**Fedora:**

- Standard user: `bash -x bootstrap.sh -b machine -s normal -p "$(pwd)/../dotfiles-private"`
- Administrator: `bash -x bootstrap.sh -b machine -s admin -p "$(pwd)/../dotfiles-private"`
- Primary developer: `bash -x bootstrap.sh -b machine -s dev_single -p "$(pwd)/../dotfiles-private"`
- Secondary developer: `bash -x bootstrap.sh -b machine -s dev_multi -p "$(pwd)/../dotfiles-private"`

**ArchLinux:**

- Standard user: `bash -x bootstrap.sh -b machine -s normal -p "$(pwd)/../dotfiles-private"`
- Administrator: `bash -x bootstrap.sh -b machine -s admin -p "$(pwd)/../dotfiles-private"`
- Primary developer: `bash -x bootstrap.sh -b machine -s dev_single -p "$(pwd)/../dotfiles-private"`
- Secondary developer: `bash -x bootstrap.sh -b machine -s dev_multi -p "$(pwd)/../dotfiles-private"`

### CI / bootstrap tests

There is no standalone unit‑test suite; CI exercises the end‑to‑end bootstrap flows via GitHub Actions in `.github/workflows/test_bootstrap.yml`.

- The matrix jobs call reusable workflows (`bootstrap_on_macos.yaml`, `bootstrap_on_fedora.yaml`, `bootstrap_on_archlinux.yaml`), which in turn:
  - Set `BOOTSTRAP_MODE=noninteractive`.
  - Configure various `BOOTSTRAP_SKIP_*` flags to control optional steps.
  - Run `bash bootstrap.sh -d -b machine -s <profile>` and, when requested, `bash bootstrap.sh -d -b dotfiles -s <profile>`.

To approximate a single CI scenario locally (for example, macOS `dev_single`):

- `export BOOTSTRAP_MODE=noninteractive`
- Optionally export the same `BOOTSTRAP_SKIP_*` variables as in `bootstrap_on_macos.yaml` to skip interactive steps.
- Run:
  - `bash bootstrap.sh -d -b machine -s dev_single`
  - `bash bootstrap.sh -d -b dotfiles -s dev_single`

This is effectively the closest thing to a “single test case” in this repository.

## Architecture overview

### Top‑level responsibilities

At a high level, this repository provides:

- **Machine bootstrapping** for macOS, Fedora, and ArchLinux (system packages, user accounts, services, backups, GUI apps, etc.).
- **Dotfiles management** using GNU Stow, including integration with a separate `dotfiles-private` repository for secrets.
- **Shell environment management** via a custom multi‑shell framework (`.oh-my-shell`).
- **Application‑specific configuration and utilities** (e.g., Vim/Neovim upgrade scripts, browser extension installers, cron jobs, small helper binaries).

These concerns are wired together by `bootstrap.sh` and a set of supporting scripts under `install/` and `.oh-my-shell/`.

### `bootstrap.sh`: orchestration layer

`bootstrap.sh` is the main orchestrator and is responsible for:

- Parsing CLI arguments (`-b`, `-s`, `-t`, `-p`, `-d`).
- Canonicalizing the `dotfiles-private` path when possible and warning when `greadlink` is missing.
- Loading reusable helpers from `install/common/shell/os.sh` and `install/common/shell/stow.sh`.
- Dispatching based on the `-b` command:
  - `machine` – detects the OS (`is_macos`, `is_fedora`, `is_archl`) and calls `install/bootstrap_macos.sh`, `install/bootstrap_fedora.sh`, or `install/bootstrap_archlinux.sh`.
  - `dotfiles` – performs user‑level setup (shell, PATH, symlinks, Vim/Neovim plugins).

Within the `dotfiles` branch it:

- Optionally changes the default shell (guarded by `BOOTSTRAP_SKIP_SHELL_CHANGE`).
- Calls `bootstrap_homebrew_path`, which sources `.oh-my-shell/shellrc/bootstrap/helper*.sh` to locate Homebrew and export its environment.
- Calls `bootstrap_dotfiles`, which stows dotfiles into `$HOME` using `stow_files`.
- Ensures the repository itself is symlinked to `~/.dotfiles` for cron‑based maintenance.
- Integrates the `dotfiles-private` repository via `bootstrap_dotfiles_private`, using its own helper binaries to check lock status and instruct the user to decrypt when necessary.
- Marks `~/.bin/*` as executable so custom scripts are directly invocable from `$PATH`.
- Triggers Vim/Neovim plugin installation via `install/bootstrap_vim_plugins.sh`.
- Finishes by ensuring `.oh-my-shell` is wired into the user’s login shell RC and prints a ready message.

### `install/`: OS‑level bootstrap modules

The `install/` directory contains the bulk of the machine bootstrap logic, factored into reusable, OS‑agnostic modules and OS‑specific layers.

Key pieces:

- **OS dispatch and shared helpers:**
  - `install/common/shell/os.sh` – low‑level OS detection for macOS, generic Linux, Fedora, ArchLinux; must stay in sync with `.oh-my-shell/shellrc/bootstrap/helper2.sh`.
  - `install/common/shell/stow.sh` – wraps GNU Stow via `stow_files(user, sourceDir, destDir)` and enforces that `stow` is installed.
  - `install/common/shell/*.sh` – shared building blocks for package managers (Homebrew, DNF, pacman), language runtimes (Python, Rust, etc.), containers, systemd, tmux, VS Code integration, sudo helpers, and more.
- **Per‑OS bootstrap scripts:**
  - `install/bootstrap_macos.sh` – orchestrates macOS setup: reads a profile from `config/config.sh`, manages sudo via an ephemeral RAM disk, ensures Xcode + CLI tools, installs Homebrew, applies system defaults (including Time Machine and SSD tuning), installs GUI and CLI apps (via `bootstrap_apps.sh`), and manages accounts (guest, dedicated admin account, demotion of the primary user when `dev_single`).
  - `install/bootstrap_fedora.sh` – similar orchestration for Fedora: seeds DNF, installs Homebrew, enables Flatpak and Snap, applies Fedora defaults, and wires up user/admin accounts.
  - `install/bootstrap_archlinux.sh` – equivalent bootstrap for ArchLinux: seeds pacman, installs Homebrew and related tools, configures defaults and backup tooling.
  - `install/bootstrap_os.sh` – additional OS‑environment conveniences (e.g., `zram` and `dnf-plugins-core` on Fedora) for admin‑type profiles.
- **Applications / tools:**
  - `install/app/{vim,neovim}/upgrade.sh` – upgrade scripts for editor plugins/configuration.
  - `install/browsers/{chrome,firefox}/extensions/install.sh` – configure browser extensions; referenced from the macOS bootstrap script via `BOOTSTRAP_SKIP_BROWSER_EXTENSION_SETUP`.
- **Configuration and utilities:**
  - `install/config/config.sh` – central configuration file for bootstrap (usernames, passwords, backup destinations, etc.); bootstrap scripts source this and then use helpers from `utils/` and `common/shell/`.
  - `install/utils/{debug.sh,message.sh,profile.sh,todolist.sh}` – logging, profiling, and “todolist” helpers used across bootstrap flows.

When extending machine bootstrap logic, new functionality should typically be implemented as a small helper in `install/common/shell/` or the relevant OS subdirectory, then invoked from the appropriate `install/bootstrap_*.sh` script.

### `.oh-my-shell/`: shell environment framework

`.oh-my-shell` is a custom, multi‑shell (bash/zsh) initialization framework that wires in Homebrew, the dotfiles layout, and a large set of pluggable tools.

Core flow:

- `~/.oh-my-shell/oh-my-shellrc` is sourced from the user’s default shell RC (e.g., `~/.bash_profile` or `~/.zshrc`) by `bootstrap_oh_my_shell()` in `bootstrap.sh`.
- `oh-my-shellrc`:
  - Short‑circuits when the shell is non‑interactive.
  - Defines key paths (`SHELLRC_ROOT_DIR`, `SHELLRC_SHELLRC_DIR`, `SHELLRC_BOOTSTRAP_DIR`, `SHELLRC_PLUGINS_DIR`).
  - Resolves the dotfiles repo (`DOTFILES_HOME_LOCAL`) via `realpath`/`readlink`, and a private config root (`DOTFILES_PRIVATE_HOME_LOCAL`).
  - Loads the bootstrap helpers `helper.sh`, `helper2.sh`, `helper3.sh`, `helper4.sh`, and `init.sh`.
  - Calls `homebrew_init` to export the Homebrew environment, then caches `HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX`.
  - Loads shell‑specific plugins (`environment`, `history`, completions, corrections, custom) in phases.
  - Iterates over each plugin under `shellrc/plugins/<name>` via `dot_plugin_if_exists`:
    - Prepends `bin/` to `PATH` when present.
    - Sources `environment.sh`, `functions.sh`, and `aliases.sh` (plus optional `private/*` variants).
    - Defers `completions.sh` and `post.sh` to asynchronous/background phases via per‑shell‑session marker files.
  - Optionally profiles load times when `SHELLRC_PROFILE_SPEED` is set, using `_timeNow`, `_timeInterval`, and `_reportIfSlowerThan` from `helper.sh`.

The bootstrap helpers in `.oh-my-shell/shellrc/bootstrap/` mirror some of the OS‑detection logic from `install/common/shell/os.sh` and add utilities for:

- Determining OS, shell, and terminal type (`get_os_type`, `get_shell_type`, `get_terminal_app_type`).
- Managing PATH, MANPATH, and Info paths.
- Creating, tearing down, and locking tasks via RAM disks and `flock` (used for more advanced workflows and background jobs).

When adding new environment features or tool integrations, the typical pattern is to create a new plugin directory under `.oh-my-shell/shellrc/plugins/<name>/` with `environment.sh`, `functions.sh`, `aliases.sh`, and optionally `completions.sh` and `post.sh`.

### Other notable directories

- `~/.bin/` (in this repo as `.bin/`) – user‑level CLI utilities made executable by `bootstrap_dotfiles_binaries()`. After dotfiles bootstrap, these are expected to be on `PATH` and used throughout the environment.
- `.cron/` – cron job scaffolding grouped by schedule (e.g., `5min-any`, `daily-morning`, `weekday-any`), containing example scripts and maintenance tasks (such as Vim plugin upgrades). The bootstrap flow symlinks the repository into `~/.dotfiles` so cron jobs can reference a stable path.
- `.config/` – application‑specific configuration, including Git hooks (`.config/git/hooks/`) and mail client helpers (`.config/mutt/`). These are managed via GNU Stow during dotfiles bootstrap.
- `.studio/` – helper wrapper for the external “Studio” binary (download instructions in `.studio/README`).

### Upstream policy

The README notes that the main source of truth is `https://github.com/davidandreoletti/dotfiles` and that "No code contribution [is] accepted." When working locally in this clone, treat upstream as authoritative and keep changes compatible with the documented bootstrap flows and profiles.