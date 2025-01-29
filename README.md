# dotfiles

This repo contains dotfiles for userspace and basic tools

## install

Execute [./install.sh](/install.sh) to symlink files into the current users home directory

## config

The following environment variables can be used to influence the process:

* 'DEBUG': If set to '1', debug mode will be activated, enabling debug code paths and setting verbosity to '1' (debug). Default is '0' (off)
* 'VERBOSITY': This can be set to a severity rating, in order to mute any output not of the same or higher severity. Default is '3' (info)
* 'DO_BACKUP': If set to '1', any existing files and folders will be backed up with an '.old' suffix. Default is '0' (off)

## logging

Log output will be generated according to the current verbosity setting (see the [config section](##config) above for details). Verbosity can be set to a number between 0 and 5, representing the minimum severity rating of any output to be generated. The severity ratings for the different output types are as follows:

0) none (silent)
1) debug
2) trace
3) info (default)
4) warning
5) error

When verbosity is set to a severity rating, any messages of the same or of higher severity, will be output

LICENSE MIT

Copyright 2025 Ole A. Sjo Fasting
