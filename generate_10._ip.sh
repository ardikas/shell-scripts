#! /bin/bash

#! /bin/bash
#
# This shell script will generate all IP addresses in the 10.0.0.0/8 address space.
# So 10.0.0.0 - 10.255.255.255
#
  #seq -f "10.20.30.%g" 00 255
#seq 1 23 | sed 's/^/10.0.0./'
 #for i in $(seq 1 23); do echo "10.0.0.$i"; done

# First octets
network_prefix="10."

#second, third, and fourth octets; set to 0
octet2=0
octet3=0
octet4=0


while [[ "$octet2" -le 5 ]]; do # stopped at 5 so it will not print all
	
	while [[ "$octet3" -le 255 ]]; do	
		
		while [[ "$octet4" -le 255 ]]; do 
			
			# %s = append each field. \n = new line;
			printf "%s%s%s%s%s%s%s%s%s\n" $network_prefix $octet2 "." $octet3 "." $octet4 
			octet4=$(($octet4+1)) # increment by 1
		done
		
		octet3=$(($octet3+1)) # increment by 1
		octet4=0 # reset
	done
	
	octet2=$(($octet2+1))
	octet3=0
	octet4=0
done


