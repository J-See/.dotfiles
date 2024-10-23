import argparse
import subprocess
import sys


def run_command(command: str) -> None:
    pass

def install_browser() -> None:
    print("install browser")

def install_texteditor() -> None:
    print("install editor")

def install_packages() -> None:
    print("install package")

def install_snapper() -> None:
    print("install snapper")

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