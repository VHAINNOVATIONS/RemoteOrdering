#!/bin/bash
# This script will install Hapi
# HL7 application programming interface

SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}
LOG_FILE=$SCRIPT_DIR/../logs/${SCRIPT_NAME%%.*}.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

TMP_PATH='/tmp'
INSTALL_PATH='/opt'
HAPI_DIR='hapi-testpanel-2.0.1'
HAPI_TAR_URL='http://sourceforge.net/projects/hl7api/files/hapi-testpanel/2.0.1/hapi-testpanel-2.0.1-linux.tar.bz2/download -O /tmp/hapi-testpanel-2.0.1-linux.tar.bz2'
HAPI_TAR_NAME=${HAPI_TAR_URL##*/}

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

if [ -f "$INSTALL_PATH/$HAPI_DIR/testpanel.sh" ]; then
  echo "Hapi is already installed...."
  exit 0
fi


if yum list java | grep Available; then
  echo "Installing java...."
  yum -y install java
fi

echo "Installing Hapi hl7 TestPanel ...." 
wget $HAPI_TAR_URL -O $TMP_PATH/$HAPI_TAR_NAME
tar -jxvf $TMP_PATH/$HAPI_TAR_NAME -C $INSTALL_PATH

echo "Install complete...."
echo
