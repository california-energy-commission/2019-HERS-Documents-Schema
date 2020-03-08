require 'xsd_populator'

Dir.chdir 'testing'

Dir.glob('../../schema/{CF1R,CF2R,CF3R,NRCV}/*.xsd').each do |filename|
  reader = XsdPopulator.new(:xsd => filename)
  xml = reader.populated_xml

  File.open("#{filename}.xml", 'w'){|file| file.write(xml)}

  `xmllint --noout --schema "#{filename}" "#{filename}.xml"`
end
