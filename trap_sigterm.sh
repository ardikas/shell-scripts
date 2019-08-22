#!/bin/bash
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_12_02.html
# https://www.lifewire.com/use-linux-sleep-command-3572060

trap "echo 'Sleeping! Please try again later!'"  SIGINT  SIGTERM # interrupt terminate

echo "pid is $$"

x=60 # 30 seconds pause

while [ $x -gt 0 ];			# This is the same as "while true".
do
        sleep 1	# This script is not really doing anything.
	echo "Sleeping for [$x] seconds"
	x=$(( $x -1 )) 
done   # this creates an infinite loop


