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

if [ ! -f "Modelfile-architect" ]; then
    echo -e "${RED}Error: Modelfile-architect not found in current folder!${NC}"
    exit 1
fi

echo -e "${YELLOW}Building qwen3-coder:30b-tweaked (Architect)...${NC}"
if ollama create qwen3-coder:30b-tweaked -f Modelfile-architect; then
    echo -e "${GREEN}✔ qwen3-coder:30b-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build qwen3-coder:30b-tweaked. Make sure you pulled 'qwen3-coder:30b' first.${NC}"
fi

# 3. Install vibe-check and vibe-hud scripts
echo -e "\n${BLUE}[3/5] Installing 'vibe-check' and 'vibe-hud' Scripts...${NC}"
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

if [ -f "vibe-hud" ]; then
    cp vibe-hud "$BIN_DIR/vibe-hud"
    chmod +x "$BIN_DIR/vibe-hud"
    echo -e "${GREEN}✔ Installed 'vibe-hud' to $BIN_DIR/vibe-hud.${NC}"
else
    echo -e "${RED}Error: vibe-hud script not found in current folder!${NC}"
    exit 1
fi

if [ -f "vibe-start" ]; then
    cp vibe-start "$BIN_DIR/vibe-start"
    chmod +x "$BIN_DIR/vibe-start"
    echo -e "${GREEN}✔ Installed 'vibe-start' to $BIN_DIR/vibe-start.${NC}"
fi

# 4. Copy Aider configuration files & Shell integrations
echo -e "\n${BLUE}[4/5] Copying Global Aider Configuration Files & Shell Integrations...${NC}"

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

if [ -f "aider.fish" ] && [ -d "$HOME/.config/fish/functions" ]; then
    cp aider.fish "$HOME/.config/fish/functions/aider.fish"
    echo -e "${GREEN}✔ Copied Fish Shell function integration to ~/.config/fish/functions/aider.fish.${NC}"
fi

# 5. Check PATH for bin folder
echo -e "\n${BLUE}[5/6] Checking Zsh/Bash Path Integration...${NC}"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $BIN_DIR is not in your current PATH variable!${NC}"
    echo -e "${YELLOW}Please add the following to your ~/.zshrc or ~/.bashrc:${NC}"
    echo -e "export PATH=\"\$HOME/.local/bin:\$PATH\""
else
    echo -e "${GREEN}✔ $BIN_DIR is successfully configured in PATH.${NC}"
fi

# 6. Check Git Identity & GitHub Linkage
echo -e "\n${BLUE}[6/6] Checking Git Identity & GitHub Remote Integration...${NC}"

# A. Verify Git user.name and user.email (mandatory for Aider autocommits)
git_name=$(git config --global user.name)
git_email=$(git config --global user.email)

if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    echo -e "${YELLOW}Git identity is not fully configured! Aider requires a Git identity to autocommit changes.${NC}"
    if [ -z "$git_name" ]; then
        read -p "Enter your Git Name (for commits): " input_name
        if [ -n "$input_name" ]; then
            git config --global user.name "$input_name"
            git_name="$input_name"
        fi
    fi
    if [ -z "$git_email" ]; then
        read -p "Enter your Git Email (for commits): " input_email
        if [ -n "$input_email" ]; then
            git config --global user.email "$input_email"
            git_email="$input_email"
        fi
    fi
    echo -e "${GREEN}✔ Git identity configured successfully.${NC}"
else
    echo -e "${GREEN}✔ Git identity detected: $git_name <$git_email>${NC}"
fi

# B. Link this repository to GitHub
echo -e "\nWould you like to link this local setup repository to your remote GitHub repository now?"
read -p "Link to GitHub? (y/n): " link_github

if [[ "$link_github" =~ ^[Yy]$ ]]; then
    read -p "Enter your GitHub Repository URL (e.g., https://github.com/WoofahRayetCode/vibe-coding-setup.git): " repo_url
    if [ -n "$repo_url" ]; then
        # Check if origin already exists
        if git remote get-url origin &>/dev/null; then
            echo -e "${YELLOW}An 'origin' remote already exists. Updating to new URL...${NC}"
            git remote set-url origin "$repo_url"
        else
            git remote add origin "$repo_url"
        fi
        echo -e "${GREEN}✔ Linked 'origin' remote to: $repo_url${NC}"
        
        # Ask if they want to push the commits right now
        read -p "Push to GitHub main branch right now? (y/n): " push_now
        if [[ "$push_now" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Pushing to GitHub...${NC}"
            if git push -u origin main; then
                echo -e "${GREEN}✔ Successfully pushed to GitHub main branch!${NC}"
            else
                echo -e "${RED}Warning: Push failed. Make sure the repository exists on GitHub and your credentials are configured.${NC}"
            fi
        fi
    fi
fi

echo -e "\n${GREEN}==========================================================${NC}"
echo -e "${GREEN}  Installation Complete! Local Vibe Coding is Ready!     ${NC}"
echo -e "${GREEN}==========================================================${NC}"
echo -e "\n${BLUE}To launch Aider, navigate to any repository folder and run:${NC}"
echo -e "   ${GREEN}aider${NC}\n"
