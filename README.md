# GeminiSH
Gemini in your terminal!

GeminiSH provides a simple and interactive way to chat with Google's Gemini models directly from your command line, relying only on Bash and common core utilities.

## Features
*   Interactive menu-driven interface.
*   Select from available Gemini models.
*   Multiline input for prompts.
*   Markdown rendering for responses.

## Requirements
*   **bash**: The script is written in bash.
*   **curl**: Used for making API requests.
*   **jq**: Used for parsing JSON responses.
*   **awk**: Used for text manipulation (listing models).
*   ![glow](https://github.com/charmbracelet/glow)
*   ![gum](https://github.com/charmbracelet/gum)
*   **GEMINI_API_KEY**: You need a Gemini API key exported as an environment variable.
    *   Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey).
*   **Terminal Support**: For the best visual experience and to avoid potential display issues with `gum` and `glow`, it's recommended to use a terminal emulator that supports 256 colors and Truecolor.

## Installation & Setup

1.  **Clone the repository (or download the scripts):**
    ```bash
    git clone <your-repo-url> # Replace <your-repo-url> with the actual URL
    cd GeminiSH
    ```
2.  **Ensure all dependencies are installed.**
    *   For `gum`, follow the instructions [here](https://github.com/charmbracelet/gum#installation).
    *   For `curl`, `jq`, `awk`, and `glow`, use your system's package manager. For example, on Debian/Ubuntu:
        ```bash
        sudo apt update
        sudo apt install curl jq gawk glow
        ```
        On macOS (using Homebrew):
        ```bash
        brew install curl jq gawk glow gum
        ```
3.  **Set up your API Key:**
    Export your Gemini API key as an environment variable. Add this line to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):
    ```bash
    export GEMINI_API_KEY="YOUR_API_KEY"
    ```
    Replace `"YOUR_API_KEY"` with your actual key. Remember to source your configuration file (e.g., `source ~/.bashrc`) or open a new terminal session.

4.  **Make the scripts executable:**
    ```bash
    chmod +x GeminiSH.sh lib/ui.sh lib/models_list.sh lib/gradient_color.sh configs/gum_vars.sh
    ```

## Usage

Simply run the main script:

```bash
./GeminiSH.sh
```

This will launch an interactive menu:

1.  **Intro Screen:** Displays the script name, developer, and default model.
2.  **Main Menu:**
    *   **Prompt**: Allows you to enter your prompt for the Gemini model. A multi-line input box will appear. After submitting your prompt, the script will fetch and display the model's response.
    *   **Choose a model**: Fetches and displays a list of available Gemini models. You can select a different model to use for your session. The default model is `gemini-1.5-flash`.
    *   **History**: Displays a list of previous prompts and responses from the current session. You can select an entry to view the full conversation.
    *   **Exit**: Exits the script.

If the `GEMINI_API_KEY` is not set or is invalid, the script (especially when trying to list models) will display an error message.

## Script Overview

*   **`GeminiSH.sh`**: The main script that orchestrates the UI and API calls.
*   **`lib/ui.sh`**: Handles all user interface elements using `gum`, including menus and prompt input.
*   **`lib/models_list.sh`**: Fetches the list of available Gemini models from the API.

---
Developed by: Amirali Toori
GitHub: @AmirAliToori
