<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork"
										exclude-result-prefixes="eml">

	<xsl:param name="displayInfo"/>
	<xsl:param name="lang"/>
	
	<!-- ============================================================================= -->

	<xsl:template match="eml:eml">
		
		<xsl:variable name="info" select="geonet:info"/>
		
		<csw:SummaryRecord>

			<xsl:for-each select="dataset/alternateIdentifier">
				<dc:identifier><xsl:value-of select="."/></dc:identifier>
			</xsl:for-each>
			
			<!-- DataIdentification -->
			<xsl:for-each select="dataset/title">    
				<dc:title><xsl:value-of select="."/></dc:title>
			</xsl:for-each>

			<!-- bounding box -->
			<xsl:for-each select="dataset/coverage/geographicCoverage">
				<ows:BoundingBox crs="epsg::4326">
					<ows:LowerCorner>
						<xsl:value-of select="concat(boundingCoordinates/eastBoundingCoordinate, ' ', boundingCoordinates/southBoundingCoordinate)"/>
					</ows:LowerCorner>
					
					<ows:UpperCorner>
						<xsl:value-of select="concat(boundingCoordinates/westBoundingCoordinate, ' ', boundingCoordinates/northBoundingCoordinate)"/>
					</ows:UpperCorner>
				</ows:BoundingBox>
			</xsl:for-each>
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</csw:SummaryRecord>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
