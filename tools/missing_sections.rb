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
@gb = 0
order = ('A'..'Z').to_a

Dir.glob("#{project_path}/**/{CF1R,CF2R,CF3R,NRCV}/*.xsd").map do |schema|
  doc = Nokogiri::XML(File.open(schema))
  doc.xpath('/xsd:schema/xsd:complexType/xsd:sequence/xsd:element/@name').map.with_index do |section, i|
    letter = section.to_s.partition('_').last
    if order[i] != letter
      @error = 1
      @gb = 1
    end
  end
  puts "#{File.basename(schema)} has the wrong Section letters\n" unless @error.zero?
  @error = 0
end

exit 1 unless @gb.zero?
