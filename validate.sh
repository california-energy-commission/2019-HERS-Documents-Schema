#! /bin/sh
for file in deployed/**/**/*.xsd;
do
    xmllint --noout "$file" 2>&1 >/dev/null || exit 1
done