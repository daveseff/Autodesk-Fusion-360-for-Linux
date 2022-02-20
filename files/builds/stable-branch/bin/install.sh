#!/bin/bash

####################################################################################################
# Name:         Autodesk Fusion 360 - Setup Wizard (Linux)                                         #
# Description:  With this file you can install Autodesk Fusion 360 on Linux.                       #
# Author:       Steve Zabka                                                                        #
# Author URI:   https://cryinkfly.com                                                              #
# License:      MIT                                                                                #
# Copyright (c) 2020-2022                                                                          #
# Time/Date:    xx:xx/xx.xx.2022                                                                   #
# Version:      1.7.7                                                                              #
####################################################################################################

###############################################################################################################################################################
# DESCRIPTION IN DETAIL                                                                                                                                       #
###############################################################################################################################################################
# With the help of my setup wizard, you will be given a way to install Autodesk Fusion 360 with some extensions on                                            #
# Linux so that you don't have to use Windows or macOS for this program in the future!                                                                        #
#                                                                                                                                                             #
# Also, my setup wizard will guides you through the installation step by step and will install some required packages.                                        #
#                                                                                                                                                             #
# The next one is you have the option of installing the program directly on your system or you can install it on an external storage medium.                  #
#                                                                                                                                                             #
# But it's important to know, you must to purchase the licenses directly from the manufacturer of Autodesk Fusion 360, when you will work with them on Linux! #
###############################################################################################################################################################

# Window Title (Setup Wizard)
program_name="Autodesk Fusion 360 for Linux - Setup Wizard"

# Reset the driver-value for the installation of Autodesk Fusion 360!
driver_used=0

# Reset the logfile-value for the installation of Autodesk Fusion 360!
f360path_log=0

###############################################################################################################################################################
# ALL LOG-FUNCTIONS ARE ARRANGED HERE:                                                                                                                        #
###############################################################################################################################################################

# Provides information about setup actions during installation.
function setupact-install-log {
  mkdir -p "$HOME/.config/fusion-360/logs/"
  exec 5> $HOME/.config/fusion-360/logs/setupact.log
  BASH_XTRACEFD="5"
  set -x
}

# Check if already exists a Autodesk Fusion 360 installation on your system.
function setupact-check-f360 {
  f360_path="$HOME/.config/fusion-360/logs/wineprefixes.log" # Search for f360-path.log file.
  if [ -f "$f360_path" ]; then
    cp "$f360_path" "/tmp/fusion-360/logs"
    mv "/tmp/fusion-360/logs/wineprefixes.log" "/tmp/fusion-360/logs/wineprefixes"
    setupact-modify-f360 # Modify a exists Wineprefix of Autodesk Fusion 360.
  else
    f360path_log=1
    setupact-select-f360-path # Install a new Wineprefix of Autodesk Fusion 360.
  fi
}

# Save the path of the Wineprefix of Autodesk Fusion 360 into the f360-path.log file.
function setupact-log-f360-path {
if [ $f360path_log -eq 1 ]; then
  echo "$wineprefixname" >> $HOME/.config/fusion-360/logs/wineprefixes.log
fi
}

###############################################################################################################################################################
# THE INITIALIZATION OF DEPENDENCIES STARTS HERE:                                                                                                             #
###############################################################################################################################################################

# Create the structure for the installation of Autodesk Fusion 360.
function setupact-structure {
  mkdir -p $HOME/.config/fusion-360/bin
  mkdir -p $HOME/.config/fusion-360/locale/cs-CZ
  mkdir -p $HOME/.config/fusion-360/locale/de-DE
  mkdir -p $HOME/.config/fusion-360/locale/en-US
  mkdir -p $HOME/.config/fusion-360/locale/es-ES
  mkdir -p $HOME/.config/fusion-360/locale/fr-FR
  mkdir -p $HOME/.config/fusion-360/locale/it-IT
  mkdir -p $HOME/.config/fusion-360/locale/ja-JP
  mkdir -p $HOME/.config/fusion-360/locale/ko-KR
  mkdir -p $HOME/.config/fusion-360/locale/zh-CN
  mkdir -p $HOME/.config/fusion-360/driver/video
  mkdir -p $HOME/.config/fusion-360/driver/video/dxvk
  mkdir -p $HOME/.config/fusion-360/driver/video/opengl
  mkdir -p $HOME/.config/fusion-360/extensions
}

