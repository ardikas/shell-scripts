#!/bin/bash
#
#
# Write a script that looks over this directory and finds the duplicate files
# - Hint: this should work on any directory or files with different filenames
#
#
#



# -print0 is to print them all in one line as opposed to new line
# xargs -0 (input items are terminated by a null char instead of whitespace) and takes the argument as stdin?
# awk '{print $1}' prints the first word of file 

# repeating_md5sum=$(find . -type f -print0 | xargs -0 md5sum | awk '{print $1}' | uniq -d)
# echo ${repeating_md5sum}
# find . -type f -print0 | xargs -0 md5sum | grep ${repeating_md5sum}  | awk '{print $2}'



# first section, finds files that are not emptpy and searches by size then newline.
# uniq -d; show repeateded ones
# xargs -I{}; this section finds the files with the matching size from the previous argument.
# xargs -0 md5sum
# runs md5sum on the files from previous argument, -0 is to terminate the null character which can cause problems when running xargs.
# sort, small to large
# last section reports the comparison, and checks/compares no more than x characters in lines.
# --all-repeated (-D) prints all duplicate lines groups with an empty line to

find -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | uniq -w 32 --all-repeated=separate
