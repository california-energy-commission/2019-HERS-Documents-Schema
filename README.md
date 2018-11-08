# 2019 HERS Documents Schema

The current process uses the `schema` folder as the original set of schema files.

The `Schema-Deployer.exe` Windows Desktop C# based application is used to deploy the schema to 
the `deployed` folder.  This application will create a `deployed` folder at your 
location of choosing.

The `schema` folder contains embedded markup in square tags `[ ]`, and `t4ref` links which are  
processed by the `Schema-Deployer.exe`. 

This application also normalizes, strips whitespace and
sorts each schema file alphabetically by it's elements `name` attribute which are
directly below the root xsd:schema element.

The `Schema-Deployer.exe` also updates each schema file's root xsd:schema version attribute.

## Contributing

Thanks for your interest in contributing! There are many ways to contribute to this project. 
Get started here [CONTRIBUTING](CONTRIBUTING.md)
