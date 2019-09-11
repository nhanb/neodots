#!/usr/bin/env python3

import hashlib
import os
from subprocess import run
from urllib.request import urlretrieve


def hash_file(filename):
    sha256_hash = hashlib.sha256()
    with open(filename, "rb") as f:
        # Read and update hash string value in blocks of 4K
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()


def stow():
    targets = ["bash", "git", "kde", "kitty", "neovim", "tmux"]
    for target in targets:
        print(f"stow {target}")
        run(["stow", target])


def download_binary_software():
    BINARIES = "~/binaries/"
    os.makedirs(BINARIES, exist_ok=True)
    TMP = "tmp"
    os.makedirs(TMP, exist_ok=True)
    os.chdir(TMP)

    # zola
    url = "https://github.com/getzola/zola/releases/download/v0.8.0/zola-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
    hash = "bcdb334b47c34b0b35ffbba8400ca29df0d85377020c6468d2657a74dbef117e"
    print("Downloading zola...", end=" ", flush=True)
    dl_filename, _ = urlretrieve(url)
    assert hash_file(dl_filename) == hash
    print("extracting...", end=" ", flush=True)
    run(["tar", "-xvf", dl_filename])
    run(["mv", "zola", BINARIES])
    run(["rm", dl_filename])
    print("done.")

    os.chdir("..")


if __name__ == "__main__":
    stow()
    download_binary_software()
