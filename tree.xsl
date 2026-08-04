<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.forester-notes.org"
  xmlns:html="http://www.w3.org/1999/xhtml">

  <xsl:key name="tree-with-uri" match="/f:tree/f:mainmatter//f:tree" use="f:frontmatter/f:uri/text()" />

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" data-base-url="{/f:tree/@base-url}">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="{/f:tree/@base-url}favicon.ico" sizes="any" />
        <link rel="icon" type="image/png" sizes="32x32" href="{/f:tree/@base-url}favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="{/f:tree/@base-url}favicon-16x16.png" />
        <link rel="apple-touch-icon" href="{/f:tree/@base-url}apple-touch-icon.png" />
        <link rel="alternate" type="application/atom+xml" title="Blog" href="{/f:tree/@base-url}0002/atom.xml" />
        <link rel="stylesheet" href="{/f:tree/@base-url}style.css" />
        <link rel="stylesheet" href="{/f:tree/@base-url}katex.min.css" />
        <script type="text/javascript">
          <xsl:if test="/f:tree/f:frontmatter/f:source-path">
            <xsl:text>window.sourcePath = '</xsl:text>
            <xsl:value-of select="/f:tree/f:frontmatter/f:source-path" />
            <xsl:text>'</xsl:text>
          </xsl:if>
        </script>
        <script type="module" src="{/f:tree/@base-url}forester.js"></script>
        <script src="{/f:tree/@base-url}highlight.min.js"></script>
        <script src="{/f:tree/@base-url}highlightjs-line-numbers.min.js"></script>
        <script>
          <xsl:text disable-output-escaping="yes"><![CDATA[
window.addEventListener('load', function () {
  if (!window.hljs) return;
  document.querySelectorAll('pre code').forEach(function (el) {
    hljs.highlightElement(el);
    if (hljs.lineNumbersBlock) hljs.lineNumbersBlock(el, { singleLine: true });
  });
});
          ]]></xsl:text>
        </script>
        <script>
          <xsl:text disable-output-escaping="yes"><![CDATA[
(function(){
  var ws = new WebSocket("ws://" + location.host + "/livereload");
  ws.onopen = function() {
    ws.send(JSON.stringify({command:"hello", protocols:["http://livereload.com/protocols/official-7"], ver:"2.0.0"}));
  };
  ws.onmessage = function(e) {
    var m = JSON.parse(e.data);
    if (m.command == "hello") {
      ws.send(JSON.stringify({command:"info", url:location.href, plugins:{}}));
    } else if (m.command == "reload") {
      fetch('http://localhost:1235/current-slug')
        .then(function(r){ return r.text(); })
        .then(function(slug){
          var cur = location.pathname.split('/').filter(Boolean)[0] || '';
          if (slug && slug !== cur) {
            location.href = '/' + slug + '/';
          } else {
            location.reload();
          }
        })
        .catch(function(){ location.reload(); });
    }
  };
})();
          ]]></xsl:text>
        </script>
        <script>
          <xsl:text disable-output-escaping="yes"><![CDATA[
console.log('[FOPEN] handler installed, sourcePath=', window.sourcePath);
document.addEventListener('keydown', function(e) {
  console.log('[FOPEN] keydown', e.key, 'ctrl=', e.ctrlKey, 'shift=', e.shiftKey, 'alt=', e.altKey);
  if (e.ctrlKey && !e.shiftKey && !e.altKey && (e.key === 'e' || e.key === 'E')) {
    console.log('[FOPEN] match, sourcePath=', window.sourcePath);
    if (window.sourcePath) {
      e.preventDefault();
      fetch('http://localhost:1235/open?path=' + encodeURIComponent(window.sourcePath))
        .then(function(r){console.log('[FOPEN] response', r.status);})
        .catch(function(err){console.log('[FOPEN] error', err);});
    }
  }
});
          ]]></xsl:text>
        </script>
        <title>
          <xsl:value-of select="/f:tree/f:frontmatter/f:title/@text" />
        </title>
      </head>
      <body>
        <ninja-keys placeholder="Start typing a note title or ID"></ninja-keys>

        <xsl:if test="not(/f:tree[@root = 'true'])">
          <!-- Back-to-home chrome, on every page but the root. The chevron is
               an inline SVG rather than a guillemet or an arrow character: at
               this size a text arrow sets differently in every fallback font
               and never optically aligns with the label. Inline keeps the
               theme free of an icon font or any external request, which
               matters because these pages are transformed in the browser.
               aria-hidden on the glyph leaves "Home" as the accessible name.

               The xmlns on the <svg> is load-bearing. Literal elements written
               inside the <html> above inherit its XHTML namespace, and these
               pages are served as XML, so namespaces are matched strictly — an
               <svg> left in the XHTML namespace parses as an unknown inline
               element and paints nothing at all. -->
          <header class="header">
            <nav class="nav">
              <a class="home-link" href="{/f:tree/@base-url}index.html">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" aria-hidden="true" focusable="false">
                  <path d="M9.75 3.5 5.25 8l4.5 4.5" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <span>Home</span>
              </a>
            </nav>
          </header>
        </xsl:if>
        <div id="grid-wrapper">
          <article>
            <xsl:apply-templates select="f:tree" />
          </article>
          <xsl:if test="f:tree/f:mainmatter/f:tree[not(@toc='false')] and not(/f:tree/f:frontmatter/f:meta[@name = 'toc']/.='false')">
            <nav id="toc">
              <div class="block">
                <h1>Table of Contents</h1>
                <xsl:apply-templates select="f:tree/f:mainmatter" mode="toc" />
              </div>
            </nav>
          </xsl:if>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="f:tree" mode="tree-taxon-with-number">
    <xsl:param name="suffix" select="''" />
    <xsl:param name="taxon" select="f:frontmatter/f:taxon" />
    <xsl:param name="number" select="f:frontmatter/f:number" />
    <xsl:param name="fallback-number" />
    <xsl:param name="in-backmatter" select="ancestor::f:backmatter" />

    <xsl:variable name="tree-is-root" select="not(parent::*)" />

    <xsl:variable name="explicitly-unnumbered" select="boolean(ancestor-or-self::f:tree[@numbered='false' or @toc='false'])" />
    <xsl:variable name="implicitly-unnumbered" select="count(../f:tree) = 1 and not(count(f:mainmatter/f:tree) > 1)" />

    <xsl:variable name="should-number" select="$number != '' or (not($in-backmatter) and not($tree-is-root) and not($explicitly-unnumbered)) and not($implicitly-unnumbered)" />

    <xsl:if test="$taxon != ''">
      <xsl:value-of select="$taxon" />
      <xsl:if test="$should-number or $fallback-number != ''">
        <xsl:text>&#160;</xsl:text>
      </xsl:if>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$should-number">
        <xsl:choose>
          <xsl:when test="$number != ''">
            <xsl:value-of select="$number" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:number format="1.1" count="f:tree[ancestor::f:tree and (not(@toc='false' or @numbered='false'))]" level="multiple" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$fallback-number != ''">
        <xsl:value-of select="$fallback-number" />
      </xsl:when>
    </xsl:choose>

    <xsl:if test="$taxon != '' or $fallback-number != '' or $should-number">
      <xsl:value-of select="$suffix" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="f:tree" mode="contextual-number">
    <xsl:param name="suffix" select="''" />
    <xsl:param name="number" select="f:frontmatter/f:number" />
    <xsl:param name="fallback-number" />
    <xsl:param name="in-backmatter" select="ancestor::f:backmatter" />

    <xsl:variable name="tree-is-root" select="not(parent::*)" />

    <xsl:variable name="explicitly-unnumbered" select="boolean(ancestor-or-self::f:tree[@numbered='false' or @toc='false'])" />
    <xsl:variable name="implicitly-unnumbered" select="count(../f:tree) = 1 and not(count(f:mainmatter/f:tree) > 1)" />

    <xsl:variable name="should-number" select="$number != '' or (not($in-backmatter) and not($tree-is-root) and not($explicitly-unnumbered)) and not($implicitly-unnumbered)" />

    <xsl:choose>
      <xsl:when test="$should-number">
        <xsl:choose>
          <xsl:when test="$number != ''">
            <xsl:value-of select="$number" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:number format="1.1" count="f:tree[ancestor::f:tree and (not(@toc='false' or @numbered='false'))]" level="multiple" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$fallback-number != ''">
        <xsl:value-of select="$fallback-number" />
      </xsl:when>
    </xsl:choose>

    <xsl:if test="$fallback-number != '' or $should-number">
      <xsl:value-of select="$suffix" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="f:tree" mode="toc">
    <li>
      <xsl:for-each select="f:frontmatter">
        <a class="bullet">
          <xsl:choose>
            <xsl:when test="f:display-uri and f:route">
              <xsl:attribute name="href">
                <xsl:value-of select="f:route" />
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="f:title/@text" />
                <xsl:text>&#160;[</xsl:text>
                <xsl:value-of select="f:display-uri" />
                <xsl:text>]</xsl:text>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="generate-id(..)" />
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="f:title" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>■</xsl:text>
        </a>
        <span class="link local" data-target="#{generate-id(..)}">
          <span class="taxon">
            <xsl:apply-templates select=".." mode="tree-taxon-with-number">
              <xsl:with-param name="suffix">.&#160;</xsl:with-param>
            </xsl:apply-templates>
          </span>

          <xsl:apply-templates select="f:title" />
        </span>
      </xsl:for-each>
      <xsl:apply-templates select="f:mainmatter" mode="toc" />
    </li>
  </xsl:template>

  <xsl:template match="f:mainmatter" mode="toc">
    <ul class="block">
      <xsl:apply-templates select="f:tree[not(@toc='false')]" mode="toc" />
    </ul>
  </xsl:template>

  <!-- On an index page (\meta{index}{true}), a collapsed entry's title links to
       the entry's own page instead of unfolding it in place. The decision is
       made here rather than in a separate mode so the whole f:frontmatter
       template — taxon, slug, date, author — is reused untouched; only the
       title's rendering changes. See the index-entry rule on f:tree below for
       the conditions, which this repeats. -->
  <xsl:template match="f:frontmatter/f:title">
    <xsl:variable name="is-index-entry" select="
      ../../@expanded = 'false'
      and not(../../@show-heading = 'false')
      and not(../f:meta[@name = 'index'] = 'true')
      and not(ancestor::f:backmatter)
      and ../../ancestor::f:tree[1]/f:frontmatter/f:meta[@name = 'index'] = 'true'" />
    <xsl:choose>
      <xsl:when test="$is-index-entry and ../f:route">
        <a class="index-entry-link" href="{../f:route}">
          <xsl:apply-templates />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="f:mainmatter">
     <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:display-uri[../f:route]">
    <a class="slug" href="{../f:route}">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>]</xsl:text>
    </a>
  </xsl:template>

  <xsl:template match="f:display-uri[not(../f:route)]">
  </xsl:template>

  <xsl:template match="f:resource">
    <xsl:apply-templates select="f:resource-content" />
  </xsl:template>

  <xsl:template match="f:resource-content">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:source-path">
    <a class="edit-button" href="{concat('vscode://file', .)}">
      <xsl:text>[edit]</xsl:text>
    </a>
  </xsl:template>

  <xsl:template match="f:taxon">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="f:frontmatter">
      <header>
        <xsl:if test="f:meta[@name='image']">
          <xsl:apply-templates select="f:meta[@name='image']" />
        </xsl:if>
        <h1>
          <span class="taxon">
            <xsl:apply-templates select=".." mode="tree-taxon-with-number">
              <xsl:with-param name="suffix">.&#160;</xsl:with-param>
            </xsl:apply-templates>
          </span>

          <xsl:apply-templates select="f:title" />
          <xsl:text>&#032;</xsl:text>
          <xsl:apply-templates select="f:display-uri" />
          <xsl:text>&#032;</xsl:text>
          <xsl:apply-templates select="f:source-path" />
        </h1>
        <div class="metadata">

          <xsl:if test="f:taxon='Reference'">
          <xsl:if test="f:date[string-length(normalize-space(.)) > 0]">
            <ul>
              <xsl:apply-templates select="f:date" />
            </ul>
            <br></br>
          </xsl:if>
          <xsl:if test="not(f:meta[@name = 'author']/.='false') and f:authors/f:author[string-length(normalize-space(.)) > 0]">
            <ul>
            <xsl:apply-templates select="f:authors" />
            </ul>
            <br></br>
          </xsl:if>
          <ul>
            <xsl:apply-templates select="f:meta[@name='orcid']" />
            <xsl:apply-templates select="f:meta[@name='doi']" />
            <xsl:apply-templates select="f:meta[@name='external']" />
            <xsl:apply-templates select="f:meta[@name='position']" />
            <xsl:apply-templates select="f:meta[@name='institution']" />
            <xsl:apply-templates select="f:meta[@name='venue']" />
            <xsl:apply-templates select="f:meta[@name='source']" />
            <xsl:apply-templates select="f:meta[@name='slides']" />
            <xsl:apply-templates select="f:meta[@name='paper']" />
            <xsl:apply-templates select="f:meta[@name='poster']" />
            <xsl:apply-templates select="f:meta[@name='video']" />
          </ul>
          </xsl:if>
          <xsl:if test="not(f:taxon='Reference')">
          <ul>
            <xsl:apply-templates select="f:date" />
            <xsl:if test="not(f:meta[@name = 'author']/.='false')">
              <xsl:apply-templates select="f:authors" />
            </xsl:if>
            <xsl:apply-templates select="f:meta[@name='position']" />
            <xsl:apply-templates select="f:meta[@name='institution']" />
            <xsl:apply-templates select="f:meta[@name='venue']" />
            <xsl:apply-templates select="f:meta[@name='source']" />
            <xsl:apply-templates select="f:meta[@name='orcid']" />
            <xsl:apply-templates select="f:meta[@name='doi']" />
            <xsl:apply-templates select="f:meta[@name='external']" />
            <xsl:apply-templates select="f:meta[@name='slides']" />
            <xsl:apply-templates select="f:meta[@name='paper']" />
            <xsl:apply-templates select="f:meta[@name='poster']" />
            <xsl:apply-templates select="f:meta[@name='video']" />
            <!-- Last in the line: the date and author say what this is, the
                 reading time says what it costs, which is what a reader
                 deciding whether to open it wants read to them last. -->
            <xsl:apply-templates select="f:meta[@name='reading-time'][. = 'true']" />
          </ul>
          </xsl:if>
        </div>
      </header>
  </xsl:template>

  <xsl:template match="f:ref">
    <xsl:variable name="fallback-number">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="@uri" />
      <xsl:text>]</xsl:text>
    </xsl:variable>

    <xsl:variable name="taxon">
      <xsl:choose>
        <xsl:when test="@taxon">
          <xsl:value-of select="@taxon" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>§</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <a class="link local">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="key('tree-with-uri',current()/@uri)">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="generate-id(key('tree-with-uri',current()/@uri))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@href" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="key('tree-with-uri', current()/@uri)">
          <xsl:apply-templates select="key('tree-with-uri', current()/@uri)" mode="tree-taxon-with-number">
            <xsl:with-param name="in-backmatter" select="boolean(ancestor::f:backmatter)" />
            <xsl:with-param name="number" select="@number" />
            <xsl:with-param name="fallback-number" select="$fallback-number" />
            <xsl:with-param name="taxon" select="$taxon" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$taxon" />
          <xsl:text>&#160;</xsl:text>
          <xsl:choose>
            <xsl:when test="@number">
              <xsl:value-of select="@number" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$fallback-number" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="f:contextual-number[@uri]">
    <xsl:variable name="fallback-number">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="@display-uri" />
      <xsl:text>]</xsl:text>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="key('tree-with-uri', current()/@uri)">
        <xsl:apply-templates select="key('tree-with-uri', current()/@uri)" mode="contextual-number">
          <xsl:with-param name="in-backmatter" select="boolean(ancestor::f:backmatter)" />
          <xsl:with-param name="fallback-number" select="$fallback-number" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fallback-number" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/f:tree[@root='true']/f:backmatter">
  </xsl:template>

  <xsl:template match="/f:tree[not(@root='true')]/f:backmatter">
    <footer>
      <xsl:apply-templates />
    </footer>
  </xsl:template>

  <xsl:template match="f:mainmatter//f:backmatter">
  </xsl:template>

  <xsl:template match="f:backmatter//f:backmatter">
  </xsl:template>

  <!-- Spaced-repetition cards (\taxon{Card}, trees/cards/) are Anki prompts;
       keep them out of the backlink/context footer of the notes they link. A
       card transcluded into a note's mainmatter still renders — this only
       suppresses cards appearing as backlinks. -->
  <xsl:template match="f:backmatter//f:tree[normalize-space(f:frontmatter/f:taxon) = 'Card']" priority="10">
  </xsl:template>

  <!-- Index-page entries. A tree marked \meta{index}{true} is a navigation page
       — the home page, 0002 Blog, RCNT — rather than a piece of writing, and
       its collapsed entries are a listing, not content folded away. Render
       those as their usual heading (taxon, linked title, slug, date, author)
       with no <details>, so clicking navigates to the entry instead of
       unfolding it in place.

       Nothing that was visible becomes hidden. The rule fires only on entries
       the page already renders collapsed (@expanded='false'), so anything
       transcluded expanded keeps its body. An index page nested inside another
       index page is exempt via the f:meta test — that is what keeps the home
       page's Research subtree an expandable block while the papers listed
       under it become links. Backlink context in f:backmatter is exempt too,
       and the page's own top-level rendering is untouched.

       Higher priority than the general f:tree rule below, whose pattern also
       matches these. The f:frontmatter/f:title template above repeats these
       conditions to decide whether to wrap the title in a link. -->
  <xsl:template priority="5" match="f:tree[
    @expanded = 'false'
    and not(@show-heading = 'false')
    and not(f:frontmatter/f:meta[@name = 'index'] = 'true')
    and not(ancestor::f:backmatter)
    and ancestor::f:tree[1]/f:frontmatter/f:meta[@name = 'index'] = 'true']">
    <section>
      <xsl:choose>
        <xsl:when test="@show-metadata = 'false'">
          <xsl:attribute name="class">block index-entry hide-metadata</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">block index-entry</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="f:frontmatter/f:taxon">
        <xsl:attribute name="data-taxon">
          <xsl:value-of select="f:frontmatter/f:taxon" />
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="f:frontmatter" />
    </section>
  </xsl:template>

  <xsl:template match="f:tree[f:mainmatter[*] or not(@hidden-when-empty = 'true')]">
    <section>
      <xsl:attribute name="lang">
        <xsl:choose>
          <xsl:when test="f:frontmatter/f:meta[@name='lang']">
            <xsl:value-of select="f:frontmatter/f:meta[@name='lang']" />
          </xsl:when>
          <xsl:otherwise>en</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="@show-metadata = 'false'">
          <xsl:attribute name="class">block hide-metadata</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">block</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="f:frontmatter/f:taxon">
        <xsl:attribute name="data-taxon">
          <xsl:value-of select="f:frontmatter/f:taxon" />
        </xsl:attribute>
      </xsl:if>

      <!-- A collapsed listing should say what it is, not just what it is called.
           The home page folds Research and Blog away, and a fold hides the one
           sentence that explains the listing along with the entries it
           explains — leaving two bare headings, and revealing the description
           only once the reader has already committed to opening it.

           So an index page transcluded collapsed keeps its opening paragraph in
           the summary. Its first \p is a description of the listing by
           convention, which makes it exactly the right thing to leave showing.

           Deliberately narrow, on two counts. It fires only on a collapsed tree
           that is itself an index page, so it never lifts a paragraph out of an
           article: the entries within a listing are ordinary trees, and they
           keep rendering as bare headings. And it skips f:backmatter, where
           index pages turn up constantly as backlinks — "what links here" is a
           reference, not a listing being browsed, and describing each row there
           would bury the link the reader came for. -->
      <xsl:variable name="listing-blurb" select="
        f:mainmatter/*[1][self::html:p]
                      [../../@expanded = 'false']
                      [../../f:frontmatter/f:meta[@name = 'index'] = 'true']
                      [not(../../ancestor::f:backmatter)]" />

      <xsl:choose>
        <xsl:when test="not(@show-heading='false')">
          <details id="{generate-id(.)}">
            <!-- Cards (\taxon{Card}) start collapsed: the question (summary)
                 shows, the answer stays hidden until clicked — a flashcard. -->
            <xsl:if test="not(@expanded = 'false') and not(normalize-space(f:frontmatter/f:taxon) = 'Card')">
              <xsl:attribute name="open">open</xsl:attribute>
            </xsl:if>
            <summary>
              <xsl:apply-templates select="f:frontmatter" />
              <xsl:apply-templates select="$listing-blurb" />
            </summary>
            <xsl:choose>
              <!-- The blurb was lifted into the summary above; rendering
                   f:mainmatter wholesale here would print it a second time
                   the moment the listing is opened. -->
              <xsl:when test="$listing-blurb">
                <xsl:apply-templates select="f:mainmatter/*[position() &gt; 1]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="f:mainmatter" />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="f:frontmatter/f:meta[@name='bibtex']" />
          </details>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="f:mainmatter" />
        </xsl:otherwise>
      </xsl:choose>
    </section>

    <xsl:apply-templates select="f:backmatter" />
  </xsl:template>

  <xsl:template match="f:tree"></xsl:template>

</xsl:stylesheet>
