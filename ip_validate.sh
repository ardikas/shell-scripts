#!/bin/bash
#
# Validate IP script
#
# Use IFS; Internal Field Separator
# https://subscription.packtpub.com/book/networking_and_servers/9781785286216/8/ch08lvl1sec69/the-ifs-and-loops
# https://stackoverflow.com/questions/7815989/need-to-break-ip-address-stored-in-bash-variable-into-octets
#
# Use set
# https://unix.stackexchange.com/questions/308260/what-does-set-do-in-this-dockerfile-entrypoint/308263

# validate ip function
validate_ip(){
	echo "You've reached the function"
	IFS=. 
	set -- $ip_input

	echo "$ip_input  ****"
	
	if [[ "$#" -ne "4" ]]; then
		echo "IP address must contain 4 octets"
		return_validate=1
		return "$return_validate"
	fi
	
	for octet in $1 $2 $3 $4; do
		
		# this will return a 0 if $octet contains numbers, return a 1 if there are any letters. 
		# /dev/null redirects standard output (stdout) to /dev/null, which discards it.
		echo $octet | egrep "^[0-9]+$" >/dev/null 2>&1
		
		if [[ "$?" -ne "0" ]]; then
			echo "$octet: IPv4 address cannot contain alphabet letters."
			return_validate=2
			return "$return_validate"
		elif [[ "$octet" -lt "0" ]] || [[ "$octet" -gt "255" ]]; then
			echo "$octet: IP address is invalid. Out of range."
			return_validate=3
			return "$return_validate"
		fi
	done	
	return_valid_ip=0
	return "$return_valid_ip"
} 


ip_input=$1
echo "$ip_input"


# If user input is empty, prompt again	
while [[ -z "$ip_input" ]]; do
	read -p "No IP was given. Please enter an IP address:" ip_input
	echo ""
done

# call function
validate_ip

if [[ "$return_valid_ip" != "0" ]]; then
	echo "Please try again."
	exit 1
elif [[ "$return_valid_ip" == "0" ]]; then
	echo "$ip_input is valid!"
fi
exit 0
