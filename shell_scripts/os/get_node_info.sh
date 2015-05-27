#!/bin/bash
node_version=`node -v`
iojs_version=`iojs -v`
npm_version=`npm -v`
echo "{\"node_version\": \"$node_version\", \"iojs_version\": \"$iojs_version\", \"npm_version\": \"$npm_version\"}"