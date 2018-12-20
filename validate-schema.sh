#!/bin/bash

errors=0
for file in schema/**/*.xsd;
do
    xmllint --noout "$file" >> validation.txt  2>&1
    if [ $(wc -l <validation.txt) -ge 1 ]
    then
        #echo "This has more 1 line or more."
        cat validation.txt
        errors=1
    fi
    > validation.txt
done
[ "$errors" -eq 1 ] && echo "111"