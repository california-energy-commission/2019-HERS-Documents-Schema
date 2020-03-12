"""
Check for missing schema sections.
python3 missing_sections.py
"""

import glob
import os
import sys
import string

from xml.etree import ElementTree

hasError = False
schemaFiles = glob.glob('../deployed/**[!base]/*.xsd', recursive=True) # exclude base schemas
namespace = {'xsd': 'http://www.w3.org/2001/XMLSchema'};

for filename in schemaFiles:
    try:
        tree = ElementTree.parse(filename)
        root = tree.getroot()
        sections = root.findall('./xsd:complexType/xsd:sequence/xsd:element[@name]', namespace)

        for index, section in enumerate(sections):
            name = section.attrib.get('name')

            # check if any section is missing, e.g. Section_C or Section_3
            # transform ASCII character to number and check if it's equal to loop index
            ascii = ord(name[-1:])
            number = ascii - 65 if ascii > 64 else ascii - 49
            expected = chr(index + 65) if ascii > 64 else number

            if number != index:
                hasError = True
                basePath = os.path.join(*(filename.split(os.path.sep)[2:]))
                print('{} - Expected: Section_{}, instead got: {}'.format(basePath, expected, name))
    except ElementTree.ParseError as err:
        raise err

if hasError == True:
    sys.exit(1)
