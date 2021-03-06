<img width="256"
     src="./confie.png"
     alt="Confie - configuration manager">

#### The fast and portable configuration manager for GNU/Linux systems.

##### WARNING: Still highly experimental so use with caution!

Confie is a portable and extensible configuration manager for the everyday user 
to simplify the process of maintaining a system's configuration files and packages
while transferring them with ease across different installations.

## Features
* Easy to use
* Static binary with no dependencies
* Easily configurable
* Supports many package managers

## Usage

Confie is made to be included as a binary in repositories containing dotfiles for 
easy redistribution. It checks the current directory for a valid configuration file
and supports the following:

**Installing packages/dotfiles**

Install packages and/or dotfiles as defined in the config

```bash
# Install all packages
$ confie install packages

# Install all dotfiles
$ confie install dotfiles

# Install everything
$ confie install
```
**Printing configuration**

Print the config in a user-friendly format

```bash
$ confie print-config
```

**Fetching changes**

Fetch all dotfiles from the system and overwrite local changes

```bash
$ confie fetch
```

## Configuring
Configuration should be located in a file named `confie.cfg` which is
in `ini` format.

A sample config goes as follows:
```ini
packages="""
emacs
nvim
i3
alacritty
"""

[nvim]
local_path = "nvim"
install_path = "~/.config/nvim"

[emacs]
local_path = "emacs"
install_path = "~/.emacs.d"
```

The `packages` key contains the list of packages to be installed using the system's package manager.

NOTE: packages should always be surrounded with three double quotes as seen above

Sections such as `[nvim]` are named after the package they represent and contain 2 keys:
* `local_path` which is the path to the directory containing the configuration
* `install_path` which is the path to install the files defined in local_path

## Installation
To build from source, make sure you have [Nim](https://nim-lang.org/install_unix.html) and 
[Make](https://www.gnu.org/software/make/) installed and run `make` in the project folder. 
An executable will appear which you can copy to your path or your repository.
