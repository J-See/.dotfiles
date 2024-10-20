#!/bin/bash

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview-window=80%"

set -o errexit # exit on error
set -o pipefail # fail the pipe if any of its command fails
set -o nounset # if any variable is undefined exit


# dynamic help message
declare -A options=(
    ["-h"]="Show [h]elp message"
    ["-i"]="[i]nstall packages from internet"
    ["-r"]="[r]emove packages"
    ["-o"]="[r]emove [o]rphans"
    ["-d"]="[d]atabase update"
    ["-u"]="[u]pdate system"
    ["-e"]="[e]mpty cache"
)
# Desire order
ordered_options=(
    "-h"
    "-i"
    "-r"
    "-o"
    "-d"
    "-u"
    "-e"
)


show_help(){
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"

    # calculate maximum flag characters
    max_length=0
    for opt in "${!options[@]}"; do
        len=${#opt}
        if (( len>max_length));then
            max_length=$len
        fi
    done

    for opt in "${ordered_options[@]}"; do
        printf "  %-${max_length}s : %s\n" "$opt" "${options[$opt]}"
    done

}

install_pak(){
	local packages=$(sudo pacman --color=always -Sl | sed -E 's: :/:; s/ (\x1b\[[0-9;]*m)?unknown-version/\1/')
	local selected_packages=$(
	    echo "$packages" |\
	    fzf --multi --reverse --ansi --preview "pacman --color=always -Si {1} | grep --color=never -v '^ '" |\
	    awk '{print $1}'
	)

	if [[ -n "$selected_packages" ]]; then
	    echo "Installing Packages...." | awk '{print "\033[32m" $0 "\033[0m"}'
	    echo "$selected_packages" | nl -w2 -s'. '
	    echo

	    echo "$selected_packages" | tr '\n' ' ' |  xargs -ro sudo pacman -S
	fi
}

remove_pak(){
    # List installed packages
    local installed_packages=$(pacman --color=always -Qq | sed -E 's: :/:; s/ (\x1b\[[0-9;]*m)?unknown-version/\1/')

    # Use fzf to select packages to remove
    local selected_packages=$(
        echo "$installed_packages" |\
        fzf --multi --reverse --ansi --preview "pacman --color=always -Qi {1} | grep --color=never -v '^ '" |\
        awk '{print $1}'
    )

    if [[ -n "$selected_packages" ]]; then
        # echo "Removing Packages...." | awk '{print "\033[31m" $0 "\033[0m"}'
        # echo "$selected_packages" | nl -w2 -s'. '
        # echo

        # Ask for user confirmation before removing
        # read -p "Are you sure you want to remove these packages? (y/n): " confirm
        # if [[ "$confirm" != "y" ]]; then
        #     echo "Removal canceled."
        #     return
        # fi

        # # Use pv to show progress during removal
        # echo "$selected_packages" | tr '\n' ' ' | pv -cN "Removing" | xargs -ro sudo pacman -Rns
        echo "$selected_packages" | tr '\n' ' ' | xargs -ro sudo pacman -Rns
    fi
}

remove_orphans(){
    echo -e "pacman -Rsun:- Remove all unneeded (-u) dependencies (-s):\n"
    sudo pacman -Rsun $(pacman -Qdtq) 
}

database_update(){
    sudo pacman -Sy 1> /dev/null 2> /dev/null
}

update_system(){
    echo "System Upgrade:" &&
    # uncomment the pacman line given below if you don't use AUR (yay); don't forget to comment out the yay line
    sudo pacman -Syu && 
    # yay -Syu --combinedupgrade --devel --batchinstall --sudoflags "--askpass" && 
    echo "PACDIFF..." && 
    pacdiff -o
}

empty_cache(){
    # remove unused cached database and packages.
    echo "Empty Unused Caches:"
    # yay -Sc
    # comment out the above yay line and uncomment the following pacman line if you don't use AUR and yay
    sudo pacman -Sc
}

# default function if no argument were passed
if [[ $# -eq 0 ]]; then
    install_pak
    exit 1
fi

while getopts "hirodue" opt; do
    case $opt in
        h)
            show_help
            ;;
        i)
            install_pak
            ;;
        r)
            remove_pak
            ;;
        o)
            remove_orphans
            ;;
        d)
            database_update
            ;;
        u)
            update_system
            ;;
        e)
            empty_cache
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            ;;
    esac
done