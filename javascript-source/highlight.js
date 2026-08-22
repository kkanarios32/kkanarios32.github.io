// Bundled separately from forester.js and loaded as a classic script, because
// tree.xsl calls hljs.highlightElement on window load and XSLT-inserted script
// tags are not parser-inserted (module scope would not expose it in time).
//
// The stock "common" bundle has no grammar for the IR this forest quotes most:
// MLIR, StableHLO, and HLO. Auto-detection over the common set guesses `perl`,
// `rust`, or `go` — differently per block, so one notation gets three colour
// schemes on one page. Two additions fix that:
//
//   llvm     — MLIR / StableHLO / HLO. Same family: %value, @symbol, ^label,
//              !type, iN/fN types. Not exact (no MLIR region or attribute
//              grammar) but every token it colours, it colours correctly.
//   haskell  — jaxpr, for `let` / `in` and numeric literals. Deliberately not
//              `llvm`: LLVM treats `;` as a comment, and a jaxpr's invars sit
//              behind one, so the whole signature line would grey out.
import hljs from 'highlight.js/lib/common';
import llvm from 'highlight.js/lib/languages/llvm';
import haskell from 'highlight.js/lib/languages/haskell';

hljs.registerLanguage('llvm', llvm);
hljs.registerLanguage('haskell', haskell);

window.hljs = hljs;
