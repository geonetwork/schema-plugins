<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"  
		xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
    xmlns:dc="http://purl.org/dc/terms/"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This stylesheet produces eml-gbif metadata in XML format -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- Metadata is passed under /root XPath -->
  <xsl:template match="/root">
    <xsl:choose>
      <!-- Export eml-gbif XML (just a copy) -->
      <xsl:when test="eml:eml">
        <xsl:apply-templates select="eml:eml"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Copy the root element and add the appropriate schemaLocation -->
	<!-- FIXME: get schemaLocation from official schema-ident.xml file -->
	<xsl:template match="eml:eml">
     <xsl:copy>
      <xsl:copy-of select="@*[name(.)!='xsi:schemaLocation']"/>
      <xsl:attribute name="xsi:schemaLocation">eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/dev/eml.xsd</xsl:attribute>
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