###############################################################################################################################################################

# Load the locale files for the setup wizard.
function setupact-load-locale {
  wget -N -P $HOME/.config/fusion-360/locale https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/builds/stable-branch/locale/locale.sh
  chmod +x $HOME/.config/fusion-360/locale/locale.sh
  . $HOME/.config/fusion-360/locale/locale.sh
}

function load-locale-cs {
  . $HOME/.config/fusion-360/locale/cs-CZ/locale-cs.sh
}

function load-locale-de {
  . $HOME/.config/fusion-360/locale/de-DE/locale-de.sh
}

function load-locale-en {
  . $HOME/.config/fusion-360/locale/en-US/locale-en.sh
}

function load-locale-es {
  . $HOME/.config/fusion-360/locale/es-ES/locale-es.sh
}

function load-locale-fr {
  . $HOME/.config/fusion-360/locale/fr-FR/locale-fr.sh
}

function load-locale-it {
  . $HOME/.config/fusion-360/locale/it-IT/locale-it.sh
}

function load-locale-ja {
  . $HOME/.config/fusion-360/locale/ja-JP/locale-ja.sh
}

function load-locale-ko {
  . $HOME/.config/fusion-360/locale/ko-KR/locale-ko.sh
}

function load-locale-zh {
  . $HOME/.config/fusion-360/locale/zh-CN/locale-zh.sh
}

###############################################################################################################################################################

# Load newest winetricks version for the Setup Wizard!
function setupact-load-winetricks {
  wget -N -P $HOME/.config/fusion-360/bin https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x $HOME/.config/fusion-360/bin/winetricks
}

###############################################################################################################################################################

# Load newest Autodesk Fusion 360 installer version for the Setup Wizard!
function setupact-load-f360exe {
  f360exe="$HOME/.config/fusion-360/bin/Fusion360installer.exe" # Search for a existing installer of Autodesk Fusion 360
  if [ -f "$f360exe" ]; then
    echo "Autodesk Fusion 360 installer exist!"
  else
    wget https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Admin%20Install.exe -O Fusion360installer.exe
    mv "Fusion360installer.exe" "$HOME/.config/fusion-360/bin/Fusion360installer.exe"
  fi
}

###############################################################################################################################################################
# ALL FUNCTIONS FOR DXVK AND OPENGL START HERE:                                                                                                               #
###############################################################################################################################################################

function setupact-dxvk-opengl-1 {
  if [ $driver_used -eq 1 ]; then
    WINEPREFIX=$wineprefixname sh $HOME/.config/fusion-360/bin/winetricks -q dxvk
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/builds/stable-branch/driver/video/dxvk/DXVK.reg
    WINEPREFIX=$wineprefixname wine regedit.exe DXVK.reg
  fi
}

function setupact-dxvk-opengl-2 {
  if [ $driver_used -eq 1 ]; then
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/builds/stable-branch/driver/video/dxvk/DXVK.xml
    mv "DXVK.xml" "NMachineSpecificOptions.xml"
  else
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/builds/stable-branch/driver/video/opengl/OpenGL.xml
    mv "OpenGL.xml" "NMachineSpecificOptions.xml"
  fi
}

###############################################################################################################################################################
# ALL FUNCTIONS FOR WINE AND WINETRICKS START HERE:                                                                                                           #
###############################################################################################################################################################

