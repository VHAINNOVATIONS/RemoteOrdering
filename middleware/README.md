# SOTTP Middleware

#### Table of Contents

1. [Description](#description)
1. [Requirements](#requirements)
1. [Installation](#install)
    * [MQ Install](#mq-install)
    * [IIB Install](#iib-install)
    * [Hapi Install](#hapi-install)
    * [HL7Comm Install](#hl7comm-install)
1. [Setup](#setup)
1. [Usage](#usage)


## Description

This is a mock up of what would be needed on the VA EMi system to broker data from
Vista hubs to Vista spokes. 

The VA is currently using IBMs Integration Bus(IIB) with IBMs Message queue (MQ).
With the proper setup and configuration they can be used to broker data from 
one system to another.  This repo explains how to install and configure each of 
the pieces needed to broker messages from a Vista hub to Vista spoke.

## Requirements

* Red Hat Enterprise Linux 6 (RHEL6)
* 8G RAM.
* Port 5000 open
* IBMs IIB software 10.0.0.3-IIB-LINUX64-DEVELOPER.tar.gz saved to /path/to/middleware/IIB
* IBMs MQ software mqadv_dev80_linux_x86-64.tar.gz saved to /path/to/middleware/MQ

## Installation

Each piece has its own installer this way if any or all parts are already 
installed you can just do the setup. Below are commands to install the MQ,
IIB, Hapi, and HL7Comm.  The MQ and IIB are the only installers need for 
production the rest are Optional(for development or DEBUG). **_Once finished 
running the installers be sure to log out and back in to update your 
environment PATH variable._**

#### MQ Install

```bash
    cd /path/to/middleware/MQ
    ./mq_install.sh
```

#### IIB Install

```bash
    cd /path/to/middleware/IIB
    ./iib_install.sh
```

#### Hapi Install **Optional**

```bash
    cd /path/to/middleware/Hapi
    ./hapi_install.sh
```

#### HL7Comm Install **Optional**

```bash
    cd /path/to/middleware/HL7Comm
    ./hl7comm_install.sh
```

## Setup

This section will setup the MQ and IIB software to properly broker messages between
the Vista hub and spoke.  A queue manager is created with several queues. The 
message flow is deployed to the IIB broker that is attached to the queue manager. 
A service is created to allow the application to start at boot up and shutdown
when system is stopped.

```bash
    cd /path/to/middleware/IIB
    ./SOAFTLD_setup.sh
```

## Usage

The hub to spoke mapping is done with a CSV file.  The format of the 
file is facility, ip, and port. To update the hub and spoke information
the file to modify is.

```bash
    /app/sottp/rec_facility_ids.txt
```

If you modify this file on a windows machine the CRLF values will need to be changed
to just LF values. To correct the CRLF values to LF run command below.

```bash
    dos2unix /app/sottp/rec_facility_ids.txt
```


