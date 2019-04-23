#!/bin/bash
#
# Scripting challenge (please commit to git)
#
# First create 1000 randomly sized files in a directory with random filenames
# - Hint: Use a for loop to do this
# - Bonus: Write a script that does this automatically
# Copy 1-10 of these newly created files but with different names
# - The copied files will have the same md5sums as the original files they were copied from
# Write a script that looks over this directory and finds the duplicate files
# - Hint: this should work on any directory or files with different filenames
#
 


for i in {1..5}
do
 #echo Heyyo > "File$RANDOM.txt"

 # Create file with random size; 'bs' r/w up to x bytes at a time
 # 'count' multiplies the number of 'bs'
 # 'if=FILE'... read from FILE instead of stdin
 # 'of=FILE'... write to FILE instead of stout 
 #  what is 'skip=0' 

 n=$RANDOM
 
 dd bs=1 count=$RANDOM if=/dev/xvdb2 of=file_$n.txt
 chown ardika:ardika ./file_$n.txt
done
