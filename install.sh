#!/bin/bash

# Installation script for Sectigo Unzip Script

SCRIPT_NAME="sectigo-unzip"
INSTALL_DIR=""

# Check if the script is being run as root
if [[ "$EUID" -eq 0 ]]; then
  echo "You are running the installation as root."
  echo "Where do you want to install the script?"
  echo "1) /usr/local/bin (accessible to all users)"
  echo "2) ~/.local/bin (only for the current user)"
  read -p "Select an option (1 or 2): " choice

  if [[ "$choice" == "1" ]]; then
    INSTALL_DIR="/usr/local/bin"
  elif [[ "$choice" == "2" ]]; then
    INSTALL_DIR="$HOME/.local/bin"
  else
    echo "Invalid option. Exiting."
    exit 1
  fi
else
  echo "You are not running the installation as root."
  read -p "Do you want to install the script in ~/.local/bin? (y/n): " choice
  if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    INSTALL_DIR="$HOME/.local/bin"
  else
    echo "Installation aborted. Please run as root to install globally."
    exit 1
  fi
fi

# Create the installation directory if it doesn't exist
if [[ ! -d "$INSTALL_DIR" ]]; then
  mkdir -p "$INSTALL_DIR"
fi

# Copy the script to the installation directory and make it executable
cp sectigo-unzip.sh "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "Installed Sectigo Unzip Script as '$SCRIPT_NAME' in '$INSTALL_DIR'"

# Add to PATH if installed in ~/.local/bin
if [[ "$INSTALL_DIR" == "$HOME/.local/bin" ]]; then
  if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo "Please add '$HOME/.local/bin' to your PATH."
  fi
fi
