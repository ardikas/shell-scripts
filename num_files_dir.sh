#!/bin/bash
# 
# Function Exercise
#
#
# Write a shell script that consists of a function that display the number of files in the present working directory.
# Name this function "file_count" and call it in your script. 
# If you use a variable in your function, remember to make it a local variable.
#
#
#
# Exercise 2:
# Make the file_count function accept a directory as an argument.
# Next have the function display the name of the diretory followed by a colon.
# Display the number of files to the screen on the next line.
# Call the function three times. First on the /etc directory, then the /var, then the /usr/bin directory.   
# 

# FUNCTIONS

function file_count() {
  # Get number of files and directories in the working directory
  # Runs list command for the current directoy, searches for lines starting with '-', which means its a file
  file="$(ls -l "$path" | grep -c ^-)"

  # Run list command for the current directory, searches for lines stsarting with 'd', which means its a directory
  dir=$(ls -l "$path" | grep -c ^d)

# This is my first comment
# second comment
# third change

}

function validate_dir() {
  if [ -d "$path" ]; then
	echo
	echo "Directory exists."
	echo "Path: "$path
  else
	echo
	echo "Directory does not exists."
  	echo
	exit
  fi
}

# MAIN

path=$1

if [ -n "$path" ]; then
  # call function
  validate_dir

elif [ -z "$path" ]; then 
  read -p "Please enter a path: "  user_input  
  path=$user_input 
  echo $path
  validate_dir
  
  #exit
fi

#call function
file_count

if [ $file == "1" ]; then
  echo "There is $file file in this directory."
elif [ $file != "1" ]; then
  echo "There are $file file(s) in this directory."          
fi

if [ $dir == "1" ]; then
   echo "There is only $dir directory in this directory."
   echo
elif [ $file != "1" ]; then
   echo "There are $dir directories in this directory."
   echo
fi

exit 0
