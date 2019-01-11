#!/bin/bash

errors=0
cd ../ || exit
for file in schema/**/*.xsd;
do
    xmllint --noout "$file" >> validation.txt  2>&1
    if [ "$(wc -l <validation.txt)" -ge 1 ]
    then
        #echo "This has more 1 line or more."
        cat validation.txt
        errors=1
    fi
    :> validation.txt
done
if [ "$errors" -ge 1 ]
then
    exit 1
else
    exit 0
fi