#!/bin/bash

# Path to this file, regardless from where it is executed.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OBJECTMAPPER_FOLDER=$DIR/ObjectMapper
OBJECTMAPPER_DOCS_PATH=$OBJECTMAPPER_FOLDER/docs.json

# Remove previous ObjectMapper clone, if any.
rm -rf $OBJECTMAPPER_FOLDER

# Clone ObjectMapper.
git clone git@github.com:Hearst-DD/ObjectMapper.git $OBJECTMAPPER_FOLDER

# Move to ObjectMapper's folder.
pushd $OBJECTMAPPER_FOLDER

# Checkout version 1.5.0
git checkout 1.5.0

# Generate SourceKitten JSON documentation
sourcekitten doc --module-name ObjectMapper -- \
	-workspace ObjectMapper.xcworkspace -scheme "ObjectMapper-iOS" \
	> $OBJECTMAPPER_DOCS_PATH

# Move to previous directory
popd

# Run Swift Dependency Graph
$DIR/../bin/swift-dependency-graph \
	$OBJECTMAPPER_DOCS_PATH \
	graph \
	protocols,structs,classes \
	$DIR/ObjectMapper.pdf