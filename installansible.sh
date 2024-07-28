#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Ansible is installed
if command_exists ansible; then
    echo "Ansible is already installed."
else
    echo "Ansible is not installed. Installing Ansible..."

    # Update package list
    sudo apt update
    
    # Install Ansible
    sudo apt install -y ansible
    
    # Verify installation
    if command_exists ansible; then
        echo "Ansible has been successfully installed."
    else
        echo "Failed to install Ansible."
        exit 1
    fi
fi

