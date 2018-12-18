#!/bin/bash
errors=0
for file in deployed/**/**/*.xsd;
do
    xmllint --noout "$file"  >> part1-results.txt  2>&1
    if [[ $(wc -l <part1-results.txt) -ge 1 ]]
    then
        echo "This has more 1 line or more."
        cat part1-results.txt
        errors=1
    fi
    > part1-results.txt
done
echo $errors
if  (($errors==1))
then
    exit 1
fi