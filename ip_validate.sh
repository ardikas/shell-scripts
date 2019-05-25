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
	echo ""
	echo "User input: $ip_input"
	#echo "valiate_ip() was called."
	
	front_dot=$(echo $ip_input | fold -w 1 | head -1)
	end_dot=$(echo $ip_input | fold -w 1 | tail -1 )
	
	if [[ $front_dot == "." ]]; then
  		echo "IP address cannot have a decimal in the beginning!"
		return_validate=1
		return "$return_validate"
	elif [[ $end_dot == "." ]]; then
		echo "IP address cannot end in a decimal!"
		return_validate=2
		return "$return_validate"
	fi

	# set the Internal Field Separator to '.'
	IFS=. 
	set -- $ip_input   # I sort of forgot what this does

	# "$#" stores the number of command line arguments that were passed to the shell program
	if [[ "$#" -ne "4" ]] || [[ "$#" -gt "4" ]]; then
		echo "IP address must contain 4 octets"
		return_validate=2
		return "$return_validate"
	fi
	
	for octet in $1 $2 $3 $4; do
		
		# this will return a 0 if $octet contains numbers, return a 1 if there are any letters. 
		# /dev/null redirects standard output (stdout) to /dev/null, which discards it.
		echo $octet | egrep "^[0-9]+$" >/dev/null 2>&1
		
		if [[ "$?" -ne "0" ]]; then
			echo "$octet: IPv4 address cannot contain alphabet letters or special characters!"
			return_validate=3
			return "$return_validate"
		elif [[ "$octet" -lt "0" ]] || [[ "$octet" -gt "255" ]]; then
			echo "$octet: IP address is invalid. Out of range."
			return_validate=4
			return "$return_validate"
		fi
	done	
	return_valid_ip=0
	return "$return_valid_ip"
} 

# get user input
ip_input=$1

# If user input is empty, prompt again	
while [[ -z "$ip_input" ]]; do
	echo ""
	read -p "No IP was given. Please enter an IP address:" ip_input
done

# call function
validate_ip

# finale
if [[ "$return_valid_ip" != "0" ]]; then
	echo "Please try again."
	echo ""
	exit 1
elif [[ "$return_valid_ip" == "0" ]]; then
	echo "$ip_input is valid!"
	echo ""
fi
exit 0
