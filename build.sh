#!/bin/bash

#    Copyright 2016, 2017 Rafal Wisniewski (wisniew99@gmail.com)
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


#############################################
#############################################
##                                         ##
####           Harfix builder            ####
##                                         ##
#############################################
#############################################
##                   1.1                   ##
#                                           #
# Build script for Kernels.                 #
# By wisniew99 / rafciowis1999              #
#                                           #
# Script based on inplementation            #
# in Harfix3 kernel for i9300.              #
#                                           #
# Read and edit all things in tables.       #
#                                           #
##      REMEMBER TO EDIT LOCATIONS!!!      ##
#############################################
#############################################
#                                            #
# If colours looks ugly, use black terminal.  #
#                                              #
#####################################################
###################  MAIN THINGS  ###################
#####################################################
##                                                  ##
PRONAME="Harfix4"         # Project name.            ##
VERSION="R2.2"            # Version number or name.   ##
#                                                      ##
#               New name = new main folder              ##
#############################################################
########################  OPTIONS  ##########################
#############################################################
####              (1-enabled, 0-disabled)                ####
##                                                         ##
CLEAN=0                         # Clean before compile.    ##
##        ##  111  ##                                      ##
MAIN1=1                         # Compile first version.   ##
    MAINZIP1=1                      # Zip first  version.  ##
##                                                         ##
SECCLEAN=0                      # Clean between versions.  ##
##        ##  222  ##                                      ##
MAIN2=0                         # Compile second version.  ##
    MAINZIP2=1                      # Zip second version.  ##
##                                                         ##
THICLEAN=0                      # Clean between versions.  ##
##        ##  333  ##                                      ##
MAIN3=0                         # Compile third version.   ##
    MAINZIP3=1                      # Zip third version.   ##
##                                                         ##
FOUCLEAN=0                      # Clean between versions.  ##
##        ##  444  ##                                      ##
MAIN4=0                         # Compile fourth version.  ##
    MAINZIP4=1                      # Zip fourth version.  ##
##                                                         ##
FIFCLEAN=0                      # Clean between versions.  ##
##        ##  555 ##                                       ##
MAIN5=0                         # Compile fifth version.   ##
    MAINZIP5=1                      # Zip fifth version.   ##
