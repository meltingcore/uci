<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [UCI](#uci)
   * [Usage](#usage)
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