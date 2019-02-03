# ruby generate_docs.rb -h

require 'optparse'

VERSION = '1.0.0'.freeze

# implement commandline options
options = {:path => nil}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: generate_docs.rb'

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

# run shell command
`generateDocs.bat`

def create_path(path)
  path.tr('\\', '/')
end

page = %(<html>
  <head><head>
  <body>
    <ul>
)

Dir.glob("#{create_path(options[:path])}/documentation/*").each do |file_folder|
  doc = File.basename(file_folder)
  page += %(
      <li><a href="#{doc}/#{doc}.html" target="_blank">#{folder}</a></li>
  )
end

page += %(
    </ul>
  </body>
</html>)

f = File.open("#{create_path(options[:path])}/documentation/index.html", 'w')
f.write(page)
f.close
