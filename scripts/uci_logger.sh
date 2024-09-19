#!/bin/bash

# Function to install jq if it's not available
install_jq() {
    # Detect the OS and install jq accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -x "$(command -v apt)" ]; then
            sudo apt update && sudo apt install -y jq
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y epel-release && sudo yum install -y jq
        elif [ -x "$(command -v dnf)" ]; then
            sudo dnf install -y jq
        else
            echo "Unsupported Linux package manager. Please install jq manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [ -x "$(command -v brew)" ]; then
            brew install jq
        else
            echo "Homebrew is not installed. Please install Homebrew and try again."
            exit 1
        fi
    else
        echo "Unsupported operating system. Please install jq manually."
        exit 1
    fi

    # Verify installation
    if ! command -v jq &> /dev/null; then
        echo "jq installation failed. Please install it manually."
        exit 1
    else
        echo "jq installed successfully."
    fi
}

# Validate input
if [ -z "$SECTION" ] || [ -z "$KEY" ]; then
    echo "Usage: $0 <section> <key>"
    exit 1
fi

# Check if jq is installed, install if needed
if ! command -v jq &> /dev/null; then
    install_jq
fi

# Script to update JSON file using jq
SECTION=$1
KEY=$2
EXIT_CODE=$3

# Set the value to true or false without quotes if it's a boolean
if [[ $EXIT_CODE == "0" ]]; then
  jq --indent 4 ".$SECTION += {\"$KEY\": \"successful\"}" "$GITHUB_ACTION_PATH"/uci_checks.json > uci_checks.tmp \
  && mv uci_checks.tmp "$GITHUB_ACTION_PATH"/uci_checks.json
  echo "UCI $SECTION check $KEY successful."
else
  jq --indent 4 ".$SECTION += {\"$KEY\": \"failed\"}" "$GITHUB_ACTION_PATH"/uci_checks.json > uci_checks.tmp \
  && mv uci_checks.tmp "$GITHUB_ACTION_PATH"/uci_checks.json
  echo "UCI $SECTION check $KEY failed."
fi