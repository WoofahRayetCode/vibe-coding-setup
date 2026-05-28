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
                  │  (Designs & Plans)     │      Configured with 32K context
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

### 2. Zero-Interruption Auto-Fix Loop (`vibe-check`)
Every time Aider applies a code modification, it automatically invokes the **`vibe-check`** script:
* `vibe-check` dynamically detects your project type (supporting C# `.csproj`, Rust `Cargo.toml`, Node.js `package.json`, Python, and Go).
* It automatically triggers the appropriate compile or test command (e.g., `dotnet build`, `cargo test`, `npm test`).
* **If it compiles cleanly**: Aider automatically commits the changes to Git.
* **If it fails to compile**: Aider feeds the compiler error logs back to the Architect model in a loop, correcting the code automatically until it compiles.

### 3. Real-Time Telemetry HUD (`vibe-hud`)
A pure-Bash terminal telemetry dashboard runs in a split pane, giving you instant hardware and AI pipeline observability:
* **System CPU Usage & Temperatures**: Parsed directly from `/proc/stat` and thermal zones.
* **NVIDIA GPU Load & VRAM Bar**: Displays real-time GPU load, GPU temp, and exact VRAM capacity/percentage.
* **Ollama Active States**: Tracks what models are currently loaded in VRAM, detailing exactly when Aider is `Designing Plan...`, `Applying Edits...`, or standing by.

### 4. Dual-Model Reliability & Edge Cases
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
| **qwen3-coder:30b-tweaked** (Architect) | ~18 GB | **Hybrid GPU + CPU RAM** | Highly intelligent conceptual plans and C# structure designs, utilizing CPU system memory and GPU offloading seamlessly. |

---

## 🛠️ Setup Component Breakdown

Here are the key configuration files and utilities provided in this repository:

| File / Folder | Role | Description |
| :--- | :--- | :--- |
| [`Modelfile-architect`](Modelfile-architect) | Model Template | Tweaked Ollama configuration for `qwen3-coder:30b` (low temperature, 32K context window, tailored system instructions). |
| [`Modelfile-editor`](Modelfile-editor) | Model Template | Tweaked Ollama configuration for `qwen2.5-coder:7b` (deterministic temperature, 32K context, zero-filler coding instructions). |
| [`.aider.conf.yml`](.aider.conf.yml) | Global Config | Global settings for Aider. Enables architect mode, sets `vibe-check` as the test command, activates auto-testing, enables git history restore, and activates hands-free prompts. |
| [`.aider.model.settings.yml`](.aider.model.settings.yml) | Model Settings | Configures model settings. Force-pairs `qwen3-coder:30b-tweaked` (Architect) with `qwen2.5-coder:7b-tweaked` (Editor), configures `editor-whole` format, and expands the Repository Map token budget. |
| [`vibe-check`](vibe-check) | Executable | The universal, language-agnostic compile and test runner. |
| [`vibe-hud`](vibe-hud) | Executable | The terminal-based telemetry and active Ollama model status dashboard. |
| [`vibe-start`](vibe-start) | Executable | Terminal workspace manager. Automatically launches Aider and `vibe-hud` side-by-side in a split window session using Tmux. |
| [`aider.fish`](aider.fish) | Shell Integration | Fish Shell wrapper function. Automatically archives Large chat history files (>25KB) on startup to prevent local CPU connection timeout loops. |
| [`setup.sh`](setup.sh) | Shell Script | Automates building models in Ollama, installing executables to `~/.local/bin/`, copying configuration files, and installing shell integrations. |

---

## 🚀 Installation & Usage

### Step 1: Pre-requisites
Ensure you have **Ollama** installed, running, and the base models pulled:
```bash
ollama pull qwen3-coder:30b
ollama pull qwen2.5-coder:7b
```

### Step 2: Run the Installer
Clone this repository and run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```
This script will build your custom tweaked models, install `vibe-check` and `vibe-hud` to `~/.local/bin`, and configure your global Aider environment.

> [!NOTE]
> Make sure `~/.local/bin` is in your Shell's `PATH` variable. If it is not, add `export PATH="$HOME/.local/bin:$PATH"` to your `~/.zshrc` or `~/.bashrc`.

### Step 3: Run the Environment

You have two excellent choices to run this workspace:

#### Option A: Side-by-Side Split Window Workspace (Recommended 🚀)
If you have **`tmux`** installed, navigate to your active repository and run the unified workspace command:
```bash
vibe-start
```
This automatically launches a split-pane layout: **Aider** will open in the left pane (70% width) and **vibe-hud** will open in the right pane (30% width) in a single, gorgeous terminal frame!
* *To close the session*: Exit Aider (type `/exit` or `Ctrl+D`) and then close the panes (type `exit` or press `Ctrl+D` in `vibe-hud`).

#### Option B: Manual Multi-Terminal Panes
If you prefer standard windows or don't use tmux:
1. **Open a split terminal pane** and start the telemetry dashboard:
   ```bash
   vibe-hud
   ```
2. **Open your active project directory** and start Aider:
   ```bash
   aider
   ```
3. Type your feature requests in Aider and watch the HUD swap models and compile code dynamically in real time!

---

## 💡 Best Practices

> [!TIP]
> **Keep Chats Fast:** Over long coding sessions, your Aider history (`.aider.chat.history.md`) can grow very large, slowing down local model loading and context processing times. Periodically type `/clear` in Aider to prune your conversation history and restore instant startup speeds.

> [!IMPORTANT]
> **No Prompts/Confirmations:** This environment is built for hands-free coding. All `yes/no` prompts are automatically bypassed (`yes-always: true`). Any changes made by Aider that pass the compile test are immediately committed to Git. Work in a clean git branch so you can easily revert or review changes!
