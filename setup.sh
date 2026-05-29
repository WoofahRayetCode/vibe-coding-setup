#!/bin/bash

# ==========================================================
# Polyglot Local Vibe Coding Environment Installer/Setup
# ==========================================================

# CHANGELOG:
# - Added installation routine for the new vibe-free script

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
echo -e "\n${BLUE}[1/7] Checking Ollama Service...${NC}"
if ! ollama list &>/dev/null; then
    echo -e "${RED}Error: Ollama service is not running or not in PATH! Please start Ollama and try again.${NC}"
    exit 1
fi
echo -e "${GREEN}✔ Ollama is active and running.${NC}"

# 2. Build/tweaked Ollama models
echo -e "\n${BLUE}[2/7] Building Customized Tweaked Models in Ollama...${NC}"

if [ ! -f "Modelfile-architect" ]; then
    echo -e "${RED}Error: Modelfile-architect not found in current folder!${NC}"
    exit 1
fi

if [ ! -f "Modelfile-editor" ]; then
    echo -e "${RED}Error: Modelfile-editor not found in current folder!${NC}"
    exit 1
fi

if [ ! -f "Modelfile-deepseek-general" ]; then
    echo -e "${RED}Error: Modelfile-deepseek-general not found in current folder!${NC}"
    exit 1
fi

if [ ! -f "Modelfile-deepseek-translate" ]; then
    echo -e "${RED}Error: Modelfile-deepseek-translate not found in current folder!${NC}"
    exit 1
fi

if [ ! -f "Modelfile-dolphin" ]; then
    echo -e "${RED}Error: Modelfile-dolphin not found in current folder!${NC}"
    exit 1
fi

echo -e "${YELLOW}Building qwen3-coder:30b-tweaked (Architect)...${NC}"
if ollama create qwen3-coder:30b-tweaked -f Modelfile-architect; then
    echo -e "${GREEN}✔ qwen3-coder:30b-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build qwen3-coder:30b-tweaked. Make sure you pulled 'qwen3-coder:30b' first.${NC}"
fi

echo -e "${YELLOW}Building qwen2.5-coder:7b-tweaked (Editor)...${NC}"
if ollama create qwen2.5-coder:7b-tweaked -f Modelfile-editor; then
    echo -e "${GREEN}✔ qwen2.5-coder:7b-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build qwen2.5-coder:7b-tweaked. Make sure you pulled 'qwen2.5-coder:7b' first.${NC}"
fi

echo -e "${YELLOW}Ensuring DeepSeek Coder V2 16B is pulled...${NC}"
if ! ollama list | grep -q "deepseek-coder-v2:16b"; then
    echo -e "${YELLOW}Pulling deepseek-coder-v2:16b...${NC}"
    ollama pull deepseek-coder-v2:16b
fi

echo -e "${YELLOW}Building deepseek-coder-v2:16b-tweaked (General Coding)...${NC}"
if ollama create deepseek-coder-v2:16b-tweaked -f Modelfile-deepseek-general; then
    echo -e "${GREEN}✔ deepseek-coder-v2:16b-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build deepseek-coder-v2:16b-tweaked.${NC}"
fi

echo -e "${YELLOW}Building deepseek-coder-v2:16b-translate (Code Translation)...${NC}"
if ollama create deepseek-coder-v2:16b-translate -f Modelfile-deepseek-translate; then
    echo -e "${GREEN}✔ deepseek-coder-v2:16b-translate built successfully.${NC}"
else
    echo -e "${RED}Failed to build deepseek-coder-v2:16b-translate.${NC}"
fi

echo -e "${YELLOW}Ensuring Dolphin Llama 3 8B is pulled...${NC}"
if ! ollama list | grep -q "dolphin-llama3:8b"; then
    echo -e "${YELLOW}Pulling dolphin-llama3:8b...${NC}"
    ollama pull dolphin-llama3:8b
fi

