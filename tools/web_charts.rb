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

# common function that prints the chart title
def chart_title(chart_type, ind)
  "#{ind + 1} - #{chart_type}"
end

# function to draw the plotly.js charts
def draw_plotly_chart(chart_div, data, title, height, width, type=0)
  %(
    var data = [{
      values: #{data.map(&:last)},
      labels: #{data.map(&:first)},
      hole: #{type},
      type: 'pie',
      textinfo: 'value'
    }];
    var layout = {
      title: '#{title}',
      titlefont: {
        size: 12,
        color: 'black'
      },
      height: #{height},
      width: #{width},
      showlegend: true,
	      legend: {
          "orientation": "h"
        }
      };
    Plotly.newPlot('plotly_chart_div_#{chart_div}', data, layout);
  )
end

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: web_charts.rb'

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

# variables
types=[]; subtype=[]; revision=[]; doctype=[]; responsible=[]; header=[]; version=[]; section=[]
# declare base schema variable
base = %w[DataTypes.xsd ResBuilding.xsd ResCommon.xsd ResCompliance.xsd ResEnvelope.xsd ResHvac.xsd ResLighting.xsd]

Dir.glob("#{project_path}/*").map.with_index do |sfolder, _|
  if File.basename(sfolder).size == 4
    file_count = Dir["#{sfolder}/*.xsd"].size
    paths = sfolder.split('/')
    types << [paths.last, file_count]
    Dir.glob("#{sfolder}/*.xsd").map do |z|
      filename = z.split('/').last
      if !base.include? filename
        st = filename.gsub(/^(CF\dR|NRCV)*([a-z]{3})(.*)$/i, '\2')
        if st == 'Fea'
          st = 'FeatureNotTested'
        elsif st == 'NoT'
          st = 'NoTest'
        end
        subtype << st
      end
      file = File.open(z, 'r'); data = file.read; file.close; fn = filename.split('.').first
      if paths.last != 'base'
        revision << data.gsub(/(.*<xsd:attribute name="revision".*?fixed=")(.*?)("\/>.*<\/xsd:schema>)/m, '\2').strip
        doctype << data.gsub(/(.*<xsd:attribute name="docType".*?fixed=")(.*?)(".*)/m, '\2').strip
        if /PSR01E.xsd/i.match?(filename)
          responsible << 'PSR01E'
          header << 'PSR01E'
        else
          responsible << data.gsub(/(.*<xsd:element name="RespPerson" type=")(.*?)(" ?\/>.*<\/xsd:schema>)/m, '\2').strip.split(':').last.gsub(/ResponsiblePerson/, '')
          header << data.gsub(/(.*<xsd:element name="Header" type=")(.*?)(".*)/m, '\2').strip
        end
      else
        doctype << 'base'
        header << 'base'
        revision << 'base'
        responsible << 'base'
      end
      version << data.gsub(/(.*<xsd:schema.*version=")(.*?)(">.*<\/xsd:schema>)/m, '\2').strip
      section << data.scan(/<xsd:element name="Section_/).size
    end
  end
end

subtype_output = subtype.group_by{|x| x}.map{|k, v| [k, v.size]}.sort

revision_output = revision.group_by{|x| x}.map{|k, v| [k.to_s, v.size]}

doctype_output =  doctype.group_by{|x| x}.map{|k, v| [k, v.size]}

responsible_output = responsible.group_by{|x| x}.map{|k, v| [k.to_s, v.size]}

header_output = header.group_by{|x| x}.map{|k, v| [k.gsub(/comp:/, ''), v.size]}

version_output = version.group_by{|x| x}.map{|k, v| [k.to_s, v.size]}

section_output = section.group_by{|x| x}.map{|k, v| ["#{k} #{k == 1 ? 'section' : 'sections'}", v.size]}.sort{|a, b| a[0].to_i - b[0].to_i}

# all charts
charts = [[types, 'Type'], [subtype_output, 'Subtype'], [revision_output, 'Revsion'], [doctype_output, 'docType'],
          [responsible_output, 'Responsible'], [header_output, 'Header'], [version_output, 'Version'], [section_output, 'Sections']]

# start HTML global $pagetemp variable
$pagetemp = %(<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other
         head content must come *after* these tags -->
    <title>2019 HERS Documents Schema Analytics Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand" href="#">2019 HERS Documents Schema Analytics Dashboard</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
        <div class="navbar-nav">
          <a class="nav-item nav-link active" href="index.html">Home <span class="sr-only">(current)</span></a>
        </div>
      </div>
    </nav>
    <div>)

charts.map.with_index do |_chart, i|
  $pagetemp += %(<div class="col-lg-4 col-md-6 col-sm-12 plotlypie" id="plotly_chart_div_#{i}"></div>)
end

$pagetemp += %(</div>
  <script>)

charts.map.with_index do |data, i|
  $pagetemp += draw_plotly_chart(i, data[0], chart_title(data[1], i), i == 7 ? 600 : 400, 400, 0)
end

$pagetemp += %(</script>
  </body>
</html>)

$page = $pagetemp
FileUtils.mkdir_p "#{Dir.getwd}/output/web-charts"
file = File.open("#{Dir.getwd}/output/web-charts/index.html", 'w')
file.write($page)
file.close
