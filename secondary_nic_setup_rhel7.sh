

#!/bin/bash

# This script sets up secondary NIC for RHEL7.

# Instructions: RUN SCRIPT WITH SUDO/ROOT

 

# Functions

validate_eth1(){

    echo "Validating if eth1 exists"

   

    eth1=$(ip a | grep ^[[:digit:]] | grep -i "eth1")

  

    if [[ -n $eth1 ]]; then

        echo "Eth1 exists"

        return_validate=1

        return "$return_validate"

    elif [[ -z $eth1 ]]; then

        echo "Eth1 doesn't exist!"

        return_validate=2

        return "$return_validate"

    fi

}

 

create_eth1(){

    echo ""

    echo "Creating the 'ifcfg-eth1' file..."

 

    # Create file:

    touch /etc/sysconfig/network-scripts/ifcfg-eth1

 

    # Get MAC address of eth1:

    mac_eth1=$(cat /sys/class/net/eth1/address)

 

cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth1

DEVICE=eth1

NAME=eth1

HWADDR=$(cat /sys/class/net/eth1/address)

BOOTPROTO=dhcp

ONBOOT=yes

TYPE=Ethernet

USERCTL=no

NM_CONTROLLED=no

EOF

 

    echo "File '/etc/sysconfig/network-scripts/ifcfg-eth1' was created."

    echo ""

}

 

network_defgateway(){

    echo "Editing the file /etc/sysconfig/network..."

    echo "GATEWAYDEV=eth0" >> /etc/sysconfig/network

    echo "File '/etc/sysconfig/network' successfully edited."

    echo ""

}

 

restart_network(){

    systemctl restart network

    status=$(echo $?)

 

    if [[ "$status" != "0" ]]; then

        echo "Network restart failed.."

        echo ""

        exit 1

    elif [[ "$status" == "0" ]]; then

        echo "Network restarted successfully"

        echo ""

    fi

}

 

secondary_RT(){

    echo "Creating a new secondary routing table for the secondary interface."

 

    # Get default gateway IP

    default_gw_ip=$(/sbin/ip route | awk '/default/ { print $3 }')

 

   # Get IP of eth1

    eth1_ip=$(/sbin/ip -o -4 addr list eth1 | awk '{print $4}' | cut -d/ -f1)

 

    ip route add default via $default_gw_ip dev eth1 table 1000

    ip route add $eth1_ip dev eth1 table 1000

    ip rule add from $eth1_ip lookup 1000

 

    echo ""

    echo "Show table 1000: "

    ip route show table 1000

}

 

route_eth1(){

    echo ""

    echo "Creating a secondary static route file..."

    touch /etc/sysconfig/network-scripts/route-eth1

 

cat <<EOF > /etc/sysconfig/network-scripts/route-eth1

default via $default_gw_ip dev eth1 table 1000

ip route add $eth1_ip dev eth1 table 1000

EOF

 

    echo "File '/etc/sysconfig/network-scripts/route-eth1' successfully created."

 

}

 

rule_eth1(){

    echo ""

    echo "Seting rule for the secondary NIC IP in the routing policy database so that traffic coming from these IPs is routed according to table 1000."

    touch /etc/sysconfig/network-scripts/rule-eth1

 

cat <<EOF > /etc/sysconfig/network-scripts/rule-eth1

from $eth1_ip lookup 1000

EOF

 

    echo "File '/etc/sysconfig/network-scripts/rule-eth1' successfully created."

    echo ""

}

 

# call validate_eth1() function

validate_eth1

 

# Start File creation if eth1 exists

if [[ "$return_validate" != "1" ]]; then

    echo "Please try again."

    echo ""

    exit 1

elif [[ "$return_validate" == "1" ]]; then

 

    # Call create_eth1() function

    create_eth1

fi

 

# Create the primary interface to not lose connectivity. Edit the /etc/sysconfig/network file

network_defgateway

 

# Call restart_network() Function

restart_network

 

# Create new secondary routing table

secondary_RT

 

# Create secondary static route file

route_eth1

 

# Set rules in the routing policy database

rule_eth1

 

# Call restart_network() Function again

restart_network

 

echo "Done!"
