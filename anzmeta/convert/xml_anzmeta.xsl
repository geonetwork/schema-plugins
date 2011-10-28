<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"  
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This stylesheet produces anzmeta metadata in XML format -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- Metadata is passed under /root XPath -->
  <xsl:template match="/root">
    <xsl:choose>
      <!-- Export anzmeta XML (just a copy) -->
      <xsl:when test="anzmeta">
        <xsl:apply-templates select="anzmeta"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

	<!-- Delete any GeoNetwork specific elements -->
  <xsl:template match="geonet:*"/> 

  <!-- Copy everything else -->
  <xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()[name(self::*)!='geonet:info']"/>
      </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