# Autodesk Fusion 360 will now be installed using Wine and Winetricks.
function setupact-f360install {
  # Note that the winetricks sandbox verb merely removes the desktop integration and Z: drive symlinks and is not a true sandbox.
  # It protects against errors rather than malice. It's useful for, e.g., keeping games from saving their settings in random subdirectories of your home directory. 
  WINEPREFIX=$wineprefixname sh winetricks -q sandbox atmlib gdiplus corefonts cjkfonts msxml4 msxml6 vcrun2017 fontsmooth=rgb winhttp win10
  # We must install cjkfonts again then sometimes it doesn't work in the first time!
  WINEPREFIX=$wineprefixname sh winetricks -q cjkfonts
  setupact-dxvk-opengl-1
  WINEPREFIX=$wineprefixname wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
  WINEPREFIX=$wineprefixname wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
  mkdir -p "$wineprefixname/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
  cd "$wineprefixname/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
  setupact-dxvk-opengl-2
  mkdir -p "$wineprefixname/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
  cd "$wineprefixname/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
  setupact-dxvk-opengl-2
  cd "$HOME/.config/fusion-360/bin"
  setupact-f360-launcher
  wget -N -P $HOME/.config/fusion-360/bin https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/bin/fusion360.svg
  setupact-log-f360-path
  setupact-f360extensions
  setupact-completed
}

###############################################################################################################################################################

# Create a launcher for your Wineprefix of Autodesk Fusion 360.
function setupact-f360-launcher {
  if [ $f360_launcher -eq 1 ]; then
    wget -N -P $HOME/.local/share/applications/wine/Programs/Autodesk https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/.desktop/Autodesk%20Fusion%20360.desktop
    wget -N -P $HOME/.local/share/applications/wine/Programs/Autodesk https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/blob/main/files/builds/stable-branch/.desktop/Autodesk%20Fusion%20360%20Uninstall.desktop
    wget -N -P $HOME/.config/fusion-360/bin https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/bin/uninstall.sh
    chmod +x $HOME/.config/fusion-360/bin/uninstall.sh  
    wget -N -P $HOME/.config/fusion-360/bin https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/bin/launcher.sh
    chmod +x $HOME/.config/fusion-360/bin/launcher.sh
  else
    wget -N -P $HOME/.local/share/applications/wine/Programs/Autodesk https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/.desktop/Autodesk%20Fusion%20360.desktop
    wget -N -P $HOME/.local/share/applications/wine/Programs/Autodesk https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/blob/main/files/builds/stable-branch/.desktop/Autodesk%20Fusion%20360%20Uninstall.desktop
    wget -N -P $HOME/.config/fusion-360/bin https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/bin/uninstall.sh
    chmod +x $HOME/.config/fusion-360/bin/uninstall.sh
    wget -P /tmp/fusion-360/logs https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/builds/stable-branch/bin/launcher.sh -O Fusion360launcher
    setupact-f360-modify-launcher
  fi
}

###############################################################################################################################################################
# ALL FUNCTIONS FOR SUPPORTED LINUX DISTRIBUTIONS START HERE:                                                                                                 #
###############################################################################################################################################################

# For the installation of Autodesk Fusion 360 one of the supported Linux distributions must be selected! - Part 2
function archlinux {
  echo "Checking for multilib..."
  if archlinux-verify-multilib ; then
    echo "multilib found. Continuing..."
    sudo pacman -Sy --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
    setupact-f360install
  else
    echo "Enabling multilib..."
    echo "[multilib]" | sudo tee -a /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
    setupact-f360install
  fi
}

function archlinux-verify-multilib {
  if cat /etc/pacman.conf | grep -q '^\[multilib\]$' ; then
    true
  else
    false
  fi
}

function debian-based-1 {
  # Some systems require this command for all repositories to work properly and for the packages to be downloaded for installation!
  sudo apt-get --allow-releaseinfo-change update  
  # Added i386 support for wine!
  sudo dpkg --add-architecture i386
}

function debian-based-2 {
  sudo apt-get update
  sudo apt-get install p7zip p7zip-full p7zip-rar curl winbind cabextract wget
  sudo apt-get install --install-recommends winehq-staging
  setupact-f360install
}

function debian10 {
  sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/debian/ buster main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10//Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/ ./'
}

function debian11 {
  sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11//Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/ ./'
}

function ubuntu18 {
  sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'
}

function ubuntu20 {
  sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/ ./'
}

function ubuntu21 {
  sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/ ./'
}

function ubuntu21_10 {
  sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.10/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.10/ ./'
}

