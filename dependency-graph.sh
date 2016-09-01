#!/bin/bash

FILE="./$1"
TYPES=${2:-protocols}
DOT_FILE="$FILE.dot"
PDF_FILE="$FILE.pdf"

#sourcekitten doc -- -workspace Visual.xcworkspace -scheme Visual > $FILE
if [ -f $FILE ];
then
	node dependency-graph.js $FILE dotGraph $TYPES > $DOT_FILE
	dot $DOT_FILE -Tpdf -o $PDF_FILE -Kdot
else
	echo "File $FILE does not exist"
fi