#!/bin/bash

#############################################
##                                         ##
####           Kernel builder            ####
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
##      REMEMBER TO EDIT LOCATIONS!!!      ##
#############################################
#                                            #
# If colours looks ugly, use black terminal   #
#                                              #
########################  OPTIONS  ##########################
##                 (1-enabled, 0-disabled)                 ##
#                                                           #
CLEAN=0				# Clean before compile.     #
NORMAL=0			# Compile normal version.   #
    NORMALZIP=1                     # Zip normal version.   #
SECCLEAN=0			# Clean between versions.   #
MALIFIX=0			# Compile MALI_fix version. #
    MALIFIXZIP=1                    # Zip MALI_fix version. #
THICLEAN=0			# Clean between versions.   #
STOCK43=0                       # Compile stock version.    #
    STOCK43ZIP=1                    # Zip stock version.    #
FOUCLEAN=0                      # Clean between versions.   #
STOCK44=0                       # Compile stock version.    #
    STOCK44ZIP=1                    # Zip stock version.    #
FIFCLEAN=0                      # Clean between versions.   #
STOCK51=1                       # Compile stock version.    #
    STOCK51ZIP=1                    # Zip stock version.    #
SIXCLEAN=0                      # Latest clean.             #
PRONAME="Harfix3"               # Project name.             #
VERSION="1.1"                   # Version number or name.   #
#                                                           #
##       If compile is disabled, zip is disabled too.      ##
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
####################################  Configs  #######################################
#                                                                                    #
CONFIGNORMAL=custom_i9300_defconfig             # Standard config                    #
CONFIGMALIFIX=custom_mali_fix_i9300_defconfig   # Standard config with broken fences #
CONFIGSTOCK43=custom_stock43_i9300_defconfig	# Standard config for stock ROMs     #
CONFIGSTOCK44=custom_stock44_i9300_defconfig	# Standard config for stock ROMs     #
CONFIGSTOCK51=custom_stock51_i9300_defconfig	# Standard config for stock ROMs     #
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

