#!/bin/bash

##################################
##################################
###### Harfix3 build script ######
##################################
##################################

# You can use and edit this as You want. :)
# REMEMBER TO EDIT LOCATIONS!!!


# Let's start!


# Shortcuts  EDIT THIS!
KERNELDIR=/home/gemi/git/Harfix3
TCDIR=/home/gemi/TC

# Clean before build
rm $KERNELDIR/harfix3/ZIP_FILES/Harfix3-MALI_fix.zip
rm $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip
rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*

# Prepering
export ARCH=arm
export CROSS_COMPILE=$TCDIR/gcc-linaro-5.3-2016.02/bin/arm-linux-gnueabihf-

# Cleaning
# make clean


##################
# Normal version #
##################

# Load config
make custom_i9300_defconfig

# Compile
make -j4

# Move compiled files to harfix3 folder
find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/normal/modules/ \;
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/normal/boot/

# copy from harfix3 to ZIP_FILES
# cp $KERNELDIR/harfix3/normal/modules/* $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/
# cp $KERNELDIR/harfix3/normal/boot/zImage $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/

# zip ZIP_FILES folder
# zip $KERNELDIR/harfix3/Harfix3.zip $KERNELDIR/harfix3/ZIP_FILES/*

# move zip to main Harfix3 folder
# mv $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip $KERNELDIR/harfix3/



####################
# MALI fix version #
####################

# Load config for second compile (MALI fix)
make custom_mali_fix_i9300_defconfig

# Second compile (MALI fix)
make -j4

# Move compiled files to harfix3 folder (MALI fix)
find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/MALI_fix/modules/ \;
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/MALI_fix/boot/

# Remove old files
rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*

# copy from harfix3 to ZIP_FILES
# cp $KERNELDIR/harfix3/MALI_fix/modules/* $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/
# cp $KERNELDIR/harfix3/MALI_fix/boot/zImage $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/

# zip ZIP_FILES folder
# zip $KERNELDIR/harfix3/Harfix3-MALI_fix.zip $KERNELDIR/harfix3/ZIP_FILES/*

# move zip to main Harfix3 folder
# mv $KERNELDIR/harfix3/ZIP_FILES/Harfix3-MALI_fix.zip $KERNELDIR/harfix3/

# Clean
rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*
