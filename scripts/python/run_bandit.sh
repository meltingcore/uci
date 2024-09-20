#!/usr/bin/env bash

set -o pipefail

if [[ -f $GITHUB_WORKSPACE/.bandit.yml ]]; then
  BANDIT_CONFIG=$GITHUB_WORKSPACE/.bandit.yml
else
  BANDIT_CONFIG=$GITHUB_ACTION_PATH/configs/.bandit.yml
fi

bandit -c "$BANDIT_CONFIG" -r "$GITHUB_WORKSPACE" | tee "$GITHUB_WORKSPACE"/reports/python/bandit.log
uci_logger python bandit $?