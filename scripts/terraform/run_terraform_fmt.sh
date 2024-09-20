#!/usr/bin/env bash

set -o pipefail

terraform fmt -check -recursive "$GITHUB_WORKSPACE" | tee "$GITHUB_WORKSPACE"/reports/terraform/terraform_fmt.log
uci_logger terraform terraform_fmt $?