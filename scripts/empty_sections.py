"""
Python check for empty schema sections.
python3 empty_sections.py ../schema
"""

import glob
import os
import sys
from lxml import etree

def empty_sections():
    for filename in glob.glob(os.path.join(sys.argv[1], '**/*.xsd'), recursive=True):
        with open(filename, 'r') as schema:
            data = schema.read()
            tree = etree.fromstring(str.encode(data))
            section = tree.xpath('/xsd:schema/xsd:complexType/xsd:sequence/xsd:element',
                                 namespaces={'xsd': 'http://www.w3.org/2001/XMLSchema'})
            try:
                letter = section[0].xpath('@name')[0].split('_')[1]
                if not section[0].xpath('xsd:complexType/xsd:sequence/*',
                                        namespaces={'xsd': 'http://www.w3.org/2001/XMLSchema'}):
                    print('{} has an empty Section {}'.format(os.path.basename(filename), letter))
                    sys.exit(1)
            except IndexError:
                pass
