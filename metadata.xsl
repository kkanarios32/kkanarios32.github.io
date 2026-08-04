<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.forester-notes.org"
  xmlns:html="http://www.w3.org/1999/xhtml">

  <xsl:template match="f:month[.='1']">
    <xsl:text>January</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='2']">
    <xsl:text>February</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='3']">
    <xsl:text>March</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='4']">
    <xsl:text>April</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='5']">
    <xsl:text>May</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='6']">
    <xsl:text>June</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='7']">
    <xsl:text>July</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='8']">
    <xsl:text>August</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='9']">
    <xsl:text>September</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='10']">
    <xsl:text>October</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='11']">
    <xsl:text>November</xsl:text>
  </xsl:template>

  <xsl:template match="f:month[.='12']">
    <xsl:text>December</xsl:text>
  </xsl:template>

  <xsl:template match="f:year">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:day">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:date" mode="date-inner">
    <xsl:apply-templates select="f:month" />
    <xsl:if test="f:day">
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates select="f:day" />
    </xsl:if>
    <xsl:if test="f:month">
      <xsl:text>,&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="f:year" />
  </xsl:template>

  <xsl:template match="f:date[@href]">
    <li class="meta-item">
      <a class="link local" href="{@href}">
        <xsl:apply-templates select="." mode="date-inner" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:date[not(@href)]">
    <li class="meta-item">
      <xsl:apply-templates select="." mode="date-inner" />
    </li>
  </xsl:template>

  <xsl:template match="f:authors">
    <xsl:if test="f:author or f:contributor">
      <li class="meta-item">
        <address class="author">
          <xsl:for-each select="f:author">
            <xsl:apply-templates />
            <xsl:if test="position()!=last()">
              <xsl:text>, &#x20;</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:if test="f:contributor">
            <xsl:text>&#x20;with contributions from&#x20;</xsl:text>
            <xsl:for-each select="f:contributor">
              <xsl:apply-templates />
              <xsl:if test="position()!=last()">
                <xsl:text>,&#x20;</xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </address>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="f:meta[@name='doi']">
    <li class="meta-item">
      <a class="doi link" href="{concat('https://www.doi.org/', .)}">
        <xsl:value-of select="." />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='orcid']">
    <li class="meta-item">
      <a class="orcid" href="{concat('https://orcid.org/', .)}">
        <xsl:value-of select="." />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='bibtex']">
    <pre>
      <xsl:value-of select="." />
    </pre>
  </xsl:template>

  <xsl:template match="f:meta[@name='image']">
    <div class="frontmatter-image">
      <img class="frontmatter-image" src="{.}" />
    </div>
  </xsl:template>

  <xsl:template match="f:meta[@name='venue']|f:meta[@name='position']|f:meta[@name='institution']|f:meta[@name='source']">
    <li class="meta-item">
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='external']">
    <li class="meta-item">
      <a class="link external" href="{.}">
        <xsl:value-of select="." />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='slides']">
    <li class="meta-item">
      <a class="link external" href="{.}">
        <xsl:text>Slides</xsl:text>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='paper']">
    <li class="meta-item">
      <a class="link external" href="{.}">
        <xsl:text>Paper</xsl:text>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='poster']">
    <li class="meta-item">
      <a class="link external" href="{.}">
        <xsl:text>Poster</xsl:text>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="f:meta[@name='video']">
    <li class="meta-item">
      <a class="link external" href="{.}">
        <xsl:text>Video</xsl:text>
      </a>
    </li>
  </xsl:template>

  <!-- Estimated reading time, derived at render time from the tree's own body.

       Opt-in per tree via \meta{reading-time}{true}, the same tag/meta pairing
       \tag{index} uses: a tree's \tag{...} never reaches the generated XML, so
       the theme cannot ask "is this a blog post?" and the tree has to say so.
       Opting in also keeps the estimate off the pages where it would mislead —
       a notebook is a reference to dip into, not a 55-minute sitting, and a
       reference card's body is somebody else's abstract.

       Counted from characters rather than words because XSLT 1.0 has no
       tokenizer, and a recursive split template over a long post is slow enough
       to see, in a stylesheet the browser runs on every page load. Prose here
       averages 6.6 characters per word including the trailing space, so 1100
       characters per minute is about 165 words per minute — a technical-reading
       pace rather than the 200 wpm a news site would assume, because these
       posts are the kind you stop and re-read a line of.

       Math is counted as its LaTeX source, at the same rate as prose. That
       looks like an overcount and is not: the source runs perhaps twice the
       length of the notation it renders to, and a symbol takes several times
       longer to read than a character of prose, so the two roughly cancel. It
       is also self-scaling in the way a flat per-formula weight is not —
       #{\alpha} costs a word, a two-line inline expression costs what it
       deserves.

       A display equation gets DISPLAY-SECONDS on top of its source, for the
       stop-and-parse that a centred formula asks of a reader and inline math
       does not. Between them these two rules are what separate a derivation
       from an essay of the same length: with math as a flat token, this
       forest's most equation-dense post scored the same as a piece of pure
       prose two-thirds its length. -->
  <xsl:template match="f:meta[@name = 'reading-time'][. = 'true']">
    <xsl:variable name="counted">
      <xsl:apply-templates select="../../f:mainmatter" mode="reading-time" />
    </xsl:variable>
    <xsl:variable name="body" select="normalize-space($counted)" />
    <!-- Display equations are tallied by the traversal, which marks each one
         with a sentinel it then counts back out, rather than by a second XPath
         over the same body. A second expression is a second definition of what
         counts, and the two drifted the moment they existed: the traversal
         starts at f:mainmatter, so a collapsed ancestor above it is out of
         scope, while `ancestor::f:tree[@expanded='false']` saw that same node
         and dropped every equation in the tree. The result was a post that read
         three minutes shorter in a listing than on its own page. One traversal,
         one answer.

         U+E000 is a private-use codepoint: legal in XML, and it cannot occur in
         a tree's prose, so nothing in the body can be mistaken for a marker. -->
    <xsl:variable name="displays"
      select="string-length($body) - string-length(translate($body, '&#xE000;', ''))" />
    <xsl:variable name="chars" select="string-length($body) - $displays" />
    <!-- Below a paragraph or so there is nothing to estimate, and an unwritten
         \tag{upcoming} draft should not advertise a one-minute read. -->
    <xsl:if test="$chars &gt;= 400">
      <li class="meta-item">
        <!-- 10 seconds per display equation. -->
        <xsl:value-of select="ceiling(($chars div 1100) + ($displays div 6))" />
        <xsl:text>&#160;min read</xsl:text>
      </li>
    </xsl:if>
  </xsl:template>

  <!-- What counts as body text. Everything not named here falls to the built-in
       rules, which recurse into elements and copy text, so inline \subtree and
       \section content — which Forester models as nested f:tree — is counted
       like the prose around it. -->

  <!-- A collapsed transclusion renders as a heading and a link. Whatever sits
       behind it is read on its own page, and counting it here would charge a
       post for its own reference list. An expanded one is on the page and
       counts. -->
  <xsl:template match="f:tree[@expanded = 'false']" mode="reading-time" />

  <!-- Code is scanned, not read at prose speed, and a long listing would swamp
       the estimate for a post that is mostly discussion. Dropping it outright
       is cruder than discounting it would be, but a discount needs a second
       traversal to weigh separately, and across this forest's posts the largest
       code block on any of them is worth about a minute — not worth doubling
       the work the browser does on every page load. Revisit if a post ever
       turns out to be mostly listing.

       Math is deliberately absent from this list: its source counts as prose.
       See the rate note above. -->
  <xsl:template match="f:pre | html:pre" mode="reading-time" />

  <!-- A display equation counts as its source, like any other math, plus a
       marker the caller counts back out to charge the stop-and-parse. -->
  <xsl:template match="f:tex[@display = 'block']" mode="reading-time">
    <xsl:value-of select="." />
    <xsl:text>&#xE000;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
