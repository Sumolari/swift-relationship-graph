This project is a small utility to create a dependency graph for protocols,
classes and structs in a Swift codebase.

# Examples

## [Alamofire](https://github.com/Alamofire/Alamofire)
![Alamofire](https://cloud.githubusercontent.com/assets/779767/18409425/f740c232-7746-11e6-80f6-7a89562787f3.png)

## [Haneke](https://github.com/Haneke/HanekeSwift)
![Haneke](https://cloud.githubusercontent.com/assets/779767/18409427/f747d5ae-7746-11e6-8f33-b5e94640cdac.png)

## [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
![Objectmapper](https://cloud.githubusercontent.com/assets/779767/18409426/f7459442-7746-11e6-8fd5-39cafaf032d4.png)

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
- [X] Add legend
- [ ] Add support for generating UML class-like diagrams
