#!/usr/bin/env python3
"""
Tested on python 3.14.
Dependencies:
    - libisoburn (xorrisofs)
    - par2cmdline (par2)

This script creates par2 recovery files and sha256 checksums for a target dir
then rolls everything into an ISO image ready to be burned to physical media
for archival purposes.

To create an archival image from "~/my-data" with the label "DATA_01":
    mkbdr.py ~/my-data DATA_01
which should create a new DATA_01 dir containing the final .iso file with
15% redundancy built in. This ratio is configurable. See source code for details.

---

To burn then verify without having to eject (tested on an I-O Data slim drive):
    # find out which usb bus & port our drive (/dev/sr0) is:
    udevadm info -q path -n /dev/sr0
    # sample output:
    # /devices/pci0000:00/0000:00:08.3/0000:67:00.0/usb4/4-2/4-2:1.0/host0/target0:0:0/0:0:0:0/block/sr0
    # This part - /usb4/4-2/ - means our drive is at bus 4 port 2 (4-2).

    # Now burn, then soft-reset the drive, then verify:
    cd DATA_01
    xorriso -as cdrecord -v -sao dev=/dev/sr0 DATA_01.iso -speed=2b &&
        echo 0 | sudo tee /sys/bus/usb/devices/4-2/authorized &&
        sleep 5 &&
        echo 1 | sudo tee /sys/bus/usb/devices/4-2/authorized &&
        sleep 10 &&
        pv DATA_01.iso | cmp - /dev/sr0
"""

import hashlib
import os
import re
import shlex
import shutil
import subprocess
import sys
from argparse import ArgumentParser, ArgumentTypeError
from datetime import datetime
from pathlib import Path

SCRIPT_NAME = Path(__file__).name
CHECKSUMS_FILENAME = "sha256-checksums.txt"


