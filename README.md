# GeminiSH

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Options](#options)
- [Examples](#examples)

## Introduction

GeminiSH is a command-line interface (CLI) tool that allows you to interact with Google's Gemini models directly from your terminal. You can use it to send prompts to the Gemini API and receive responses in a markdown-rendered format.

## Prerequisites

To use GeminiSH, you need the following software installed on your system:

- **bash**: The script is written in bash (`#!/usr/bin/env bash`). Most Unix-like systems have bash pre-installed.
- **curl**: Used to send HTTP requests to the Gemini API.
    - *Installation*: You can download curl from [https://curl.se/download.html](https://curl.se/download.html) or install it using your system's package manager (e.g., `sudo apt install curl` on Debian/Ubuntu).
- **jq**: A lightweight and flexible command-line JSON processor. Used to parse the API response.
    - *Installation*: Download from [https://jqlang.github.io/jq/download/](https://jqlang.github.io/jq/download/) or install using your system's package manager (e.g., `sudo apt install jq`).
- **glow**: A terminal-based markdown reader. Used to render the model's output.
    - *Installation*: Find installation instructions on the glow repository: [https://github.com/charmbracelet/glow](https://github.com/charmbracelet/glow)
- **GEMINI_API_KEY**: You need a Google Gemini API key to use this script.
    - *Setup*:
        1. Obtain your API key from Google AI Studio: [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
        2. Set the `GEMINI_API_KEY` environment variable. For your current session:
            ```bash
            export GEMINI_API_KEY="YOUR_API_KEY"
            ```
           Replace `"YOUR_API_KEY"` with your actual API key.
        3. To set it permanently, add the export line to your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`):
            ```bash
            echo 'export GEMINI_API_KEY="YOUR_API_KEY"' >> ~/.bashrc
            source ~/.bashrc
            ```
           Remember to replace `"YOUR_API_KEY"` with your actual key.

## Usage

Run GeminiSH from your terminal using the following options:

```bash
./GeminiSH.sh -p "Your prompt here"
```

To specify a model:

```bash
./GeminiSH.sh -p "Your prompt here" -m gemini-1.0-pro
```

To list all available models:

```bash
./GeminiSH.sh -l
```

## Options

| Option              | Description                                 |
|---------------------|---------------------------------------------|
| `-p <prompt>`       | Set the prompt to send to Gemini (required) |
| `-m <model_name>`   | Set the Gemini model to use (optional)      |
| `-l`                | List available models (no prompt needed)    |

- If no model is specified with `-m`, the script defaults to `gemini-2.0-flash`.
- To use the options together, combine them as needed. The script does not support positional arguments.

## Examples

1. **Send a prompt using the default model:**
    ```bash
    ./GeminiSH.sh -p "What is the capital of France?"
    ```

2. **Specify a different model:**
    ```bash
    ./GeminiSH.sh -p "Write a short poem about a robot learning to code" -m gemini-1.0-pro
    ```

3. **List available models:**
    ```bash
    ./GeminiSH.sh -l
    ```

4. **Scripting and Automation:**
    Since GeminiSH is a command-line tool, you can integrate it into your shell scripts or other automation workflows. Example (conceptual):
    ```bash
    # Example: Generate a commit message based on staged changes
    # CHANGES=$(git diff --staged)
    # COMMIT_MSG_PROMPT="Write a concise git commit message for the following changes: $CHANGES"
    # ./GeminiSH.sh -p "$COMMIT_MSG_PROMPT"
    ```

## Output

The script will display the model being used and the response from the Gemini API, rendered in your terminal by `glow`:

```
MODEL: GEMINI-2.0-FLASH

<Formatted response from the model>
```

---

**If you encounter issues, ensure all dependencies are installed and the `GEMINI_API_KEY` is set correctly.**
