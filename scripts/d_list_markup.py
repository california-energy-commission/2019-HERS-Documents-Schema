"""
Check for d-list inside d-list markup tags
python3 d_list_markup.py
"""

import glob
import os
import sys

from xml.etree import ElementTree

hasError = False
schemaFiles = glob.glob('../deployed/**[!base]/*.xsd', recursive=True) # exclude base schemas
namespace = {'xsd': 'http://www.w3.org/2001/XMLSchema'}

for filename in schemaFiles:
    try:
        tree = ElementTree.parse(filename)
        root = tree.getroot()
        elements = root.findall('.//xsd:annotation/..', namespace)
        basePath = os.path.join(*(filename.split(os.path.sep)[2:]))

        for element in elements:
            name = element.attrib.get('name')
            documentation = element.find('xsd:annotation/xsd:documentation', namespace)

            if documentation.findall('.//d:l/d:l', { 'd': 'http://www.lmonte.com/besm/d' }):
                hasError = True
                basePath = os.path.join(*(filename.split(os.path.sep)[2:]))
                print('List inside list found in {} in embedded markup in element {}'.format(basePath, name))
    except ElementTree.ParseError as err:
        raise err

if hasError == True:
    sys.exit(1)
