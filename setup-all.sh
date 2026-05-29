#!/bin/bash
# setup-all.sh - The ultimate master automation script to setup the entire Vibe Coding environment.
# Orchestrates Ollama base pulls, optimized model compilations, system utilities, ComfyUI assets, and GPU Voice-to-Text.

set -e

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
# ASCII art
echo -e "${BLUE}  __     ___ _            ___           _tall_ ____  ${NC}"
echo -e "${BLUE}  \\ \\   / (_) |__   ___  |_ _|_ __  ___| |_ __ _|  _ \\ ${NC}"
echo -e "${BLUE}   \\ \\ / /| | '_ \\ / _ \\  | || '_ \\/ __| __/ _\` | | | |${NC}"
echo -e "${BLUE}    \\ V / | | |_) |  __/  | || | | \\__ \\ || (_| | |_| |${NC}"
echo -e "${BLUE}     \\_/  |_|_.__/ \\___| |___|_| |_|___/\\__\\__,_|____/ ${NC}"
echo -e "${BLUE}                                                                      ${NC}"
echo -e "${BLUE}        THE ULTIMATE MASTER ENVIRONMENT INSTALLATION SCRIPT           ${NC}"
echo -e "${BLUE}======================================================================${NC}"

# 1. System Package Diagnostics
echo -e "\n${BLUE}[1/8] Verifying Core System Packages...${NC}"
missing_pkg=0
for pkg in git curl python tmux paru; do
    if ! command -v "$pkg" &>/dev/null; then
        echo -e "${YELLOW}Warning: '$pkg' is not installed or not in PATH!${NC}"
        missing_pkg=1
    fi
done

if [ "$missing_pkg" -eq 1 ]; then
    echo -e "${YELLOW}Some packages are missing. On CachyOS/Arch, you can install them via:${NC}"
    echo -e "   sudo pacman -S git curl python tmux && paru -S whispers-cuda-bin wtype\n"
    read -p "Would you like the installer to attempt auto-installing core Pacman packages now? (y/n): " inst_core
    if [[ "$inst_core" =~ ^[Yy]$ ]]; then
        sudo pacman -S --needed --noconfirm git curl python tmux
    fi
fi
echo -e "${GREEN}✔ Core system packages verified.${NC}"

# 2. Ollama Status & Pulls
echo -e "\n${BLUE}[2/8] Ensuring Ollama is active and pulling base models...${NC}"
if ! ollama list &>/dev/null; then
    echo -e "${RED}Error: Ollama service is not running or not in PATH! Please start Ollama first.${NC}"
    exit 1
fi

ensure_base_model() {
    local model="$1"
    if ! ollama list | grep -q "$model"; then
        echo -e "${YELLOW}Pulling base model '$model' (This may take a moment)...${NC}"
        ollama pull "$model"
    else
        echo -e "${GREEN}✔ Base model '$model' already present.${NC}"
    fi
}

ensure_base_model "qwen3-coder:30b"
ensure_base_model "qwen2.5-coder:7b"
ensure_base_model "deepseek-coder-v2:16b"
ensure_base_model "dolphin-llama3:8b"

# 3. Compile custom tweaked models
echo -e "\n${BLUE}[3/8] Compiling Optimized Custom Model Modelfiles in Ollama...${NC}"

build_custom_model() {
    local name="$1"
    local modelfile="$2"
    if [ ! -f "$modelfile" ]; then
        echo -e "${RED}Error: $modelfile not found in current folder!${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Building custom model '$name' using $modelfile...${NC}"
    if ollama create "$name" -f "$modelfile"; then
        echo -e "${GREEN}✔ $name built successfully.${NC}"
    else
        echo -e "${RED}Failed to build custom model $name!${NC}"
        exit 1
    fi
}

build_custom_model "qwen3-coder:30b-tweaked" "Modelfile-architect"
build_custom_model "qwen2.5-coder:7b-tweaked" "Modelfile-editor"
build_custom_model "deepseek-coder-v2:16b-tweaked" "Modelfile-deepseek-general"
build_custom_model "deepseek-coder-v2:16b-translate" "Modelfile-deepseek-translate"
build_custom_model "dolphin-llama3:8b-tweaked" "Modelfile-dolphin"

# 4. Copy system binaries
echo -e "\n${BLUE}[4/8] Installing custom system binaries...${NC}"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

install_bin() {
    local script="$1"
    if [ -f "$script" ]; then
        cp "$script" "$BIN_DIR/$script"
        chmod +x "$BIN_DIR/$script"
        echo -e "${GREEN}✔ Installed '$script' successfully to $BIN_DIR/$script.${NC}"
    else
        echo -e "${RED}Error: '$script' not found in current folder!${NC}"
        exit 1
    fi
}

install_bin "vibe-check"
install_bin "vibe-hud"
install_bin "vibe-asset"
install_bin "vibe-free"
install_bin "vibe-asset-monitor"
install_bin "vibe-asset-menu"
install_bin "vibe-start"
install_bin "vibe-translate"
install_bin "vibe-commands"
install_bin "vibe-switch"

# 5. Global Config & Shell integration
echo -e "\n${BLUE}[5/8] Copying Aider Configurations & Integrations...${NC}"
if [ -f ".aider.conf.yml" ]; then
    cp .aider.conf.yml "$HOME/.aider.conf.yml"
    echo -e "${GREEN}✔ Copied Aider config to ~/.aider.conf.yml.${NC}"
