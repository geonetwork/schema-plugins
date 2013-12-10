<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<xsl:param name="displayInfo"/>
	
	<!-- ============================================================================= -->

	<xsl:template match="sml:SensorML">
		<xsl:variable name="info" select="geonet:info"/>
		<csw:BriefRecord>

			<!-- Identifier -->
			<xsl:for-each select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name='siteID']/sml:Term">
				<dc:identifier><xsl:value-of select="sml:value"/></dc:identifier>
			</xsl:for-each>


			<xsl:for-each select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteType']/sml:Term">
     		<dc:type><xsl:value-of select="sml:value"/></dc:type>
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
