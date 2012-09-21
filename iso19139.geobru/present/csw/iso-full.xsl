<?xml version="1.0" encoding="UTF-8"?>
<!-- heikki added geobru namespace declaration and exclude-result-prefix for geobru -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:geobru="http://geobru.irisnet.be"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork"
										exclude-result-prefixes="geobru">

	<xsl:param name="displayInfo"/>
	
	<!-- ============================================================================= -->
<!--
	<xsl:template match="gmd:MD_Metadata">
		<csw:IsoRecord>
			<xsl:apply-templates select="*"/>
		</csw:IsoRecord>
	</xsl:template>
-->
	<!-- ============================================================================= -->
	
	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:BXL_Address">
		<gmd:CI_Address>
				<xsl:apply-templates select="@*|node()"/>
		</gmd:CI_Address>
	</xsl:template>

	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:BXL_Lineage">
		<gmd:LI_Lineage>
				<xsl:apply-templates select="@*|node()"/>
		</gmd:LI_Lineage>
	</xsl:template>	
	
	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:BXL_Distribution">
		<gmd:MD_Distribution>
				<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_Distribution>
	</xsl:template>		
	
	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:*">
	</xsl:template>	
	

	

	<xsl:template match="@*|node()[name(.)!='geonet:info']">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()[name(.)!='geonet:info']"/>
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
