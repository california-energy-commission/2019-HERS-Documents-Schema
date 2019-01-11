# 2019 HERS Documents Schema

## Contributing

Thanks for your interest in contributing! There are many ways to contribute to this project. 
Get started here [CONTRIBUTING](CONTRIBUTING.md)

## Checks to run before submitting a pull request

- validate XML schema
- check for empty display term text

On [Ubuntu](https://www.ubuntu.com/) Linux you can use [xmllint](http://xmlsoft.org/xmllint.html)
to check the well formedness of a directory of XML or even XML schema.

The [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about)
can be installed on Windows and emulates the Ubuntu environment.

The command to run is:
```
cd 2019-HERS-Documents-Schema
find schema -type f -name "*.xsd" -exec xmllint --noout {} \;
```

Current regular expressions to use to check for `empty` terms:
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

### Deploy Schema

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

