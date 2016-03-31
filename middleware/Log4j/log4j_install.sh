#!/bin/bash
# This script will install log4j node
# 

SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}
LOG_FILE=$SCRIPT_DIR/../logs/${SCRIPT_NAME%%.*}.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

TMP_PATH='/tmp'
INSTALL_PATH='/opt'
IIB_PATH="$INSTALL_PATH/IBM"
IIB_DIR='iib-10.0.0.3'
L4J_DIR='log4j'
L4J_TAR_NAME='iam3.zip'

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

if [ ! -f "$IIB_PATH/$IIB_DIR/iib" ]; then
  echo "IIB is required for log4j...."
  exit 1
fi

if [ -f "$INSTALL_PATH/$L4J_DIR/IAM3.pdf" ]; then
  echo "Log4j is already installed...."
  exit 0
fi

# Make sure wget is installed
if yum list unzip | grep Available; then
  echo "Installing unzip...."
  yum -y install unzip
fi

# Create install directory
if [ ! -d "$INSTALL_PATH/$L4J_DIR" ]; then
  echo "Creating install directory...."
  mkdir -p $INSTALL_PATH/L4J_DIR
fi

# Extract zip file
if [ ! -d "$INSTALL_PATH/$IIB_DIR" ]; then
  echo "Extractinr files from zip to install directory...."
  unzip $SCRIPT_DIR/$L4J_TAR_NAME -d $INSTALL_PATH/L4J_DIR
fi

# Copy jar files to specified directories
echo "Copy jar files to specified directories...."
cd $INSTALL_PATH/$L4J_DIR
cp Log4jLoggingNode_v1.2.2.jar jakarta-oro-2.0.4.jar log4j-1.2.8.jar /var/mqsi/shared-classes/.
chmod 755 /var/mqsi/shared-classes/*.jar
chown :mqbrkrs /var/mqsi/shared-classes/*.jar

cp Log4jLoggingNode_v1.2.2.jar $IIB_PATH/$IIB_DIR/server/jplugin/.
chmod 755 $IIB_PATH/$IIB_DIR/server/jplugin/Log4jLoggingNode_v1.2.2.jar
chown :mqbrkrs $IIB_PATH/$IIB_DIR/server/jplugin/Log4jLoggingNode_v1.2.2.jar

unzip Log4jLoggingPluginFeature_v1.1.zip


echo "Install complete...."
echo
