# 2019 HERS Documents Schema

- [Contributing](#contributing)
- [Reports](#reports)
- [Checks to run before submitting a pull request](#checks-to-run-before-submitting-a-pull-request)
- [Deploy Schema](#deploy-schema)
  - [Windows](#windows)
    - [Example run](#example-run)
- [Ruby](#ruby)
- [Links](#links)
- [Go Faster](#go-faster)
- [Advanced Links](#advanced-links)

## Contributing

Thanks for your interest in contributing! There are many ways to contribute to this project.
Get started here [CONTRIBUTING](CONTRIBUTING.md)

[&#8593;](#2019-hers-documents-schema)

## Reports

We have four reports located in the `tools\output` directory.

- docid: **CSV** report that is a summary of the original schema files which shows data on the
  version, revision and the DocID element. Best viewed in Excel
- excel: **Excel** report with charts which reports on the files in the repository
- rubycritic: **Web based** report using mainly HTML, JavaScript and CSS that reports on the Ruby code
- web-charts: **Awesome web based** report using [plotly.js](https://plot.ly/javascript/) pie charts

The Excel report is best seen in Excel but can be opened with other programs like Google Sheets.
The HTML files in the RubyCritic report can be opened locally with a web browser. The Plotly charts
can also be opened locally with a web browser.

[&#8593;](#2019-hers-documents-schema)

## Checks to run before submitting a pull request

- validate XML schema
- check for empty display term text

On [Ubuntu](https://www.ubuntu.com/) Linux you can use [xmllint](http://xmlsoft.org/xmllint.html)
to check the well formedness of a directory of XML or even XML schema. Well formed XML is the first step
towards full XML validation.

The [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about)
can be installed on Windows and emulates the Ubuntu environment.

The command to run is:

```
cd 2019-HERS-Documents-Schema
find schema -type f -name "*.xsd" -exec xmllint --noout {} \;
```

Current [regular expressions](https://www.rexegg.com/) to use to check for `empty` terms:

```
<dtyp:displayterm value=".*?" *?><
```

```
<dtyp:CBECCresXMLterm value=".*?" *?><
```

On Windows you can use the Git Bash terminal to find the `empty` terms
with [grep](https://www.gnu.org/software/grep/) as shown below:

```
grep -rnE schema -e '<dtyp:displayterm value=".*?" *?><'
```

```
grep -rnE schema -e '<dtyp:CBECCresXMLterm value=".*?" *?><'
```

[&#8593;](#2019-hers-documents-schema)

## Deploy Schema

`deploy-schema.exe` is a command line application executable file that was
written in [Golang](https://golang.org/). This application deploys the schema (replaces embedded
square markup, formats, indents, removes whitespace, orders alphabetically)
to a `deployed` folder. There is also a `deploy-schema` script that runs
on Linux and MacOS.

### Windows

```
deploy-schema.exe
Usage: deploy-schema.exe [options]
Options:
  -d, --destination string
        Path to deploy the schema:
  -s, --source string
        Path to schema:
  -v, --version string
        Enter new schema version:
```

#### Example run

```
cd 2019-HERS-Documents-Schema
deploy-schema.exe -d . -s schema -v 2019.1.000
```

[&#8593;](#2019-hers-documents-schema)

## Ruby

So far most of the [Ruby](https://www.ruby-lang.org) code has been tested on Ruby 2.5.3 and Ruby 2.6.1

We are using [Bundler](https://bundler.io/) to manage and install the [RubyGems](https://rubygems.org/).

```
gem install bundler
```

Then to install this projects RubyGems run:

```
bundle install
```

We are using [overcommit](https://github.com/brigade/overcommit) to manage and configure Git hooks which
can be installed by running:

```
overcommit --install
```

```
overcommit --sign
```

To generate the web based [RubyCritic](https://github.com/whitesmith/rubycritic) report run:

```
cd 2019-HERS-Documents-Schema
rubycritic -p tools/output/rubycritic
```

To generate the Excel report of the repositories files run:

```
cd tools
ruby excel.rb -p ../
```

To generate the CSV report of the schema files that is best viewed in Excel run:

```
cd tools
ruby doc_id.rb -p ../schema
```

To generate the web based Plotly pie charts run:

```
cd tools
ruby web_charts.rb -p ../schema
```

On Linux you can generate all the reports at once as shown below:

```
cd tools
./run.sh
```

[&#8593;](#2019-hers-documents-schema)

## Links

- [The Extensible Stylesheet Language Family (XSL)](https://www.w3.org/Style/XSL/)
- [Ibex PDF Creator .NET Programmers Guide](http://www.xmlpdf.com/builds/ibex.pdf)
- [XSL-FO Tutorial - Apache FOP](https://xmlgraphics.apache.org/fop/fo.html)
- [FO Processors](http://www.sagehill.net/docbookxsl/FOprocessors.html)
- [XPath Intro](https://www.w3schools.com/xml/xpath_intro.asp)
- [XSLT Intro](https://www.w3schools.com/xml/xsl_intro.asp)
- [XHTML](https://en.wikipedia.org/wiki/XHTML)
- [HTML5](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5)
- [XML Schema Tutorial](https://www.w3schools.com/xml/schema_intro.asp)
- [Saxonica](https://www.saxonica.com/)
- [Git](https://git-scm.com/)
- [Shell script](https://en.wikipedia.org/wiki/Shell_script)
- [grep](https://www.gnu.org/software/grep/)
- [dwdiff](https://linux.die.net/man/1/dwdiff)
- [GNU wdiff](https://www.gnu.org/software/wdiff/)
- [pdftotext](https://www.xpdfreader.com/pdftotext-man.html)
- [colordiff](https://www.colordiff.org/)
- [Ruby](https://www.ruby-lang.org)
- [Bundler](https://bundler.io/)
- [Gemfile](https://bundler.io/gemfile.html)
- [Nokogiri](https://nokogiri.org/)
- [FileUtils](https://ruby-doc.org/stdlib-2.5.3/libdoc/fileutils/rdoc/FileUtils.html)
- [Rubocop](https://github.com/rubocop-hq/rubocop)
- [Axlsx](https://github.com/randym/axlsx)
- [overcommit](https://github.com/brigade/overcommit)
- [OptionParser](https://docs.ruby-lang.org/en/2.5.0/OptionParser.html)
- [CSV](https://ruby-doc.org/stdlib-2.5.3/libdoc/csv/rdoc/CSV.html)
- [RubyCritic](https://github.com/whitesmith/rubycritic)
- [YAML](https://yaml.org/)
- [CircleCI](https://circleci.com/)
- [xmllint](http://xmlsoft.org/xmllint.html)
- [Ubuntu](https://www.ubuntu.com/)
- [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about)
- [Markdown](https://guides.github.com/features/mastering-markdown/)
- [RubyGems](https://rubygems.org/)
- [plotly.js](https://plot.ly/javascript/)
- [Regular expressions](https://www.rexegg.com/)
- [APT](<https://en.wikipedia.org/wiki/APT_(Debian)>)
- [xargs](https://en.wikipedia.org/wiki/Xargs)
- [wc](<https://en.wikipedia.org/wiki/Wc_(Unix)>)
- [find](https://linux.die.net/man/1/find)
- [libxml2-utils](https://packages.ubuntu.com/search?keywords=libxml2-utils)
- [XML](https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction)
- [XML Schema Part 2: Datatypes Second Edition](https://www.w3.org/TR/xmlschema-2/)
- [XML Schema built in datatypes](https://www.w3.org/TR/xmlschema-2/#built-in-datatypes)
- [XMLSpy](https://www.altova.com/xmlspy-xml-editor)
- [Oxygen XML Editor](https://www.oxygenxml.com/)
- [dos2unix](https://linux.die.net/man/1/dos2unix)
- [RubyMine](https://www.jetbrains.com/ruby/)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- [PyCharm](https://www.jetbrains.com/pycharm/)
- [Sublime Text](https://www.sublimetext.com/)
- [GitHub Desktop](https://desktop.github.com/)
- [Sourcetree](https://www.sourcetreeapp.com/)
- [GitKraken](https://www.gitkraken.com/git-client)
- [Tower](https://www.git-tower.com/)
- [Batch file](https://en.wikipedia.org/wiki/Batch_file)
- [cloc](https://github.com/AlDanial/cloc)
- [pdftocairo](https://www.mankier.com/1/pdftocairo)
- [Python](https://www.python.org/)
- [yamllint](https://yamllint.readthedocs.io/en/stable/index.html)
- [pip](https://pypi.org/project/pip/)
- [Debian](https://www.debian.org/)

[&#8593;](#2019-hers-documents-schema)

## Go Faster

- [Golang](https://golang.org/) - Go is a statically typed, compiled programming language designed at Google
- [Getting Started on Heroku with Go](https://devcenter.heroku.com/articles/getting-started-with-go)
- [govendor](https://github.com/kardianos/govendor) - Go vendor tool that works with the standard vendor file.
- [Gin](https://github.com/gin-gonic/gin) - Gin is a HTTP web framework written in Go (Golang). It features a Martini-like API with much better performance -- up to 40 times faster. If you need smashing performance, get yourself some Gin.
- [GoLand](https://www.jetbrains.com/go) - A Clever IDE to Go
- [Colly](http://go-colly.org) - Fast and Elegant Scraping Framework for Gophers
- [que-go](https://github.com/bgentry/que-go) - An interoperable Golang port of the Ruby Que queuing library for PostgreSQL
- [pgx](https://github.com/jackc/pgx) - PostgreSQL driver and toolkit for Go
- [ratago](https://github.com/jbowtie/ratago) - Go implementation of an XSLT 1.0 processor
- [pflag](https://github.com/ogier/pflag) - Drop-in replacement for Go's flag package, implementing POSIX/GNU-style --flags.
- [etree](https://github.com/beevik/etree) - parse and generate XML easily in go
- [gofpdf](https://github.com/jung-kurt/gofpdf) - A PDF document generator with high level support for text, drawing and images
- [xmlquery](https://github.com/antchfx/xmlquery) - xmlquery, is an XPath query package for XML in Go.

[&#8593;](#2019-hers-documents-schema)

## Advanced Links

- [GitHub Pages](https://pages.github.com/)
- [Heroku](https://www.heroku.com/)
- [Linode](https://www.linode.com/)
- [DigitalOcean](https://www.digitalocean.com/)
- [Google Cloud](https://cloud.google.com/)
- [Oracle VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Docker](https://www.docker.com/)

[&#8593;](#2019-hers-documents-schema)

## Cloc Report

[cloc](https://github.com/AlDanial/cloc) counts blank lines, comment lines, and physical lines of source code in many programming languages.

```
cd 2019-HERS-Documents-Schema
cloc --report-file=assets/cloc.txt .
```
