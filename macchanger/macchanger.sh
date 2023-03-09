#!/bin/bash

# Checking system
if [[ `uname` != "Darwin" ]]
then
  printf "macchanger is only available for macOS!\n"
  exit 1
fi

# Checking sudo
if [[ $EUID -ne 0 ]]
then
  printf "Use macchanger only as root!\n"
  exit 1
fi

# Checking device
deviceExists () {
  ifconfig $1 > /dev/null 2> /dev/null
  if [[ $? -ne 0 ]]
  then
    printf "Can not find device / interface. Maybe it is down?\n"
    exit 1
  fi
}

# Checking type of interface
typeIs(){
  printf `ifconfig -v $1 | awk '/type:/ {print $NF}'` + "\n"
}

# Setting MAC
Set(){
  TYPE=$( typeIs $1 )

  if [[ $TYPE == "Wi-Fi" ]]
  then
    printf "Type of interface is Wi-Fi. Will disassociate from any network.\n"
    /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
  fi

  ifconfig $1 ether $2 2> /dev/null

  STATUS=$?

  if [[ $TYPE == "Wi-Fi" ]]
  then
    networksetup -detectnewhardware
  fi

  if [[ $STATUS -ne 0 ]]
  then
    printf "This interface has no MAC address to set.\n"
    exit 1
  fi
}
# Generate new MAC
Generate() {
  printf `openssl rand -hex 6 | sed 's/\(..\)/:\1/g; s/^.\(.\)[0-3]/\12/; s/^.\(.\)[4-7]/\16/; s/^.\(.\)[89ab]/\1a/; s/^.\(.\)[cdef]/\1e/'`
}

# Current MAC
Current () {
  ETHERCURRENT=`ifconfig $1 2> /dev/null`

  if [[ $? -ne 0 ]]
  then
    printf "Can not find device / interface. Maybe it is down?\n"
    exit 1
  fi

  printf `awk '/ether/ {print $NF}' <<< "$ETHERCURRENT"`
}

# Permanent MAC
Permanent (){
  printf `networksetup -getmacaddress $1 | awk '{print $3}'`
}

# SHOW 
if [[ "$1" == "-s" ]] || [[ "$1" == "--show" ]]
then
  if [[ "$2" == "" ]]
  then
    printf "Please specify interface\n"
    exit 1
  fi
  deviceExists $2
  ETHERCURRENT=$(Current $2)
  printf "Type of device:          $( typeIs $2 )\n"
  printf "Permanent MAC address:   $( Permanent $2 )\n"
  printf "Current MAC address:     $ETHERCURRENT\n"
# RANDOM
elif [[ "$1" == "-r" ]] || [[ "$1" == "--random" ]]
then
  if [[ "$2" == "" ]]
  then
    printf "Please specify interface\n"
    exit 1
  fi
  deviceExists $2
  OLDMAC=$( Current $2 )
  Set $2 $( Generate )
  Current=$( Current $2 )
  if [[ $OLDMAC == $Current ]]
  then
    printf "Can't set MAC address, ensure the driver supports changing it.\n"
    exit 1
  fi
  printf "Permanent MAC address:  $( Permanent $2 )\n"
  printf "Old MAC address:        $OLDMAC\n"
  printf "New MAC address:        $Current\n"
# CUSTOM
elif [[ "$1" == "-m" ]] || [[ "$1" == "--mac" ]]
then
  deviceExists $3
  OLDMAC=$( Current $3 )
  Set $3 $2
  printf "Permanent MAC address:  $( Permanent $3 )\n"
  printf "Old MAC address:        $OLDMAC\n"
  printf "New MAC address:        $( Current $3 )\n"
# RESET
elif [[ "$1" == "-p" ]] || [[ "$1" == "--permanent" ]]
then
  deviceExists $2
  OLDMAC=$( Current $2 )
  Set $2 $( Permanent $2 )
  printf "Permanent MAC address:  $( Permanent $2 )\n"
  printf "Old MAC address:        $OLDMAC\n"
  printf "New MAC address:        $( Current $2 )\n"
else
  printf "Usage: sudo macchanger [option] [data] [interface]\n"
  printf "Options:\n"
  printf " -r, --random         Sets a random MAC, e.g. macchanger -r en0\n"
  printf " -m, --mac MAC        Set a custom MAC address, e.g. macchanger -m DE:AD:BE:EF:DE:AD en0\n"
  printf " -p, --permanent      Resets the MAC to the default, e.g. macchanger -p en0\n"
  printf " -s, --show           Shows the current MAC address, e.g. macchanger -s en0\n"
fi