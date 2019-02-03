require 'nokogiri'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: restriction.rb'

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

@error = 0

# start
project_path = create_path(options[:path])

Dir.glob("#{project_path}/**/{CF1R,CF2R,CF3R,NRCV}/*.xsd").map do |schema|
  shortname = File.basename(schema)
  folder = schema.split('/')[0..-3].join('/') + '/base/'
  doc = Nokogiri::XML(File.open(schema))
  doc.xpath('//xsd:restriction').map do |tag|
    base, type = tag.attribute('base').to_s.split(':')
    tag.xpath('.//xsd:enumeration').map do |enum|
      value = enum.attribute('value')
      if /^(bld|com|comp|dtyp|env|hvac|lit)/.match?(base)
        case base

        when 'bld'
          basedoc = Nokogiri::XML(File.open("#{folder}/ResBuilding.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResBuilding.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        when 'com'
          basedoc = Nokogiri::XML(File.open("#{folder}/ResCommon.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        when 'comp'
          basedoc = Nokogiri::XML(File.open("#{folder}/ResCompliance.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        when 'dtyp'
          basedoc = Nokogiri::XML(File.open("#{folder}/DataTypes.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        when 'env'
          basedoc = Nokogiri::XML(File.open("#{folder}/ResEnvelope.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        when 'hvac'
          basedoc = Nokogiri::XML(File.open("#{folder}/ResHvac.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        when 'lit'
          basedoc = Nokogiri::XML(File.open("#{folder}/ResLighting.xsd"))
          found = basedoc.xpath('//xsd:simpleType[@name="' + type + '"]//xsd:enumeration[@value="'+value+'"]')
          if found.empty?
            puts "#{shortname} uses missing ResEnvelope.xsd simpleType: #{type} enumeration: #{value}"
            @error = 1
          end
        end
      end
    end
  end
end

exit 1 unless @error.zero?
