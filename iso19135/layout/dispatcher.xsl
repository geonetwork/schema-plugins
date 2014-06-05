<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:grg="http://www.isotc211.org/2005/grg"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  
  <xsl:include href="layout.xsl"/>

  <!-- 
    Load the schema configuration for the editor.
      -->
  <xsl:template name="get-iso19135-configuration">
    <xsl:copy-of select="document('config-editor.xml')"/>
  </xsl:template>


  <!-- Dispatch to the current profile mode -->
  <xsl:template name="dispatch-iso19135">
    <xsl:param name="base" as="node()"/>
    <xsl:apply-templates mode="mode-iso19135" select="$base"/>
  </xsl:template>


  <!-- The following templates usually delegates all to iso19139. -->
  <xsl:template name="evaluate-iso19135">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="in"/>
    <xsl:variable name="nodeOrAttribute" select="saxon:evaluate(concat('$p1', $in), $base)"/>
    <xsl:choose>
      <xsl:when test="$nodeOrAttribute/*">
        <xsl:copy-of select="$nodeOrAttribute"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nodeOrAttribute"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Evaluate XPath returning a boolean value. -->
  <xsl:template name="evaluate-iso19135-boolean">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="in"/>

    <xsl:value-of select="saxon:evaluate(concat('$p1', $in), $base)"/>
  </xsl:template>


</xsl:stylesheet>
