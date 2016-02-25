#!/bin/bash
# This script will install HL7Comm
# A robust HL7 communications client that can 
# perform network communication, translation,
# file actions, logic and much more on HL7 
# messages and other types of data.

SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}
LOG_FILE=$SCRIPT_DIR/../logs/${SCRIPT_NAME%%.*}.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

INSTALL_PATH='/opt'
HL7COMM_DIR='hl7Comm'
HAPI_TAR_NAME=${HAPI_TAR_URL##*/}

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

if [ -f "$INSTALL_PATH/$HL7COMM_DIR/testpanel.sh" ]; then
  echo "HL7Comm is already installed...."
  exit 0
fi

if yum list java | grep Available; then
  echo "Installing java...."
  yum -y install java
fi

echo "Installing HL7Comm ...." 
tar -jxvf $SCRIPT_DIR/$HAPI_TAR_NAME -C $INSTALL_PATH

echo "Install complete...."
echo
