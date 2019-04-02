"""Python check for existence of responsible person.
cd tools
python3 responsible_person.py ../schema
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
        resp = tree.xpath('/xsd:schema/xsd:element[@name="ComplianceDocumentPackage"]//xsd:element[@name="RespPerson"]',  # pylint:disable=C0301
                          namespaces={'xsd': 'http://www.w3.org/2001/XMLSchema'})
        if resp:
            atype = resp[0].xpath('@type')[0].split(':')[1]
            with open(os.path.join(sys.argv[1], 'base/ResCompliance.xsd'), 'r') as base:
                bdata = base.read()
                btree = etree.fromstring(str.encode(bdata))  # pylint:disable=I1101
                bresp = btree.xpath('/xsd:schema/xsd:complexType[@name="{}"]/@name'.format(atype),
                                    namespaces={'xsd': 'http://www.w3.org/2001/XMLSchema'})
                if not bresp:
                    error = 1
                    print('{} header {} mismatch with Rescompliance.xsd'.format(os.path.basename(filename), atype))  # pylint:disable=C0301

if error == 1:
    exit(1)
