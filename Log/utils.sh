#!/bin/bash


# This will delete all files except *.c and *.h file in linux
find . -maxdepth 1 ! -name "*.c" ! -name "*.h" -type f -exec rm -rf {} \;
# or
find . -maxdepth 1 ! -name "*.c" ! -name "*.h" -type f -delete

# install tazpkg file
cpio -id < xxx.tazpkg
lzcat fs.cpio.lzma| cpio -idm
