#!/bin/bash
#
# Use: ./redirect.sh dikapedia.com
#
# Shows the redirections
# Credit: https://www.liquidweb.com/kb/troubleshooting-too-many-redirects/


echo
for domain in $@; do
echo --------------------
echo $domain
echo --------------------
curl -sILk $domain | egrep 'HTTP|Loc' | sed 's/Loc/ -> Loc/g'
echo
done
