#!/bin/bash
#                             
# Launch EC2 Instance Script
# By: Ardika Sulistija     
#
# Command: 
# aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name [mykeypair] --security-group-ids sg-xxxxxxxx --subnet-id subnet-xxxxxxxx

# Functions

check_ami_input() {
	#still need to figure out how to determine if ami exists, this will do for now.
	first_three=$(echo $ami_id | fold -w 3 | head -1) #isolate first three char
	fourth_dash=$(echo $ami_id | head -c 4 | tail -c 1) #isolate fourth char

	if [[ -z "$ami_id" ]]; then
		return_ami_val=2
		return "$return_ami_val"
	elif [ $first_three == "ami" ]; then
		echo "'ami' detected"
	elif [ $first_three != "ami" ]; then
		echo "Please enter an 'ami-xxxxxxx' value"
		exit 1
	fi
	
	if [[ $fourth_dash == '-' ]]; then
		echo "fourth char is a '-'"
		return 0		 
	elif [[ $fourth_dash != '-' ]]; then
		echo "Dash not detected"
		echo "Please enter a proper ami value"
		exit 1
	fi
	
}

check_instance_type() {
    	if [[ -z "$instance_type" ]]; then
                return_inst_val=2
                return "$return_inst_val"
	elif [[ -n "$instance_type" ]]; then
		if [[ $instance_type == "t2.micro" ]]; then
			return_inst_val=0
			return "$return_inst_val"
		elif [[ $instance_type != "t2.micro" ]]; then
			return_inst_val=1
			return "$return_inst_val"
		fi
	fi
}

check_key_name() {
	if [[ -z "$key_name" ]]; then
		return_key_val=2
		return "$return_key_val"
	elif [[ -n "$key_name" ]]; then

		#aws ec2 describe-key-pairs | grep "$key_name"
		aws ec2 describe-key-pairs --key-name "$key_name"
		key_exist=$?
		if [[ $key_exist == 0 ]]; then
			echo "Key pair exists."
			return_key_val=1
 	                return "$return_key_val"
		elif [[ $key_exist != 0 ]]; then
			echo "Key pair does not exist. Please try again."
			exit 1
		fi
	fi
} 

check_security_group() {
	if [[ -z "$sec_group" ]]; then
		return_sg_val=2
		return "$return_sg_val"
	elif [[ -n "$sec_group" ]]; then
	 	aws ec2 describe-security-groups --group-ids "$sec_group"	
#flaw		#aws ec2 describe-security-groups | grep "$sec_group"
		group_exist=$?
		if [[ $group_exist == 0 ]]; then
			echo "Security group exists."
			return_sg_val=1
			return "$return_sg_val"
		elif [[ $group_exist != 0 ]]; then
			echo "Security group does not exist. Please try again."
			exit 1
		fi
	fi
}

check_subnet_id() {
	if [[ -z "$subnet_id" ]]; then
		return_sub_val=2
		return "$return_sub_val"
	elif [[ -n "$subnet_id" ]]; then
		
		aws ec2 describe-subnets --subnet-ids "$subnet_id"
		subnet_exist=$?
		if [[ $subnet_exist == 0 ]]; then
			echo "Subnet exists."
			return_sub_val=1
			return "$return_sub_val"
		elif [[ $subnet_exist != 0 ]]; then
			echo "Subnet does not exist. Please try again."
			exit 1
		fi
	fi
}

check_instance_id() {
	if [[ -z "$instance_id" ]]; then
		return_ii_val=2
		return "$return_ii_val"
	elif [[ -n "$instance_id" ]]; then
		
		#list instances
		aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId" --instance-ids "$instance_id"
		instance_exist=$?
		if [[ $instance_exist == 0 ]]; then
			return_ii_val=1
			return "$return_ii_val"
		elif [[ $instance_exist != 0 ]]; then
			echo "Instance does not exist. Please try again."
			exit 1
		fi
	fi
}



# MAIN BODY

action_arg=$1
create_or_term=$2

#echo $action_arg
#echo $create_or_term

