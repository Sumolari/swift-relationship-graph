#!/bin/bash

FILE="./$1"
DOT_FILE="$FILE.dot"
PDF_FILE="$FILE.pdf"

if [ -f $FILE ];
then
	node dependency-graph.js $FILE > $DOT_FILE
	dot $DOT_FILE -Tpdf -o $PDF_FILE -Kdot
else
	echo "File $FILE does not exist"
fi