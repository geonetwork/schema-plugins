<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"  
		xmlns:grg="http://www.isotc211.org/2005/grg"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:gnreg="http://geonetwork-opensource.org/register"
		xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This stylesheet produces iso19135 metadata in XML format -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- Metadata is passed under /root XPath -->
  <xsl:template match="/root">
    <xsl:choose>
      <!-- Export iso19135 XML (just a copy) -->
      <xsl:when test="grg:RE_Register">
        <xsl:apply-templates select="grg:RE_Register"/>
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
