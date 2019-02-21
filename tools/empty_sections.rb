# ruby empty_sections.rb -p ../schema

require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: empty_sections.rb'

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
  doc.xpath('/xsd:schema/xsd:complexType/xsd:sequence/xsd:element').map do |section|
    letter = section.attribute('name').to_s.split('_').last
    if section.xpath('xsd:complexType/xsd:sequence/*').size.zero?
      @error = 1
      puts "#{File.basename(schema)} has an empty Section #{letter}\n"
    end
  end
end

exit 1 unless @error.zero?
