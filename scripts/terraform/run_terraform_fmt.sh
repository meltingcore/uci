#!/usr/bin/env bash

set -o pipefail

terraform fmt -recursive "$GITHUB_WORKSPACE" | tee reports/terraform/terraform_fmt.log
uci_logger terraform terraform_fmt $?