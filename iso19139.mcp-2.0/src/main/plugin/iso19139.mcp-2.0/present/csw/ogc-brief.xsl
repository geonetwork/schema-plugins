<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<xsl:param name="displayInfo"/>

	<!-- ============================================================================= -->

	<xsl:template match="mcp:MD_Metadata">
		<xsl:variable name="info" select="geonet:info"/>
		<csw:BriefRecord>

			<xsl:for-each select="gmd:fileIdentifier">
				<dc:identifier><xsl:value-of select="gco:CharacterString"/></dc:identifier>
			</xsl:for-each>

			<xsl:for-each select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue">
				<dc:type><xsl:value-of select="."/></dc:type>
			</xsl:for-each>

			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</csw:BriefRecord>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
