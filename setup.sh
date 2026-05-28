#!/bin/bash

# ==========================================================
# Polyglot Local Vibe Coding Environment Installer/Setup
# ==========================================================

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================================${NC}"
echo -e "${BLUE}  Starting Local Vibe Coding Environment Installer...     ${NC}"
echo -e "${BLUE}==========================================================${NC}"

# 1. Check if Ollama is running
echo -e "\n${BLUE}[1/5] Checking Ollama Service...${NC}"
if ! ollama list &>/dev/null; then
    echo -e "${RED}Error: Ollama service is not running or not in PATH! Please start Ollama and try again.${NC}"
    exit 1
fi
echo -e "${GREEN}✔ Ollama is active and running.${NC}"

# 2. Build/tweaked Ollama models
echo -e "\n${BLUE}[2/5] Building Customized Tweaked Models in Ollama...${NC}"

if [ ! -f "Modelfile-architect" ] || [ ! -f "Modelfile-agent" ]; then
    echo -e "${RED}Error: Modelfile-architect or Modelfile-agent not found in current folder!${NC}"
    exit 1
fi

echo -e "${YELLOW}Building qwen3-coder:30b-tweaked (Architect)...${NC}"
if ollama create qwen3-coder:30b-tweaked -f Modelfile-architect; then
    echo -e "${GREEN}✔ qwen3-coder:30b-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build qwen3-coder:30b-tweaked. Make sure you pulled 'qwen3-coder:30b' first.${NC}"
fi

echo -e "\n${YELLOW}Building qwen3-coder-next-tweaked (Agent)...${NC}"
if ollama create qwen3-coder-next-tweaked -f Modelfile-agent; then
    echo -e "${GREEN}✔ qwen3-coder-next-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build qwen3-coder-next-tweaked. Make sure you pulled 'qwen3-coder-next' first.${NC}"
fi

# 3. Install vibe-check script
echo -e "\n${BLUE}[3/5] Installing Universal 'vibe-check' Test Runner...${NC}"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

if [ -f "vibe-check" ]; then
    cp vibe-check "$BIN_DIR/vibe-check"
    chmod +x "$BIN_DIR/vibe-check"
    echo -e "${GREEN}✔ Installed 'vibe-check' to $BIN_DIR/vibe-check.${NC}"
else
    echo -e "${RED}Error: vibe-check script not found in current folder!${NC}"
    exit 1
fi

# 4. Copy Aider configuration files
echo -e "\n${BLUE}[4/5] Copying Global Aider Configuration Files...${NC}"

if [ -f ".aider.conf.yml" ]; then
    cp .aider.conf.yml "$HOME/.aider.conf.yml"
    echo -e "${GREEN}✔ Copied Aider config to ~/.aider.conf.yml.${NC}"
else
    echo -e "${YELLOW}Warning: .aider.conf.yml not found. Skipping.${NC}"
fi

if [ -f ".aider.model.settings.yml" ]; then
    cp .aider.model.settings.yml "$HOME/.aider.model.settings.yml"
    echo -e "${GREEN}✔ Copied model settings to ~/.aider.model.settings.yml.${NC}"
else
    echo -e "${YELLOW}Warning: .aider.model.settings.yml not found. Skipping.${NC}"
fi

# 5. Check PATH for bin folder
echo -e "\n${BLUE}[5/5] Checking Zsh/Bash Path Integration...${NC}"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $BIN_DIR is not in your current PATH variable!${NC}"
    echo -e "${YELLOW}Please add the following to your ~/.zshrc or ~/.bashrc:${NC}"
    echo -e "export PATH=\"\$HOME/.local/bin:\$PATH\""
else
    echo -e "${GREEN}✔ $BIN_DIR is successfully configured in PATH.${NC}"
fi

echo -e "\n${GREEN}==========================================================${NC}"
echo -e "${GREEN}  Installation Complete! Local Vibe Coding is Ready!     ${NC}"
echo -e "${GREEN}==========================================================${NC}"
echo -e "\n${BLUE}To launch Aider, navigate to any repository folder and run:${NC}"
echo -e "   ${GREEN}aider${NC}\n"
