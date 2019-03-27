require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: document_mismatch.rb'

  opts.on('-p', '--path path', 'Path to schema') do |path|
    options[:path] = path
  end

  opts.on('-h', '--help', 'Displays help') do
    puts opts
    exit
  end

  opts.on_tail('--version', 'Show program version') do
    puts VERSION
    exit
  end
end

parser.parse!

if options[:path].nil?
  print 'Enter path to schema: '
  options[:path] = STDIN.gets.chomp
end

# start
project_path = create_path(options[:path])
@error = 0

Dir.glob("#{project_path}/**/{CF1R,CF2R,CF3R,NRCV}/*.xsd").map do |schema|
  next if File.basename(schema) == 'CF3RNoTestH.xsd'

  doc = Nokogiri::XML(File.open(schema))
  namespace = doc.xpath('/xsd:schema/@targetNamespace').to_s.split('/').last
  compliance = doc.xpath('//xsd:element[@name="DocID"]//xsd:attribute[@name="doc"][@type="comp:ComplianceDocumentTag"]/@fixed').to_s
  required = doc.xpath('//xsd:complexType/xsd:attribute[@name="doc"][@use="required"]/@fixed').to_s
  complex = doc.xpath('/xsd:schema/xsd:complexType/@name').to_s
  ref = doc.xpath('//xsd:element[@name="DocumentData"]//xsd:element/@ref').to_s
  element = doc.xpath('/xsd:schema/xsd:element[@name != "ComplianceDocumentPackage"]')
  name = element.attribute('name').to_s
  type = element.attribute('type').to_s
  if [namespace, compliance, required, complex, ref, name, type].map(&:downcase).uniq.size > 1
    @error = 1
    puts "#{File.basename(schema)} has a targetNamespace:#{namespace} | xsd:element[@name='DocID']//xsd:attribute[@name='doc'][@type='comp:ComplianceDocumentTag']/@fixed:#{compliance} | //xsd:complexType/xsd:attribute[@name='doc'][@use='required']/@fixed:#{required} | xsd:complexType:#{complex} | xsd:element[@name='DocumentData']//xsd:element/@ref:#{ref} | xsd:element/@name:#{name} | xsd:element/@type:#{type} - mismatch\n\n"
  end
end

exit 1 unless @error.zero?
