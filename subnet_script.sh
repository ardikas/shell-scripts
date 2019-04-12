#!/bin/bash
#
# Subnet Script
#
# Calculates number of hosts in a given subnet 
# -> The formula for that is 2^(32-subnet_value)-2. Thus for a /24 its 2^(32-24)-2
# -> This script should parse the subnet from the command line and should be able to produce a result with the invocation of: ./script /22
# -> If no argument is passed it should prompt the user for the cidr notation value.

#Accept user input
echo 
echo "Enter a subnet value to calculate the number of hosts in a given subnet: "
read subnet_value

#check first character and make sure it is '/'
if [ -n "$subnet_value" ]
 then w="${subnet_value//[!0-9]/}"
#then 
#drops everything that that is not numbers 0 - 9
integer="${subnet_value//[!0-9]/}"

x="$((32-$integer))"

y="$((2**$x))"

z="$(($y-2))"

echo $z

elif [ -z "$subnet_value" ]
 then 
 echo 
 echo "Please enter a CIDR notation value."
 echo
fi

