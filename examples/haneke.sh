#!/bin/bash

# Path to this file, regardless from where it is executed.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

HANEKE_FOLDER=$DIR/Haneke
HANEKE_DOCS_PATH=$HANEKE_FOLDER/docs.json

# Remove previous Haneke clone, if any.
rm -rf $HANEKE_FOLDER

# Clone Haneke.
git clone git@github.com:Haneke/HanekeSwift.git $HANEKE_FOLDER

# Move to Haneke's folder.
pushd $HANEKE_FOLDER

# Checkout version 0.10.1
git checkout v0.10.1

# Generate SourceKitten JSON documentation
sourcekitten doc --module-name Haneke -- -workspace Haneke.xcworkspace \
	-scheme Haneke > $HANEKE_DOCS_PATH

# Move to previous directory
popd

# Run Swift Dependency Graph
$DIR/../bin/swift-relationship-graph \
	$HANEKE_DOCS_PATH \
	graph \
	protocols,structs,classes \
	$DIR/Haneke.pdf