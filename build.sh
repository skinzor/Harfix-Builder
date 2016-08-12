#!/bin/bash

#############################################
##                                         ##
###$           Kernel builder            ####
##                                         ##
#############################################
##                  2016                   ##
#                                           #
# Build script for Kernels.                 #
# By wisniew99 / rafciowis1999              #
# You can use and edit this as You want. :) #
# But please save orginal author.           #
#                                           #
# Script based on inplementation            #
# in Harfix3 kernel for i9300.              #
# by me of course :)                        #
#                                           #
## REMEMBER TO EDIT LOCATIONS!!!           ##
#############################################
#                                            #
#                                             #
########################  OPTIONS  ##########################
# Possible options to run: 	(1-enabled, 0-disabled)     #
CLEAN=0				# Clean before compile.     #
NORMAL=0			# Compile normal version.   #
    NORMALZIP=1                     # Zip normal version.   #
SECCLEAN=0			# Clean before next version.#
MALIFIX=0			# Compile MALI_fix version. #
    MALIFIXZIP=1                    # Zip MALI_fix version. #
THICLEAN=0			# Clean after last version. #
PRONAME="Harfix3"               # Name for folders, files.  #
VERSION="1.0"                   # Version number or name.   #
# If compile is disabled, zip is disabled too.              #
#############################################################
#                                                           #
# Auto detect Your home folder.                              #
HOME="$(dirname ~)/$(basename ~)"                             #
#                                                              #
########################  EDIT THIS!  ##########################
#                                                              #
#                     ##  Shortcuts:  ##                        #
ARCH="arm"                          # arch of device             #
TCDIR=$HOME/TC                      # Toolchain dir               #
TCNAME="gcc-linaro-5.3-2016.02"     # Toolchain name               #
TCEND="bin/arm-linux-gnueabihf-"    # Toolchain end of name         #
#                                                                    #
#                     ##  TC example:  ##                             #
# $TCDIR/$TCNAME/$TCEND                                                #
#                                                                       #
########################################  Configs  ###################################
#                                                                                    #
CONFIGNORMAL=custom_i9300_defconfig             # Standard config                    #
CONFIGMALIFIX=custom_mali_fix_i9300_defconfig   # Standard config with broken fences #
#                                                                                    #
######################################################################################
#                                                                                    #
#                                                                                    #

# Shortcuts (editing isn't needed)
JOBS="$(grep -c "processor" "/proc/cpuinfo")"   # Maximum jobs that Your computer can do.

# let's colorize :)
red=$(tput setaf 1)             # red     # Error
grn=$(tput setaf 2)             # green   # Done
ylw=$(tput setaf 11)            # yellow  # Warring
blu=$(tput setaf 4)             # blue    # path
gren=$(tput setaf 118)          # green   # Name
pur=$(tput setaf 201)           # purple  # Name
txtbld=$(tput bold)             # Bold    # Info
bldred=${txtbld}$(tput setaf 1) # Red     # Error desc
bldblu=${txtbld}$(tput setaf 4) # blue    # Info
txtrst=$(tput sgr0)             # Reset
# I using black terminal so that can look ugly on white.

echo -e '\0033\0143'
echo ""
echo ""
echo "${gren} Starting Kernel builder...${txtrst}"
echo "${gren} By${txtrst} ${pur}wisniew99 / rafciowis1999 ${txtrst} "
echo ""
echo ""
echo ""
echo "${txtbld} Creating folders... ${txtrst}"
echo ""

