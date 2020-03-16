require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# Function to open and read in file and return the data
# TODO: refactor to use less memory
def read_file(file)
  f = File.open(file, 'r')
  data = f.read
  f.close
  data
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: namespace_prefixes.rb'

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

@global_error = 0

# start
project_path = create_path(options[:path])

# d namespace required for the square markup for when it becomes XML in the deployed folder
# req = '"xmlns:d"=>"http://www.lmonte.com/besm/d"'

Dir.glob("#{project_path}/**/*.xsd").map do |schema|
  @prefixes = []
  @namespaces = []
  @doc = Nokogiri::XML(File.open(schema))
  @namespaces = @doc.namespaces
  # d namespace check  [d:l t="*"]
  @data = read_file(schema)
  @error = 0
  if @data.scan(/\[d:.*?\]/).size.positive?
    @error = 1 unless @namespaces.key?('xmlns:d') && @namespaces.value?('http://www.lmonte.com/besm/d')
    puts File.basename(schema) + ' has missing namespace declaration "xmlns:d"=>"http://www.lmonte.com/besm/d"' unless @error.zero?
    @global_error = 1 unless @error.zero?
  end
  @doc.xpath('//*').map do |element|
    begin
      pre = element.namespace.prefix
    rescue # rubocop:disable Style/RescueStandardError, Lint/HandleExceptions
    end
    begin
      base = element.attribute('base').to_s.split(':').first
    rescue # rubocop:disable Style/RescueStandardError, Lint/HandleExceptions
    end
    begin
      att = element.attribute('type').to_s
      type = att.split(':').first if att.include?(':')
    rescue # rubocop:disable Style/RescueStandardError, Lint/HandleExceptions
    end
    @prefixes << pre unless pre.nil? || @prefixes.include?(pre)
    @prefixes << base unless base.nil? || @prefixes.include?(base)
    @prefixes << type unless type.nil? || @prefixes.include?(type)
    @prefixes.uniq!
  end
  # puts @namespaces
  # puts @prefixes
  @prefixes.map do |fix|
    if !@namespaces.key?("xmlns:#{fix}")
      # TODO: refactor error message to be more descriptive
      puts "#{File.basename(schema)} has missing namespace declaration xmlns:#{fix}"
      @global_error = 1
    end
  end
end

exit 1 unless @global_error.zero?