fi

if [ -f ".aider.model.settings.yml" ]; then
    cp .aider.model.settings.yml "$HOME/.aider.model.settings.yml"
    echo -e "${GREEN}✔ Copied model settings to ~/.aider.model.settings.yml.${NC}"
fi

if [ -f "aider.fish" ] && [ -d "$HOME/.config/fish/functions" ]; then
    cp aider.fish "$HOME/.config/fish/functions/aider.fish"
    echo -e "${GREEN}✔ Copied Fish Shell function integration.${NC}"
fi

# Ensure path is updated
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $BIN_DIR is not in your current PATH variable!${NC}"
    echo -e "${YELLOW}Please add the following to your ~/.zshrc or ~/.bashrc:${NC}"
    echo -e "export PATH=\"\$HOME/.local/bin:\$PATH\""
else
    echo -e "${GREEN}✔ $BIN_DIR is successfully configured in PATH.${NC}"
fi

# 6. SD local sprite generator pipeline (ComfyUI)
echo -e "\n${BLUE}[6/8] Setting Up Local AI Sprites Generator Pipeline (ComfyUI)...${NC}"
read -p "Would you like to install/configure ComfyUI and download local models? (y/n): " setup_comfy
if [[ "$setup_comfy" =~ ^[Yy]$ ]]; then
    COMFY_DIR="$HOME/Documents/GitHub/ComfyUI"
    echo -e "${YELLOW}Installing ComfyUI in $COMFY_DIR...${NC}"
    mkdir -p "$HOME/Documents/GitHub"
    
    if [ ! -d "$COMFY_DIR" ]; then
        if git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"; then
            echo -e "${GREEN}✔ Cloned ComfyUI repository.${NC}"
        fi
    fi

    if [ -d "$COMFY_DIR" ]; then
        # Check and install optimized PyTorch with CUDA if on Arch Linux
        if command -v pacman &>/dev/null; then
            echo -e "${YELLOW}Arch Linux detected. Optimizing PyTorch with CUDA...${NC}"
            if ! pacman -Qi python-pytorch-opt-cuda &>/dev/null; then
                sudo pacman -Rdd --noconfirm python-pytorch &>/dev/null
                sudo pacman -S --noconfirm python-pytorch-opt-cuda python-torchvision-cuda
            fi
        fi

        # Create Python venv
        python -m venv --system-site-packages "$COMFY_DIR/venv"
        "$COMFY_DIR/venv/bin/pip" install -r "$COMFY_DIR/requirements.txt"
        "$COMFY_DIR/venv/bin/pip" install torchaudio --extra-index-url https://download.pytorch.org/whl/cpu

        # Download checkpoints
        CKPT_FILE="$COMFY_DIR/models/checkpoints/dreamshaper_8.safetensors"
        if [ ! -f "$CKPT_FILE" ]; then
            echo -e "${YELLOW}Downloading DreamShaper 8 checkpoint (2GB)...${NC}"
            curl -L -o "$CKPT_FILE" "https://huggingface.co/Lykon/DreamShaper/resolve/main/DreamShaper_8_pruned.safetensors"
        fi
        
        PIXEL_CKPT="$COMFY_DIR/models/checkpoints/pixelartDiffusion_v10.safetensors"
        if [ ! -f "$PIXEL_CKPT" ]; then
            echo -e "${YELLOW}Downloading Pixel Art Diffusion checkpoint (2GB)...${NC}"
            curl -L -o "$PIXEL_CKPT" "https://huggingface.co/Jonas-Mugge/pixel-art-diffusion/resolve/main/pixelartDiffusion_v10.safetensors"
        fi
        echo -e "${GREEN}✔ Local ComfyUI Sprites pipeline fully set up.${NC}"
    fi
fi

# 7. Git Identity verification
echo -e "\n${BLUE}[7/8] Verifying Git Commit Identity...${NC}"
git_name=$(git config --global user.name)
git_email=$(git config --global user.email)
if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    echo -e "${YELLOW}Git identity is not configured! Aider requires a Git identity to autocommit changes.${NC}"
    if [ -z "$git_name" ]; then
        read -p "Enter your Git Name: " input_name
        [ -n "$input_name" ] && git config --global user.name "$input_name"
    fi
    if [ -z "$git_email" ]; then
        read -p "Enter your Git Email: " input_email
        [ -n "$input_email" ] && git config --global user.email "$input_email"
    fi
else
    echo -e "${GREEN}✔ Git Identity detected: $git_name <$git_email>${NC}"
fi

# 8. Dictation pipeline
echo -e "\n${BLUE}[8/8] Installing Local GPU-Accelerated Voice Dictation...${NC}"
if [ -f "./setup-voice.sh" ]; then
    chmod +x ./setup-voice.sh
    ./setup-voice.sh
else
    echo -e "${RED}Warning: setup-voice.sh script not found! Skipping voice installation.${NC}"
fi

echo -e "\n${GREEN}======================================================================${NC}"
echo -e "${GREEN}  MASTER SETUP COMPLETE! YOUR LOCAL VIBE CODING SYSTEM IS READY!     ${NC}"
echo -e "${GREEN}======================================================================${NC}"
echo -e "\nLaunch your new workspace in Tmux splits instantly by typing:"
echo -e "   ${GREEN}vibe-start <project_directory>${NC}\n"
