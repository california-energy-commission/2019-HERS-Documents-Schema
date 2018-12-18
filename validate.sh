#! /bin/sh
errors="$(find schema -type f -name '*.xsd' -exec xmllint --noout {} \;)"
if [ -z "$errors" ]; then
    echo "No errors in the schema folder"
else
    exit 1
fi
errors="$(find deployed -type f -name '*.xsd' -exec xmllint --noout {} \;)"
echo $errors
if [ -z "$errors" ]; then
    echo "No errors in the deployed schema folder"
else
    exit 1
fi
