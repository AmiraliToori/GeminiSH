# GeminiSH

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Examples](#examples)

## Introduction

GeminiSH is a command-line interface (CLI) tool that allows you to interact with Google's Gemini models directly from your terminal. You can use it to send prompts to the Gemini API and receive responses, making it a convenient way to leverage the power of Gemini for various tasks without leaving your command line.

## Prerequisites

To use GeminiSH, you need the following software installed on your system:

- **bash**: The script is written in bash (`#!/usr/bin/env bash`). Most Unix-like systems have bash pre-installed.
- **curl**: Used to send HTTP requests to the Gemini API.
    - *Installation*: You can download curl from [https://curl.se/download.html](https://curl.se/download.html) or install it using your system's package manager (e.g., `sudo apt install curl` on Debian/Ubuntu, `brew install curl` on macOS).
- **jq**: A lightweight and flexible command-line JSON processor. Used to parse the API response.
    - *Installation*: You can download jq from [https://jqlang.github.io/jq/download/](https://jqlang.github.io/jq/download/) or install it using your system's package manager (e.g., `sudo apt install jq` on Debian/Ubuntu, `brew install jq` on macOS).
- **glow**: A terminal-based markdown reader. Used to render the model's output.
    - *Installation*: You can find installation instructions on the glow repository: [https://github.com/charmbracelet/glow](https://github.com/charmbracelet/glow)
- **GEMINI_API_KEY**: You need a Google Gemini API key to use this script.
    - *Setup*:
        1. Obtain your API key from Google AI Studio: [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
        2. Set the `GEMINI_API_KEY` environment variable. You can do this temporarily for your current session by running:
           ```bash
           export GEMINI_API_KEY="YOUR_API_KEY"
           ```
           Replace `"YOUR_API_KEY"` with your actual API key.
        3. For a permanent setup, add the export line to your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`). For example, if you use bash, add the line to `~/.bashrc` and then run `source ~/.bashrc` to apply the changes.
           ```bash
           echo 'export GEMINI_API_KEY="YOUR_API_KEY"' >> ~/.bashrc
           source ~/.bashrc
           ```
           Remember to replace `"YOUR_API_KEY"` with your actual key.

## Usage

To run GeminiSH, execute the script from your terminal with your prompt enclosed in quotes.

```bash
./GeminiSH.sh "Your prompt here"
```

**Arguments:**

- **Prompt (Required)**: The first argument is the text prompt you want to send to the Gemini model. It should be enclosed in quotation marks.
- **Model (Optional)**: The second argument allows you to specify which Gemini model to use. If not provided, the script defaults to `gemini-2.0-flash`. To specify a model, pass its name as the second argument. For example:
  ```bash
  ./GeminiSH.sh "Translate 'hello' to Spanish" "gemini-1.5-flash"
  ```

The script will then display the model being used and the response from the Gemini API, rendered in your terminal by `glow`.

**Example Output Structure:**

```
MODEL: GEMINI-2.0-FLASH

<Formatted response from the model>
```

## Examples

Here are a couple of examples of how to use GeminiSH:

1.  **Simple Prompt (using default model):**

    ```bash
    ./GeminiSH.sh "What is the capital of France?"
    ```

    This will send the prompt "What is the capital of France?" to the default `gemini-2.0-flash` model.

2.  **Specifying a Different Model:**

    ```bash
    ./GeminiSH.sh "Write a short poem about a robot learning to code" "gemini-1.0-pro"
    ```

    This will send the prompt to the `gemini-1.0-pro` model. (Note: Ensure the model name is valid and accessible with your API key).

3.  **Scripting and Automation:**
    Since GeminiSH is a command-line tool, you can integrate it into your shell scripts or other automation workflows. For example, you could use it to generate commit messages or summarize text.

    ```bash
    # Example: Generate a commit message based on staged changes (conceptual)
    # Note: This is a simplified example. You'd need to process 'git diff' output.
    # CHANGES=$(git diff --staged)
    # COMMIT_MSG_PROMPT="Write a concise git commit message for the following changes: $CHANGES"
    # ./GeminiSH.sh "$COMMIT_MSG_PROMPT"
    ```
