#!/bin/bash
# setup-voice.sh - Installs and configures the local GPU-accelerated voice dictation tool (Whispers)

set -e

echo -e "\e[0;34m[VIBE]\e[0m Setting up Local GPU-Accelerated Voice-to-Text..."

# 1. Ensure paru (AUR helper) is installed
if ! command -v paru &> /dev/null; then
    echo -e "\e[0;31mError: 'paru' is required to install the whispers package from the AUR.\e[0m"
    echo -e "Please install paru and try again."
    exit 1
fi

# 2. Install dependencies (whispers-cuda-bin and wtype for Wayland typing)
echo -e "\e[0;32m-> Installing whispers-cuda-bin and wtype...\e[0m"
paru -S --needed --noconfirm whispers-cuda-bin wtype

# 3. Create the Whispers configuration directory
mkdir -p ~/.config/whispers

# 4. Generate the config file to force GPU usage and small.en model
echo -e "\e[0;32m-> Configuring Whispers to use the highly-accurate 'small.en' model...\e[0m"
cat > ~/.config/whispers/config.toml << 'EOF'
[audio]
device = ""
sample_rate = 16000

[transcription]
backend = "whisper_cpp"
fallback = "configured_local"
local_backend = "whisper_cpp"
selected_model = "small.en"
language = "en"
use_gpu = true
flash_attn = true
idle_timeout_ms = 120000

[postprocess]
mode = "raw"
EOF

# 5. Create a desktop shortcut so KDE can bind it to a global hotkey
echo -e "\e[0;32m-> Registering the background task for KDE...\e[0m"
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/net.local.whispers-2.desktop << 'EOF'
[Desktop Entry]
Exec=whispers
Name=Whispers Voice Dictation
NoDisplay=true
StartupNotify=false
Type=Application
X-KDE-GlobalAccel-CommandShortcut=true
EOF

# 6. Apply to KDE system config if possible
if command -v kwriteconfig6 &> /dev/null; then
    kwriteconfig6 --file kglobalshortcutsrc --group "services" --key "net.local.whispers-2.desktop" "_launch=F8"
fi

echo -e "\e[0;32m===============================================================\e[0m"
echo -e "\e[0;32m                      SETUP COMPLETE!\e[0m"
echo -e "\e[0;32m===============================================================\e[0m"
echo -e "Your GPU-accelerated voice dictation tool is fully installed."
echo -e "To finalize the hotkey:"
echo -e "  1. Open KDE System Settings -> Keyboard -> Shortcuts"
echo -e "  2. Search for 'Whispers Voice Dictation' (or look under Custom Shortcuts)"
echo -e "  3. Bind it to \e[0;33mF8\e[0m (or whatever key you prefer)."
echo -e "Once bound, simply press the key once to start recording, and again to type it out!"
