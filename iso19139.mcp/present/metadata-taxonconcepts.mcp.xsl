<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:ibis="http://biodiversity.org.au/xml/ibis"
	xmlns:app="http://anbg.gov.au/ibis/applications/repository/xml/content"
	xpath-default-namespace="http://biodiversity.org.au/xml/ibis">

	<!-- ==================================================================== -->
	<!-- taxonConcepts elements -->
	<!-- ==================================================================== -->

	<xsl:template mode="taxonconcepts" match="mcp:taxonConcepts">
		<xsl:for-each select="*/TaxonConcept|*/TaxonName">
				<a href="http://biodiversity.org.au/{@ibis:namespace}/{@ibis:objectid}.html"><xsl:value-of select="NameComplete"/></a>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
