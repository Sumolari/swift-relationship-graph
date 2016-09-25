This project is a small utility to create a relationship graph for protocols, classes and structs in a Swift codebase.

# Examples

## [Alamofire](https://github.com/Alamofire/Alamofire)
[![Alamofire](https://cloud.githubusercontent.com/assets/779767/18813985/2e599966-830d-11e6-8162-892305455bc9.png)](https://cloud.githubusercontent.com/assets/779767/18813985/2e599966-830d-11e6-8162-892305455bc9.png)

## [Haneke](https://github.com/Haneke/HanekeSwift)
[![Haneke](https://cloud.githubusercontent.com/assets/779767/18813984/2e58e390-830d-11e6-9489-823a44383a5d.png)](https://cloud.githubusercontent.com/assets/779767/18813984/2e58e390-830d-11e6-9489-823a44383a5d.png)

## [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
[![Objectmapper](https://cloud.githubusercontent.com/assets/779767/18813986/2e5aff36-830d-11e6-9721-d239d7db710c.png)](https://cloud.githubusercontent.com/assets/779767/18813986/2e5aff36-830d-11e6-9721-d239d7db710c.png)

# Requirements

- NodeJS `>= 6.5.0`
- [Graphviz](http://www.graphviz.org/)'s `dot`

# Installation

1. Ensure your NodeJS version is `6.5.0` or later.
2. Install Graphviz's `dot` command line utility.
	- On **macOS** you can install it with `brew`:
	```
	brew install graphviz
	```
3. Install package dependencies: `npm install`.

# Installation

Until this is published in NPM registry...

```
git clone git@github.com:Sumolari/swift-relationship-graph.git
cd swift-relationship-graph
npm install -g .
```

# Usage

```
swift-relationship-graph <pathToJSON> [<operation>, <type...>, <pathToOutputFile>]
```

Where `filename` is the path to a SourceKitten's documentation JSON.

- Available `operation`s:
	- `dotGraphCode`
	- `dotGraphPDF`
	- `graph` (default, equivalent to `dotGraphPDF`)
- Available `type`s (multiple values allowed, comma separated):
	- `protocols` (default)
	- `structs`
	- `classes`

## Getting SourceKitten documentation JSON

Ensure you have [SourceKitten](https://github.com/jpsim/SourceKitten) properly installed and check [its usage guide](https://github.com/jpsim/SourceKitten#doc).

Example:

```
sourcekitten doc -- -workspace Haneke.xcworkspace -scheme Haneke
```

## Examples

Check [`examples`](https://github.com/Sumolari/swift-dependency-graph/tree/master/examples) folder to see some demos. 

Run each `.sh` file to automatically download and generate the relationsip diagram of each Open Source sample project.

# Todo

- [X] Improve README
- [X] Add proper error messages
- [X] Add examples
- [ ] ~~Call SourceKitten automatically~~
	- Not a priority, better add support to integrate graph generation in an Xcode plugin.
- [ ] Improve documentation
- [ ] Publish to NPM registry
- [X] Add support for classes' dependency graph
- [X] Made it `-g`-compatible
- [X] Add legend
- [ ] Add support for generating UML class-like diagrams
- [ ] Add unit tests
- [X] Add support for filtering by entity (`tree` mode)

## Changelog

### 0.0.1

- First version
