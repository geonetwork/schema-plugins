<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"  
		xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This stylesheet produces iso19139.mcp metadata in XML format -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- Metadata is passed under /root XPath -->
  <xsl:template match="/root">
    <xsl:choose>
      <!-- Export iso19139.mcp XML (just a copy) -->
      <xsl:when test="mcp:MD_Metadata">
        <xsl:apply-templates select="mcp:MD_Metadata"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Copy the root element and add the appropriate schemaLocation -->
	<!-- FIXME: get schemaLocation from official schema-ident.xml file -->
	<xsl:template match="mcp:MD_Metadata">
     <xsl:copy>
      <xsl:copy-of select="@*[name(.)!='xsi:schemaLocation']"/>
      <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd http://schemas.aodn.org.au/mcp-2.0 http://schemas.aodn.org.au/mcp-2.0/schema.xsd</xsl:attribute>
			<xsl:apply-templates select="*"/>
		</xsl:copy>
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