echo -e "${YELLOW}Building dolphin-llama3:8b-tweaked (Uncensored)...${NC}"
if ollama create dolphin-llama3:8b-tweaked -f Modelfile-dolphin; then
    echo -e "${GREEN}✔ dolphin-llama3:8b-tweaked built successfully.${NC}"
else
    echo -e "${RED}Failed to build dolphin-llama3:8b-tweaked.${NC}"
fi

# 3. Install vibe-check and vibe-hud scripts
echo -e "\n${BLUE}[3/7] Installing 'vibe-check' and 'vibe-hud' Scripts...${NC}"
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

if [ -f "vibe-asset" ]; then
    cp vibe-asset "$BIN_DIR/vibe-asset"
    chmod +x "$BIN_DIR/vibe-asset"
    echo -e "${GREEN}✔ Installed 'vibe-asset' to $BIN_DIR/vibe-asset.${NC}"
fi

if [ -f "vibe-free" ]; then
    cp vibe-free "$BIN_DIR/vibe-free"
    chmod +x "$BIN_DIR/vibe-free"
    echo -e "${GREEN}✔ Installed 'vibe-free' to $BIN_DIR/vibe-free.${NC}"
fi

if [ -f "vibe-asset-monitor" ]; then
    cp vibe-asset-monitor "$BIN_DIR/vibe-asset-monitor"
    chmod +x "$BIN_DIR/vibe-asset-monitor"
    echo -e "${GREEN}✔ Installed 'vibe-asset-monitor' to $BIN_DIR/vibe-asset-monitor.${NC}"
fi

if [ -f "vibe-asset-menu" ]; then
    cp vibe-asset-menu "$BIN_DIR/vibe-asset-menu"
    chmod +x "$BIN_DIR/vibe-asset-menu"
    echo -e "${GREEN}✔ Installed 'vibe-asset-menu' to $BIN_DIR/vibe-asset-menu.${NC}"
fi

if [ -f "vibe-start" ]; then
    cp vibe-start "$BIN_DIR/vibe-start"
    chmod +x "$BIN_DIR/vibe-start"
    echo -e "${GREEN}✔ Installed 'vibe-start' to $BIN_DIR/vibe-start.${NC}"
fi

if [ -f "vibe-translate" ]; then
    cp vibe-translate "$BIN_DIR/vibe-translate"
    chmod +x "$BIN_DIR/vibe-translate"
    echo -e "${GREEN}✔ Installed 'vibe-translate' to $BIN_DIR/vibe-translate.${NC}"
fi

if [ -f "vibe-switch" ]; then
    cp vibe-switch "$BIN_DIR/vibe-switch"
    chmod +x "$BIN_DIR/vibe-switch"
    echo -e "${GREEN}✔ Installed 'vibe-switch' to $BIN_DIR/vibe-switch.${NC}"
fi

# 4. Copy Aider configuration files & Shell integrations
echo -e "\n${BLUE}[4/7] Copying Global Aider Configuration Files & Shell Integrations...${NC}"

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

# 5. Set Up Local AI Asset Pipeline (ComfyUI + PyTorch + Models)
echo -e "\n${BLUE}[5/7] Setting Up Local AI Asset Pipeline (ComfyUI + PyTorch + Models)...${NC}"
read -p "Would you like to install/configure ComfyUI and download the 2GB DreamShaper model? (y/n): " setup_comfy

