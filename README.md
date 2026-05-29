# 🚀 Local Vibe Coding Environment

Welcome to the **Local Vibe Coding Environment** setup. This repository contains the complete configuration, scripts, and customized model templates to run a fully local, hands-free, zero-interruption AI pair-programming environment. 

By leveraging **Aider** alongside **Ollama**, this environment splits complex coding tasks into a dual-model pipeline: high-level conceptual reasoning is handled by an **Architect model**, while rapid code writing is delegated to an **Editor model**.

> [!NOTE]
> This setup is currently tested and verified on **CachyOS**.

---

## 🏗️ Architecture & How It Works

This setup operates on a **split-brain architecture** that separates reasoning from execution to achieve maximum speed and high-level coding accuracy:

```
                  ┌────────────────────────┐
                  │      User Prompt       │
                  └───────────┬────────────┘
                              │
                              ▼
                  ┌────────────────────────┐
                  │    Architect (30B)     │ ◄─── Uses qwen3-coder:30b-tweaked
                  │  (Designs & Plans)     │      Configured with 16K context
                  └───────────┬────────────┘
                              │
                              ▼  Delegates instructions
                  ┌────────────────────────┐
                  │    Editor (7B Model)   │ ◄─── Uses qwen2.5-coder:7b-tweaked
                  │  (Writes Diff Blocks)  │      Ultra-fast file editing
                  └───────────┬────────────┘
                              │
                              ▼  Executes changes
                  ┌────────────────────────┐
                  │     Codebase Files     │
                  └───────────┬────────────┘
                              │
                              ▼  Auto-trigger
                  ┌────────────────────────┐
                  │  Universal vibe-check  │ ◄─── Compiles & Runs Tests
                  └───────────┬────────────┘      (Dotnet, Cargo, NPM, etc.)
                              │
            ┌─────────────────┴─────────────────┐
            │                                   │
            ▼ (Build Succeeds)                  ▼ (Build Fails)
 ┌─────────────────────┐             ┌─────────────────────┐
 │  Auto-Commit Code   │             │   Auto-Fix Loop     │
 │  to Git Repository  │             │   (Send back to AI) │
 └─────────────────────┘             └─────────────────────┘
```

### 1. Dual-Model Architect / Editor Pipeline
Aider is configured in **Architect Mode** by default. When you submit a prompt:
* **The Architect (`qwen3-coder:30b-tweaked`)**: Analyzes the codebase context via the Tree-sitter Repository Map, thinks through structural patterns, and outputs a conceptual plan of the changes needed.
* **The Editor (`qwen2.5-coder:7b-tweaked`)**: Takes the Architect's instructions and rapidly applies them using high-speed search-replace diff formats (`editor-diff`).
* **VRAM Orchestration**: Ollama manages VRAM loading and offloading dynamically under the hood, swapping models seamlessly between plans and edits.

### 2. Local Code Translation Engine (`vibe-translate`)
This environment includes a dedicated, highly optimized code translation utility:
* **One-Shot Local Translation**: Run `vibe-translate <source_file> <target_file>` (e.g., `vibe-translate Player.cs Player.gd`) to translate code between programming languages.
* **Semantic & Functional Accuracy**: Connects directly to the customized `deepseek-coder-v2:16b-translate` model. It translates code using modern language idioms (like Godot 4 GDScript conventions) while preserving logical structure, variable names, and original comments.
* **VRAM Safety**: The translation model is dynamically loaded, processes the file, and is immediately unloaded upon completion. It consumes **0 VRAM** during regular coding loops.

### 3. Uncensored/Unrestricted Profile (`dolphin-llama3:8b-tweaked`)
For an unrestricted, limit-free programming and general instruction experience, this environment integrates Dolphin Llama 3 8B:
* **Zero Refusals**: Curated to bypass safety alignments, disclaimers, and lecturing. It answers complex coding queries, cybersecurity structures, and game logic without boundaries.
* **100% GPU VRAM Loading**: Configured with `num_gpu 99` in `Modelfile-dolphin` to lock all 33 layers into VRAM for maximum execution speeds.

