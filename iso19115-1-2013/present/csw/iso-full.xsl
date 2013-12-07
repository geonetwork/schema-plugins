<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
										xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
										xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
										xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
										xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
										xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
                    xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork">

	<xsl:param name="displayInfo"/>
	
	<!-- ============================================================================= -->

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
