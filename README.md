<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [UCI](#uci)
   * [Usage](#usage)
   * [Change tools versions](#change-tools-versions)
   * [Development](#development)
   * [Checks](#checks)

<!-- TOC end -->

# UCI

Universal CI GitHub Action to add in your workflows.

## Usage

You can set it up to run on creating or updating
pull requests like this:

```yaml
name: Your workflow name

on: pull_request

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout the source code
        uses: actions/checkout@v4

      - name: Run UCI checks
        uses: meltingcore/uci@v1
```

## Change tools versions

By default, the tools' versions being used are:

* python: `3.x` (latest from v3)
  * pylint: `""` (latest from pip)
  * bandit: `""` (latest from pip)
* terraform: `latest`
  * tflint: `latest`
  * trivy: `latest` (cannot be modified)

Almost never you would want to change the defaults but if you do, you
can change what version is being used for a particular tool as follows:

```yaml
      - name: Run UCI checks
        uses: meltingcore/uci@v1
        with:
          python_version: '3.9'
          pylint_version: '>=3.0.0'
          bandit_version: '==1.7.3'
          terraform_version: '1.0.0'
          tflint_version: 'v0.36.2'  
```

**NOTES**

* The tools that are installed via pip support constraints as
seen from the examples above.
* Trivy is handled via GitHub Action that does not support version
as argument so you cannot adjust it... It will always be the latest.

## Development

Every PR that is created or updated but not merged should trigger
a workflow that creates a tag named after the developement branch
that is attempted to be merged to the main branch. So if you want to
validate any changes before your PR is ready for review, and your
development branch name is `bugfix/something`, you can just
invoke the uci action with your branch name as follows:

```yaml
      - name: Run UCI checks
        uses: meltingcore/uci@bugfix/something
```

## Checks

Currently, contains the following checks:

* **Python**
  * pylint
  * bandit
* **Terraform**
  * terraform fmt
  * tflint
  * trivy

You can disable some checks if you don't need them as follows:

* Disabling technology as a whole (i.e. don't do any Python related checks):

```yaml
      - name: Run UCI checks
        uses: meltingcore/uci@v1
        with:
          python_checks: false
```

* Disabling a specific check (i.e. don't do bandit checks only):

```yaml
      - name: Run UCI checks
        uses: meltingcore/uci@v1
        with:
          bandit_checks: false
```

For more information and details, you can examine the
[action](./.github/actions/ci/action.yml) file itself.

## TBD

* Split the taskfile to multiple ones based on technology and 
optionally include them if the checks for the technology is enabled.
* Redesign the paramters to be set in an one config .env file
that the taskfile will use.
* Implement default config to be applied if custom one is not present
in the repo where the uci action is used.