function fedora-based-1 {
  sudo dnf update
  sudo dnf upgrade
  sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function fedora-based-2 {
  sudo dnf install p7zip p7zip-plugins curl wget wine cabextract
  setupact-f360install
}

function opensuse-152 {
  su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper install p7zip-full curl wget wine cabextract'
  setupact-f360install
}

function opensuse-153 {
  su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper install p7zip-full curl wget wine cabextract'
  setupact-f360install
}

function redhat-linux {
  sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
  sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  sudo dnf upgrade
  sudo dnf install wine
  setupact-f360install
}

function solus-linux {
  sudo eopkg install -y wine winetricks p7zip curl cabextract samba ppp
  setupact-f360install
}

function void-linux {
  sudo xbps-install -Sy wine wine-mono wine-gecko winetricks p7zip curl cabextract samba ppp
  setupact-f360install
}

function gentoo-linux {
  sudo emerge -nav virtual/wine app-emulation/winetricks app-emulation/wine-mono app-emulation/wine-gecko app-arch/p7zip app-arch/cabextract net-misc/curl net-fs/samba net-dialup/ppp
  setupact-f360install
}

###############################################################################################################################################################
# ALL FUNCTIONS FOR THE EXTENSIONS START HERE:                                                                                                                #
###############################################################################################################################################################

# Install a extension: Airfoil Tools

function airfoil-tools-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Fusion-360---Linux-Wine-Version-/raw/main/files/extensions/AirfoilTools_win64.msi &&
  WINEPREFIX=$wineprefixname wine AirfoilTools_win64.msi
}

###############################################################################################################################################################

# Install a extension: Additive Assistant (FFF)

function additive-assistant-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/AdditiveAssistant.bundle-win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i AdditiveAssistant.bundle-win64.msi
}

###############################################################################################################################################################

# Install a extension: Czech localization for F360
function czech-locale-extension {
  czech-locale-search-extension
  WINEPREFIX=$wineprefixname msiexec /i $CZECH_LOCALE_EXTENSION
}

###############################################################################################################################################################

# Install a extension: HP 3D Printers for Autodesk® Fusion 360™
function hp-3dprinter-connector-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/HP_3DPrinters_for_Fusion360-win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i HP_3DPrinters_for_Fusion360-win64.msi
}

###############################################################################################################################################################

# Install a extension: Helical Gear Generator
function helical-gear-generator-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/HelicalGear_win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i HelicalGear_win64.msi
}

###############################################################################################################################################################

# Install a extension: OctoPrint for Autodesk® Fusion 360™
function octoprint-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/OctoPrint_for_Fusion360-win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i OctoPrint_for_Fusion360-win64.msi
}

###############################################################################################################################################################

# Install a extension: Parameter I/O
function parameter-i-o-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/ParameterIO_win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i ParameterIO_win64.msi
}

###############################################################################################################################################################

# Install a extension: RoboDK
function robodk-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/RoboDK.bundle-win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i RoboDK.bundle-win64.msi
}

###############################################################################################################################################################

# Install a extension: Ultimaker Digital Factory for Autodesk Fusion 360™
function ultimaker-digital-factory-extension {
  cd "$HOME/.config/fusion-360/extensions"
  wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/Ultimaker_Digital_Factory-win64.msi &&
  WINEPREFIX=$wineprefixname msiexec /i Ultimaker_Digital_Factory-win64.msi
}

###############################################################################################################################################################
# ALL DIALOGS ARE ARRANGED HERE:                                                                                                                              #
###############################################################################################################################################################

# Welcome Screen - Setup Wizard of Autodesk Fusion 360 for Linux
function setupact-welcome {
  zenity --question \
         --title="$program_name" \
         --text="Would you like to install Autodesk Fusion 360 on your system?" \
         --width=400 \
         --height=100
  answer=$?

  if [ "$answer" -eq 0 ]; then
    setupact-progressbar
  elif [ "$answer" -eq 1 ]; then
    exit;
  fi
}

###############################################################################################################################################################

