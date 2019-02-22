# ruby d_list_markup.rb -p ../deployed

require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: d_list_markup.rb'

  opts.on('-p', '--path path', 'Path to deployed schema') do |path|
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
  print 'Enter path to deployed schema: '
  options[:path] = STDIN.gets.chomp
end

# start
project_path = create_path(options[:path])
@error = 0

Dir.glob("#{project_path}/**/*.xsd").map do |schema|
  doc = Nokogiri::XML(File.open(schema))
  doc.xpath('//xsd:documentation').map do |documentation|
    element = documentation.xpath('ancestor::xsd:element[1]/@name')
    if documentation.xpath('.//d:l/d:l', 'd' => 'http://www.lmonte.com/besm/d').size.positive?
      @error = 1
      puts "List inside list found in #{File.basename(schema)} in embedded markup in element #{element}\n\n"
    end
  end
end

exit 1 unless @error.zero?
