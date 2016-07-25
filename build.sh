#!/bin/bash

########################
# Harfix3 build script #
########################

# Prepering
export ARCH=arm
export CROSS_COMPILE=/home/gemi/TC/gcc-linaro-5.3-2016.02/bin/arm-linux-gnueabihf-

# Cleaning
make clean

# Load config
make custom_i9300_defconfig

# Compile
make -j4

# Move compiled files to harfix3 folder
find -name '*.ko' -exec cp -av {} /home/gemi/git/Harfix3/harfix3/normal/ \;
cp /home/gemi/git/Harfix3/arch/arm/boot/zImage /home/gemi/git/Harfix3/harfix3/normal/



# Load config for second compile (MALI fix)
make custom_mali_fix_i9300_defconfig

# Second compile (MALI fix)
make -j4

# Move compiled files to harfix3 folder (MALI fix)
find -name '*.ko' -exec cp -av {} /home/gemi/git/Harfix3/harfix3/MALI_fix/ \;
cp /home/gemi/git/Harfix3/arch/arm/boot/zImage /home/gemi/git/Harfix3/harfix3/MALI_fix/
