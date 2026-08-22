#!/bin/bash
cd "$(dirname "$0")"

npm install

./node_modules/.bin/esbuild --minify --bundle javascript-source/forester.js --outfile=forester.js

# highlight.min.js is a separate bundle, not part of forester.js: tree.xsl loads
# it as a classic script so `window.hljs` exists by the load handler. It is the
# stock "common" language set plus llvm and haskell — see the source file for
# why those two. Rebuild it here rather than vendoring a prebuilt blob, so the
# language list lives in git instead of inside minified output.
./node_modules/.bin/esbuild --minify --bundle --format=iife \
  javascript-source/highlight.js --outfile=highlight.min.js
