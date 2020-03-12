"""
Check if schema is well formed
python3 lint_schema.py
"""

import glob
import os
import sys

from xml.etree import ElementTree

hasError = False
schemaFiles = glob.glob('../deployed/**/*.xsd', recursive=True)

for filename in schemaFiles:
    try:
        schema = ElementTree.parse(filename)
    except ElementTree.ParseError:
        hasError = True
        print('{} is not a valid XML schema!'.format(os.path.basename(filename)))
        pass

if hasError == True:
    sys.exit(1)
