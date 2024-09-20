#!/usr/bin/env bash

if grep -q failed "$GITHUB_ACTION_PATH"/uci_checks.json; then
  echo "Failed UCI checks found"
  exit 1
else
  echo "All UCI checks passed"
  exit 0
fi