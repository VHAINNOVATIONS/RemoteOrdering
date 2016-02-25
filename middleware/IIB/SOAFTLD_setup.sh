#!/bin/bash

SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}
LOG_FILE=$SCRIPT_DIR/../logs/${SCRIPT_NAME%%.*}.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

INSTALL_PATH='/opt'
MQ_TAR_DIR='MQServer'
MQ_DIR='mqm'
IIB_DIR='iib-10.0.0.3'
MQ_NAME='SOAFTLD1'
BROKER_NODE_NAME="${MQ_NAME}_BKR"

if [ ! -d "$INSTALL_PATH/$MQ_DIR" ]; then
  echo "MQ is not installed...."
  exit 0
fi

if [ ! -f "$INSTALL_PATH/IBM/$IIB_DIR/iib" ]; then
  echo "IIB is not installed...."
  exit 0
fi

yum install dos2unix

# Set environment
. Ssetmqenv -s

# Verify environment
dspmqver

# Create Message Queue
crtmqm -q -u SYSTEM.DEAD.LETTER.QUEUE $MQ_NAME

# Start Message Queue
strmqm $MQ_NAME

# Create queues
runmqsc $MQ_NAME < SOTTP.mqsc

# Create a node using:
iib mqsicreatebroker $BROKER_NODE_NAME -q $MQ_NAME

# Verify the node using:
iib mqsicvp $BROKER_NODE_NAME

# Set admin port on node using:
iib mqsichangeproperties $BROKER_NODE_NAME -b webadmin -o HTTPConnector -n port -v 4495
 
# Start the node using:
iib mqsistart $BROKER_NODE_NAME

# Create a server on the node using:
iib mqsicreateexecutiongroup $BROKER_NODE_NAME -e default -w 180

# Stop the node using:
#./iib mqsistop $BROKER_NODE_NAME
 
# Delete the node using:
#./iib mqsideletebroker $BROKER_NODE_NAME

# Load broker archive (BAR) file
iib mqsideploy $BROKER_NODE_NAME -e default -a SOTTP_Asynchronous.bar

# Setup service for start, stop, restart, and status
cp soaftld /etc/init.d/.
chmod 755 /etc/init.d/soaftld
chkconfig --add soaftld
chkconfig soaftld on
chkconfig --list soaftld
service soaftld status

# install vista/spoke mapping
mkdir -p /app/sottp
cp rec_facility_ids.txt /app/sottp/.