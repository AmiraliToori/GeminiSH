# GeminiSH
Gemini in your terminal!

GeminiSH provides a simple and interactive way to chat with Google's Gemini models directly from your command line, relying only on Bash and common core utilities.

## Features
*   Interactive menu-driven interface.
*   Select from available Gemini models.
*   Multiline input for prompts.
*   Markdown rendering for responses.
*   Saves chat history automatically.
*   View previous conversations from a history menu.

## Requirements
*   **bash**: The script is written in bash.
*   **curl**: Used for making API requests.
*   **jq**: Used for parsing JSON responses.
*   ![glow](https://github.com/charmbracelet/glow): For rendering Markdown in the terminal.
*   ![gum](https://github.com/charmbracelet/gum): For creating interactive terminal UIs.
*   **GEMINI_API_KEY**: You need a Gemini API key exported as an environment variable.
    *   Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey).
*   **Terminal Support**: For the best visual experience and to avoid potential display issues with `gum` and `glow`, it's recommended to use a terminal emulator that supports 256 colors and Truecolor.

## Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/AmirAliToori/GeminiSH.git
    cd GeminiSH
    ```
2.  **Ensure all dependencies are installed.**
    *   For `gum` and `glow`, follow the instructions on their official GitHub pages.
    *   For `curl` and `jq`, use your system's package manager. For example, on Debian/Ubuntu:
        ```bash
        sudo apt update
        sudo apt install curl jq
        ```
        On macOS (using Homebrew):
        ```bash
        brew install curl jq glow gum
        ```
3.  **Set up your API Key:**
    Export your Gemini API key as an environment variable. Add this line to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):
    ```bash
    export GEMINI_API_KEY="YOUR_API_KEY"
    ```
    Replace `"YOUR_API_KEY"` with your actual key. Remember to source your configuration file (e.g., `source ~/.bashrc`) or open a new terminal session.

4.  **Make the scripts executable:**
    ```bash
    chmod +x GeminiSH.sh lib/*.sh
    ```

## Usage

Simply run the main script:

```bash
./GeminiSH.sh
```

This will launch an interactive menu:

1.  **Main Menu:**
    *   **Prompt**: Allows you to enter your prompt for the Gemini model. A multi-line input box will appear. After submitting, a spinner indicates that the model is "thinking," and the response is then displayed.
    *   **Choose a model**: Fetches and displays a list of available Gemini models. You can select a different model to use for your session.
    *   **History**: Displays a list of previous conversations, organized by date and time. You can select an entry to view the full content.
    *   **Exit**: Exits the script.

If the `GEMINI_API_KEY` is not set or is invalid, the script will display an error message.

## Configuration

All configuration is handled in the `configs/config.sh` file, allowing you to customize the application without modifying the core scripts.

### API Key and Model

*   **API Key**: Instead of setting an environment variable in your `~/.bashrc`, you can set your key directly in `configs/config.sh`. Uncomment the following line and add your key:
    ```bash
    # In configs/config.sh
    export GEMINI_API_KEY="<Your GEMINI API KEY goes here!>"
    ```
*   **Default Model**: You can change the default model used for conversations by modifying the `model` variable:
    ```bash
    # In configs/config.sh
    export model="gemini-1.5-pro-latest"
    ```

### Appearance (gum Theme)

The visual theme of the menus and prompts can be customized by changing the `GUM_` environment variables in `configs/config.sh`. These variables control the colors and styles of the `gum` elements. For example, to change the cursor icon and color:
```bash
# In configs/config.sh
export GUM_CHOOSE_CURSOR="🚀 "
export GUM_CHOOSE_CURSOR_FOREGROUND="#FFA500" # Orange
```

## Script Overview

The project is organized into a main script and a `lib` directory containing modular functions for each menu option.

*   **`GeminiSH.sh`**: The entry point of the application. It initializes the environment and launches the main menu.
*   **`configs/config.sh`**: Contains default configuration, such as the default Gemini model.
*   **`lib/`**: Directory containing scripts for specific functionalities.
    *   **`main_menu.sh`**: Displays the primary navigation menu.
    *   **`take_prompt_menu.sh`**: Handles the logic for taking user input, showing a spinner, calling the Gemini API, and displaying the result.
    *   **`choose_model_menu.sh`**: Manages the model selection menu.
    *   **`history_menu.sh`**: Implements the logic for browsing and viewing past conversations.
    *   **`exit_menu.sh`**: Handles the exit confirmation dialog.
    *   **`utils.sh`**: Contains utility functions (like error pages and prompt boxes) used across multiple scripts.
*   **`history/`**: Directory where conversation logs are automatically saved in Markdown files, organized by date.

---
Developed by: Amirali Toori
GitHub: @AmirAliToori
---
