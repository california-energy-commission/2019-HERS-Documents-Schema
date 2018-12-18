#! /bin/bash
for file in deployed/**/**/*.xsd;
do
    xmllint --noout "$file"; echo $?

done