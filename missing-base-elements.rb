require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

error = 0

def create_path(path)
  path.tr('\\', '/')
end

def check(folder)
  Dir.glob("#{folder}/**/*.xsd").each do |filename|
    @doc = Nokogiri::XML(File.open("#{filename}"))
    @doc.xpath("//*[@type]").map do |tag|
      fixed = tag.attribute("fixed")
      if /^((bld|com|comp|dtyp|env|hvac|lit):)/ === tag.attribute("type")
        base, simple = tag.attribute("type").to_s.split ':'

        case base

        when 'bld'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/ResBuilding.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing ResBuilding element - #{simple}"
            error = 1
          end

        when 'com'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/ResCommon.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing ResCommon element - #{simple}"
            error = 1
          end

        when 'comp'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/ResCompliance.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing ResCompliance element - #{simple}"
            error = 1
          end

        when 'dtyp'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/DataTypes.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing DataTypes element - #{simple}"
            error = 1
          end

        when 'env'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/ResEnvelope.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing ResEnvelope element - #{simple}"
            error = 1
          end

        when 'hvac'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/ResHvac.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing ResHvac element - #{simple}"
            error = 1
          end

        when 'lit'
          @basedoc = Nokogiri::XML(File.open("#{folder}/base/ResLighting.xsd"))
          found = @basedoc.xpath("//*[@name=\"#{simple}\"]")
          if found.size == 0
            puts "Missing ResLighting element - #{simple}"
            error = 1
          end
        end
      end
    end
  end
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: missing-base-elments.rb"

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

if error == 1
  exit 1
else
  exit 0
end