# A progress bar is displayed here!
function setupact-progressbar {
  (
    echo "5" ; sleep 1
    echo "# Creating folder structure." ; sleep 1
    setupact-structure
    echo "25" ; sleep 1
    echo "# Loading locale files." ; sleep 1
    setupact-load-locale
    echo "55" ; sleep 1
    echo "# Loading winetricks script." ; sleep 1
    setupact-load-winetricks
    echo "75" ; sleep 1
    echo "# Downloading Fusion 360 installation file." ; sleep 1
    setupact-load-f360exe
    echo "90" ; sleep 1
    echo "# The installation can now be started!" ; sleep 1
    echo "100" ; sleep 1
  ) |
  zenity --progress \
         --title="$program_name" \
         --text="The Setup Wizard is being configured ..." \
         --width=400 \
         --height=100 \
         --percentage=0

  if [ "$?" = 0 ] ; then
    setupact-configure-locale
  elif [ "$?" = 1 ] ; then
    zenity --question \
           --title="$program_name" \
           --text="Are you sure you want to cancel the installation?" \
           --width=400 \
           --height=100
    answer=$?

      if [ "$answer" -eq 0 ]; then
        exit;
      elif [ "$answer" -eq 1 ]; then
        setupact-progressbar
      fi
  elif [ "$?" = -1 ] ; then
    zenity --error \
           --text="An unexpected error occurred!"
    exit;
  fi
}

###############################################################################################################################################################

# Configure the locale of this Setup Wizard!
function setupact-configure-locale {
  select_locale=$(zenity --list \
                         --radiolist \
                         --title="$program_name" \
                         --width=700 \
                         --height=500 \
                         --column="Select:" --column="Language:" \
                         TRUE "English (Standard)" \
                         FALSE "German" \
                         FALSE "Czech" \
                         FALSE "Spanish" \
                         FALSE "French" \
                         FALSE "Italian" \
                         FALSE "Japanese" \
                         FALSE "Korean" \
                         FALSE "Chinese")

  [[ $select_locale = "English (Standard)" ]] && load-locale-en && licenses-en

  [[ $select_locale = "German" ]] && load-locale-de && licenses-de

  [[ $select_locale = "Czech" ]] && load-locale-cs && licenses-cs

  [[ $select_locale = "Spanish" ]] && load-locale-es && licenses-es

  [[ $select_locale = "French" ]] && load-locale-fr && licenses-fr

  [[ $select_locale = "Italian" ]] && load-locale-it && licenses-it

  [[ $select_locale = "Japanese" ]] && load-locale-ja && licenses-ja

  [[ $select_locale = "Korean" ]] && load-locale-ko && licenses-ko

  [[ $select_locale = "Chinese" ]] && load-locale-zh && licenses-zh

  [[ "$select_locale" ]] || setupact-configure-locale-abort
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - cs-CZ
function licenses-cs {
  license_cs=$HOME/.config/fusion-360/locale/cs-CZ/license-cs
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_cs \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
	      ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - de-DE
function licenses-de {
  license_de=$HOME/.config/fusion-360/locale/de-DE/license-de
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_de \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
	      ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - en-US
function licenses-en {
  license_en=$HOME/.config/fusion-360/locale/en-US/license-en
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_en \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back."
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
        ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - es-ES
function licenses-es {
  license_es=$HOME/.config/fusion-360/locale/es-ES/license-es
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_es \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
	      ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - fr-FR
function licenses-fr {
  license_fr=$HOME/.config/fusion-360/locale/fr-FR/license-fr
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_fr \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
	      ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - it-IT
function licenses-it {
  license_it=$HOME/.config/fusion-360/locale/it-IT/license-it
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_it \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
      	;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - ja-JP
function licenses-ja {
  license_ja=$HOME/.config/fusion-360/locale/ja-JP/license-ja
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_ja \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
	      ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - ko-KR
function licenses-ko {
  license_ko=$HOME/.config/fusion-360/locale/ko-KR/license-ko
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_ko \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
	      ;;
  esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - zh-CN
function licenses-zh {
  license_zh=$HOME/.config/fusion-360/locale/zh-CN/license-zh
  zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$license_zh \
         --checkbox="$text_license_checkbox"

  case $? in
    0)
        echo "Start the installation."
        setupact-check-f360
	      ;;
    1)
        echo "Go back"
        setupact-configure-locale
	      ;;
    -1)
        zenity --error \
               --text="$text_error"
        exit;
      	;;
  esac
}
