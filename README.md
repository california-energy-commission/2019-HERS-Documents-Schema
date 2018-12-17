# 2019 HERS Documents Schema

## Contributing

Thanks for your interest in contributing! There are many ways to contribute to this project. 
Get started here [CONTRIBUTING](CONTRIBUTING.md)


### Deploy Schema

`deploy-schema.exe` is a command line application executable file which
deploys the schema (formats, indents, removes whitespace, orders alphabetically)
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

