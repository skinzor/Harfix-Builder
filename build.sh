#!/bin/bash

####################################
##                                ##
###     Harfix3 build script     ###
##                                ##
####################################
#               2016
#
# Build script for Harfix3 kernel for i9300.
# By wisniew99 / rafciowis1999
# You can use and edit this as You want. :)
# But please save orginal author.
#
# REMEMBER TO EDIT LOCATIONS!!!


# Possible options to run: 	(1-enabled, 0-disabled)
CLEAN=1				# Clean before compile.
NORMAL=1			# Compile normal version.
    NORMALZIP=1                     # Zip normal version.
SECCLEAN=1			# Clean before next version
MALIFIX=1			# Compile MALI_fix version.
    MALIFIXZIP=1                    # Zip MALI_fix version.
THICLEAN=0			# Clean after last version.
VERSION="1.0"                   # Version number or name.
# If compile is disabled, zip is disabled too.

# Auto detect Your home folder.
HOME="$(dirname ~)/$(basename ~)"

# Shortcuts  EDIT THIS!
KERNELDIR=$HOME/git/Harfix3     # Kernel dir
TCDIR=$HOME/TC                  # Toolchain dir

# Configs, EDIT THIS if building other configs.
CONFIGNORMAL=custom_i9300_defconfig             # Standard Harfix3 config
CONFIGMALIFIX=custom_mali_fix_i9300_defconfig   # Standard Harfix3 config with broken fences



# Shortcuts but edit isn't needed
DATE=`date +%d.%m.%Y`                           # Date for AROMA installer.
JOBS="$(grep -c "processor" "/proc/cpuinfo")"   # Maximum jobs that Your computer can do.
CATTMP='cat tmp.txt'                            # Cat tmp.txt for AROMA edits.


# Create unnecessary folders.
if [ -e "$KERNELDIR/harfix3" ]
then
    echo "harfix3 exist."
else
    echo "harfix3 not exist."
    mkdir $KERNELDIR/harfix3
    echo "harfix3 created."
fi

if [ -e "$KERNELDIR/harfix3/normal" ]
then
    echo "harfix3/normal exist."
else
    echo "harfix3/normal not exist."
    mkdir $KERNELDIR/harfix3/normal
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/normal/boot" ]
then
    echo "harfix3/normal/boot exist."
else
    echo "harfix3/normal/boot not exist."
    mkdir $KERNELDIR/harfix3/normal/boot
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/normal/modules" ]
then
    echo "harfix3/normal/modules exist."
else
    echo "harfix3/normal/modules not exist."
    mkdir $KERNELDIR/harfix3/normal/modules
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/MALI_fix" ]
then
    echo "harfix3/MALI_fix exist."
else
    echo "harfix3/MALI_fix not exist."
    mkdir $KERNELDIR/harfix3/MALI_fix
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/MALI_fix/boot" ]
then
    echo "harfix3/MALI_fix/boot exist."
else
    echo "harfix3/MALI_fix/boot not exist."
    mkdir $KERNELDIR/harfix3/MALI_fix/boot
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/MALI_fix/modules" ]
then
    echo "harfix3/MALI_fix/modules exist."
else
    echo "harfix3/MALI_fix/modules not exist."
    mkdir $KERNELDIR/harfix3/MALI_fix/modules
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/system/lib" ]
then
    echo "ZIP_FILES/system/lib exist."
else
    echo "ZIP_FILES/system/lib not exist."
    mkdir $KERNELDIR/harfix3/ZIP_FILES/system/lib
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/system/lib/modules" ]
then
    echo "ZIP_FILES/system/lib/modules exist."
else
    echo "ZIP_FILES/system/lib/modules not exist."
    mkdir $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/boot" ]
then
    echo "harfix3/ZIP_FILES/boot exist."
else
    echo "harfix3/ZIP_FILES/boot not exist."
    mkdir $KERNELDIR/harfix3/ZIP_FILES/boot
    echo "Created."
fi

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/boot/bootimg" ]
then
    echo "harfix3/ZIP_FILES/boot/bootimg exist."
else
    echo "harfix3/ZIP_FILES/boot/bootimg not exist."
    mkdir $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg
    echo "harfix3/ZIP_FILES/boot/bootimg created."
fi