if [[ "$setup_comfy" =~ ^[Yy]$ ]]; then
    COMFY_DIR="$HOME/Documents/GitHub/ComfyUI"
    echo -e "${YELLOW}Installing ComfyUI in $COMFY_DIR...${NC}"
    mkdir -p "$HOME/Documents/GitHub"
    
    if [ ! -d "$COMFY_DIR" ]; then
        if git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"; then
            echo -e "${GREEN}✔ Cloned ComfyUI repository.${NC}"
        else
            echo -e "${RED}Failed to clone ComfyUI repository! Skipping ComfyUI setup.${NC}"
        fi
    else
        echo -e "${GREEN}✔ ComfyUI directory already exists.${NC}"
    fi

    if [ -d "$COMFY_DIR" ]; then
        # Check and install optimized PyTorch with CUDA if on Arch Linux
        if command -v pacman &>/dev/null; then
            echo -e "${YELLOW}Arch Linux detected. Installing optimized python-pytorch-opt-cuda via Pacman...${NC}"
            if ! pacman -Qi python-pytorch-opt-cuda &>/dev/null; then
                sudo pacman -Rdd --noconfirm python-pytorch &>/dev/null
                sudo pacman -S --noconfirm python-pytorch-opt-cuda python-torchvision-cuda
            fi
            echo -e "${GREEN}✔ Optimized PyTorch with CUDA installed via Pacman.${NC}"
        fi

        # Create Python venv
        echo -e "${YELLOW}Creating Python virtual environment...${NC}"
        python -m venv --system-site-packages "$COMFY_DIR/venv"
        
        # Install pip requirements
        echo -e "${YELLOW}Installing ComfyUI pip dependencies...${NC}"
        "$COMFY_DIR/venv/bin/pip" install -r "$COMFY_DIR/requirements.txt"
        
        # Install CPU torchaudio to prevent CUDA compilation conflicts with Pacman PyTorch
        echo -e "${YELLOW}Configuring system-compatible CPU torchaudio wheel...${NC}"
        "$COMFY_DIR/venv/bin/pip" install torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
        
        # Download DreamShaper 8 Checkpoint
        CKPT_FILE="$COMFY_DIR/models/checkpoints/dreamshaper_8.safetensors"
        if [ ! -f "$CKPT_FILE" ]; then
            echo -e "${YELLOW}Downloading 2GB DreamShaper 8 model checkpoint...${NC}"
            if curl -L -o "$CKPT_FILE" "https://huggingface.co/Lykon/DreamShaper/resolve/main/DreamShaper_8_pruned.safetensors"; then
                echo -e "${GREEN}✔ Downloaded DreamShaper 8 model checkpoint successfully.${NC}"
            else
                echo -e "${RED}Failed to download DreamShaper 8 model checkpoint! You may need to download it manually.${NC}"
            fi
        else
            echo -e "${GREEN}✔ DreamShaper 8 model checkpoint already exists.${NC}"
        fi

        # Download Pixel Art Diffusion Checkpoint
        PIXEL_CKPT="$COMFY_DIR/models/checkpoints/pixelartDiffusion_v10.safetensors"
        if [ ! -f "$PIXEL_CKPT" ]; then
            echo -e "${YELLOW}Downloading 2.1GB Pixel Art Diffusion model checkpoint...${NC}"
            if curl -L -o "$PIXEL_CKPT" "https://huggingface.co/Jonas-Mugge/pixel-art-diffusion/resolve/main/pixelartDiffusion_v10.safetensors"; then
                echo -e "${GREEN}✔ Downloaded Pixel Art Diffusion model successfully.${NC}"
            else
                echo -e "${RED}Failed to download Pixel Art Diffusion model! You may need to download it manually.${NC}"
            fi
        else
            echo -e "${GREEN}✔ Pixel Art Diffusion model already exists.${NC}"
        fi
    fi
fi

# 6. Check PATH for bin folder
echo -e "\n${BLUE}[6/7] Checking Zsh/Bash Path Integration...${NC}"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $BIN_DIR is not in your current PATH variable!${NC}"
    echo -e "${YELLOW}Please add the following to your ~/.zshrc or ~/.bashrc:${NC}"
    echo -e "export PATH=\"\$HOME/.local/bin:\$PATH\""
else
    echo -e "${GREEN}✔ $BIN_DIR is successfully configured in PATH.${NC}"
fi

# 7. Check Git Identity & GitHub Linkage
echo -e "\n${BLUE}[7/7] Checking Git Identity & GitHub Remote Integration...${NC}"

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
