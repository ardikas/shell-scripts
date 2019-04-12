#!/bin/bash
#
# Subnet Script
#
# Calculates number of hosts in a given subnet 
# -> The formula for that is 2^(32-subnet_value)-2. Thus for a /24 its 2^(32-24)-2
# -> This script should parse the subnet from the command line and should be able to produce a result with the invocation of: ./script /22
# -> If no argument is passed it should prompt the user for the cidr notation value.

#Accept user input 
subnet_value=$1

if [ -n "$subnet_value" ]; then
 echo "Ok I have a vlue"
 #exit
else 
  read -p "Please enter a CIDR notation value: " subnet_value
  echo "$subnet_value"
  #exit
fi
#check first character and make sure it is '/'
slash=$(echo $subnet_value | fold -w 1 | head -1)

if [ $slash == "/" ]; then
  echo "Slash detected"
elif [ $slash != "/" ] && [ ${subnet_value//[!0-9]/} ]; then
  echo "Slash not detected."
fi 


#drops everything that that is not numbers 0 - 9
if [ -n "$subnet_value" ]
 then w="${subnet_value//[!0-9]/}"
x="$((32-$w))"

y="$((2**$x))"

z="$(($y-2))"

echo $z

elif [ -z "$subnet_value" ]
 then 
  echo 
  echo "Please enter a CIDR notation value."
  echo
fi
