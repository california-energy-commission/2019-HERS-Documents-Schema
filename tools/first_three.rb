# ruby first_three.rb -p ../schema

require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: first_three.rb'

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
    elements = section.xpath('.//xsd:element[not(@name = "Row")][not(parent::xsd:choice)][not(local-name(ancestor::*[2])="sequence")]/@name')
                      .map(&:to_s).select{|x| x[3]=='_'}.map{|x| x.split('_').first}
    duplicates = elements.select{|x| elements.count(x)>1}.uniq.join(', ')
    if elements.size != elements.uniq.size
      @error = 1
      puts "#{File.basename(schema)} has similar elements in section #{letter}\n"
      puts "Similar elements are #{duplicates}\n\n"
    end
  end
end

exit 1 unless @error.zero?