def main():
    # CLI arg parsing
    arg_parser = ArgumentParser(prog=SCRIPT_NAME, description="BD-R archival utility")
    arg_parser.add_argument("input_dir", type=Path)
    arg_parser.add_argument("label", type=label)
    arg_parser.add_argument(
        "-r",
        "--redundancy",
        default=15,
        type=percentage,
        help="redundancy percentage to be passed to par2 -r. You can also disable it with -r0.",
    )
    args = arg_parser.parse_args()

    # for arg_name in vars(args):
    #     print(f"arg: {arg_name}: {getattr(args, arg_name)}")

    # Sanity checks:

    if not args.input_dir.is_dir():
        print(f"{args.input_dir} is not an existing dir. Aborted.")
        sys.exit()

    work_dir = Path(args.label)
    if work_dir.exists():
        print(f"{args.label} already exists. Aborted.")
        sys.exit()
    work_dir.mkdir()

    os.chdir(work_dir)

    output_dir = Path("disc_output")
    data_dir = output_dir / "data"
    metadata_dir = output_dir / "metadata"
    # Assuming the current working dir is named after my desired disc name
    disc_name = Path.cwd().name
    iso_path = Path(disc_name + ".iso")

    # Clean up any previous run's artifacts
    if output_dir.exists():
        print(f"Removing existing dir {output_dir!s}")
        shutil.rmtree(output_dir)
    if iso_path.exists():
        print(f"Removing existing file {iso_path!s}")
        iso_path.unlink()

    # Create data dir
    print(f"Hardlinking input files into {data_dir}")
    shutil.copytree(args.input_dir, data_dir, copy_function=os.link)

    metadata_dir.mkdir(exist_ok=True, parents=True)

    # Create reference script
    script_path = Path(__file__)
    print(f"Copying current script into {metadata_dir}/{script_path.name}")
    script_path.copy_into(metadata_dir)

    # Create instructions file
    instructions_path = metadata_dir / "instructions.txt"
    print(f"Writing {instructions_path}")
    with open(instructions_path, "w") as ifile:
        ifile.write(INSTRUCTIONS_TEXT)
        if args.redundancy > 0:
            ifile.write(RECOVERY_INSTRUCTION)
        ifile.write("\n---\n")
        ifile.write(f"PAR2 redundancy: {args.redundancy}%\n")
        ifile.write(f"Generated at: {datetime.now().astimezone()}\n")

    # Create par2 recovery files if enabled
    if args.redundancy > 0:
        par2_file_path = metadata_dir / "recovery.par2"
        print(f"Generating recovery file: {par2_file_path!s}")
        run(
            "par2",
            "create",
            # set basepath to disc's root path
            # (must provide same arg on verify/repair command):
            "-B",
            str(data_dir),
            f"-r{args.redundancy}",  # redundancy percentage
            "-n1",  # put all recovery blocks in 1 file
            "-R",  # recurse
            str(par2_file_path),  # output
            str(data_dir),  # input
        )
    else:
        print("Skipping recovery file generation.")

    # Create sha256 checksums: 1 line per file.
    # Each line's format goes like this: <sha256 hex><space><data file path>
    # so that it's compatible with `sha256sum --check`
    checksums_path = metadata_dir / CHECKSUMS_FILENAME
    print("Generating", checksums_path)
    with open(checksums_path, "w") as cfile:
        for file_path in sorted(data_dir.rglob("*")):
            if file_path.is_file():
                with open(file_path, "rb") as f:
                    digest = hashlib.file_digest(f, "sha256").hexdigest()
                    cfile.write(digest)
                    cfile.write(" ")
                    cfile.write("/".join(file_path.parts[2:]))
                    cfile.write("\n")

    # Generate iso!
    run(
        "xorrisofs",
        "-V",
        disc_name,
        "-J",
        "-r",
        "-iso-level",
        "4",  # need at least 3 to raise the 2GB file size limit - might as well do 4.
        "-o",
        str(iso_path),
        str(output_dir.absolute()),  # get path expansion for free
    )

    # Checksum the iso too for good measure:
    with open(iso_path, "rb") as iso_file:
        digest = hashlib.file_digest(iso_file, "sha256").hexdigest()
    iso_checksum_path = str(iso_path) + ".sha256"
    print(f"Writing iso checksum to {iso_checksum_path}: {digest}")
    with open(iso_checksum_path, "w") as file:
        # Same format as above: <sha256><space><path>,
        # to be compatible with `sha256sum --check`
        file.write(f"{digest} {iso_path}\n")

    # Having generated the complete iso image, we no longer need output_dir:
    print(f"Removing {output_dir}")
    shutil.rmtree(output_dir)


INSTRUCTIONS_TEXT = f"""\
This disc was created using the "{SCRIPT_NAME}" script bundled
in this same folder for future reference.

Real data is in the "data" folder.
You can verify said data using SHA-256 checksums:
    cd data
    sha256sum -c ../metadata/sha256-checksums.txt
"""

RECOVERY_INSTRUCTION = """
If any data file is corrupted, it may still be recovered
using redundant data stored in this folder (if the damaged
portion isn't too large):
    # Assuming you use Arch linux:
    sudo pacman -S coreutils cdrtools par2cmdline

    # Goes without saying, but please copy the whole disc into
    # a local writable location first, then you can do:
    cd data
    par2 repair -B . ../metadata/recovery.par2

    # Or if you just want to verify nothing broke:
    par2 verify -B . ../metadata/recovery.par2
"""


def run(*cmd):
    escaped_cmd = " ".join(shlex.quote(arg) for arg in cmd)
    print(f"Running: {escaped_cmd}")

    subprocess.run(cmd, check=True)


def percentage(arg: str) -> int:
    n = int(arg)
    if n < 0:
        raise ArgumentTypeError("redundancy percentage must be at least 0")
    return n


def label(arg: str) -> str:
    if not re.match(r"^[A-Z0-9_]{1,32}$", arg):
        raise ArgumentTypeError(
            "label must contain only uppercase alphanumerics and underscore (max length 32)"
        )
    return arg


if __name__ == "__main__":
    main()
