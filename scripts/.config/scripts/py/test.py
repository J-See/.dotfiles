import argparse
import subprocess
import sys


def conuntP():
    return 45


# Create the argument parser
parser = argparse.ArgumentParser(
    description="A script that demonstrates displaying help when no flags are passed."
)

parser.add_argument("-n", "--name", type=str, help="Name of the person.")
parser.add_argument(
    "-c", "--count", type=int, default=conuntP(), help="Number of greetings."
)

args = parser.parse_args()

print(len(sys.argv))


str = "sudo pacman -S"
print(str.split(" "))


process = subprocess.Popen(
    ["sudo", "pacman", "-Syyu"], 
    stdout=subprocess.PIPE, 
    stderr=subprocess.PIPE
)
print(process.pid)
stdout, stderr = process.communicate()
print(stdout)