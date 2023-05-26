#!/bin/sh
# WUD common

# Put MAC address of PC you want to Wake-On-LAN here
MAC_ADDR=""

# Put IP address here of your PC when it boots. We use this to SSH into the machine after WOL
IP=""

wakeonlan "$MAC_ADDR"

# Only invoke this as part of another command
if [ $# -eq 0 ]
  then
    echo "No VM to boot supplied, just booting host."
    exit
fi

echo "Waiting for desktop to boot."
#sleep 10
echo "Pinging desktop..."

function waitfor () { 
	/bin/time -q -f "Took %e seconds to ping" ping $1 | grep --line-buffered "bytes from" | head -1
}

waitfor "$IP" && echo "Host booted! Checking SSH connection..."

function ssh_check () {
    until ssh -o ConnectTimeout=2 "$1"@"$2" "$3"
        do sleep 1
    done
}
TIMEFORMAT="Took %R seconds to connect to SSH"
time ssh_check root "$IP" "exit"

echo "SSH connection successful. Booting VM \"$1\"."
echo "Sleeping for 5 seconds..."

# This is the command you want to run when your PC boots
ssh root@"$IP" "sleep 5; while ! ip link show vmbr0 up >/dev/null 2>&1; do sleep 1; done;echo \"vmbr0 is up\"; qm start $1; exit"
