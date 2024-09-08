# dotfiles

This contains dotfiles for configuring new environments and most commonly used tools

## usage

Install by executing [project.install.sh](/project.install.sh) from the repository root directory

The following should be installed on the system (installation will fail, unless `FORCE_INSTALL` is set ):

The following variables can be used to influence the install process:

- `INSTALL_TARGETS`: Use this to specify one or more of the following targets to only install modules with it included in the `MODULE__targets` array in its `module.netadata` file:
  - `all`: All targets will install this module
  - `workstation`
  - `server`
- `FORCE_INSTALL`: No binary search on install if this is set to `true` or `1`

<br>

Copyright 2024 Ole A. Sjo Fasting

License MIT