##                                                         ##
SIXCLEAN=0                      # Latest clean.            ##
##                                                         ##
####    If compile is disabled, zip is disabled too.     ####
#############################################################
####################  Edit not needed  ######################
#############################################################
#                                                           #
# Auto detect Your home folder.                             #
HOME="$(dirname ~)/$(basename ~)"                           #
#                                                           #
#############################################################
########################  CONFIGS  ##########################
#############################################################
##                                                          ##
CONFIG1=harfix4_defconfig                 # First config     ##
CONFIG2=                                  # Second config     ##
CONFIG3=                                  # Third config       ##
CONFIG4=                                  # fourth config       ##
CONFIG5=                                  # fifth config         ##
##                                                                ##
##                                                                 ##
#####################################################################
###########################  EDIT THIS!  ############################
#####################################################################
##                                                                 ##
##                                                                 ##
ARCH=arm64                                       # arch of device  ##
SUBARCH=arm64                                  # subarch of device ##
USER=wisniew99                                   # Name of builder ##
HOST=Harfix-machine                              # name of machine ##
TCDIR=$HOME/TC                                   # Toolchain dir   ##
TCNAME="google-ndk"                              # Toolchain name  ##
TCEND="bin/aarch64-linux-android-"         # End of toolchain name ##
TCLIB="lib64/"                                  # lib folder in TC ##
##                                                                 ##
##                      ##  TC example:  ##                        ##
##                     $TCDIR/$TCNAME/$TCEND                       ##
##                                                                 ##
#####################################################################
####################  BUILD SPECIFIC OPTIONS  #######################
#####################################################################
##                                                                  ##
NAME1=""                         # Name of first version             ##
NAME2=""                         # Name of second version             ##
NAME3=""                         # Name of third version               ##
NAME4=""                         # Name of fourth version               ##
NAME5=""                         # Name of fifth version                 ##
##                                                                        ##
#############################################################################
##############################  BUILD PATHS  ################################
#############################################################################
##                                                                         ##
PATHZIMAGE1=""                           # zImage path for first version   ##
PATHMODULES1="modules"                   # modules path for first version  ##
##                                                                         ##
PATHZIMAGE2=""                           # zImage path for second version  ##
PATHMODULES2=""                          # modules path for second version ##
##                                                                         ##
PATHZIMAGE3=""                           # zImage path for third version   ##
PATHMODULES3=""                          # modules path for third version  ##
##                                                                         ##
PATHZIMAGE4=""                           # zImage path for fourth version  ##
PATHMODULES4=""                          # modules path for fourthversion  ##
##                                                                         ##
PATHZIMAGE5=""                           # zImage path for fifth version   ##
PATHMODULES5=""                          # modules path for fifth version  ##
##                                                                       ##
##                                                                     ##
##                   ##  Path example:  ##                           ##
##               $PRONAME/ZIP_FILES/PATHZIMAGE                     ##
##               $PRONAME/ZIP_FILES/PATHMODULES                  ##
##                                                             ##
##                                                           ##
#############################################################
########################  COLORS  ###########################
#############################################################
##                                                         ##
red=$(tput setaf 1)             # red     # Error          ##
grn=$(tput setaf 2)             # green   # Done           ##
ylw=$(tput setaf 11)            # yellow  # Warring        ##
blu=$(tput setaf 4)             # blue    # path           ##
gren=$(tput setaf 118)          # green   # Name           ##
pur=$(tput setaf 201)           # purple  # Name           ##
txtbld=$(tput bold)             # Bold    # Info           ##
bldred=${txtbld}$(tput setaf 1) # Red     # Error desc     ##
bldblu=${txtbld}$(tput setaf 4) # blue    # Info           ##
txtrst=$(tput sgr0)             # Reset                    ##
##                                                         ##
#############################################################
#############################################################

JOBS="$(grep -c "processor" "/proc/cpuinfo")"   # Maximum jobs that Your computer can do.

echo -e '\0033\0143'
echo ""
echo ""
echo "${gren} Starting Harfix builder...${txtrst}"
echo "${gren} By${txtrst} ${pur}wisniew99 / rafciowis1999 ${txtrst} "
echo "${gren} Program is licenced under GNU GPL v2${txtrst}"
echo ""
echo ""
echo ""
echo "${txtbld} Creating folders... ${txtrst}"
echo ""

# Create unnecessary folders.
if [ -e "$PRONAME" ]
then
    echo "${bldblu} $PRONAME${txtrst}${blu} exist. ${txtrst}"
    FIRSTRUN=0
else
    echo "${ylw} $PRONAME not exist. ${txtrst}"
    mkdir $PRONAME
    echo "${grn} Created. ${txtrst}"
    FIRSTRUN=1
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

if [ -e "$PRONAME/Releases" ]
then
    echo "${bldblu} $PRONAME/Releases${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/Releases not exist. ${txtrst}"
    mkdir $PRONAME/Releases
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES2" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES2${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES2 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES2
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES3" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES3${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILE3S not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES3
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES4" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES4${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES4 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES4
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES5" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES5${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES5 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES5
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/$PATHZIMAGE1" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES/$PATHZIMAGE1${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES/$PATHZIMAGE1 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES/$PATHZIMAGE1
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES2/$PATHZIMAGE2" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES2/$PATHZIMAGE2${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES2/$PATHZIMAGE2 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES2/$PATHZIMAGE2
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES3/$PATHZIMAGE3" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES3/$PATHZIMAGE3${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES3/$PATHZIMAGE3 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES3/$PATHZIMAGE3
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES4/$PATHZIMAGE4" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES4/$PATHZIMAGE4${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES4/$PATHZIMAGE4 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES4/$PATHZIMAGE4
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES5/$PATHZIMAGE5" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES5/$PATHZIMAGE5${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES5/$PATHZIMAGE5 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES5/$PATHZIMAGE5
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES/$PATHMODULES1" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES/$PATHMODULES1${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES/$PATHMODULES1 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES/$PATHMODULES1
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES2/$PATHMODULES2" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES2/$PATHMODULES2${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES2/$PATHMODULES2 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES2/$PATHMODULES2
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES3/$PATHMODULES3" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES3/$PATHMODULES3${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES3/$PATHMODULES3 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES3/$PATHMODULES3
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES4/$PATHMODULES4" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES4/$PATHMODULES4${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES4/$PATHMODULES4 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES4/$PATHMODULES4
    echo "${grn} Created. ${txtrst}"
