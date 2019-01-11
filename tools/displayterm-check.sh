#!/bin/bash

cd ../ || exit
# print first
grep -rnE schema -e '<dtyp:displayterm value=".*?" *?><'

# then exit with fail if found
# q flag will return true if found and suppresses output
if grep -rqE schema -e '<dtyp:displayterm value=".*?" *?><'
then
    exit 1
else
    exit 0
fi
