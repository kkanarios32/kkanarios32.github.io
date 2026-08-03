<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.forester-notes.org"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:html="http://www.w3.org/1999/xhtml">

  <!-- The following ensures that node not matched by a template will show up as an error. -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <span style="background-color:red">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="name(.)" />
        <xsl:text>]</xsl:text>
      </span>
      <span style="background-color:red">
        <xsl:apply-templates select="node()|@*" />
      </span>
    </xsl:copy>
  </xsl:template>

  <!-- HTML and MathML nodes should be copied with namespace prefixes stripped.-->
  <xsl:template match="html:*">
    <xsl:element namespace="http://www.w3.org/1999/xhtml" name="{local-name()}">
      <xsl:apply-templates select="@* | node()" />
    </xsl:element>
  </xsl:template>

  <!-- Utterances comments (the .comments div emitted by \comments in
       base-macros) belong to a post's own page, not to any page that
       transcludes it. Render the block only when its containing tree is the
       top-level document tree; when the tree is expanded on an index or the
       home page it is nested under another tree, so drop the whole block —
       divider, loader script, and the injected comment thread. -->
  <xsl:template match="html:div[@class = 'comments']">
    <xsl:if test="not(ancestor::f:tree[1]/parent::*)">
      <xsl:element namespace="http://www.w3.org/1999/xhtml" name="div">
        <xsl:apply-templates select="@* | node()" />
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- The subscribe block (emitted by \subscribe in base-macros) gets the same
       treatment, and for the same reason: Forester embeds a tree's full content
       wherever it is transcluded or hover-previewed, so without this the block
       on the Blog page also turns up on the home page, the about page, and
       every index that links to it. Render it only when its containing tree is
       the top-level document tree. This cannot live in the macro — it depends
       on where the tree sits in the document, which is only known here.

       Guard the wrapper, not the <form> inside it. An earlier version matched
       the form alone, which was sufficient only while the form was the whole
       visible block; once the divider, heading, and description moved out into
       a wrapper alongside it, they sailed straight past the guard and every
       page transcluding the blog grew a stray `Subscribe by email` heading
       with no form beneath it. Suppressing the wrapper stops its descendants
       being processed at all, so the whole block travels as one unit. -->
  <xsl:template match="html:div[@class = 'subscribe-block']">
    <xsl:if test="not(ancestor::f:tree[1]/parent::*)">
      <xsl:element namespace="http://www.w3.org/1999/xhtml" name="div">
        <xsl:apply-templates select="@* | node()" />
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mml:*">
    <xsl:element namespace="http://www.w3.org/1998/Math/MathML" name="{local-name()}">
      <xsl:apply-templates select="@* | node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="f:figure">
    <figure>
      <xsl:apply-templates />
    </figure>
  </xsl:template>

  <xsl:template match="f:figcaption">
    <figcaption>
      <xsl:apply-templates />
    </figcaption>
  </xsl:template>

  <xsl:template match="f:p">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="f:code">
    <code>
      <xsl:apply-templates />
    </code>
  </xsl:template>

  <xsl:template match="f:pre">
    <pre>
      <xsl:apply-templates />
    </pre>
  </xsl:template>

  <xsl:template match="f:em">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="f:strong">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <xsl:template match="f:ol">
    <ol>
      <xsl:apply-templates />
    </ol>
  </xsl:template>

  <xsl:template match="f:ul">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="f:li">
    <li>
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="f:blockquote">
    <blockquote>
      <xsl:apply-templates />
    </blockquote>
  </xsl:template>

  <xsl:template match="f:img[@src]">
    <img src="{@src}" />
  </xsl:template>

  <xsl:template match="f:error | f:info">
    <span class="error">
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <xsl:template match="f:info">
    <span class="info">
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <xsl:template match="f:tex[@display='block']">
    <xsl:text>\[</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>\]</xsl:text>
  </xsl:template>

  <xsl:template match="f:tex[not(@display='block')]">
    <xsl:text>\(</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>\)</xsl:text>
  </xsl:template>

</xsl:stylesheet>
