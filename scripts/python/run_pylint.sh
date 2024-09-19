#!/usr/bin/env bash

set -o pipefail

if [[ -f $GITHUB_WORKSPACE/.pylintrc ]]; then
  PYLINT_CONFIG=$GITHUB_WORKSPACE/.pylintrc
else
  PYLINT_CONFIG=$GITHUB_ACTION_PATH/configs/.pylintrc
fi

pylint --rcfile "$PYLINT_CONFIG" --recursive=y "$GITHUB_WORKSPACE" | tee reports/python/pylint.log
uci_logger python pylint $?