fi

if [ -e "$PRONAME/ZIP_FILES5/$PATHMODULES5" ]
then
    echo "${bldblu} $PRONAME/ZIP_FILES5/$PATHMODULES5${txtrst}${blu} exist. ${txtrst}"
else
    echo "${ylw} $PRONAME/ZIP_FILES5/$PATHMODULES5 not exist. ${txtrst}"
    mkdir $PRONAME/ZIP_FILES5/$PATHMODULES5
    echo "${grn} Created. ${txtrst}"
fi

echo ""
echo "${txtbld} Done creating folders. ${txtrst}"
echo ""
echo ""
echo ""

if [ $FIRSTRUN = 1 ]
then
    echo "${txtbld} First run of script detected. ${txtrst}"
    echo ""
    if [ -e "$PRONAME/ZIP_FILES" ]
    then
        echo "${grn} Created folders. ${txtrst}"
    else
        echo "${red} ERROR! ${txtrst}"
        echo "${bldred} Can't create folders. ${txtrst}"
        echo "${bldred} Make them manually ${txtrst}"
        echo "${bldred} or contact with author. ${txtrst}"
        echo ""
        echo ""
        echo ""
        echo "${gren} Harfix builder completed all tasks! ${txtrst}"
        echo ""
        exit 1
    fi
    echo "${txtbld} Put Your installer in ZIP_FILES ${txtrst}"
    echo "${txtbld} and run script again. ${txtrst}"
    echo ""
    echo ""
    echo ""
    echo "${gren} Harfix builder completed all tasks! ${txtrst}"
    echo ""
    exit 0
fi

echo "${txtbld} Deleting files... ${txtrst}"
echo ""

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

