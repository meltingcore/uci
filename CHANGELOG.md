# 1.1.0

IMPROVEMENTS:

* Add separate workflow for development snapshots

BUGFIXES:

* attempt to remediate pylint command error

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
