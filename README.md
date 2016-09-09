This project is a small utility to create a dependency graph for protocols,
classes and structs in a Swift codebase.

# Examples

## [Alamofire](https://github.com/Alamofire/Alamofire)
![Alamofire](https://cloud.githubusercontent.com/assets/779767/18397916/ac6ac932-76ca-11e6-8757-5754a51852b7.png)

## [Haneke](https://github.com/Haneke/HanekeSwift)
![Haneke](https://cloud.githubusercontent.com/assets/779767/18397917/ac6bd41c-76ca-11e6-8e15-870d6cea2bb3.png)

## [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
![Objectmapper](https://cloud.githubusercontent.com/assets/779767/18397915/ac686d18-76ca-11e6-9b8c-faf8dc158213.png)

# Requirements

- NodeJS `>= 6.5.0`
- [Graphviz](http://www.graphviz.org/)'s `dot`

# Installation

1. Ensure your NodeJS version if `6.5.0` or later.
2. Install Graphviz's `dot` command line utility.
	- On **macOS** you can install it with `brew`:
	```
	brew install graphviz
	```
3. Install package dependencies: `npm install`.

# Usage

```
./dependency-graph.sh <filename> [<operation>, <type...>, <outputFileName>]
```

Where `filename` is the path to a SourceKitten's documentation JSON.

- Available `operation`s:
	- `dotGraphCode`
	- `dotGraphPDF`
	- `graph` (default, equivalent to `dotGraphPDF`)
- Available `type`s (multiple values allowed, comma separated):
	- `protocols`
	- `structs`
	- `classes`

## Getting SourceKitten documentation JSON

Ensure you have [SourceKitten](https://github.com/jpsim/SourceKitten) properly
installed and check [its usage guide](https://github.com/jpsim/SourceKitten#doc).

Exameple:

```
sourcekitten doc -- -workspace Haneke.xcworkspace -scheme Haneke
```

## Examples

Check [`examples`](https://github.com/Sumolari/swift-dependency-graph/tree/master/examples) folder to see some demos. 

Run each `.sh` file to automatically download and generate the dependency diagram of each Open Source sample project.

# Todo

- [X] Improve README
- [X] Add proper error messages
- [X] Add examples
- [ ] ~~Call SourceKitten automatically~~
	- Not a priority, better add support to integrate graph generation in an Xcode plugin.
- [ ] Improve documentation
- [ ] Publish to NPM registry
- [X] Add support for classes' dependency graph
- [ ] Made it `-g`-compatible
