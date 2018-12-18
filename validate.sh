#!/bin/bash
errors=0
for file in deployed/**/**/*.xsd;
do
    xmllint --noout "$file" >> validtion.txt  2>&1
    if [ $(wc -l <validtion.txt) -ge 1 ]
    then
        #echo "This has more 1 line or more."
        cat validtion.txt
        errors=1
    fi
    > validtion.txt
done
[ "$errors" -eq 1 ] && exit 1
