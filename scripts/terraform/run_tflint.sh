#!/usr/bin/env bash

set -o pipefail

if [[ -f $GITHUB_WORKSPACE/.tflint.hcl ]]; then
  TFLINT_CONFIG=$GITHUB_WORKSPACE/.tflint.hcl
else
  TFLINT_CONFIG=$GITHUB_ACTION_PATH/configs/.tflint.hcl
fi

tflint --config "$TFLINT_CONFIG" --chdir "$GITHUB_WORKSPACE" --recursive | tee "$GITHUB_WORKSPACE"/reports/terraform/tflint.log
uci_logger terraform tflint $?