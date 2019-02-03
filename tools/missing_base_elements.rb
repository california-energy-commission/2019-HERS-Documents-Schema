require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

@error = 0

def create_path(path)
  path.tr('\\', '/')
end
# hash
@types = {}

def check(folder)
  Dir.glob("#{folder}/**/*.xsd").each do |filename|
    doc = Nokogiri::XML(File.open(filename))
    shortname = File.basename(filename)
    doc.xpath('//*[@type]').map do |tag|
      next if @types[shortname + ' ' + tag.attribute('type').to_s] == 1

      if /^((bld|com|comp|dtyp|env|hvac|lit):)/.match?(tag.attribute('type'))
        @types[shortname + ' ' + tag.attribute('type').to_s] = 1
        base, simple = tag.attribute('type').to_s.split ':'

        case base

        when 'bld'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/ResBuilding.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing ResBuilding.xsd element - #{simple}"
            @error = 1
          end
        when 'com'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/ResCommon.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing ResCommon.xsd element - #{simple}"
            @error = 1
          end
        when 'comp'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/ResCompliance.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing ResCompliance.xsd element - #{simple}"
            @error = 1
          end
        when 'dtyp'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/DataTypes.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing DataTypes.xsd element - #{simple}"
            @error = 1
          end
        when 'env'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/ResEnvelope.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd element - #{simple}"
            @error = 1
          end
        when 'hvac'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/ResHvac.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing ResHvac.xsd element - #{simple}"
            @error = 1
          end
        when 'lit'
          basedoc = Nokogiri::XML(File.open("#{folder}/base/ResLighting.xsd"))
          found = basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.empty?
            puts "#{shortname} uses missing ResLighting.xsd element - #{simple}"
            @error = 1
          end
        end
      end
    end
  end
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: missing_base_elments.rb'

  opts.on('-p', '--path path', 'Path to folder of schema') do |path|
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
  print 'Enter path to schema folder: '
  options[:path] = STDIN.gets.chomp
end

check(create_path(options[:path]))

exit 1 unless @error.zero?
