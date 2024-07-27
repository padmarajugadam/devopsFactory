#!/bin/bash
# Run this script as ./installtf.sh 1.3.7

set -E

# Function to install Terraform
instf() {
  # Check if a version was provided
  if [ "$#" -ne 1 ]; then
    echo "No terraform version mentioned"
    exit 1
  fi

  ver="$1"

  echo "Version to install is $ver"

  # Download and install Terraform
  wget -q https://releases.hashicorp.com/terraform/$ver/terraform_${ver}_linux_amd64.zip
  if [ $? -ne 0 ]; then
    echo "Failed to download Terraform version $ver"
    exit 1
  fi

  sudo unzip -o terraform_${ver}_linux_amd64.zip -d /usr/local/bin/
  if [ $? -ne 0 ]; then
    echo "Failed to unzip Terraform version $ver"
    exit 1
  fi

  # Clean up
  rm terraform_${ver}_linux_amd64.zip

  # Verify installation
  terraform -v

  # Update .bashrc
  echo 'export TF_LOG="DEBUG"' >> $HOME/.bashrc
  echo 'export TF_LOG_PATH="$HOME/tf.log"' >> $HOME/.bashrc

  echo "Terraform $ver installed successfully."
}

# Function to check if Terraform is installed
versionchk() {
  # Check if Terraform is installed
  if command -v terraform >/dev/null 2>&1; then
    echo "Terraform is already installed:"
    terraform version
  else
    echo "No Terraform installed/found"
    echo "Installing the version $1"
    instf $1

  fi
}

# Main script execution
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

versionchk "$1"

