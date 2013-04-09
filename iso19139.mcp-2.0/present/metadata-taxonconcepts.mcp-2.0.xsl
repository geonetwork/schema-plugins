<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:ibis="http://biodiversity.org.au/xml/ibis"
  xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:app="http://anbg.gov.au/ibis/applications/repository/xml/content">

	<!-- ==================================================================== -->
	<!-- taxonConcepts elements -->
	<!-- ==================================================================== -->

	<xsl:template mode="taxonconcepts" match="mcp:taxonConcepts">
		<xsl:for-each select="*/ibis:TaxonConcept|*/ibis:TaxonName">
				<a href="{@ibis:uri}.html">
					<xsl:value-of select="dcterms:title"/>
				</a>
				<xsl:if test="count(ibis:AcceptedFor/ibis:AcceptedForNameRef)>0">
					<p>Accepted for:</p>
					<xsl:for-each select="ibis:AcceptedFor/ibis:AcceptedForNameRef">
						<p><a href="{@ibis:uriRef}.html">
							<xsl:value-of select="ibis:NameComplete"/>
						</a></p>
					</xsl:for-each>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
