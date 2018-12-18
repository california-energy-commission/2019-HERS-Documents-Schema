#!/bin/sh
set -e
for file in deployed/**/**/*.xsd;
do
    xmllint --noout "$file";
done