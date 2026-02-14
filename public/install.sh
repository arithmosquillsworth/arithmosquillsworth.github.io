#!/bin/bash

# Agent Security Stack Installer
# One-line install: curl -fsSL https://arithmos.dev/install.sh | bash

set -e

REPO="arithmosquillsworth"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/agent"
TOOLS=(
    "agent-cli"
    "prompt-guard"
    "tx-simulator"
    "agent-tx-firewall"
    "agent-honeypot"
    "agent-security-dashboard"
    "agent-wallet-monitor"
    "agent-reputation-scanner"
    "agent-config-manager"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          Agent Security Stack Installer                    ║"
    echo "║     9 open-source security tools for AI agents            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

detect_os() {
    case "$(uname -s)" in
        Linux*)     OS=linux;;
        Darwin*)    OS=darwin;;
        CYGWIN*|MINGW*|MSYS*) OS=windows;;
        *)          OS=unknown;;
    esac
    
    case "$(uname -m)" in
        x86_64)     ARCH=amd64;;
        arm64|aarch64) ARCH=arm64;;
        *)          ARCH=unknown;;
    esac
    
    echo -e "${YELLOW}Detected: $OS/$ARCH${NC}"
}

check_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${NC}"
    
    # Check for curl or wget
    if command -v curl &> /dev/null; then
        DOWNLOADER="curl -fsSL"
    elif command -v wget &> /dev/null; then
        DOWNLOADER="wget -qO-"
    else
        echo -e "${RED}Error: curl or wget required${NC}"
        exit 1
    fi
    
    # Create directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CONFIG_DIR"
    
    echo -e "${GREEN}✓ Dependencies OK${NC}"
}

download_tool() {
    local tool=$1
    local version=${2:-latest}
    
    echo -e "${YELLOW}Installing $tool...${NC}"
    
    # For now, clone and build from source
    # In production, this would download pre-built binaries
    
    if [ "$version" = "latest" ]; then
        version=$(curl -s "https://api.github.com/repos/${REPO}/${tool}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [ -z "$version" ]; then
            version="v0.1.0"
        fi
    fi
    
    local binary_name="${tool}"
    if [ "$OS" = "windows" ]; then
        binary_name="${tool}.exe"
    fi
    
    local download_url="https://github.com/${REPO}/${tool}/releases/download/${version}/${tool}-${OS}-${ARCH}"
    
    # Try to download pre-built binary
    if curl -fsSL "$download_url" -o "${INSTALL_DIR}/${binary_name}" 2>/dev/null; then
        chmod +x "${INSTALL_DIR}/${binary_name}"
        echo -e "${GREEN}✓ $tool installed${NC}"
    else
        echo -e "${YELLOW}⚠ Pre-built binary not available for $tool${NC}"
        echo -e "${YELLOW}  Build from source: git clone https://github.com/${REPO}/${tool}${NC}"
    fi
}

setup_config() {
    echo -e "${YELLOW}Setting up configuration...${NC}"
    
    # Create default config
    cat > "${CONFIG_DIR}/config.json" << 'EOF'
{
  "version": "0.1.0",
  "agent": {
    "name": "your-agent-name",
    "erc8004_id": null
  },
  "security": {
    "prompt_guard": {
      "enabled": true,
      "confidence_threshold": 90,
      "blocklist": ["ignore previous", "disregard", "forget instructions"]
    },
    "firewall": {
      "enabled": true,
      "mode": "enforce",
      "daily_limit_eth": 0.1
    },
    "honeypot": {
      "enabled": true,
      "auto_block": true
    }
  },
  "monitoring": {
    "dashboard": {
      "enabled": true,
      "port": 8080
    },
    "wallet_monitor": {
      "enabled": true,
      "alert_threshold_eth": 0.01
    }
  }
}
EOF
    
    echo -e "${GREEN}✓ Configuration created at ${CONFIG_DIR}/config.json${NC}"
}

add_to_path() {
    local shell_rc
    case "$SHELL" in
        */bash) shell_rc="${HOME}/.bashrc" ;;
        */zsh)  shell_rc="${HOME}/.zshrc" ;;
        */fish) shell_rc="${HOME}/.config/fish/config.fish" ;;
        *)      shell_rc="${HOME}/.profile" ;;
    esac
    
    if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
        echo -e "${YELLOW}Adding ${INSTALL_DIR} to PATH in ${shell_rc}${NC}"
        echo "export PATH=\"${INSTALL_DIR}:\$PATH\"" >> "$shell_rc"
        echo -e "${GREEN}✓ Added to PATH${NC}"
        echo -e "${YELLOW}Run 'source ${shell_rc}' or restart your shell${NC}"
    fi
}

print_summary() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              Installation Complete!                        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Installed tools:"
    for tool in "${TOOLS[@]}"; do
        if [ -f "${INSTALL_DIR}/${tool}" ]; then
            echo -e "  ${GREEN}✓${NC} $tool"
        else
            echo -e "  ${YELLOW}○${NC} $tool (source build required)"
        fi
    done
    echo ""
    echo "Next steps:"
    echo "  1. Run 'source ~/.bashrc' (or restart your shell)"
    echo "  2. Edit ${CONFIG_DIR}/config.json with your agent details"
    echo "  3. Run 'agent-cli security audit' to check your setup"
    echo ""
    echo "Documentation: https://github.com/arithmosquillsworth/agent-security-stack"
    echo "Support: https://discord.gg/arithmos"
}

main() {
    print_banner
    detect_os
    check_dependencies
    
    # Download tools
    for tool in "${TOOLS[@]}"; do
        download_tool "$tool"
    done
    
    setup_config
    add_to_path
    print_summary
}

# Handle command line args
if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "Agent Security Stack Installer v0.1.0"
    exit 0
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Agent Security Stack Installer"
    echo ""
    echo "Usage:"
    echo "  curl -fsSL https://arithmos.dev/install.sh | bash"
    echo "  wget -qO- https://arithmos.dev/install.sh | bash"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show version"
    echo ""
    echo "Environment:"
    echo "  INSTALL_DIR    Installation directory (default: ~/.local/bin)"
    exit 0
fi

main
