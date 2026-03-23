#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# build.sh — Install all dependencies for this Neovim config
# Supports: macOS (brew) and Linux (apt)
# Usage:    chmod +x build.sh && ./build.sh
# ============================================================

echo "==> Detecting OS..."
OS="$(uname -s)"

# ---------- Package manager helpers ----------
install_brew() {
  if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_apt() {
  sudo apt-get update -y
  sudo apt-get install -y "$@"
}

# ---------- Neovim ----------
install_neovim() {
  if command -v nvim &>/dev/null; then
    echo "==> Neovim already installed: $(nvim --version | head -1)"
  else
    echo "==> Installing Neovim..."
    if [[ "$OS" == "Darwin" ]]; then
      brew install neovim
    else
      curl -fsSL -o /tmp/nvim-linux-x86_64.tar.gz \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
      sudo rm -rf /opt/nvim
      sudo tar xzf /tmp/nvim-linux-x86_64.tar.gz -C /opt/
      sudo mv /opt/nvim-linux-x86_64 /opt/nvim
      sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
      rm -f /tmp/nvim-linux-x86_64.tar.gz
    fi
  fi
}

# ---------- Core tools (git, curl, gcc for treesitter) ----------
install_core() {
  echo "==> Installing core tools (git, curl, gcc, make)..."
  if [[ "$OS" == "Darwin" ]]; then
    # Xcode CLT provides git, gcc, make
    xcode-select --install 2>/dev/null || true
  else
    install_apt git curl build-essential unzip
  fi
}

# ---------- Node.js (for prettier, LSPs) ----------
install_node() {
  if command -v node &>/dev/null; then
    echo "==> Node.js already installed: $(node --version)"
  else
    echo "==> Installing Node.js..."
    if [[ "$OS" == "Darwin" ]]; then
      brew install node
    else
      curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
      install_apt nodejs
    fi
  fi
}

# ---------- Go ----------
install_go() {
  if command -v go &>/dev/null; then
    echo "==> Go already installed: $(go version)"
  else
    echo "==> Installing Go..."
    if [[ "$OS" == "Darwin" ]]; then
      brew install go
    else
      local GO_VERSION
      GO_VERSION="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1)"
      curl -fsSL -o /tmp/go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
      sudo rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf /tmp/go.tar.gz
      rm -f /tmp/go.tar.gz
      # Add to PATH for this session
      export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
      # Persist in shell rc
      for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [[ -f "$rc" ]] && ! grep -q '/usr/local/go/bin' "$rc"; then
          echo 'export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"' >> "$rc"
        fi
      done
    fi
  fi
}

# ---------- npm global tools ----------
install_npm_tools() {
  echo "==> Installing npm tools (prettier)..."
  npm list -g prettier &>/dev/null || npm install -g prettier
}

# ---------- ripgrep (for Snacks grep picker) ----------
install_ripgrep() {
  if command -v rg &>/dev/null; then
    echo "==> ripgrep already installed"
  else
    echo "==> Installing ripgrep..."
    if [[ "$OS" == "Darwin" ]]; then
      brew install ripgrep
    else
      install_apt ripgrep
    fi
  fi
}

# ---------- fd (for Snacks file picker) ----------
install_fd() {
  if command -v fd &>/dev/null || command -v fdfind &>/dev/null; then
    echo "==> fd already installed"
  else
    echo "==> Installing fd..."
    if [[ "$OS" == "Darwin" ]]; then
      brew install fd
    else
      install_apt fd-find
      # Debian/Ubuntu installs as fdfind; alias it
      sudo ln -sf "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
    fi
  fi
}

# ---------- Symlink config ----------
setup_config() {
  local NVIM_DIR="$HOME/.config/nvim"
  local SCRIPT_DIR
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ "$SCRIPT_DIR" != "$NVIM_DIR" ]]; then
    echo "==> Linking config to ~/.config/nvim..."
    mkdir -p "$HOME/.config"
    if [[ -e "$NVIM_DIR" && ! -L "$NVIM_DIR" ]]; then
      mv "$NVIM_DIR" "${NVIM_DIR}.bak.$(date +%s)"
      echo "    (existing config backed up)"
    fi
    ln -sfn "$SCRIPT_DIR" "$NVIM_DIR"
  fi
}

# ---------- First launch (installs plugins + treesitter parsers + mason tools) ----------
bootstrap_nvim() {
  echo "==> Bootstrapping Neovim (installing plugins, parsers, LSPs)..."
  echo "    This will take a minute on first run..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
  echo "==> Done! Run 'nvim' to start editing."
}

# ============================================================
main() {
  echo ""
  echo "  Neovim Config Installer"
  echo "  OS: $OS"
  echo ""

  [[ "$OS" == "Darwin" ]] && install_brew
  install_core
  install_neovim
  install_node
  install_go
  install_ripgrep
  install_fd
  install_npm_tools
  setup_config
  bootstrap_nvim

  echo ""
  echo "==> All done! Start with: nvim"
}

main "$@"
