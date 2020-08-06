"""
Check if schema is well formed
python3 lint_schema.py
"""

import glob
import os
import sys

from xml.etree import ElementTree

has_error = False
schema_files = glob.glob('../schema/**/*.xsd', recursive=True)

for filename in schema_files:
    try:
        schema = ElementTree.parse(filename)
    except ElementTree.ParseError:
        has_error = True
        print('{} is not a valid XML schema!\n'.format(os.path.basename(filename)))
        pass

if has_error == True:
    sys.exit(1)