### 4. Zero-Interruption Auto-Fix Loop (`vibe-check`)
Every time Aider applies a code modification, it automatically invokes the **`vibe-check`** script:
* `vibe-check` dynamically detects your project type (supporting C# `.csproj`, Rust `Cargo.toml`, Node.js `package.json`, Python, and Go).
* It automatically triggers the appropriate compile or test command (e.g., `dotnet build`, `cargo test`, `npm test`).
* **If it compiles cleanly**: Aider automatically commits the changes to Git.
* **If it fails to compile**: Aider feeds the compiler error logs back to the Architect model in a loop, correcting the code automatically until it compiles.

### 5. Memory Safety & VRAM Flushing (`vibe-free`)
An automated utility (`vibe-free`) is integrated to stop active Ollama model instances and flush the ComfyUI cache on demand:
* It guarantees maximum VRAM space on 8GB GPUs, preventing out-of-memory (`cudaMalloc`) crashes on model profile transitions.

### 6. Dynamic Triple-Model observing HUD (`vibe-hud`)
A pure-Bash terminal telemetry dashboard runs in a split pane, giving you instant observability:
* **Ollama Triple-Model Cockpit**: Displays the real-time VRAM presence and status of your **Architect** (Qwen 30B), **Editor** (Qwen 7B), and **Translator/Uncensored** (DeepSeek 16B / Dolphin 8B) models concurrently.
* **Granular Telemetry Statuses**: Integrates deep compiler and GPU activity metrics to display exactly what the model is doing: `SLEEPING` (unloaded), `READY` (idle), `THINKING` (planning), `WRITING` (applying code), `TRANSLATING` (logic mappings), or `COMPILING` (running `vibe-check` tests).
* **System CPU Usage & Temperatures**: Parsed directly from `/proc/stat` and thermal zones.
* **NVIDIA GPU Load & VRAM Bar**: Displays real-time GPU load, GPU temp, and exact VRAM capacity/percentage.

### 7. Local AI Asset Generation (`vibe-asset`)
This setup integrates a **local game asset generation pipeline** using **ComfyUI** and the highly optimized **DreamShaper 8** Stable Diffusion model running locally on your RTX 5060 GPU:
* **Terminal-Based Sprites Creation**: You can run `vibe-asset "[prompt]"` directly inside Aider using the `/run` or `!` command (e.g. `/run vibe-asset "red dragon monster sprite" red_dragon`).
* **Optimized Pixel Art Injector**: The command automatically embeds custom prompt styling to force grid-aligned, crisp, 16-bit pixel art outputs on solid flat backgrounds.
* **Automatic Integration**: The script automatically polls the local ComfyUI API, processes the image, and saves the finished `.png` directly into your active Godot project folder.

### 8. Dual-Model Reliability & Edge Cases
Because the Editor model (`qwen2.5-coder:7b-tweaked`) operates at **Temperature 0** (greedy decoding), it follows the Architect's plans with maximum fidelity, precision, and zero creative deviation. Here is how this environment mitigates common LLM edge cases:
* **Vague Plans / Guesswork**: If the Architect provides incomplete instructions, the Editor could introduce placeholders. *Mitigation: `Modelfile-architect` forces the 30B model to write fully completed, operational code blocks with no placeholders.*
* **Complex Algorithmic Logic**: Highly complex programming tasks can occasionally lead to syntax slips in smaller models. *Mitigation: The `vibe-check` auto-compile loop immediately catches compiler errors, feeds them back to the 30B Architect, and automatically applies the correction.*
* **Context Drift**: Very large files can cause smaller models to lose track of details. *Mitigation: `Modelfile-editor` configures a massive `32768` (32K) context window, keeping the Editor's attention sharp and fully inside VRAM.*

---

## 💻 Tested Hardware & Model Performance

This environment is optimized and actively running on a high-performance laptop system:

### **System Specifications**
* **Device**: HP OMEN Gaming Laptop 16-ap0xxx
* **Operating System**: CachyOS (Linux 7.0.10-1-cachyos)
* **Processor**: AMD Ryzen 9 8940HX with Radeon Graphics (16 Cores, 32 Threads)
* **System Memory**: 32 GB DDR5 RAM
* **Graphics Card**: NVIDIA GeForce RTX 5060 Laptop GPU (8 GB GDDR6 VRAM)

### **Model Performance & Resource Profile**

| Model | Size | VRAM Allocation | Execution Profile |
| :--- | :--- | :--- | :--- |
| **qwen2.5-coder:7b-tweaked** (Editor) | ~4.7 GB | **100% GPU VRAM** | Lightning-fast code generation and diff application. Executes in under a few seconds. |
| **dolphin-llama3:8b-tweaked** (Uncensored) | ~4.7 GB | **100% GPU VRAM** | Completely unrestricted general coding and reasoning. Highly optimized for snappiness on RTX 5060. |
| **deepseek-coder-v2:16b-translate** (Translator) | ~8.9 GB | **Hybrid (VRAM/RAM)** | Specialized multi-lingual software translation. Excellent API alignment and comments mapping. |
| **qwen3-coder:30b-tweaked** (Architect) | ~18 GB | **Hybrid GPU + CPU RAM** | Highly intelligent conceptual plans and C# structure designs, utilizing CPU system memory and GPU offloading seamlessly. |

---

## 🛠️ Setup Component Breakdown

Here are the key configuration files and utilities provided in this repository:

| File / Folder | Role | Description |
| :--- | :--- | :--- |
| [`Modelfile-architect`](Modelfile-architect) | Model Template | Tweaked Ollama configuration for `qwen3-coder:30b` (low temperature, 16K context, physical Ryzen 9 cores). |
| [`Modelfile-editor`](Modelfile-editor) | Model Template | Tweaked Ollama configuration for `qwen2.5-coder:7b` (deterministic temperature, 8K context, lightning edits). |
| [`Modelfile-deepseek-general`](Modelfile-deepseek-general) | Model Template | Optimized general-purpose profile for DeepSeek Coder V2 16B. |
| [`Modelfile-deepseek-translate`](Modelfile-deepseek-translate) | Model Template | Highly specialized code translation profile for DeepSeek Coder V2 16B. |
| [`Modelfile-dolphin`](Modelfile-dolphin) | Model Template | Fully unrestricted Llama 3 8B Dolphin config, locked 100% into VRAM for safety-free coding. |
| [`.aider.conf.yml`](.aider.conf.yml) | Global Config | Global settings for Aider. Enables architect mode, auto-testing, and hands-free prompt loops. |
| [`.aider.model.settings.yml`](.aider.model.settings.yml) | Model Settings | Configures model capability settings, edit formats, and token map budgets. |
| [`vibe-check`](vibe-check) | Executable | The universal, language-agnostic compile and test runner. |
| [`vibe-translate`](vibe-translate) | Executable | One-shot code translator script mapping source files directly to target languages. |
| [`vibe-hud`](vibe-hud) | Executable | The terminal-based telemetry and active Ollama triple-model cockpit dashboard. |
| [`vibe-asset`](vibe-asset) | CLI Tool | Programmatic Stable Diffusion sprite generator connecting directly to local ComfyUI. |
| [`vibe-free`](vibe-free) | Executable | Utility script to stop active Ollama instances and flush ComfyUI cache to free VRAM. |
| [`vibe-start`](vibe-start) | Executable | Terminal workspace launcher managing Tmux panes and active profile spins. |
| [`aider.fish`](aider.fish) | Shell Integration | Fish Shell integration wrapper preventing startup timeouts by auto-archiving history. |
| [`setup.sh`](setup.sh) | Shell Script | Automated setup installer managing downloads, paths, and local compilations. |

---

## 🚀 Installation & Usage

### Step 1: Pre-requisites
Ensure you have **Ollama** installed, running, and the base models pulled:
```bash
ollama pull qwen3-coder:30b
ollama pull qwen2.5-coder:7b
ollama pull deepseek-coder-v2:16b
ollama pull dolphin-llama3:8b
```

### Step 2: Run the Installer
Clone this repository and run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```
This script will build your custom tweaked models, install all system utilities to `~/.local/bin`, and configure your global Aider environment.

> [!NOTE]
> Make sure `~/.local/bin` is in your Shell's `PATH` variable. If it is not, add `export PATH="$HOME/.local/bin:$PATH"` to your `~/.zshrc` or `~/.bashrc`.

### Step 3: Run the Environment

You have two excellent choices to run this workspace:

#### Option A: Side-by-Side Split Window Workspace (Recommended 🚀)
If you have **`tmux`** installed, navigate to your active repository and run the launcher with your desired target path and model profile:
```bash
vibe-start [project_directory] [profile]
```
* **Profiles available:**
  * `qwen` (Default dual-model Architect loop)
  * `deepseek` (Lightweight general 16B coding)
  * `translate` (DeepSeek specialized code translation)
  * `uncensored` (Dolphin unrestricted assistant)
* *Example (Uncensored mode):*
  ```bash
  vibe-start ~/Documents/MyGame uncensored
  ```
This automatically launches a split-pane layout: **Aider** will open in the left pane (70% width) and your custom telemetry cockpit **vibe-hud** will open on the right in a single, gorgeous terminal frame!
* *To close the session*: Exit Aider (type `/exit` or `Ctrl+D`) and the Tmux panes will cleanly terminate.

#### Option B: Manual Multi-Terminal Panes
If you prefer standard windows or don't use tmux:
1. **Open a split terminal pane** and start the triple-model cockpit monitor:
   ```bash
   vibe-hud
   ```
2. **Open your active project directory** and start Aider targeting your desired model:
   * *General Uncensored:* `aider --model ollama_chat/dolphin-llama3:8b-tweaked --no-architect`
   * *Standard Architect Loop:* `aider`
3. Type your requests and watch the HUD track your telemetry, CPU physical threading, VRAM allocations, and compilation processes in real time!

---

## 💡 Best Practices

> [!TIP]
> **Keep Chats Fast:** Over long coding sessions, your Aider history (`.aider.chat.history.md`) can grow very large, slowing down local model loading and context processing times. Periodically type `/clear` in Aider to prune your conversation history and restore instant startup speeds.

> [!IMPORTANT]
> **No Prompts/Confirmations:** This environment is built for hands-free coding. All `yes/no` prompts are automatically bypassed (`yes-always: true`). Any changes made by Aider that pass the compile test are immediately committed to Git. Work in a clean git branch so you can easily revert or review changes!
