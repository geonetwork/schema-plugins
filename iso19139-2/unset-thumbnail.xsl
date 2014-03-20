<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmi="http://sdi.eurac.edu/metadata/iso19139-2/schema/gmi" xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:geonet="http://www.fao.org/geonetwork">
	<!-- ================================================================= -->
	<xsl:template match="/root">
		<xsl:apply-templates select="gmi:MI_Metadata" />
	</xsl:template>
	<!-- ================================================================= -->

	<xsl:template
		match="gmd:graphicOverview[gmd:MD_BrowseGraphic/gmd:fileDescription/gco:CharacterString = /root/env/type]" />

	<!-- <xsl:template match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview[gmd:MD_BrowseGraphic/gmd:fileDescription/gco:CharacterString 
		= /root/env/type]"/> -->
	<!-- ================================================================= -->

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="geonet:info" priority="2" />
</xsl:stylesheet>