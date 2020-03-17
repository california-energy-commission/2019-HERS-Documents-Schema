"""
Check for duplicate elements in each schema section
python3 duplicate_elements.py
"""

import glob
import os
import sys

from xml.etree import ElementTree
from collections import Counter

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
            section_name = None if not name else section.attrib.get('name')[-1:]

            elements = section.findall('.//xsd:element', namespace)

            names = [elem.attrib.get('name') for elem in elements if elem.attrib.get('name') != 'Row']
            duplicates = [x for x, y in Counter(names).items() if y > 1]

            if len(duplicates) > 0:
                has_error = True
                base_path = os.path.join(*(filename.split(os.path.sep)[2:]))
                print("[{}] Error in '{}'. Multiple elements with different types appear in the model group.".format(base_path, name))
                print("Multiple elements are {}.\n".format(duplicates))
                
    except ElementTree.ParseError as err:
        raise err

if has_error == True:
    sys.exit(1)
