<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" version="2.0">

  <xsl:template name="list-scale-denominator-formatter">
    <suggestion process="scale-denominator-formatter"/>
  </xsl:template>

  <!-- Analyze the metadata record and return available suggestion
      for that process -->
  <xsl:template name="analyze-scale-denominator-formatter">
    <xsl:param name="root"/>
    <xsl:variable name="dummyScales"
      select="string-join($root//gmd:equivalentScale/gmd:MD_RepresentativeFraction/
                gmd:denominator[contains(gco:Integer, '/') or contains(gco:Integer, ':') or contains(gco:Integer, ' ')], ', ')"/>
    <xsl:if test="$dummyScales!=''">
      <suggestion process="scale-denominator-formatter" category="identification" target="scale">
        <name xml:lang="en">The following values are not recommended for scale denominator: <xsl:value-of select="$dummyScales"/>. Run
          this task to try to fix it(them).</name>
        <operational>true</operational>
        <form/>
      </suggestion>
    </xsl:if>
  </xsl:template>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <!-- Remove duplicates
  -->
    <xsl:template match="gmd:equivalentScale/gmd:MD_RepresentativeFraction/
    gmd:denominator[contains(gco:Integer, '/') or contains(gco:Integer, ':') or contains(gco:Integer, ' ')]" priority="2">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <gco:Integer>
          <xsl:value-of select="replace(replace(replace(gco:Integer, '1:', ''), '1/', ''), ' ', '')"/>
        </gco:Integer>
      </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