# Create unnecessary folders.
if [ -e "$PRONAME" ]
then
    echo "${bldblu} $PRONAME${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME not exist. ${txtrst}"
    mkdir $PRONAME
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/work" ]
then
    echo "${bldblu} $PRONAME/work${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/work not exist. ${txtrst}"
    mkdir $PRONAME/work
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/work/boot" ]
then
    echo "${bldblu} $PRONAME/work/boot${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/work/boot not exist. ${txtrst}"
    mkdir $PRONAME/work/boot
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/work/modules" ]
then
    echo "${bldblu} $PRONAME/work/modules${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/work/modules not exist. ${txtrst}"
    mkdir $PRONAME/work/modules
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/system/lib" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES/system/lib${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES/system/lib not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES/system/lib
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/system/lib/modules" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES/system/lib/modules${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES/system/lib/modules not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES/system/lib/modules
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/boot" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES/boot${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES/boot not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES/boot
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/boot/bootimg" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES/boot/bootimg${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES/boot/bootimg not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES/boot/bootimg
    echo "${grn} Created. ${txtrst}"
fi

echo ""
echo "${txtbld} Done creating folders. ${txtrst}"
echo ""
echo ""
echo ""
echo "${txtbld} Deleting files... ${txtrst}"
echo ""

# Delete old zips and zimage, modules from ZIP_FILES.
if [ -e "$PRONAME/ZIP_FILES/$PRONAME.zip" ]
then
    echo "${ylw} $PRONAME/ZIP_FILES/$PRONAME.zip exist. ${txtrst}"
    rm -rf $PRONAME/ZIP_FILES/$PRONAME.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME/ZIP_FILES/$PRONAME.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/work/boot/zImage" ]