#if [ -e "$KERNELDIR/harfix3/tmp.txt" ]
#then
#    echo "tmp.txt exist."
#else
#    touch $KERNELDIR/harfix3/tmp.txt
#    echo "tmp.txt created."
#fi


# Delete old zips and zimage, modules from ZIP_FILES.
if [ -e "$KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip" ]
then
    echo "ZIP_FILES/Harfix3.zip exist."
    rm -rf $KERNELDIR/harfix3/ZIP_FILES/Harfix3.zip
    echo "Deleted."
else
    echo "ZIP_FILES/Harfix3.zip not exist."
fi

if [ -e "$KERNELDIR/harfix3/Harfix3-$VERSION.zip" ]
then
    echo "/harfix3/Harfix3-$VERSION.zip exist."
    rm -rf $KERNELDIR/harfix3/Harfix3-$VERSION.zip
    echo "Deleted."
else
    echo "/harfix3/Harfix3-$VERSION.zip not exist."
fi

if [ -e "$KERNELDIR/harfix3/Harfix3-$VERSION-MALI_fix.zip" ]
then
    echo "/harfix3/Harfix3-$VERSION-MALI_fix.zip exist."
    rm -rf $KERNELDIR/harfix3/Harfix3-$VERSION-MALI_fix.zip
    echo "Deleted."
else
    echo "/harfix3/Harfix3-$VERSION-MALI_fix.zip not exist."
fi

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*" ]
then
    echo "ZIP_FILES/boot/bootimg/* exist."
    rm -rf $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
    echo "Deleted."
else
    echo "ZIP_FILES/boot/bootimg/* not exist."
fi

if [ -e "$KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*" ]
then
    echo "ZIP_FILES/system/lib/modules/* exist."
    rm -rf $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*
    echo "Deleted."
else
    echo "ZIP_FILES/system/lib/modules/* not exist."
fi

# Prepering.
export ARCH=arm
export CROSS_COMPILE=$TCDIR/gcc-linaro-5.3-2016.02/bin/arm-linux-gnueabihf-

###############
## Functions ##
###############

function escape_slashes {
    sed 's/\//\\\//g'
}

function change_line {
    local OLD_LINE_PATTERN=$1; shift
    local NEW_LINE=$1; shift
    local FILE=$1

    local NEW=$(echo "${NEW_LINE}" | escape_slashes)
    sudo sed -i .bak '/'"${OLD_LINE_PATTERN}"'/s/.*/'"${NEW}"'/' "${FILE}"
    sudo mv "${FILE}.bak" /tmp/
}


###########
## Clean ##
###########

# Cleaning.
if [ $CLEAN = 1 ]
then
    echo "Cleaning..."
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "Cleaned."
else
    echo "Clean skipped."
fi

##########
## MISC ##
##########

# Add date to installer

#grep -e '$(ini_set("rom_date",)' $KERNELDIR/harfix3/ZIP_FILES/META-INF/com/google/android/aroma-config > tmp.txt
#change_line "$(ini_set("rom_date",)" "$CATTMP" $BASEOUT/build.prop


####################
## Normal version ##
####################

if [ $NORMAL = 1 ]
then

    # Load config.
    echo "Loading config..."
    make $CONFIGNORMAL
    echo "Done."

    # Compile.
    echo "Compiling..."
    make -j "$JOBS"
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
        zip -r Harfix3.zip *
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
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "Cleaned."
else
    echo "Clean skipped."
fi

######################
## MALI fix version ##
######################

if [ $MALIFIX = 1 ]
then

    # Load config.
    echo "Loading config..."
    make $CONFIGMALIFIX
    echo "Done."

    # Second compile.
    echo "Compiling..."
    make -j "$JOBS"
    echo "Done."

    # Move compiled files to harfix3 folder.
    echo "Coping modules..."
    find -name '*.ko' -exec cp -av {} $KERNELDIR/harfix3/MALI_fix/modules/ \;
    echo "Done."
    echo "Coping zImage..."
    cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/harfix3/MALI_fix/boot/
    echo "Done."

    # Remove older files.
    rm -rf $KERNELDIR/harfix3/ZIP_FILES/boot/bootimg/*
    rm -rf $KERNELDIR/harfix3/ZIP_FILES/system/lib/modules/*

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
        zip -r Harfix3.zip *
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
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "Cleaned."
else
    echo "Clean skipped."
fi

echo "DONE!"
