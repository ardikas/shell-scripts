#!/bin/bash
  
count=0
sum=0

for region in `aws ec2 describe-regions --region us-east-1 --output text | cut -f4`
do
     # List the number of instances per region
     echo -e "\nNumber of instances in region:'$region'..."
     aws ec2 describe-instances --region $region | grep -i "instanceid" | wc -l

     # Add up the total
     count=$((count + 1))
     number=$(aws ec2 describe-instances --region $region | grep -i "instanceid" | wc -l)
     sum=$((sum + number))

done

echo ""

echo "The total number of instances in this account is: $sum"
