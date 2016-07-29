#!/bin/bash

####################################
##                                ##
###     Harfix3 build script     ###
##                                ##
####################################
#				2016
#
# Build script for Harfix3 kernel for i9300.
# By wisniew99 / rafciowis1999
# You can use and edit this as You want. :)
# But please save orginal author.
#
# REMEMBER TO EDIT LOCATIONS!!!


# Possible options to run: 		(1-enabled, 0-disabled)
CLEAN=0				# Clean before compile.
NORMAL=1			# Compile normal version.
	NORMALZIP=1			# Zip normal version.
SECCLEAN=0			# Clean before next version
MALIFIX=1			# Compile MALI_fix version.
	MALIFIXZIP=1		# Zip MALI_fix version.
THICLEAN=0			# Clean after last version.
VERSION="beta1"		# Version number or name.
# If compile disabled, zip is disabled too.


# Shortcuts  EDIT THIS!
KERNELDIR=/home/gemi/git/Harfix3
TCDIR=/home/gemi/TC



# Let's start!

# Date.
DATE=`date +%d.%m.%Y`

# Add date to installer
sed -i '29d' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config
sed -i '29i\ini_set("rom_date",             "$DATE");' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config


# Create folders.
if [ -e "$KERNELDIR/harfix3" ] 
then 
	echo "harfix3 exist."
else 	
	echo "harfix3 not exist."
	mkdir $KERNELDIR/harfix3
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/normal" ] 
then 
	echo "harfix3/normal exist."
else 	
	echo "harfix3/normal not exist."
	mkdir $KERNELDIR/harfix3/normal
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/normal/boot" ] 
then 
	echo "harfix3/normal/boot exist."
else 	
	echo "harfix3/normal/boot not exist."
	mkdir $KERNELDIR/harfix3/normal/boot
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/normal/modules" ] 
then 
	echo "harfix3/normal/modules exist."
else 	
	echo "harfix3/normal/modules not exist."
	mkdir $KERNELDIR/harfix3/normal/modules
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/MALI_fix" ] 
then 
	echo "harfix3/MALI_fix exist."
else 	
	echo "harfix3/MALI_fix not exist."
	mkdir $KERNELDIR/harfix3/MALI_fix
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/MALI_fix/boot" ] 
then 
	echo "harfix3/MALI_fix/boot exist."
else 	
	echo "harfix3/MALI_fix/boot not exist."
	mkdir $KERNELDIR/harfix3/MALI_fix/boot
	echo "Done."
fi 

if [ -e "$KERNELDIR/harfix3/MALI_fix/modules" ] 
then 
	echo "harfix3/MALI_fix/modules exist."
else 	
	echo "Harfix3/MALI_fix/modules not exist."
	mkdir hKERNELDIR/harfix3/MALI_fix/modules
	echo "Done."
fi 

# Clean before build.
if [ -e "$KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip" ] 
then 
	echo "ZIP_FILES/Harfix3.zip exist."
	rm $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip	
	echo "Deleted."
else 	
	echo "ZIP_FILES/Harfix3.zip not exist."
fi 

if [ -e "$KERNELDIR/harfix3/Harfix3-$VERSION.zip" ] 
then 
	echo "/harfix3/Harfix3-$VERSION.zip exist."
	$KERNELDIR/harfix3/Harfix3-$VERSION.zip
	echo "Deleted."
else 	
	echo "/harfix3/Harfix3-$VERSION.zip not exist."
fi 

if [ -e "$KERNELDIR/harfix3/Harfix3-$VERSION-MALI_fix.zip" ] 
then 
	echo "/harfix3/Harfix3-$VERSION-MALI_fix.zip exist."
	$KERNELDIR/harfix3/Harfix3-$VERSION-MALI_fix.zip
	echo "Deleted."
else 	
	echo "/harfix3/Harfix3-$VERSION-MALI_fix.zip not exist."
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

# Prepering.
export ARCH=arm
export CROSS_COMPILE=$TCDIR/gcc-linaro-5.3-2016.02/bin/arm-linux-gnueabihf-

###########
## Clean ##
###########

# Cleaning.
if [ $CLEAN = 1 ]
then
	echo "Cleaning..."
	make -j4 clean
	make -j4 mrproper
	echo "Cleaned."
else
	echo "Clean skipped."
fi

####################
## Normal version ##
####################

