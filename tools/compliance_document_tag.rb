# ruby compliance_document_tag.rb -p ../schema

require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: compliance_document_tag.rb'

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
  doc = Nokogiri::XML(File.open(schema))
  doc.xpath('/xsd:schema/xsd:element[@name="ComplianceDocumentPackage"]/xsd:complexType/xsd:attribute[@name="doc"]/@fixed').map do |tag|
    base = Nokogiri::XML(File.open("#{project_path}/base/ResCompliance.xsd"))
    value = base.xpath("/xsd:schema/xsd:simpleType[@name='ComplianceDocumentTag']//dtyp:displayterm[@value='#{tag}']/@value").to_s
    text = base.xpath("/xsd:schema/xsd:simpleType[@name='ComplianceDocumentTag']//dtyp:displayterm[@value='#{tag}']/text()").to_s
    enumeration = base.xpath("/xsd:schema/xsd:simpleType[@name='ComplianceDocumentTag']//xsd:enumeration[@value='#{tag}']/@value").to_s
    if enumeration != value || enumeration != text || value != text || enumeration.empty? || value.empty? || text.empty?
      @error = 1
      puts "ComplianceDocumentTag mismatch for #{File.basename(schema)} and ResCompliance.xsd\n"
    end
  end
end

exit 1 unless @error.zero?
