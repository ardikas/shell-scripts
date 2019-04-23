#!/bin/bash
#
# Scripting challenge (please commit to git)
#
# Copy 1-10 of these newly created files but with different names
# - The copied files will have the same md5sums as the original files they were copied from
# Write a script that looks over this directory and finds the duplicate files
# - Hint: this should work on any directory or files with different filenames


#  shuf -n$((1 + RANDOM % 10)) -e File_* | xargs cp -vt ./file_$RANDOM.txt

#files=(./file_*)
#n=${#files[@]}
#file_to_copy="${files[1 + RANDOM % 10]}"
#cp $file_to_copy ./File_copy_$RANDOM.txt

# find . -type f -name "file_*" -print0 | xargs -0 shuf -e -n8 -z | xargs -0 cp -vt ./file_copy_$RANDOM.txt

# -n specifies the number of 
#find . -name 'file_*' | shuf -n $((RANDOM % 10)) 

for i in {$((RANDOM % 10))}; do

	# finds the file and shuffles, picks the first one
	file_var=$(find . -name 'file_*' | shuf -n 1) 
	
	echo "Copying and renaming ${file_var}"
        
 	mv ./${file_var} ./rando_copy_$(cat /dev/urandom | LC_CTYPE=C tr -dc "[:alpha:]" | head -c 3)
done

echo "Successfully copied and renamed some files."

exit 0
