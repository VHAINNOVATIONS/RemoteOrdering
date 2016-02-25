#!/bin/bash
# This script will install IBM Message queue (MQ)
# 

SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}
LOG_FILE=$SCRIPT_DIR/../logs/${SCRIPT_NAME%%.*}.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

TMP_PATH='/tmp'
INSTALL_PATH='/opt'
MQ_TAR_DIR='MQServer'
MQ_DIR='mqm'
MQ_TAR_NAME='mqadv_dev80_linux_x86-64.tar.gz'

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

if [ -d "$INSTALL_PATH/$MQ_DIR" ]; then
  echo "MQ is already installed...."
  exit 0
fi

if yum list java* | grep Available; then
  echo "Installing java...."
  yum -y install java
fi

echo "Untar MQ server files...." 
tar -zxvf $SCRIPT_DIR/$MQ_TAR_NAME -C $INSTALL_PATH

# Add mq to path
echo "export PATH=\$PATH:$INSTALL_PATH/$MQ_DIR/bin" > /etc/profile.d/mq.sh
echo "set path = (\$path $INSTALL_PATH/$MQ_DIR/bin)" > /etc/profile.d/mq.csh
source /etc/profile.d/mq.sh

echo "Install MQ rpms...."
cd $INSTALL_PATH/$MQ_TAR_DIR
./mqlicense.sh -accept
yum -y install MQSeriesServer* MQSeriesRuntime* MQSeriesGSKit* MQSeriesJava* MQSeriesJRE* MQSeriesMan* MQSeriesSamples* MQSeriesSDK* MQSeriesExplorer*

# Set environment
. /opt/mqm/bin/setmqenv -s

# Verify environment
/opt/mqm/bin/dspmqver

# add root to mqm group
usermod -a -G mqm root

echo "Install complete...."
echo