if [ -e "$PRONAME/$PRONAME-$VERSION-$NAME1.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-$NAME1.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-$NAME1.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-$NAME1.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-$NAME2.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-$NAME2.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-M$NAME2.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-$NAME2.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-$NAME3.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-$NAME3.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-$NAME3.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-$NAME3.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-$NAME4.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-$NAME5.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-$NAME4.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-$NAME4.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "$PRONAME/$PRONAME-$VERSION-$NAME5.zip" ]
then
    echo "${ylw} $PRONAME-$VERSION-$NAME5.zip exist. ${txtrst}"
    rm -rf $PRONAME/$PRONAME-$VERSION-$NAME5.zip
    echo "${grn} Deleted. ${txtrst}"
else
    echo "${bldblu} $PRONAME-$VERSION-$NAME5.zip${txtrst}${blu} not exist. ${txtrst}"
fi

if [ -e "arch/$ARCH/boot/zImage" ]
then
    echo "${ylw} arch/$ARCH/boot/zImage exist. ${txtrst}"
    rm -rf arch/$ARCH/boot/zImage
    echo "${grn} Deleted old zImage. ${txtrst}"
else
    echo "${bldblu} arch/$ARCH/boot/zImage${txtrst}${blu} not exist. ${txtrst}"
fi

    rm -rf $PRONAME/ZIP_FILES/PATHZIMAGE1/*zImage*
    rm -rf $PRONAME/ZIP_FILES/PATHZIMAGE1/Image
    rm -rf $PRONAME/ZIP_FILES2/PATHZIMAGE2/*zImage*
    rm -rf $PRONAME/ZIP_FILES2/PATHZIMAGE2/Image
    rm -rf $PRONAME/ZIP_FILES3/PATHZIMAGE3/*zImage*
    rm -rf $PRONAME/ZIP_FILES3/PATHZIMAGE3/Image
    rm -rf $PRONAME/ZIP_FILES4/PATHZIMAGE4/*zImage*
    rm -rf $PRONAME/ZIP_FILES4/PATHZIMAGE4/Image
    rm -rf $PRONAME/ZIP_FILES5/PATHZIMAGE5/*zImage*
    rm -rf $PRONAME/ZIP_FILES5/PATHZIMAGE5/Image
    echo "${grn} Deleted old Images. ${txtrst}"

    rm -rf $PRONAME/ZIP_FILES/PATHMODULES1/*
    rm -rf $PRONAME/ZIP_FILES2/PATHMODULES2/*
	rm -rf $PRONAME/ZIP_FILES3/PATHMODULES3/*
    rm -rf $PRONAME/ZIP_FILES4/PATHMODULES4/*
    rm -rf $PRONAME/ZIP_FILES5/PATHMODULES4/*
    echo "${grn} Deleted all modules. ${txtrst}"

echo ""
echo "${txtbld} Done deleting files. ${txtrst}"
echo ""
echo ""
echo ""


# Edit at beginning of script, not here.
export ARCH=$ARCH
export SUBARCH=$SUBARCH
export KBUILD_BUILD_USER=$USER
export KBUILD_BUILD_HOST=$HOST
export CROSS_COMPILE=$TCDIR/$TCNAME/$TCEND
export LD_LIBRARY_PATH=$TCDIR/$TCNAME/$TCLIB
STRIP=$TCDIR/$TCNAME/$TCENDstrip

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
    echo ""
    echo ""
    echo "${gren} Harfix builder completed all tasks! ${txtrst}"
    echo ""
    exit 1
fi

#############
# Functions #
#############

function COMPILEZIP
{
    if [ $MAIN = 1 ]
    then

        echo "${txtbld} Starting $NAME compile... ${txtrst}"
        echo ""
        echo ""
        echo ""

        echo "${bldblu} Loading config... ${txtrst}"
        make $CONFIG
        echo "${grn} Done. ${txtrst}"
        echo ""

        echo "${bldblu} Compiling... ${txtrst}"
        make -j "$JOBS"
        echo "${grn} Done. ${txtrst}"
        echo ""

        if [ $ARCH = "arm64" ]
        then
            if [ -e "arch/$ARCH/boot/Image.gz-dtb" ]
            then
                mv arch/$ARCH/boot/Image.gz-dtb arch/$ARCH/boot/zImage
            else
                mv arch/$ARCH/boot/Image.gz arch/$ARCH/boot/zImage
            fi
        fi

        if [ -e "arch/$ARCH/boot/zImage" ]
        then

            echo "${bldblu} Coping modules... ${txtrst}"
            find -name '*.ko' -exec cp -av {} $PRONAME/work/modules/ \;
            echo "${grn} Done. ${txtrst}"
            echo ""

            echo "${bldblu} Coping zImage... ${txtrst}"
            cp arch/$ARCH/boot/zImage $PRONAME/work/boot/
            echo "${grn} Done. ${txtrst}"
            echo ""
            echo ""
            echo ""

            echo "${grn} zImage detected. ${txtrst}"
            echo ""
            echo ""
            echo ""

            if [ $MAINZIP = 1 ]
            then

                echo "${txtbld} Starting $NAME compress... ${txtrst}"
                echo ""
                echo ""
                echo ""

                echo "${bldblu} Coping files for zip... ${txtrst}"
                cp $PRONAME/work/modules/* $PRONAME/$ZIP_FILES/$PATHMODULES/
                cp $PRONAME/work/boot/zImage $PRONAME/$ZIP_FILES/$PATHZIMAGE/
                echo "${grn} Done. ${txtrst}"
                echo ""

                echo "${bldblu} Zipping... ${txtrst}"
                cd $PRONAME/$ZIP_FILES
                zip -r $PRONAME.zip *
                cd -
                echo "${grn} Done. ${txtrst}"
                echo ""

                echo "${bldblu} Moving... ${txtrst}"
                mv $PRONAME/$ZIP_FILES/$PRONAME.zip $PRONAME/Releases/
                echo "${grn} Done. ${txtrst}"
                echo ""

                echo "${bldblu} Renaming... ${txtrst}"
                mv $PRONAME/Releases/$PRONAME.zip $PRONAME/Releases/$PRONAME-$NAME-$VERSION.zip
                echo "${grn} Done. ${txtrst}"
                echo ""
                echo ""
                echo ""
                echo "${txtbld} Done $NAME build compile with compress. ${txtrst}"
            else
                echo "${txtbld} Done $NAME build compile. ${txtrst}"
            fi
        else
            echo "${red} ERROR! ${txtrst}"
            echo "${bldred} zImage NOT detected. ${txtrst}"
            echo ""
            echo ""
            echo ""
            echo "${gren} Harfix builder completed all tasks! ${txtrst}"
            echo ""
            exit 1
        fi
        echo ""
        echo ""
        echo ""
    else
        echo "${ylw} Skipped $NAME build. ${txtrst}"
        echo ""
        echo ""
        echo ""
    fi
}

function CLEANER
{
    rm -rf arch/$ARCH/boot/zImage
    rm -rf $PRONAME/$ZIP_FILES/$PATHZIMAGE/*zImage*
    rm -rf $PRONAME/$ZIP_FILES/$PATHZIMAGE/Image
    rm -rf $PRONAME/$ZIP_FILES/$PATHMODULES/*
    rm -rf $PRONAME/work/boot/*
    rm -rf $PRONAME/work/modules/*
}
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


###############
## Compiling ##
###############

MAIN=$MAIN1
MAINZIP=$MAINZIP1
NAME=$NAME1
CONFIG=$CONFIG1
PATHMODULES=$PATHMODULES1
PATHZIMAGE=$PATHZIMAGE1
ZIP_FILES=ZIP_FILES
COMPILEZIP
CLEANER

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

###############
## Compiling ##
###############

MAIN=$MAIN2
MAINZIP=$MAINZIP2
NAME=$NAME2
CONFIG=$CONFIG2
PATHMODULES=$PATHMODULES2
PATHZIMAGE=$PATHZIMAGE2
ZIP_FILES=ZIP_FILES2
COMPILEZIP
CLEANER

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

###############
## Compiling ##
###############

MAIN=$MAIN3
MAINZIP=$MAINZIP3
NAME=$NAME3
CONFIG=$CONFIG3
PATHMODULES=$PATHMODULES3
PATHZIMAGE=$PATHZIMAGE3
ZIP_FILES=ZIP_FILES3
COMPILEZIP
CLEANER

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

###############
## Compiling ##
###############

MAIN=$MAIN4
MAINZIP=$MAINZIP4
NAME=$NAME4
CONFIG=$CONFIG4
PATHMODULES=$PATHMODULES4
PATHZIMAGE=$PATHZIMAGE4
ZIP_FILES=ZIP_FILES4
COMPILEZIP
CLEANER

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

###############
## Compiling ##
###############

MAIN=$MAIN5
MAINZIP=$MAINZIP5
NAME=$NAME5
CONFIG=$CONFIG5
PATHMODULES=$PATHMODULES5
PATHZIMAGE=$PATHZIMAGE5
ZIP_FILES=ZIP_FILES5
COMPILEZIP
CLEANER

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

################
# Latest clean #
################

rm -rf $PRONAME/work


echo "${gren} Harfix builder completed all tasks! ${txtrst}"
echo ""
exit 0
