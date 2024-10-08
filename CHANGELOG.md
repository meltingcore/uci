# 2.0.2

IMPROVEMENTS:

* [BREAKING CHANGE] Refactor the whole solution to use 
taskfile for parallelism
* [BREAKING CHANGE] `uci.env` introduced as configuration file
in place of arguments to the actino itself
* Now comes with default configuration files for the checks
that support them
* Add separate workflow for development snapshots

BUGFIXES:

* Adjust the documentation to reflect the changes
* Adjust the `tag-on-dev` workflow to run on PR updates

# 1.0.2

IMPROVEMENTS:

* Adds CHANGELOG.md and switch to stable versioning
* Switch `preprelease` to `false` in the release creation action

BUGFIXES:

* tags (except the major version ones) are no longer
forcefully overwritten remotely
* the petname separator is now a correctly a space
* new releases are marked now correctly marked as latest

# 0.1.2

IMPROVEMENTS:

* Merge the 2 github workflows in one and heavily refactor them
* Get rid of the update major tag action

BUGFIXES:

* Make sure the run steps in the composite action specify the shell to use

# 0.1.1

BUGFIXES:

* strings are now in double quotes

# 0.1.0

Initial version