if [ $NORMAL = 1 ] 
then 

	# Changing version for normal version.
	sed -i '41d' $KERNELDIR/arch/arm/configs/custom_i9300_defconfig
	sed -i '41i\CONFIG_LOCALVERSION="-Harfix3-$VERSION"' $KERNELDIR/arch/arm/configs/custom_i9300_defconfig
	sed -i '28d' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config
	sed -i '28i\ini_set("rom_version",          "$VERSION");' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config

	# Load config.
	echo "Loading config..."
	make custom_i9300_defconfig
	echo "Done."

	# Compile.
	echo "Compiling..."
	make -j4
	echo "Done."

	# Move compiled files to harfix3 folder.
	echo "Coping modules..."
	find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/normal/modules/ \;
	echo "Done."
	echo "Coping zImage..."
	cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/normal/boot/
	echo "Done."

	if [ $NORMALZIP = 1 ]
	then
		# Copy from harfix3 to ZIP_FILES.
		echo "Coping files for zip..."
		cp $KERNELDIR/harfix3/normal/modules/ $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/
		cp $KERNELDIR/harfix3/normal/boot/zImage $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/
		echo "Done,"

		echo "Zipping..."
		# zip ZIP_FILES folder.
		cd $ZERNELDIR/harfix3/ZIP_FILES
		zip $KERNELDIR/harfix3/Harfix3.zip boot
		zip $KERNELDIR/harfix3/Harfix3.zip boot/bootimg
		zip $KERNELDIR/harfix3/Harfix3.zip boot/bootimg/zImage
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/update-binary
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma-config
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/ttf
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/ttf/Roboto-Regular.ttf
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/agreement.txt
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material3.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material2.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/materia1.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material1.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material4.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material5.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/changelog.txt
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/next.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/install.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/back.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/blue.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/sound.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/info.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/yellow.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/device.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/purple.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/warning.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/agreement.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/green.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/red.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/installbutton.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/welcome.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/pink.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/text.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/dialog.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio_on.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/progress_full.9.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/titlebar.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/aroma-config.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/button_focus.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/icon.menu.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/dialog_titlebar.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/theme.prop
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/button_press.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/navbar.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/progress_empty.9.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/select.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio_on_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/button_rest.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/background.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb_on_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/select_push.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb_on.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/update-binary-installer
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/updater-script
		zip $KERNELDIR/harfix3/Harfix3.zip system
		zip $KERNELDIR/harfix3/Harfix3.zip system/priv-app
		zip $KERNELDIR/harfix3/Harfix3.zip system/lib
		zip $KERNELDIR/harfix3/Harfix3.zip system/lib/modules
		zip $KERNELDIR/harfix3/Harfix3.zip system/lib/modules/dhd.ko
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S55enable_001bkgputhreshold_020-on_battsave
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S75enable_001bkintreadspeed_020-512
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S48enable_001bkschedint_005-row
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S47enable_001bkgov_016-zzmoove_zzopt
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S76enable_001bkextreadspeed_030-1024
		zip $KERNELDIR/harfix3/Harfix3.zip tools
		zip $KERNELDIR/harfix3/Harfix3.zip tools/bootimgtools
		zip $KERNELDIR/harfix3/Harfix3.zip tools/cleanup.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/init.agnimounts.rc
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/f2fstat
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/sysinitd.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/mkfs.f2fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/rootrw
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/quick_boot.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/e2fsck
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fs_checker.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/tinyplay
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/busybox
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/mount.exfat
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/psnconfig.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/ntfs-3g
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/make_ext4fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fibmap.f2fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fstab_handler.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/optimise_remounts.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/rootro
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/touchkey_manage.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/sysro
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fsck.f2fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/sysrw
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/agni-init.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/res
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/res/misc
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/res/misc/silence.wav
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/init-append
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/system-sysinit-replace
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/init.rc.patch
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/sepolicy
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/init.smdk4x12-append
		zip $KERNELDIR/harfix3/Harfix3.zip tools/reseter.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/PSN_AGNi_builder.sh
		cd $KERNELDIR

		# Move zip to main Harfix3 folder.
		mv $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip $KERNELDIR/harfix3/
		# Rename new zip.
		mv $KERNELDIR/harfix3/Harfix3.zip $KERNELDIR/harfix3/Harfix3-$VERSION.zip
		echo "Done."
	fi
	
	echo "Done Normal version."
else
	echo "Skipped normal version."
fi

##################
## Second clean ##
##################

# Cleaning.
if [ $SECCLEAN = 1 ]
then
	echo "Cleaning..."
	make -j4 clean
	make -j4 mrproper
	echo "Cleaned."
else
	echo "Clean skipped."
fi

######################
## MALI fix version ##
######################

