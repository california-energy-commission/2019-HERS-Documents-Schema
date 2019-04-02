"""Python check for empty schema sections.
cd tools
python3 empty_sections.py ../schema
"""

import glob
import os
import sys
from lxml import etree


# start
error = 0  # pylint:disable=C0103

for filename in glob.glob(os.path.join(sys.argv[1], '**/*.xsd'), recursive=True):
    # TODO: fix error # pylint:disable=W0511
    with open(filename, 'r') as schema:
        data = schema.read()
        tree = etree.fromstring(str.encode(data))  # pylint:disable=I1101
        section = tree.xpath('/xsd:schema/xsd:complexType/xsd:sequence/xsd:element',
                             namespaces={'xsd': 'http://www.w3.org/2001/XMLSchema'})
        try:
            letter = section[0].xpath('@name')[0].split('_')[1]
            if not section[0].xpath('xsd:complexType/xsd:sequence/*',
                                    namespaces={'xsd': 'http://www.w3.org/2001/XMLSchema'}):
                error = 1
                print('{} has an empty Section {}'.format(os.path.basename(filename), letter))
        except IndexError:
            pass

if error == 1:
    exit(1)
