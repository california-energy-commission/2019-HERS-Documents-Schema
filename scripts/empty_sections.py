"""
Check for empty schema sections.
python3 empty_sections.py
"""

import glob
import os
import sys

from xml.etree import ElementTree

has_error = False
schema_files = glob.glob('../deployed/**[!base]/*.xsd', recursive=True) # exclude base schemas
namespace = {'xsd': 'http://www.w3.org/2001/XMLSchema'}

for filename in schema_files:
    try:
        tree = ElementTree.parse(filename)
        root = tree.getroot()
        sections = root.findall('./xsd:complexType/xsd:sequence/xsd:element', namespace)

        for section in sections:
            name = section.attrib.get('name')
            query = section.findall('./xsd:complexType/xsd:sequence', namespace)

            if len(query) == 0:
                has_error = True
                base_path = os.path.join(*(filename.split(os.path.sep)[2:]))
                print('{} has an empty section: {}'.format(base_path, name))
    except ElementTree.ParseError as err:
        raise err

if has_error == True:
    sys.exit(1)
