<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:ows="http://www.opengis.net/ows"
  xmlns:gn="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">
  
  <xsl:param name="displayInfo"/>
 
  <!-- summary - just return document metadata and entities, activities and agents -->

  <xsl:template match="prov:document">
    <xsl:variable name="info" select="gn:info"/>
    <xsl:copy>
      <xsl:apply-templates select="prov:other"/>

      <xsl:apply-templates select="prov:entity"/>
      <xsl:apply-templates select="prov:activity"/>
      <xsl:apply-templates select="prov:person"/>
      <xsl:apply-templates select="prov:organization"/>
      <xsl:apply-templates select="prov:softwareAgent"/>
      
      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
