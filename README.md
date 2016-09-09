This project is a small utility to create a dependency graph for protocols,
classes and structs in a Swift codebase.

# Requirements

- NodeJS `>= 6.5.0`
- [Graphviz](http://www.graphviz.org/)'s `dot`

# Installation

1. Ensure your NodeJS version if `6.5.0` or later.
2. Install Graphviz's `dot` command line utility.
	1. On **macOS** you can install it via `brew`: `brew install graphviz`
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

Check `examples` folder to see some demos. Run each `.sh` file to automatically
download and generate the dependency diagram of each Open Source sample project.

# Todo

- [X] Improve README
- [X] Add proper error messages
- [X] Add examples
- [X] ~~Call SourceKitten automatically~~
- [ ] Improve documentation
- [ ] Publish to NPM registry
- [X] Add support for classes' dependency graph
- [ ] Made it `-g`-compatible
