require 'csv'
require 'fileutils'
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
  opts.banner = 'Usage: doc_id.rb'

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

filename=[]; doc=[]; doc_type=[]; doc_title=[]; doc_variant_subtitle=[]; doc_variant_letter=[]

Dir.glob("#{project_path}/*").map do |schema_folder|
  folder = File.basename(schema_folder)
  if folder.size == 4 && folder != 'base'
    Dir.glob("#{schema_folder}/*.xsd").map do |schema_file|
      data = read_file(schema_file)
      schema = File.basename(schema_file)
      filename << schema
      fn = schema.downcase
      if fn == 'cf3rnotesth.xsd'
        doc << 'CF3RNoTestH'
        doc_title << 'CF3RNoTestH'
      elsif fn == 'cf3rfeaturenottestedh.xsd'
        doc << 'CF3RFeatureNotTestedH'
        doc_title << 'CF3RFeatureNotTestedH'
      else
        doc << data.gsub(/(.*<xsd:attribute name="doc" type="comp:ComplianceDocumentTag" fixed=")(.*?)("\/>.*<\/xsd:schema>)/m, '\2').strip
        # revision << data.gsub(/(.*<xsd:attribute name="revision".*?fixed=")(.*?)("\/>.*<\/xsd:schema>)/m,'\2').strip
        doc_title << data.gsub(/(.*<xsd:attribute name="docTitle" type="comp:ComplianceDocumentTitleRes" fixed=")(.*?)("\/>.*<\/xsd:schema>)/m, '\2').strip
      end
      doc_type << data.gsub(/(.*<xsd:attribute name="docType" type="comp:ComplianceDocumentType" fixed=")(.*?)("\/>.*<\/xsd:schema>)/m, '\2').strip
      doc_variant_subtitle << if data.include?('docVariantSubtitle') && fn != 'cf3rnotesth.xsd' && fn != 'cf3rfeaturenottestedh.xsd'
                                data.gsub(/(.*<xsd:attribute name="docVariantSubtitle" type="comp:ComplianceDocumentVariantSubtitle" fixed=")(.*?)("\/>.*<\/xsd:schema>)/m, '\2').strip
                              else
                                'N/A'
                              end
      doc_variant_letter << if data.include?('docVariantLetter') && fn != 'cf3rnotesth.xsd' && fn != 'cf3rfeaturenottestedh.xsd'
                              data.gsub(/(.*<xsd:attribute name="docVariantLetter" type="comp:ComplianceDocumentVariant" fixed=")(.*?)("\/>.*<\/xsd:schema>)/m, '\2').strip
                            else
                              'N/A'
                            end
    end
  end
end

FileUtils.mkdir_p "#{Dir.getwd}/output/docid"
CSV.open("#{Dir.getwd}/output/docid/DocID.csv", 'wb') do |csv|
  csv << ['File Path', 'doc', 'docType', 'docTitle', 'docVariantSubtitle', 'docVariantLetter']
  filename.map.with_index do |item, i|
    csv << [item, doc[i], doc_type[i], doc_title[i], doc_variant_subtitle[i], doc_variant_letter[i]]
  end
end
