#!/usr/bin/env bash

set -o pipefail

if [[ -f $GITHUB_WORKSPACE/.trivy.yml ]]; then
  TRIVY_CONFIG=$GITHUB_WORKSPACE/.trivy.yml
else
  TRIVY_CONFIG=$GITHUB_ACTION_PATH/configs/.trivy.yml
fi

trivy config -c "$TRIVY_CONFIG" "$GITHUB_WORKSPACE"/ | tee "$GITHUB_WORKSPACE"/reports/terraform/trivy.log
uci_logger terraform trivy $?