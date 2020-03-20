"""
Check for missing xsd:enumeration in xsd:restriction
python3 missing_enumeration.py
"""

import glob
import os
import sys

from xml.etree import ElementTree

has_error = False
schema_files = glob.glob('../deployed/**[!base]/*.xsd', recursive=True) # exclude base schemas
namespace = {'xsd': 'http://www.w3.org/2001/XMLSchema'};

dataTypes = ElementTree.parse('../deployed/base/DataTypes.xsd').getroot()
resBuilding = ElementTree.parse('../deployed/base/ResBuilding.xsd').getroot()
resCommon = ElementTree.parse('../deployed/base/ResCommon.xsd').getroot()
resCompliance = ElementTree.parse('../deployed/base/ResCompliance.xsd').getroot()
resEnvelope = ElementTree.parse('../deployed/base/ResEnvelope.xsd').getroot()
resHvac = ElementTree.parse('../deployed/base/ResHvac.xsd').getroot()
resLighting = ElementTree.parse('../deployed/base/ResLighting.xsd').getroot()

map = dict({
    'dtyp': {
        'root': ElementTree.parse('../deployed/base/DataTypes.xsd').getroot(),
        'path': 'base/DataTypes.xsd'
    },
    'bld': {
        'root': ElementTree.parse('../deployed/base/ResBuilding.xsd').getroot(),
        'path': 'base/ResBuilding.xsd'
    },
    'com': {
        'root': ElementTree.parse('../deployed/base/ResCommon.xsd').getroot(),
        'path': 'base/ResCommon.xsd'
    },
    'comp': {
        'root': ElementTree.parse('../deployed/base/ResCompliance.xsd').getroot(),
        'path': 'base/ResCompliance.xsd'
    },
    'env': {
        'root': ElementTree.parse('../deployed/base/ResEnvelope.xsd').getroot(),
        'path': 'base/ResEnvelope.xsd'
    },
    'hvac': {
        'root': ElementTree.parse('../deployed/base/ResHvac.xsd').getroot(),
        'path': 'base/ResHvac.xsd'
    },
    'lit': {
        'root': ElementTree.parse('../deployed/base/ResLighting.xsd').getroot(),
        'path': 'base/ResLighting.xsd'
    },
})

for filename in schema_files:
    try:
        tree = ElementTree.parse(filename)
        root = tree.getroot()
        restrictions = root.findall('.//xsd:restriction', namespace)
        base_path = os.path.join(*(filename.split(os.path.sep)[2:]))

        for restriction in restrictions:
            fullBase = restriction.attrib.get('base')
            base, type = fullBase.split(':')
            enumerations = restriction.findall('xsd:enumeration', namespace)

            for enumeration in enumerations:
                value = enumeration.attrib.get('value')

                if base in map.keys():
                    query = map[base].get('root').findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        basedoc = map[base].get('base_path')
                        print("[{}]: Enumeration value '{}' is not in the value space of the base type '{}' in '{}'.".format(base_path, value, type, basedoc))
                        has_error = True

    except ElementTree.ParseError as err:
        raise err

if has_error == True:
    sys.exit(1)
