#!/bin/bash

# List of system packages to install
packages=(
    git vim curl htop wget python python-pip neofetch zsh tmux zoxide fzf stow nodejs npm ranger w3m
    
)

browser=(
    "Chromium:sudo pacman -S chromium"
    "Firefox:sudo pacman -S firefox"
    "Microsoft Edge:sudo pacman -S microsoft-edge-stable-bin"
    "Opera:yay -S opera-beta"
)

editors=(
    "Nano:sudo pacman -S nano"
    "Nvim:sudo pacman -S neovim"
    "Emacs:sudo pacman -S emacs"
    "Micro:sudo pacman -S micro"
    "Gedit:sudo pacman -S gedit"
    "Sublime Text:sudo pacman -S sublime-text"
    "VSCode:sudo pacman -S visual-studio-code-bin"
)



# select browser
install_browser(){
    echo "Select a text editor to install:"  | awk '{print "\033[32m" $0 "\033[0m"}'
    for i in "${!browser[@]}"; do
        echo "$i) ${browser[$i]%%:*}"  # Display only the editor name
    done
    
    read -p "Enter your choice (1-$((${#browser[@]}-1))): " choice

    if [[ -n "${browser[$choice]}" ]]; then
        # Extract the installation command using parameter expansion
        command="${browser[$choice]#*:}"
        
        # Execute the installation command
        eval "$command"
        echo "${browser[$choice]%%:*} installed."
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi

}

install_texteditor(){
    echo "Select a text editor to install:"  | awk '{print "\033[32m" $0 "\033[0m"}'
    for i in "${!editors[@]}"; do
        echo "$i) ${editors[$i]%%:*}"  # Display only the editor name
    done

    read -p "Enter your choice [0-$((${#editors[@]}-1))]: " choice

    if [[ -n "${editors[$choice]}" ]]; then
        # Extract the installation command using parameter expansion
        command="${editors[$choice]#*:}"
        
        # Execute the installation command
        eval "$command"
        echo "${editors[$choice]%%:*} installed."
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi

}

install_packages() {
    echo "Updating package database..."  | awk '{print "\033[32m" $0 "\033[0m"}'
    sudo pacman -Syu --noconfirm

    echo "Installing packages..."  | awk '{print "\033[32m" $0 "\033[0m"}'
    pkg=""
    for item in "${packages[@]}"; do
        pkg+="$item " 
    done
    echo "$pkg" | xargs -ro sudo pacman -S

    echo "All packages installed successfully."
}

install_snapper(){
    echo "Installing Snapper..."  | awk '{print "\033[32m" $0 "\033[0m"}'
    sudo pacman -S --noconfirm --needed btrfs-assistant
    sudo pacman -S --noconfirm --needed grub-btrfs
    sudo pacman -S --noconfirm --needed snap-pac-git
    sudo pacman -S --noconfirm --needed snapper
    sudo pacman -S --noconfirm --needed snapper-tools-git
    sudo pacman -S --noconfirm --needed snapper-support

}

# install_packages

# install_browser

# install_texteditor


## Interactive section
show_help(){
    declare -A options=(
        ["-h"]="show [h]elp message"
        ["-i"]="[i]nstall required packages"
        ["-b"]="select prefferd [b]rowser"
        ["-e"]="select prefferd [e]ditor"
        ["-s"]="install [s]napper"

    )
    echo "Usage: $0 [options]"  | awk '{print "\033[32m" $0 "\033[0m"}'
    echo ""
    echo "Options:"

    max_length=0
    for opt in "${!options[@]}"; do
        len=${#opt}
        if (( len>max_length));then
            max_length=$len
        fi
    done

    for opt in "${!options[@]}"; do
        printf "  %-${max_length}s : %s\n" "$opt" "${options[$opt]}"
    done
}

# default function if no argument were passed
if [[ $# -eq 0 ]]; then
    show_help
    exit 1
fi

while getopts "hibes" opt; do
    case $opt in
        h)
            show_help
            ;;
        i)
            install_packages
            ;;
        b)
            install_browser
            ;;
        e)
            install_texteditor
            ;;
        s)
            install_snapper
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
