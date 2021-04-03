# 2019 HERS Documents Schema

[![Remote Dispatch Action Dispatcher](https://github.com/california-energy-commission/2019-HERS-Documents-Schema/actions/workflows/dispatch.yml/badge.svg)](https://github.com/california-energy-commission/2019-HERS-Documents-Schema/actions/workflows/dispatch.yml)

- [Documentation](#documentation)
- [Contributing](#contributing)
- [Deploy Schema](#deploy-schema)

## Documentation

#### schema

Each schema document has its own docs files inside the `documentation` folder.

#### Miscellaneous

Miscellaneous documentation such as slides, HERS documents change notes and diagrams can be found at `documentation/misc`.

## Contributing

Get started here [CONTRIBUTING](CONTRIBUTING.md)

## Deploy Schema

`deploy-schema` is a command line application that deploys the schema (replaces embedded square markup, formats, indents, removes whitespace, orders alphabetically)
to a `deployed` folder.

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

### Unix

```
./deploy-schema
Usage of ./deploy-schema:
  -d, --destination="": Path to deploy the schema:
  -s, --source="": Path to schema:
  -v, --version="": Enter new schema version:
```

#### Example

```
cd 2019-HERS-Documents-Schema/scripts
./deploy-schema -d ../deployed -s ../schema -v 2019.1.000
```
