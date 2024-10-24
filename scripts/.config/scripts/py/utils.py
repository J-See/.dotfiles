import subprocess
from variables import colors
# colored text
def esc(code):
    """Return the ANSI escape sequence for the given code."""
    return f'\033[{code}m'

def color_text(text, color_code='0', bold=False, underline=False):
    """Print text with specified color, bold, and underline options."""
    # Example Final code: print("\033[1;4;31mThis is bold, underlined, red text!\033[0m")
    styles = []
    
    if bold:
        styles.append('1')  # Bold
    if underline:
        styles.append('4')  # Underline

    style_code = ';'.join(styles)
    if style_code:
        style_code += f';{color_code}'
    else:
        style_code = color_code

    return (f"{esc(style_code)}{text}{esc('0')}")  # Reset after printing

# run command
def run_command(command: str, captureOutput: bool = False) -> list:
    """Run external commands"""
    process = subprocess.run(
        command.split(),
        capture_output=captureOutput,
        text=True
    )
    args, returncode, output, error = vars(process).values()
    if returncode != 0:
        print(f"{color_text('X',color_code=colors['red'], bold=True)} something wrong: manually run {' '.join(args)}")
    
    if command == "sudo pacman -Sy --noconfirm":
        print()

    return [args, returncode, output, error]



if __name__ == "__main__":
    # Example usage:
    print(color_text("This is bold red text!", color_code=colors['red'], bold=True))
    print(color_text("This is green text!", color_code='32'))
    print(color_text("This is underlined blue text!", color_code='34', underline=True))
    print(color_text("This is bold and underlined magenta text!", color_code='35', bold=True, underline=True))
