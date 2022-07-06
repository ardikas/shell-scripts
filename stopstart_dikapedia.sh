#!/bin/bash
#
#
# Author: Ardika Sulistija
#
# Description: This script checks the status of Dikapedia instances and prompts you if you want to stop/start/reboot the instance.
#
# 07/03/2022


check_state(){
	instance_state=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[].Instances[].State[].Name[]' --output=text)

	echo "Instance state: $instance_state"
}

check_status_checks(){
	instance_status=$(aws ec2 describe-instance-status --instance-ids $instance_id --query 'InstanceStatuses[].InstanceStatus[].Status[]' --output=text)

	echo "Instance Status: $instance_status"

	system_status=$(aws ec2 describe-instance-status --instance-ids $instance_id --query 'InstanceStatuses[].SystemStatus[].Status[]' --output=text)

	echo "System Status: $system_status"
}

start_action(){
	echo "Starting instance now..."

	aws ec2 start-instances --instance-ids $instance_id  --output=text

	echo "Instance Started!"
}

stop_action(){
	echo "Stopping instance now..."

	aws ec2 stop-instances --instance-ids  $instance_id --output=text

	echo "Instance stopped!"
}

reboot_action(){
	echo "Rebooting instance now..."

	aws ec2 reboot-instances --instance-ids  $instance_id --output=text

	echo "Instance rebooted!"
}

reboot_stop_exit(){
	read -p "Do you want to (r)eboot or (s)top the instance? Press (x) to exit: " answer

	if [[ $answer == "s" ]]; then
		stop_action
	elif [[ $answer == "r" ]]; then
		reboot_action
	elif [[ $answer == "x" ]]; then
		echo "Good-bye!"
		exit
	fi
}

instance_id=i-0dcecd45293806bb7

echo "Checking the status of instance $instance_id..." 

check_state

if [[ $instance_state == "stopped" ]];  then
	read -p "Do you want to START the instance? (y/n): " start_instance
	
	if [[ $start_instance == "y" ]]; then
		start_action
	elif [[ $start_instance == "n" ]]; then
		echo "Good-bye!"
	fi
elif [[ $instance_state == "running" ]]; then
	check_status_checks
	
	if [[ $instance_status == "ok" ]]; then
		echo "Instance is healthy."
		reboot_stop_exit
	elif [[ $instance_status == "initializing" ]]; then
		echo "Instance is still initializing..."
		reboot_stop_exit
	elif [[ $instance_status == "impaired" ]]; then
		read -p "Instance is failing 1/2."
		reboot_stop_exit
	fi
fi