then
    echo "${ylw} $PRONAME/work/boot/zImage exist. ${txtrst}"
    rm -rf $PRONAME/work/boot/*
    echo "${grn} Deleted old zImage. ${txtrst}"
else
    echo "${bldblu} $PRONAME/work/boot/*${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/work/modules/dhd.ko" ]
then
    echo "${ylw} $PRONAME/work/modules/dhd.ko exist. ${txtrst}"
    rm -rf $PRONAME/work/modules/*
    echo "${grn} Deleted all modules. ${txtrst}"
else
    echo "${bldblu} $PRONAME/work/modules/*${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-MALI_fix.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-MALI_fix.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-MALI_fix.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-MALI_fix.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/boot/bootimg/zImage" ]
then
    echo "${ylw} $PRONAME/ZIP_FILES/boot/bootimg/zImage exist. ${txtrst}"
    rm -rf $PRONAME/ZIP_FILES/boot/bootimg/*
    echo "${grn} Deleted old zImage. ${txtrst}"
else
    echo "${bldblu} $PRONAME/ZIP_FILES/boot/bootimg/*${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/system/lib/modules/dhd.ko" ]
then
    echo "${ylw} $PRONAME/ZIP_FILES/system/lib/modules/dhd.ko exist. ${txtrst}"
    rm -rf $PRONAME/ZIP_FILES/system/lib/modules/*
    echo "${grn} Deleted all modules. ${txtrst}"
else
    echo "${bldblu} $PRONAME/ZIP_FILES/system/lib/modules/*${txtrst}${blu} not exist. ${txtrst}"
fi

echo ""
echo "${txtbld} Done deleting files. ${txtrst}"
echo ""
echo ""
echo ""


# Prepering. Edit at beginning of script, not here.
export ARCH=$ARCH
export CROSS_COMPILE=$TCDIR/$TCNAME/$TCEND

# Testing Toolchain
if [ -e $TCDIR/$TCNAME/$TCENDgcc ]
then
    echo "${txtbld} Toolchain set correctly. ${txtrst}"
    echo ""
    echo ""
    echo ""
else
    echo "${red} ERROR! ${txtrst}"
    echo "${bldred} Toolchain is NOT correct. ${txtrst}"
    echo "${bldred} Change dir or name in script ${txtrst}"
    echo "${bldred} to correctly set up toolchain. ${txtrst}"
    echo ""
    exit 1
fi


###########
## Clean ##
###########

# Cleaning.
if [ $CLEAN = 1 ]
then
    echo "${bldblu} Cleaning... ${txtrst}"
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "${grn} Cleaned. ${txtrst}"
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Clean skipped. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi


####################
## Normal version ##
####################

if [ $NORMAL = 1 ]
then

    echo "${txtbld} Starting Normal build... ${txtrst}"
    echo ""
    echo ""
    echo ""

    # Load config.
    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGNORMAL
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Compile.
    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to $PRONAME folder.
    echo "${bldblu} Coping modules... ${txtrst}"
    find -name '*.ko' -exec cp -av {} $PRONAME/work/modules/ \;
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Coping zImage... ${txtrst}"
    cp arch/arm/boot/zImage $PRONAME/work/boot/
    echo "${grn} Done. ${txtrst}"
    echo ""
    echo ""
    echo ""

    if [ $NORMALZIP = 1 ]
    then

        echo "${txtbld} Starting Normal build compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        # Copy from $PRONAME to ZIP_FILES.
        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/ $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        # zip ZIP_FILES folder.
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        # Move zip to main $PRONAME folder.
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        # Rename new zip.
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
    fi

    if [ $NORMALZIP = 0 ]
    then
        echo "${txtbld} Done Normal build compile. ${txtrst}"
    else
        echo "${txtbld} Done Normal build compile with compress. ${txtrst}"
    fi
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Skipped normal build. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi

##################
## Second clean ##
##################

# Cleaning.
if [ $SECCLEAN = 1 ]
then
    echo "${bldblu} Cleaning... ${txtrst}"
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "${grn} Cleaned. ${txtrst}"
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Clean skipped. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi

#########################
# Clean between version #   Copy that between other versions.
#########################

# Remove older files.
rm -rf $PRONAME/ZIP_FILES/boot/bootimg/*
rm -rf $PRONAME/ZIP_FILES/system/lib/modules/*
rm -rf $PRONAME/work/boot/*
rm -rf $PRONAME/work/modules/*

####################
## MALI fix Build ##
####################

if [ $MALIFIX = 1 ]
then
    echo "${txtbld} Starting MALI_FIX build... ${txtrst}"
    echo ""
    echo ""
    echo ""

    # Load config.
    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGMALIFIX
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Second compile.
    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to $PRONAME folder.
    echo "${bldblu} Coping modules... ${txtrst}"
    find -name '*.ko' -exec cp -av {} $PRONAME/work/modules/ \;
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Coping zImage... ${txtrst}"
    cp arch/arm/boot/zImage $PRONAME/work/boot/
    echo "${grn} Done. ${txtrst}"
    echo ""

    if [ $MALIFIXZIP = 1 ]
    then

        echo "${txtbld} Starting MALI_fix build compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        # Copy from $PRONAME to ZIP_FILES.
        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/* $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        # Zip ZIP_FILES folder.
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        # Move zip to main $PRONAME folder.
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        # Rename new zip.
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION-MALI_fix.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
    fi

    if [ $MALIFIXZIP = 0 ]
    then
        echo "${txtbld} Done MALI_fix build compile. ${txtrst}"
    else
        echo "${txtbld} Done MALI_fix build compile with compress. ${txtrst}"
    fi
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Skipped MALI_fix build. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi

#################
## Third clean ##
#################

# Cleaning.
if [ $THICLEAN = 1 ]
then
    echo "${bldblu} Cleaning... ${txtrst}"
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "${grn} Cleaned. ${txtrst}"
    echo ""
    echo ""
else
    echo "${ylw} Clean skipped. ${txtrst}"
    echo ""
    echo ""
fi

#########################
# Clean between version #   Copy that between other versions.
#########################

# Remove older files.
rm -rf $PRONAME/ZIP_FILES/boot/bootimg/*
rm -rf $PRONAME/ZIP_FILES/system/lib/modules/*
rm -rf $PRONAME/work/boot/*
rm -rf $PRONAME/work/modules/*

echo ""
echo "${gren} Kernel builder completed all tasks! ${txtrst}"
echo ""
exit 0
