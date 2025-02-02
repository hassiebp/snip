#!/bin/bash
# snip.sh - A modular snippet management tool.

# Configuration
EDITOR="${EDITOR:-vi}"
SNIP_FILE="$HOME/.snip/data"
mkdir -p "$(dirname "$SNIP_FILE")"
touch "$SNIP_FILE"

usage() {
  cat <<EOF
Usage: snip.sh [OPTIONS] [snippet]
A CLI tool for managing code snippets.

Options:
  -e            Open editor for multi-line snippet entry.
  -h, --help    Show this help message.
  --version     Show version information.

If no snippet is provided, the tool will launch an interactive selection.
EOF
}

version() {
  echo "snip version 0.1"
}

# Basic option parsing
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit 0
fi

if [ "$1" = "--version" ]; then
  version
  exit 0
fi

########################################
# Escape newlines in a file.
# Reads the file passed as first argument,
# trims leading/trailing whitespace on each line,
# and outputs a single line with literal "\n" between lines.
#
# Globals:
#   None
# Arguments:
#   $1 - file to process
# Outputs:
#   Escaped snippet on stdout.
########################################
escape_newlines() {
  local file="$1"
  awk 'NF {
    sub(/^[[:space:]]*/, "");
    sub(/[[:space:]]*$/, "");
    if (NR > 1) printf "\\n";
    printf "%s", $0
  }' "$file"
}

########################################
# Unescape newlines in a snippet.
# Converts literal "\n" sequences back into actual newline characters.
#
# Globals:
#   None
# Arguments:
#   $1 - snippet text with escaped newlines
# Outputs:
#   Unescaped snippet on stdout.
########################################
unescape_newlines() {
  # Use awk to replace literal "\n" with real newline characters.
  echo "$1" | awk '{gsub(/\\n/, "\n")}1'
}

########################################
# Add a multi-line snippet using the default editor.
# Opens a temporary file for editing, escapes newlines,
# and appends the result to the snippet file.
#
# Globals:
#   SNIP_FILE, EDITOR
########################################
snip_edit() {
  local tmp snippet
  tmp=$(mktemp)
  "$EDITOR" "$tmp"

  if [[ -s "$tmp" ]]; then
    snippet=$(escape_newlines "$tmp")
    echo "$snippet" >> "$SNIP_FILE"
    echo "Added multi-line snippet."
  else
    echo "No snippet entered."
  fi

  rm -f "$tmp"
}

########################################
# Add a single-line snippet passed as command-line arguments.
#
# Globals:
#   SNIP_FILE
# Arguments:
#   Snippet text as parameters.
########################################
snip_add() {
  echo "$*" >> "$SNIP_FILE"
  echo "Added snippet."
}

########################################
# Select a snippet using fzf and copy it to the clipboard.
# Unescapes the stored snippet before copying.
#
# Globals:
#   SNIP_FILE
########################################
snip_select() {
  local sel snippet
  sel=$(tail -r "$SNIP_FILE" | fzf --reverse --info=inline --height 38% --prompt "snip > " --preview 'echo {}' --preview-window=right:62%:wrap)
  if [ -n "$sel" ]; then
    snippet=$(unescape_newlines "$sel")
    echo "✅ Snippet copied to clipboard:"
    echo
    echo "$snippet" | tee >(pbcopy)
    echo
  fi
}

########################################
# Main logic:
# - If called with "-e": add a multi-line snippet.
# - If no arguments: select a snippet.
# - Otherwise: add a single-line snippet.
########################################
main() {
  if [ "$1" = "-e" ]; then
    snip_edit
  elif [ "$#" -eq 0 ]; then
    snip_select
  else
    snip_add "$@"
  fi
}

# Run the main function with all script arguments.
main "$@"
