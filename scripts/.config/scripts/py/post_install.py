import argparse
import subprocess
import sys
from rich.progress import track
from utils import color_text, run_command
from variables import colors, editors, browsers, packages

def install_packages() -> None:
    run_command('sudo pacman -Sy --noconfirm')

    print(color_text("Installing packages...", colors["blue"]))
    for package in track(
            sequence=packages,
            description='[blue]Install packages',
            total=len(packages)
        ):
        _, retuncode, out, _ = run_command(f"sudo pacman -S --noconfirm --needed {package}", True)
        if retuncode == 0:
            print(f"{package}: {color_text("SUCESS", colors["green"], True)}")

def install_browser() -> None:
    run_command('sudo pacman -Sy --noconfirm')

    print(color_text("Select a browser to install...", colors["blue"]))
    browsersKey = list(browsers.keys())
    for browser in browsersKey:
        print(f"{browsersKey.index(browser)}) {browser}")

    choice = int(input(f"Enter your choice {color_text(f"[0-{len(browsers)-1}]", colors["red"])}: "))
    run_command(f"sudo pacman -S --noconfirm --needed {browsers[browsersKey[choice]]}")

def install_texteditor() -> None:
    run_command('sudo pacman -Sy --noconfirm')

    print(color_text("Select a text editor to install...", colors["blue"]))
    editorsKey = list(editors.keys())
    for editor in editorsKey:
        print(f"{editorsKey.index(editor)}) {editor}")

    choice = int(input(f"Enter your choice {color_text(f"[0-{len(editors)-1}]", colors["red"])}: "))
    run_command(f"sudo pacman -S --noconfirm --needed {editors[editorsKey[choice]]}")

def install_snapper() -> None:
    run_command('sudo pacman -Sy --noconfirm')
    snapper_packages: list = [
        'btrfs-assistant',
        'grub-btrfs',
        'snap-pac',
        'snapper',
        'snapper-tools-git',
        'snapper-support',
    ]

    for package in track(
            sequence=snapper_packages,
            description='[blue]Snapper Setup',
            total=len(snapper_packages)
        ):
        _, retuncode, out, _ = run_command(f"sudo pacman -S --noconfirm --needed {package}", True)
        if retuncode == 0:
            print(f"{package}: {color_text("SUCESS", colors["green"], True)}")


def main():
    # settings flags
    parser = argparse.ArgumentParser(description="Linux post installtion script")

    parser.add_argument("-b", "--browser", action='store_true', help="Seclect desired browser wnat to install.")
    parser.add_argument("-e", "--editor", action='store_true', help="Seclect desired editor wnat to install.")
    parser.add_argument("-p", "--package", action='store_true', help="Install necessary packages")
    parser.add_argument("-s", "--snapper", action='store_true', help="Install BTRFS snapper.")

    args, unknown= parser.parse_known_args()

    # if no flags were passed
    if len(sys.argv) == 1:
        parser.print_help()

    # action with corresponding flags
    flag_action: dict = {
        args.browser: install_browser,
        args.editor: install_texteditor,
        args.package: install_packages,
        args.snapper: install_snapper,
    }
    for flag in flag_action:
        if flag is True:
            flag_action.get(flag)()

    # for unknown flags
    if unknown:
        print(f"Sorry unknown flag. reffer help section.")
        parser.print_help()


if __name__ == "__main__":
    main()