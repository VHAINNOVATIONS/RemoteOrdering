#!/bin/bash
# This script will install IBM Integration Bus (IIB)
# v10.0.0.3

SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}
LOG_FILE=$SCRIPT_DIR/../logs/${SCRIPT_NAME%%.*}.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

TMP_PATH='/tmp'
INSTALL_PATH='/opt/IBM'
IIB_DIR='iib-10.0.0.3'
IIB_TAR_NAME='10.0.0.3-IIB-LINUX64-DEVELOPER.tar.gz'
echo $IIB_TAR_NAME

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

if [ -f "$INSTALL_PATH/$IIB_DIR/iib" ]; then
  echo "IIB is already installed...."
  exit 0
fi

# Make sure wget is installed
if yum list wget | grep Available; then
  echo "Installing wget...."
  yum -y install wget
fi

# Make sure webkitgtk is installed
if yum list webkitgtk | grep Available; then
  echo "Installing webkitgtk...."
  yum -y install webkitgtk
fi

# Create install directory
if [ ! -d "$INSTALL_PATH" ]; then
  echo "Creating install directory...."
  mkdir -p $INSTALL_PATH
fi

# Extract tar file
if [ ! -d "$INSTALL_PATH/$IIB_DIR" ]; then
  echo "Extractinr files from tar to install directory...."
  tar -zxvf $SCRIPT_DIR/$IIB_TAR_NAME -C $INSTALL_PATH
fi

# Add iib to path
echo "export PATH=\$PATH:$INSTALL_PATH/$IIB_DIR" > /etc/profile.d/iib.sh
echo "set path = (\$path $INSTALL_PATH/$IIB_DIR)" > /etc/profile.d/iib.csh
source /etc/profile.d/iib.sh

# Accept the IBM Integration Bus license
echo "Accept the IBM Integration Bus license...."
cd "$INSTALL_PATH/$IIB_DIR"
./iib make registry global accept license silently

# verify install version
echo "Verify installed version...."
./iib version

# add root to mqbrkrs group
usermod -a -G mqbrkrs root

echo "Install complete...."
echo
