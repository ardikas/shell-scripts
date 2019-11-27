#!/bin/bash
#
#For loop , the bottom for statement works, but the latter is easier and better so you dont have to cut
#I used cut because originally I would get the instance id as "i-dfjksafdfads",  -- so to remove the "", I used cut -d'"' -f 2

#for instance in $(aws ec2 describe-instances --filters "Name=instance-type,Values=t3*" | grep -i instanceid | awk '{print $2}' | cut -d'"' -f 2); 

for instance in $(aws ec2 describe-instances --filters "Name=instance-type,Values=t3*" --output text | grep -i instances | awk '{print $9}');
	do aws ec2 modify-instance-credit-specification --region us-east-1 --instance-credit-specification "InstanceId=$instance,CpuCredits=standard";
done
