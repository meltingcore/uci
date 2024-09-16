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
  Linux*)
    os="linux"
    ;;
  *)
    echo "Unsupported OS."
    exit 1
    ;;
esac

echo "Detected OS: $os"

# Function to install Python on Linux using package managers
install_python_linux() {
    if command -v apt-get >/dev/null; then
        echo "Detected apt-based system. Installing Python using apt..."

        # Retry mechanism to handle lock file issue
        retries=40
        wait_time=3

        set +e
        for ((i=1; i<=retries; i++)); do
            if sudo apt-get update; then
                sudo apt-get install -y python3 python3-pip
                break
            else
                echo "Attempt $i: Could not get lock, retrying in $wait_time seconds..."
                sleep $wait_time
            fi

            # If it's the last retry, exit with failure
            if [[ $i -eq $retries ]]; then
                echo "Failed to acquire the lock after 2 minutes. Exiting..."
                exit 1
            fi
        done
        set -e
    elif command -v dnf >/dev/null; then
        echo "Detected dnf-based system. Installing Python using dnf..."
        sudo dnf install -y python3 python3-pip
    elif command -v yum >/dev/null; then
        echo "Detected yum-based system. Installing Python using yum..."
        sudo yum install -y python3 python3-pip
    else
        echo "No compatible package manager found for Linux."
        exit 1
    fi
}

# Install Python based on the OS
if [[ $os == "linux" ]]; then
  echo "Installing Python on Linux ..."
  install_python_linux
elif [[ $os == "darwin" ]]; then
  echo "Installing Python on macOS ..."
  brew install python
else
  echo "Windows is not supported by this script. Please install Python manually."
  exit 1
fi

# Verify installation
echo "===================================================="
echo "Python installed successfully!"
echo "Current Python version:"
python3 --version

# Upgrade pip
echo "Upgrading pip ..."
python3 -m pip install --upgrade pip

echo "===================================================="
echo "Python and pip setup complete!"