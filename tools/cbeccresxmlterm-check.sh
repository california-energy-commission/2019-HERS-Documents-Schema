#!/bin/bash

cd ../
# print first
grep -rnE schema -e '<dtyp:CBECCresXMLterm value=".*?" *?><'

# then exit with fail if found
# q flag will return true if found and suppresses output
if grep -rqE schema -e '<dtyp:CBECCresXMLterm value=".*?" *?><'
then
    exit 1
else
    exit 0
fi