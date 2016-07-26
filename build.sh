#!/bin/bash

##################################
##################################
###### Harfix3 build script ######
##################################
##################################

# You can use and edit this as You want. :)
# REMEMBER TO EDIT LOCATIONS!!!


##################
# Normal version #
##################

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
find -name '*.ko' -exec cp -av {} /home/gemi/git/Harfix3/harfix3/normal/modules/ \;
cp /home/gemi/git/Harfix3/arch/arm/boot/zImage /home/gemi/git/Harfix3/harfix3/normal/boot/

# Remove old files
rm /home/gemi/git/Harfix3/harfix3/ZIP_FILES/boot/bootimg/*
rm /home/gemi/git/Harfix3/harfix3/ZIP_FILES/system/lib/modules/*

# copy from harfix3 to ZIP_FILES
cp /home/gemi/git/Harfix3/harfix3/normal/modules/* /home/gemi/git/Harfix3/harfix3/ZIP_FILES/system/lib/modules/
cp /home/gemi/git/Harfix3/harfix3/normal/boot/zImage /home/gemi/git/Harfix3/harfix3/ZIP_FILES/boot/bootimg/

# zip ZIP_FILES folder
cd /home/gemi/git/Harfix3/harfix3/ZIP_FILES/
zip -qry -9 "Harfix3.zip" . -x "*.zip"
cd /home/gemi/git/Harfix3



####################
# MALI fix version #
####################

# Load config for second compile (MALI fix)
make custom_mali_fix_i9300_defconfig

# Second compile (MALI fix)
make -j4

# Move compiled files to harfix3 folder (MALI fix)
find -name '*.ko' -exec cp -av {} /home/gemi/git/Harfix3/harfix3/MALI_fix/modules/ \;
cp /home/gemi/git/Harfix3/arch/arm/boot/zImage /home/gemi/git/Harfix3/harfix3/MALI_fix/boot/

# Remove old files
rm /home/gemi/git/Harfix3/harfix3/ZIP_FILES/boot/bootimg/*
rm /home/gemi/git/Harfix3/harfix3/ZIP_FILES/system/lib/modules/*

# copy from harfix3 to ZIP_FILES
cp /home/gemi/git/Harfix3/harfix3/MALI_fix/modules/* /home/gemi/git/Harfix3/harfix3/ZIP_FILES/system/lib/modules/
cp /home/gemi/git/Harfix3/harfix3/MALI_fix/boot/zImage /home/gemi/git/Harfix3/harfix3/ZIP_FILES/boot/bootimg/

# zip ZIP_FILES folder
cd /home/gemi/git/Harfix3/harfix3/ZIP_FILES/
zip -qry -9 "Harfix3-MALI_fix.zip" . -x "*.zip"
cd /home/gemi/git/Harfix3

# Clean
rm /home/gemi/git/Harfix3/harfix3/ZIP_FILES/boot/bootimg/*
rm /home/gemi/git/Harfix3/harfix3/ZIP_FILES/system/lib/modules/*
rm /home/gemi/git/Harfix3/harfix3/normal/modules/*
rm /home/gemi/git/Harfix3/harfix3/normal/boot/zImage
rm /home/gemi/git/Harfix3/harfix3/MALI_fix/modules/*
rm /home/gemi/git/Harfix3/harfix3/MALI_fix/boot/zImage

