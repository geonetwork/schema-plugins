<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:grg="http://www.isotc211.org/2005/grg"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:srv="http://www.isotc211.org/2005/srv"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork">

	<xsl:param name="displayInfo"/>
	
	<!-- =================================================================== -->

	<xsl:template match="grg:RE_Register">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy>
			<xsl:apply-templates select="@uuid"/>
			<xsl:apply-templates select="grg:name"/>
			<xsl:apply-templates select="grg:contentSummary"/>
			<xsl:apply-templates select="grg:uniformResourceIdentifier"/>
			<xsl:apply-templates select="grg:operatingLanguage"/>
			<xsl:apply-templates select="grg:version"/>
			<xsl:apply-templates select="grg:dateOfLastChange"/>
			<xsl:apply-templates select="grg:containedItem"/>
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
			
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === copy template === -->
	<!-- =================================================================== -->

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

</xsl:stylesheet>



