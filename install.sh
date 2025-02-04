#! /usr/bin/env bash

set -e

DEPSFILE="dotfiles-deps.txt"

# print coloured text:
function echo_colour() {
    case "$1" in
    "green")
        colour=32m
        ;;
    "red")
        colour=31m
        ;;
    "yellow")
        colour=33m
        ;;
    *)
        colour=0m
        ;;
    esac
    echo -e "\n\033[0;$colour$2\033[0m"
}

# install all packages from deps file:
function install_packages() {
    if [ -f "$1/$DEPSFILE" ]; then
        echo_colour "green" "Installing packages from $1/$DEPSFILE"
        # squash all lines from deps file into one string so we can install all packages at once:
        packages=$(cat $1/$DEPSFILE | tr '\n' ' ')
        echo_colour "green" "  Installing packages: $packages"
        sudo apt install -y $packages
    else
        echo_colour "yellow" "  WARNING: $DEPSFILE not found."
    fi
}

# symlink everything in $1 into $HOME:
function stow_directory() {
    # check if directory exists
    if [ ! -d "$1" ]; then
        echo_colour "red" "Directory $1 does not exist."
        return
    fi
    echo_colour "green" "Stowing $1"
    stow --verbose --target="$HOME" --restow $1
}

function main() {

    # check we have at least one argument
    if [ "$#" -lt 1 ]; then
        echo_colour "red" "Usage: $0 <directory1> [<directory2> ...]"
        exit 1
    fi

    # ensure directories exist to avoid creating dir symlinks and overwriting
    # any local setup outside of here
    mkdir -p \
        "$HOME/.ssh" \
        "$HOME/.oh-my-zsh/custom" \
        "$HOME/.oh-my-zsh-custom/plugins"

    # update submodules so we're installing the latest versions of ohmyzsh and plugins
    git submodule update --remote


    echo_colour "green" "Updating and upgrading lists/packages..."
    sudo apt update
    sudo apt upgrade -y

    for folder in $@; do
        install_packages $folder
    done

    echo_colour "green" "Cleaning old packages up..."
    sudo apt autoremove -y
    sudo apt autoclean

    # check zsh is installed, and set it as default shell if not already
    if ! command -v zsh &>/dev/null; then
        echo_colour "red" "zsh is not installed. Please install zsh first."
        exit 1
    fi
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        echo_colour "green" "Setting zsh as default shell..."
        chsh -s $(command -v zsh)
    fi

    echo_colour "green" "Installing dotfiles..."
    for folder in $@; do
        stow_directory $folder
    done

    echo_colour "green" "Done"
    exit 0
}

# cd to the directory of this script and run it:
cd "$(dirname $0)"
main "$@"
