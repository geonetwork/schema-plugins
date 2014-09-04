<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:grg="http://www.isotc211.org/2005/grg"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork"
										exclude-result-prefixes="grg gmd gco">

	<xsl:param name="displayInfo"/>
	<xsl:param name="lang"/>
	
	<xsl:include href="../metadata-utils.xsl"/>
	
	<!-- ============================================================================= -->

	<xsl:template match="grg:RE_Register">
		
		<xsl:variable name="info" select="geonet:info"/>

		<xsl:variable name="langId">
			<xsl:call-template name="getLangId">
				<xsl:with-param name="langGui" select="$lang"/>
				<xsl:with-param name="md" select="."/>
			</xsl:call-template>
		</xsl:variable>
		
		<csw:BriefRecord>

			<dc:identifier><xsl:value-of select="@uuid"/></dc:identifier>
			
			<dc:title>
				<xsl:apply-templates mode="localised" select="grg:name/*">
					<xsl:with-param name="langId" select="$langId"/>
				</xsl:apply-templates>
			</dc:title>

			<dc:type>register</dc:type>

			<!-- URI of register goes out as dc:URI -->
			<xsl:for-each select="grg:uniformResourceIdentifier/gmd:CI_OnlineResource">
				<dc:URI>
					<xsl:if test="gmd:protocol/*">
						<xsl:attribute name="protocol">
							<xsl:value-of select="gmd:protocol/*"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="gmd:linkage/*"/>
				</dc:URI>
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
