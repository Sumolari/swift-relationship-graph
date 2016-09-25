#!/bin/bash

# Path to this file, regardless from where it is executed.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ALAMOFIRE_FOLDER=$DIR/Alamofire
ALAMOFIRE_DOCS_PATH=$ALAMOFIRE_FOLDER/docs.json

# Remove previous Alamofire clone, if any.
rm -rf $ALAMOFIRE_FOLDER

# Clone Alamofire.
git clone git@github.com:Alamofire/Alamofire.git $ALAMOFIRE_FOLDER

# Move to Alamofire's folder.
pushd $ALAMOFIRE_FOLDER

# Checkout version 3.5.0
git checkout 3.5.0

# Generate SourceKitten JSON documentation
sourcekitten doc --module-name Alamofire -- -project Alamofire.xcodeproj \
	> $ALAMOFIRE_DOCS_PATH

# Move to previous directory
popd

# Run Swift Dependency Graph
$DIR/../bin/swift-relationship-graph \
	$ALAMOFIRE_DOCS_PATH \
	graph \
	protocols,structs,classes \
	$DIR/alamofire.pdf