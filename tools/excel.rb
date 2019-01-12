# requires a command line argument
# ruby excel.rb -p path/to/project
# example run from tools directory
# ruby excel.rb -p ../
# builds an excel report at path/to/project/tools/output/excel

require 'axlsx'
require 'fileutils'
require 'optparse'

VERSION = '1.0.0'.freeze

def create_path(path)
  path.tr('\\', '/')
end

def arrsort(arr)
  group(arr.flatten.compact)
end

def group(arr)
  arr.group_by{|x| x}.map{|k, v| [k, v.size]}.sort_by{|_, y| -y}
end

# Function to open and read in file and return the data
# TODO: refactor to use less memory
def read_file(file)
  f = File.open(file, 'r')
  data = f.read
  f.close
  data
end

# Common code that builds the file extensions counts for whole repository
# used both in a CSV and an Excel report
def ext_count(project_path)
  Dir.glob("#{project_path}/**/*").map do |x|
    ext = File.extname(x)
    # TODO: refactor to use .gitignore
    next if ['.sublime-project', '.sublime-workspace', '.xpr', '.iml', '.iws', '.ipr'].include? ext

    if File.basename(x) == 'Gemfile'
      'Gemfile'
    elsif ext == ''
      'folders'
    else
      ext[1..-1]
    end
  end
end

def schema_excel_report(project_path, path)
  versions = []
  revisions = []
  Dir.glob("#{project_path}/#{path}/**/*.xsd").map do |schema|
    data = read_file(schema)
    versions << data.gsub(/(.*<xsd:schema.*?version=")(.*?)(".*<\/xsd:schema>.*)/m, '\2')
    revisions << if schema.include? 'base'
                   'Base'
                 else
                   data.gsub(/(.*<xsd:attribute name="revision".*?fixed=")(.*?)("\/>.*<\/xsd:schema>.*)/m, '\2')
                 end
  end
  [group(versions), group(revisions)]
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: excel.rb'

  opts.on('-p', '--path path', 'Path to project') do |path|
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
  print 'Enter path to project: '
  options[:path] = STDIN.gets.chomp
end

# start
project_path = create_path(options[:path])
allfiles = arrsort(ext_count(project_path))
data_size = allfiles.size + 1

# data for 4 charts
deployed_schema_versions, deployed_schema_revisions = schema_excel_report(project_path, 'deployed/schema')
original_schema_versions, original_schema_revisions = schema_excel_report(project_path, 'schema')

# variables to control columns one and two and their data layout
space = 3

dss = data_size + space
dse = dss + deployed_schema_versions.size - 1

oss = dse + space
ose = oss + original_schema_versions.size - 1

dsrs = ose + space
dsre = dsrs + deployed_schema_revisions.size - 1

osrs = dsre + space
osre = osrs + original_schema_revisions.size - 1

# start spreadsheet
Axlsx::Package.new do |p|
  p.workbook.styles do |s|
    header_cell = s.add_style :sz => 20
    header_cell_right = s.add_style :sz => 20, :alignment => {:horizontal => :right}
    cell = s.add_style :sz => 16
    p.workbook.add_worksheet(:name => 'Chart Report') do |sheet|
      sheet.add_row ['File type', 'Count'], :style => [header_cell, header_cell_right]
      allfiles.each{|x, y| sheet.add_row [x, y], :style => [cell, cell]}
      sheet.add_chart(Axlsx::Pie3DChart,
                      :start_at => [3, 0], :end_at => [10, 15],
                      :title => 'Whole repository count of files grouped by type') do |chart|
        chart.add_series :data => sheet["B2:B#{data_size}"], :labels => sheet["A2:A#{data_size}"]
      end
      sheet.add_chart(Axlsx::Bar3DChart,
                      :start_at => 'L1', :end_at => 'S16',
                      :title => 'Whole repository count of files grouped by type') do |chart|
        chart.add_series :data => sheet["B2:B#{data_size}"], :labels => sheet["A2:A#{data_size}"]
      end

      sheet.add_row []
      sheet.add_row ['Deployed Version', 'Count'], :style => [header_cell, header_cell_right]
      deployed_schema_versions.each{|x, y| sheet.add_row [x, y], :style => [cell, cell]}
      sheet.add_chart(Axlsx::Pie3DChart, :start_at => [3, 16], :end_at => [10, 32],
                                         :title => 'Deployed schema versions') do |chart|
        chart.add_series :data => sheet["B#{dss}:B#{dse}"],
                         :labels => sheet["A#{dss}:A#{dse}"]
      end

      sheet.add_row []
      sheet.add_row ['Original Version', 'Count'], :style => [header_cell, header_cell_right]
      original_schema_versions.each{|x, y| sheet.add_row [x, y], :style => [cell, cell]}
      sheet.add_chart(Axlsx::Pie3DChart, :start_at => [11, 16], :end_at => [18, 32],
                                         :title => 'Original schema versions') do |chart|
        chart.add_series :data => sheet["B#{oss}:B#{ose}"],
                         :labels => sheet["A#{oss}:A#{ose}"]
      end

      sheet.add_row []
      sheet.add_row ['Deployed Revision', 'Count'], :style => [header_cell, header_cell_right]
      deployed_schema_revisions.each{|x, y| sheet.add_row [x, y], :style => [cell, cell]}
      sheet.add_chart(Axlsx::Pie3DChart, :start_at => [3, 33], :end_at => [10, 49],
                                         :title => 'Deployed schema revisions') do |chart|
        chart.add_series :data => sheet["B#{dsrs}:B#{dsre}"],
                         :labels => sheet["A#{dsrs}:A#{dsre}"]
      end

      sheet.add_row []
      sheet.add_row ['Original Revision', 'Count'], :style => [header_cell, header_cell_right]
      original_schema_revisions.each{|x, y| sheet.add_row [x, y], :style => [cell, cell]}
      sheet.add_chart(Axlsx::Pie3DChart, :start_at => [11, 33], :end_at => [18, 49],
                                         :title => 'Original schema revisions') do |chart|
        chart.add_series :data => sheet["B#{osrs}:B#{osre}"],
                         :labels => sheet["A#{osrs}:A#{osre}"]
      end
    end
  end
  FileUtils.mkdir_p "#{project_path}/tools/output/excel"
  p.serialize("#{project_path}/tools/output/excel/whole_repository_file_type_count.xlsx")
end
