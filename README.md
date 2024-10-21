## After Installation

> Clone this git repo
`git clone https://github.com/J-See/.dotfiles.git ~`
>

Execute post installation script which have following options.

`-h`: for help

`-i`: install required packages

`-b`: choose browser

`-e`: choose editor


```bash
chmod +x ~/.dotfiles/scripts/.config/scripts/post_install_pak.sh
./.dotfiles/scripts/.config/scripts/post_install_pak.sh
```

---

## dot-file installation

**Install stow**
In arch Linux install stow and git using below command.

```bash
sudo pacman -S git stow
```

**setup dot-file folder**

Place dotfile directory in home folder.

```bash
cd ~ && git clone https://github.com/J-See/.dotfiles.git
```

Restore entire dotfile into new machine.

```bash
cd ~/.dotfiles
stow -vt ~ */
```

## Short GNU STOW tutorial

gnu stow options basic one.

`-n`: within simulation. for testing always enable this.
`-v`: verbose
`-S`: enable linking(enabled by default).
`-D`: enable delinking.
`-t`: target directory for dotfile manage. In our case `home`should be target directory(always last option).

> `--adopt` : This option enable us to override existing stow package directory with conflicting package directory(own configuration). This modifies the dotfile managing directory.
> 

**Restoring single/multiple packages**

Simulating to find if there is any error.

```bash
stow -nvSt ~ alacritty
```

Restore if we are fully satisfied.

```bash
stow -vSt ~ alacritty
```

Restoring multiple packages

```bash
stow -vSt ~ alacritty kitty tmux nvim
```

Forcefully restoring commiting changes to stow package directory from own configuration.

for safety `stow --adopt -nvSt ~ <package>`

```bash
stow --adopt -vSt ~ kitty
```

**Delink single/multiple packages**

Simulating to find if there is any error.

```bash
stow -nvDt ~ alacritty
```

Delink if we are fully satisfied.

```bash
stow -vDt ~ alacritty
```

Delink multiple packages

```bash
stow -vDt ~ alacritty kitty tmux nvim
```