if [ $MALIFIX = 1 ] 
then 

	# Change version for MALI_fix.
	sed -i '50d' $KERNELDIR/arch/arm/configs/custom_mali_fix_i9300_defconfig
	sed -i '50i\CONFIG_LOCALVERSION="-Harfix3-$VERSION-fix"' $KERNELDIR/arch/arm/configs/custom_mali_fix_i9300_defconfig
	sed -i '28d' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config
	sed -i '28i\ini_set("rom_version",          "$VERSION-fix");' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config

	# Load config.
	echo "Loading config..."
	make custom_mali_fix_i9300_defconfig
	echo "Done."

	# Second compile.
	echo "Compiling..."
	make -j4
	echo "Done."

	# Move compiled files to harfix3 folder.
	echo "Coping modules..."
	find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/MALI_fix/modules/ \;
	echo "Done."
	echo "Coping zImage..."
	cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/MALI_fix/boot/
	echo "Done."

	# Remove other files.
	rm $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
	rm $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*

		if [ $MALIFIXZIP = 1 ]
	then
		# Copy from harfix3 to ZIP_FILES.
		echo "Coping files for zip..."
		cp $KERNELDIR/harfix3/MALI_fix/modules/* $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/
		cp $KERNELDIR/harfix3/MALI_fix/boot/zImage $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/
		echo "Done,"

		echo "Zipping..."
		# Zip ZIP_FILES folder.
		cd $KERNELDIR/harfix3/ZIP_FILES
		zip $KERNELDIR/harfix3/Harfix3.zip boot
		zip $KERNELDIR/harfix3/Harfix3.zip boot/bootimg
		zip $KERNELDIR/harfix3/Harfix3.zip boot/bootimg/zImage
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/update-binary
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma-config
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/ttf
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/ttf/Roboto-Regular.ttf
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/agreement.txt
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material3.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material2.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/materia1.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material1.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material4.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/splash/material5.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/changelog.txt
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/next.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/install.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/back.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/blue.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/sound.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/info.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/yellow.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/device.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/purple.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/warning.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/agreement.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/green.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/red.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/installbutton.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/welcome.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/pink.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/icons/text.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/dialog.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio_on.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/progress_full.9.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/titlebar.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/aroma-config.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/button_focus.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/icon.menu.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/dialog_titlebar.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/theme.prop
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/button_press.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/navbar.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/progress_empty.9.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/select.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio_on_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/button_rest.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/background.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb_on_sel.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/select_push.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/cb_on.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/aroma/themes/material_green/radio.png
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/update-binary-installer
		zip $KERNELDIR/harfix3/Harfix3.zip META-INF/com/google/android/updater-script
		zip $KERNELDIR/harfix3/Harfix3.zip system
		zip $KERNELDIR/harfix3/Harfix3.zip system/priv-app
		zip $KERNELDIR/harfix3/Harfix3.zip system/lib
		zip $KERNELDIR/harfix3/Harfix3.zip system/lib/modules
		zip $KERNELDIR/harfix3/Harfix3.zip system/lib/modules/dhd.ko
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S55enable_001bkgputhreshold_020-on_battsave
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S75enable_001bkintreadspeed_020-512
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S48enable_001bkschedint_005-row
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S47enable_001bkgov_016-zzmoove_zzopt
		zip $KERNELDIR/harfix3/Harfix3.zip system/etc/init.d/S76enable_001bkextreadspeed_030-1024
		zip $KERNELDIR/harfix3/Harfix3.zip tools
		zip $KERNELDIR/harfix3/Harfix3.zip tools/bootimgtools
		zip $KERNELDIR/harfix3/Harfix3.zip tools/cleanup.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/init.agnimounts.rc
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/f2fstat
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/sysinitd.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/mkfs.f2fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/rootrw
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/quick_boot.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/e2fsck
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fs_checker.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/tinyplay
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/busybox
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/mount.exfat
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/psnconfig.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/ntfs-3g
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/make_ext4fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fibmap.f2fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fstab_handler.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/optimise_remounts.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/rootro
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/touchkey_manage.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/sysro
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/fsck.f2fs
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/sysrw
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/sbin/agni-init.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/res
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/res/misc
		zip $KERNELDIR/harfix3/Harfix3.zip tools/packing/res/misc/silence.wav
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/init-append
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/system-sysinit-replace
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/init.rc.patch
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/sepolicy
		zip $KERNELDIR/harfix3/Harfix3.zip tools/workboot/init.smdk4x12-append
		zip $KERNELDIR/harfix3/Harfix3.zip tools/reseter.sh
		zip $KERNELDIR/harfix3/Harfix3.zip tools/PSN_AGNi_builder.sh
		cd $KERNELDIR

		# Move zip to main Harfix3 folder.
		mv $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip $KERNELDIR/harfix3/

		# Rename new zip.
		mv $KERNELDIR/harfix3/Harfix3.zip $KERNELDIR/harfix3/Harfix3-$VERSION-MALI_fix.zip
		echo "Done."
	fi

	echo "Done 	MALI_fix version."
else 	
	echo "Skipped MALI_fix version."
fi 

#################
## Third clean ##
#################

# Cleaning.
if [ $THICLEAN = 1 ]
then
	echo "Cleaning..."
	make -j4 clean
	make -j4 mrproper
	echo "Cleaned."
else
	echo "Clean skipped."
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