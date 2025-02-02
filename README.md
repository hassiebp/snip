# ✂️ Snip CLI

Snip CLI is a lightweight command-line tool for macOS that lets you easily save, retrieve, and manage text snippets. It supports both single-line and multi-line snippets, and uses fzf for interactive selection and pbcopy to copy snippets to your clipboard.

## Features

- **Multi-line Snippets**:
  Use your favorite editor (default: vi) to create multi-line snippets that are stored with escaped newlines.

- **Single-line Snippets**:
  Quickly add single-line snippets directly from the command line.

- **Interactive Retrieval**:
  Use fzf for fuzzy searching and selecting stored snippets.

- **Clipboard Integration**:
  Automatically unescapes newlines and copies the snippet to your clipboard using pbcopy.

## Requirements

- macOS
- Dependencies:
  - fzf for interactive snippet selection.
  - pbcopy (comes with macOS) for clipboard integration.
  - A default editor (configured via the EDITOR environment variable; defaults to vi).

## Installation

You can install Snip using the provided install script. Open your terminal and run:

```bash
curl -sSL https://raw.githubusercontent.com/hassiebp/snip/master/install.sh | sh
```

This script will:

- Check that you are on macOS.
- Download the snip.sh script from the repository.
- Install it to /usr/local/bin (or ~/bin if you don’t have permission to write to /usr/local/bin).
- Make it executable.

Make sure the install directory is in your PATH so you can run snip from anywhere.

## Usage

### Add a Multi-line Snippet

Launch your editor to add a new multi-line snippet:

```bash
snip -e
```

After editing, the snippet is saved with escaped newlines (\n), so it can be stored as a single line.

### Retrieve a Snippet

Without any arguments, snip will launch an interactive selection using fzf. Select a snippet to have it unescaped and copied to your clipboard:

```bash
snip
```

### Add a Single-line Snippet

Pass text directly on the command line to save it as a single-line snippet:

```bash
snip "This is a quick snippet"
```

## Contributing

Contributions are welcome! Feel free to open issues, submit pull requests, or discuss features on the GitHub repository.

## License

This project is licensed under the MIT License.
