# 2019 HERS Documents Schema

## Contributing

Thanks for your interest in contributing! There are many ways to contribute to this project. 
Get started here [CONTRIBUTING](CONTRIBUTING.md)

## Reports

We have two reports located in the `tools\output` directory. 

- **Excel** report with charts which reports on the files in the repository
- **Web based** report using mainly HTML, JavaScript and CSS that reports on the Ruby code

The Excel report is best seen in Excel but can be opened with other programs like Google Sheets.
The HTML files in the RubyCritic report can be opened locally with a web browser.

[&#8593;](#2019-hers-documents-schema)

## Checks to run before submitting a pull request

- validate XML schema
- check for empty display term text

On [Ubuntu](https://www.ubuntu.com/) Linux you can use [xmllint](http://xmlsoft.org/xmllint.html)
to check the well formedness of a directory of XML or even XML schema.  Well formed XML is the first step 
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
to a `deployed` folder.  There is also a `deploy-schema` script that runs
on Linux and MacOS.

#### Windows

```
$ deploy-schema.exe
Usage: deploy-schema.exe [options]
Options:
  -d, --destination string
        Path to deploy the schema: 
  -s, --source string
        Path to schema: 
  -v, --version string
        Enter new schema version:
```

##### Example run
```
$ cd 2019-HERS-Documents-Schema
$ deploy-schema.exe -d . -s schema -v 2019.1.000
```

[&#8593;](#2019-hers-documents-schema)

## Ruby

We are using [Bundler](https://bundler.io/) to manage and install the [RubyGems](https://rubygems.org/).
```
$ gem install bundler
```
Then to install this projects RubyGems run:
```
$ bundle install
```
To generate the web based [RubyCritic](https://github.com/whitesmith/rubycritic) report run:
```
$ rubycritic -p tools/output/rubycritic
```

[&#8593;](#2019-hers-documents-schema)

## Links

- [Git](https://git-scm.com/)
- [Shell script](https://en.wikipedia.org/wiki/Shell_script)
- [grep](https://www.gnu.org/software/grep/)
- [Ruby](https://www.ruby-lang.org)
- [Bundler](https://bundler.io/)
- [Gemfile](https://bundler.io/gemfile.html)
- [Nokogiri](https://nokogiri.org/)
- [FileUtils](https://ruby-doc.org/stdlib-2.5.3/libdoc/fileutils/rdoc/FileUtils.html)
- [Rubocop](https://github.com/rubocop-hq/rubocop)
- [Axlsx](https://github.com/randym/axlsx)
- [OptionParser](https://docs.ruby-lang.org/en/2.5.0/OptionParser.html)
- [RubyCritic](https://github.com/whitesmith/rubycritic)
- [Golang](https://golang.org/)
- [YAML](https://yaml.org/)
- [CircleCI](https://circleci.com/)
- [xmllint](http://xmlsoft.org/xmllint.html)
- [Ubuntu](https://www.ubuntu.com/)
- [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about)
- [Markdown](https://guides.github.com/features/mastering-markdown/)
- [RubyGems](https://rubygems.org/)
- [Regular expressions](https://www.rexegg.com/)
- [APT](https://en.wikipedia.org/wiki/APT_\(Debian\))
- [xargs](https://en.wikipedia.org/wiki/Xargs)
- [wc](https://en.wikipedia.org/wiki/Wc_\(Unix\))
- [find](https://linux.die.net/man/1/find)
- [libxml2-utils](https://packages.ubuntu.com/search?keywords=libxml2-utils)

[&#8593;](#2019-hers-documents-schema)

## Advanced Links

- [Oracle VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Docker](https://www.docker.com/)

[&#8593;](#2019-hers-documents-schema)