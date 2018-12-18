#! /bin/sh
errors="$(find schema -type f -name '*.xsd' -exec xmllint --noout {} \;)"
if [ -z "$errors" ]; then
    echo "No errors"
else
    exit 1
fi