if [ -e "$PRONAME/$PRONAME-$VERSION-stock43.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-stock43.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-stock43.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-stock43.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-stock44.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-stock44.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-stock44.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-stock44.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-stock51.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-stock51.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-stock51.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-stock51.zip${txtrst}${blu} not exist. ${txtrst}"
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


# Edit at beginning of script, not here.
export ARCH=$ARCH
export CROSS_COMPILE=$TCDIR/$TCNAME/$TCEND

# Testing Toolchain
if [ -e $TCDIR/$TCNAME/$TCENDgcc ]
then
    echo "${grn} Toolchain set correctly. ${txtrst}"
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
fi


####################
## Normal version ##
####################

if [ $NORMAL = 1 ]
then

    echo "${txtbld} Starting Normal compile... ${txtrst}"
    echo ""
    echo ""
    echo ""

    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGNORMAL
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to work folder.
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

        echo "${txtbld} Starting Normal compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/* $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
        echo "${txtbld} Done normal build compile with compress. ${txtrst}"
    else
        echo "${txtbld} Done normal build compile. ${txtrst}"
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
    echo "${txtbld} Starting MALI_FIX compile... ${txtrst}"
    echo ""
    echo ""
    echo ""

    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGMALIFIX
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to work folder.
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

        echo "${txtbld} Starting MALI_fix compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/* $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION-MALI_fix.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
        echo "${txtbld} Done MALI_FIX build compile with compress. ${txtrst}"
    else
        echo "${txtbld} Done MALI_FIX build compile. ${txtrst}"
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
fi

#########################
# Clean between version #   Copy that between other versions.
#########################

# Remove older files.
rm -rf $PRONAME/ZIP_FILES/boot/bootimg/*
rm -rf $PRONAME/ZIP_FILES/system/lib/modules/*
rm -rf $PRONAME/work/boot/*
rm -rf $PRONAME/work/modules/*

#####################
## Stock43 version ##
#####################

if [ $STOCK43 = 1 ]
then

    echo "${txtbld} Starting stock43 compile... ${txtrst}"
    echo ""
    echo ""
    echo ""

    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGSTOCK43
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to work folder.
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

    if [ $STOCK43ZIP = 1 ]
    then

        echo "${txtbld} Starting stock43 compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/* $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION-stock43.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
        echo "${txtbld} Done stock43 build compile with compress. ${txtrst}"
    else
        echo "${txtbld} Done stock43 build compile. ${txtrst}"
    fi
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Skipped stock43 build. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi

##################
## Fourth clean ##
##################

# Cleaning.
if [ $FOUCLEAN = 1 ]
then
    echo "${bldblu} Cleaning... ${txtrst}"
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "${grn} Cleaned. ${txtrst}"
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

#####################
## Stock44 version ##
#####################

if [ $STOCK44 = 1 ]
then

    echo "${txtbld} Starting stock44 compile... ${txtrst}"
    echo ""
    echo ""
    echo ""

    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGSTOCK44
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to work folder.
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

    if [ $STOCK44ZIP = 1 ]
    then

        echo "${txtbld} Starting stock44 compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/* $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION-stock44.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
        echo "${txtbld} Done stock44 build compile with compress. ${txtrst}"
    else
        echo "${txtbld} Done stock44 build compile. ${txtrst}"
    fi
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Skipped stock44 build. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi

#################
## Fifth clean ##
#################

# Cleaning.
if [ $FIFCLEAN = 1 ]
then
    echo "${bldblu} Cleaning... ${txtrst}"
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "${grn} Cleaned. ${txtrst}"
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

#####################
## Stock51 version ##
#####################

if [ $STOCK451 = 1 ]
then

    echo "${txtbld} Starting stock51 compile... ${txtrst}"
    echo ""
    echo ""
    echo ""

    echo "${bldblu} Loading config... ${txtrst}"
    make $CONFIGSTOCK51
    echo "${grn} Done. ${txtrst}"
    echo ""

    echo "${bldblu} Compiling... ${txtrst}"
    make -j "$JOBS"
    echo "${grn} Done. ${txtrst}"
    echo ""

    # Move compiled files to work folder.
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

    if [ $STOCK51ZIP = 1 ]
    then

        echo "${txtbld} Starting stock51 compress... ${txtrst}"
        echo ""
        echo ""
        echo ""

        echo "${bldblu} Coping files for zip... ${txtrst}"
        cp $PRONAME/work/modules/* $PRONAME/ZIP_FILES/system/lib/modules/
        cp $PRONAME/work/boot/zImage $PRONAME/ZIP_FILES/boot/bootimg/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Zipping... ${txtrst}"
        cd $PRONAME/ZIP_FILES
        zip -r $PRONAME.zip *
        cd -
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Moving... ${txtrst}"
        mv $PRONAME/ZIP_FILES/$PRONAME.zip $PRONAME/
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Renaming... ${txtrst}"
        mv $PRONAME/$PRONAME.zip $PRONAME/$PRONAME-$VERSION-stock51.zip
        echo "${grn} Done. ${txtrst}"
        echo ""
        echo ""
        echo ""
        echo "${txtbld} Done stock51 build compile with compress. ${txtrst}"
    else
        echo "${txtbld} Done stock51 build compile. ${txtrst}"
    fi
    echo ""
    echo ""
    echo ""
else
    echo "${ylw} Skipped stock51 build. ${txtrst}"
    echo ""
    echo ""
    echo ""
fi

#################
## Sixth clean ##
#################

# Cleaning.
if [ $SIXCLEAN = 1 ]
then
    echo "${bldblu} Cleaning... ${txtrst}"
    make -j "$JOBS" clean
    make -j "$JOBS" mrproper
    echo "${grn} Cleaned. ${txtrst}"
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

################
# Latest clean #
################

rm -rf $PRONAME/work


echo "${gren} Kernel builder completed all tasks! ${txtrst}"
echo ""
exit 0