# Validate -action argumnet
if [[ $action_arg == "-action" ]]; then
	echo "accepted argument '-action'"
elif [[ $action_arg != "-action" ]]; then
	echo "Please use argument '-action'"
fi

# Prompt for EC2 configuration or termination
if [[ $create_or_term == "create" ]]; then
       
   	read -p "Please enter Amazon Machine Image ID [ami-xxxxxxx]:" ami_id
        echo "User input:" $ami_id
	check_ami_input
	return_ami_val=$?
	if [ "$return_ami_val" == 2 ]; then
		echo "No AMI ID received."
		echo "Will use default AMI."
		echo "Default AMI: ami-011b3ccf1bd6db744 (Red Hat Enterprise Linux 7.6)"
		ami_id="ami-011b3ccf1bd6db744" 
	elif [ "$return_ami_val" == 0 ]; then
		echo "AMI ID received."
		echo "Will use AMI: " $ami_id
	fi

       	read -p "Please enter an instance type:" instance_type
       	echo "User input:" $instance_type
	check_instance_type
	return_inst_val=$?  
 	#echo "$return_inst_val"
	if [ "$return_inst_val" == 2 ]; then
		echo "No instance type received."
		echo "Will use default instance type: t2.micro"
		instance_type="t2.micro"
	elif [ "$return_inst_val" == 1 ]; then
		echo "Sorry. This script can only launch 't2.micro' instances at this time."
		echo "Will use default instance type: t2.micro"
		instance_type="t2.micro"
	elif [ "$return_inst_val" == 0 ]; then
		echo "Will use instance type:" $instance_type
	fi

       	read -p "Please enter key pair name:" key_name
       	echo "User input:" $key_name
	check_key_name
	return_key_val=$?
	#echo "$return_key_val" 
	if [ "$return_key_val" == 2 ]; then
		echo "No key pair name received. Please try again."
		exit 1
	elif [ "$return_key_val" == 1 ]; then
		echo "Will use Key pair:" $key_name
	fi 

       	read -p "Please enter security group ID [sg-xxxxxxx]:" sec_group
       	echo "User input:" $sec_group
	check_security_group
	#echo $?
	return_sg_val=$?
	if [ "$return_sg_val" == 2 ]; then
 		echo "No security group received. Please enter security group ID [sg-xxxxxxx]."
		exit 1
	elif [ "$return_sg_val" == 1 ]; then
		echo "Will use security group:" $sec_group 
  	fi

       	read -p "Please enter subnet [subnet-xxxxxxx]:" subnet_id
       	echo "User input:" $subnet_id 
	check_subnet_id
	#echo $?
	return_sub_val=$?
	if [ "$return_sub_val" == 2 ]; then
		echo "No subnet received. Please enter subnet [subnet-xxxxxxx]."
		exit 1
	elif [ "$return_sub_val" == 1 ]; then
		echo "Will use subnet:" $subnet_id 	
	fi

# Grand finale, launch instance
	aws ec2 run-instances --image-id "$ami_id" --count 1 --instance-type "$instance_type" --key-name "$key_name" --security-group-ids "$sec_group" --subnet-id "$subnet_id"
	echo "Success! Launching new EC2 instance!"
	
elif [[ "$create_or_term" == "terminate" ]]; then
# Prompt user for EC2 instance ID
# aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
        read -p "Please enter instance ID [i-xxxxxxx]:" instance_id
	echo "User input:" $instance_id
	check_instance_id
	#echo $?
	return_ii_val=$?
	if [[ "$return_ii_val" == 2 ]]; then
		echo "No instance ID received. Please enter instance ID [i-xxxxxxx]."
		exit 1
	elif [ "$return_ii_val" == 1 ]; then		
		#termination
		aws ec2 terminate-instances --instance-ids "$instance_id" 
	fi

	echo "Success! Terminating instance:" "$instance_id"
elif [ -z "$create_or_term" ] || [ "$create_or_term" != "terminate" ] || ["$create_or_term" != "create" ]; then
	echo "Please sepcify an action. 'create' or 'terminate'"
	exit 1 
fi

exit 0
