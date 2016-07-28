#!/bin/bash

####################################
####################################
####### Harfix3 build script #######
####################################
####################################

# Build script for Harfix3 kernel for i9300
# by wisniew99 / rafciowis1999
# You can use and edit this as You want. :)

# REMEMBER TO EDIT LOCATIONS!!!


# Possible run options of build.sh 		(1-enabled, 0-disabled)
CLEAN=0				# Clean before compile.
NORMAL=1			# Compile normal version.
MALIFIX=1			# Compile MALI_fix version.


# Let's start!


# Shortcuts  EDIT THIS!
KERNELDIR=/home/gemi/git/Harfix3
TCDIR=/home/gemi/TC

# Create folders
if [ -e "$KERNELDIR/harfix3" ] 
then 
	echo "harfix3 exist."
else 	
	echo "Harfix3 not exist."
	mkdir $KERNELDIR/harfix3
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/normal" ] 
then 
	echo "harfix3/normal exist."
else 	
	echo "Harfix3/normal not exist."
	mkdir $KERNELDIR/harfix3/normal
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/normal/boot" ] 
then 
	echo "harfix3/normal/boot exist."
else 	
	echo "Harfix3/normal/boot not exist."
	mkdir $KERNELDIR/harfix3/normal/boot
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/normal/modules" ] 
then 
	echo "harfix3/normal/modules exist."
else 	
	echo "Harfix3/normal/modules not exist."
	mkdir $KERNELDIR/harfix3/normal/modules
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/MALI_fix" ] 
then 
	echo "harfix3/MALI_fix exist."
else 	
	echo "Harfix3/MALI_fix not exist."
	mkdir $KERNELDIR/harfix3/MALI_fix
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/MALI_fix/boot" ] 
then 
	echo "harfix3/MALI_fix/boot exist."
else 	
	echo "Harfix3/MALI_fix/boot not exist."
	mkdir $KERNELDIR/harfix3/MALI_fix/boot
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/MALI_fix/modules" ] 
then 
	echo "harfix3/MALI_fix/modules exist."
else 	
	echo "Harfix3/MALI_fix/modules not exist."
	mkdir $KERNELDIR/harfix3/MALI_fix/modules
	echo "Done."
fi 

# Clean before build
if [ -e "$KERNELDIR/harfix3/ZIP_FILES/Harfix3-MALI_fix.zip" ] 
then 
	echo "ZIP_FILES/Harfix3-MALI_fix.zip exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/Harfix3-MALI_fix.zip	
	echo "Deleted."
else 	
	echo "ZIP_FILES/Harfix3-MALI_fix.zip not exist."
fi 

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip" ] 
then 
	echo "ZIP_FILES/Harfix3.zip exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip	
	echo "Deleted."
else 	
	echo "ZIP_FILES/Harfix3.zip not exist."
fi 

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*" ] 
then 
	echo "ZIP_FILES/boot/bootimg/* exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
	echo "Deleted."
else 	
	echo "ZIP_FILES/boot/bootimg/* not exist."
fi 

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*" ] 
then 
	echo "ZIP_FILES/system/lib/modules/* exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*
	echo "Deleted."
else 	
	echo "ZIP_FILES/system/lib/modules/* not exist."
fi 

# Prepering
export ARCH=arm
export CROSS_COMPILE=$TCDIR/gcc-linaro-5.3-2016.02/bin/arm-linux-gnueabihf-

# Cleaning
if [ $CLEAN = 1 ]
then
	echo "Cleaning..."
	make -j4 clean
	make -j4 mrproper
	echo "Cleaned."
else
	echo "Clean skipped."
fi

##################
# Normal version #
##################

if [ $NORMAL = 1 ] 
then 
	# Load config
	echo "Loading config..."
	make custom_i9300_defconfig
	echo "Done."

	# Compile
	echo "Compiling..."
	make -j4
	echo "Done."

	# Move compiled files to harfix3 folder
	echo "Coping modules..."
	find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/normal/modules/ \;
	echo "Done."
	echo "Coping zImage..."
	cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/normal/boot/
	echo "Done."

	# copy from harfix3 to ZIP_FILES
	# cp $KERNELDIR/harfix3/normal/modules/* $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/
	# cp $KERNELDIR/harfix3/normal/boot/zImage $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/

	# zip ZIP_FILES folder
	# zip $KERNELDIR/harfix3/Harfix3.zip $KERNELDIR/harfix3/ZIP_FILES/*

	# move zip to main Harfix3 folder
	# mv $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip $KERNELDIR/harfix3/
	echo "Done Normal version."
else
	echo "skipped normal version."
fi



####################
# MALI fix version #
####################

if [ $MALIFIX = 1 ] 
then 
	# Load config
	echo "Loading config..."
	make custom_mali_fix_i9300_defconfig
	echo "Done."

	# Second compile
	echo "Compiling..."
	make -j4
	echo "Done."

	# Move compiled files to harfix3 folder
	echo "Coping modules..."
	find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/MALI_fix/modules/ \;
	echo "Done."
	echo "Coping zImage..."
	cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/MALI_fix/boot/
	echo "Done."

	# Remove old files
	# rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
	# rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*

	# copy from harfix3 to ZIP_FILES
	# cp $KERNELDIR/harfix3/MALI_fix/modules/* $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/
	# cp $KERNELDIR/harfix3/MALI_fix/boot/zImage $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/

	# zip ZIP_FILES folder
	# zip $KERNELDIR/harfix3/Harfix3-MALI_fix.zip $KERNELDIR/harfix3/ZIP_FILES/*

	# move zip to main Harfix3 folder
	# mv $KERNELDIR/harfix3/ZIP_FILES/Harfix3-MALI_fix.zip $KERNELDIR/harfix3/
	echo "Done 	MALI_fix version."
else 	
	echo "Skipped MALI_fix version."
fi 

# Clean

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*" ] 
then 
	echo "ZIP_FILES/boot/bootimg/* exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
	echo "Deleted."
else 	
	echo "ZIP_FILES/boot/bootimg/* not exist."
fi 

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*" ] 
then 
	echo "ZIP_FILES/system/lib/modules/* exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*
	echo "Deleted."
else 	
	echo "ZIP_FILES/system/lib/modules/* not exist."
fi 

echo "DONE!"