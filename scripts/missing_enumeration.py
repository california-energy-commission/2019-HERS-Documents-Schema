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

                if base == 'dtyp':
                    query = dataTypes.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/DataTypes.xsd).".format(base_path, value, type))
                        has_error = True

                if base == 'bld':
                    query = resBuilding.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/ResBuilding.xsd).".format(base_path, value, type))
                        has_error = True

                if base == 'com':
                    query = resCommon.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/ResCommon.xsd).".format(base_path, value, type))
                        has_error = True

                if base == 'comp':
                    query = resCompliance.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/ResCompliance.xsd).".format(base_path, value, type))
                        has_error = True

                if base == 'env':
                    query = resEnvelope.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/ResHvac.xsd).".format(base_path, value, type))
                        has_error = True

                if base == 'hvac':
                    query = resHvac.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value), namespace)

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/ResHvac.xsd).".format(base_path, value, type))
                        has_error = True

                if base == 'lit':
                    query = resLighting.findall('.//xsd:simpleType[@name="{}"]/.//xsd:enumeration[@value="{}"]'.format(type, value))

                    if len(query) == 0:
                        print("{} - Enumeration value '{}' is not in the value space of the base type {} (base/ResLighting.xsd).".format(base_path, value, type))
                        has_error = True

                print()        
    except ElementTree.ParseError as err:
        raise err

if has_error == True:
    sys.exit(1)
