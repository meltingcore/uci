#!/usr/bin/env bash

set -e
set -o pipefail

# Function to detect machine architecture
get_machine_arch () {
    machine_arch=""
    case $(uname -m) in
        i386)     machine_arch="386" ;;
        i686)     machine_arch="386" ;;
        x86_64)   machine_arch="amd64" ;;
        arm64)    machine_arch="arm64" ;;
        aarch64)  dpkg --print-architecture | grep -q "arm64" && machine_arch="arm64" || machine_arch="arm" ;;
    esac
    echo $machine_arch
}
arch=$(get_machine_arch)

echo "Detected architecture: $arch"

# Detect Operating System
case "$(uname -s)" in
  Darwin*)
    os="darwin"
    ;;
  MINGW64*|MSYS_NT*)
    os="windows"
    ;;
  *)
    os="linux"
    ;;
esac

echo "Detected OS: $os"

# Function to get the latest Terraform release version
get_latest_release() {
  headers=()
  if [ -n "${GITHUB_TOKEN}" ]; then
      headers=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi
  curl --fail -sS "${headers[@]}" "https://api.github.com/repos/hashicorp/terraform/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

# Prepare the download path
download_path=$(mktemp -d -t terraform.XXXXXXXXXX)
download_zip="${download_path}/terraform.zip"
download_executable="${download_path}/terraform"

# Determine Terraform version to install
if [ -z "${UCI_TERRAFORM_VERSION}" ] || [ "${UCI_TERRAFORM_VERSION}" == "latest" ]; then
  echo "Looking up the latest version of Terraform ..."
  if [ -n "${GITHUB_TOKEN}" ]; then
    echo "Requesting with GITHUB_TOKEN ..."
  fi
  version=$(get_latest_release)
else
  version=${UCI_TERRAFORM_VERSION}
fi

# Remove the 'v' prefix if present
version=${version#v}

echo "Installing Terraform version: $version"

# Construct the Terraform download URL
terraform_url="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${os}_${arch}.zip"

echo "Downloading Terraform from: $terraform_url"
curl --fail -sS -L -o "${download_zip}" "${terraform_url}"
echo "Terraform downloaded successfully."

# Unzip the Terraform executable
echo "Unpacking Terraform archive ${download_zip} ..."
unzip -o "${download_zip}" -d "${download_path}"

# Install Terraform based on the OS
if [[ $os == "windows" ]]; then
  dest="${TERRAFORM_INSTALL_PATH:-/bin}/"
  echo "Installing Terraform to ${dest} ..."
  mv "${download_executable}" "$dest"
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Failed to install Terraform."
    exit $retVal
  else
    echo "Terraform installed at ${dest} successfully."
  fi
else
  dest="${TERRAFORM_INSTALL_PATH:-/usr/local/bin}/"
  echo "Installing Terraform to ${dest} ..."

  if [[ -w "$dest" ]]; then SUDO=""; else
    SUDO="sudo"
  fi

  $SUDO mkdir -p "$dest"
  $SUDO install -c -v "${download_executable}" "$dest"
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Failed to install Terraform."
    exit $retVal
  fi
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "${download_path}"

# Verify installation
echo "===================================================="
echo "Terraform installed successfully!"
echo "Current Terraform version:"
"${dest}/terraform" -v