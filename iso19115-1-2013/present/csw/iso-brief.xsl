<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
										xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
										xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
										xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
										xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
										xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork">
	
	<xsl:param name="displayInfo"/>
	
	<!-- =================================================================== -->

	<xsl:template match="mds:MD_Metadata|*[contains(@gco:isoType,'MD_Metadata')]">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy>
			<xsl:apply-templates select="mds:metadataIdentifier"/>
			<xsl:apply-templates select="mds:metadataScope"/>
			<xsl:apply-templates select="mds:identificationInfo"/>
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
			
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="mri:MD_DataIdentification|
		*[contains(@gco:isoType, 'MD_DataIdentification')]|
		srv:SV_ServiceIdentification|
		*[contains(@gco:isoType, 'SV_ServiceIdentification')]
		">
		<xsl:copy>
			<xsl:apply-templates select="mri:citation"/>
			<xsl:apply-templates select="mri:graphicOverview"/>
			<xsl:apply-templates select="mri:extent[child::gex:EX_Extent[child::gex:geographicElement]]|
				srv:extent[child::gex:EX_Extent[child::gex:geographicElement]]"/>
			<xsl:apply-templates select="srv:serviceType"/>
			<xsl:apply-templates select="srv:serviceTypeVersion"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="mcc:MD_BrowseGraphic">
		<xsl:copy>
			<xsl:apply-templates select="mcc:fileName"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gex:EX_Extent">
        <xsl:copy>
        	<xsl:apply-templates select="gex:geographicElement[child::gex:EX_GeographicBoundingBox]"/>
        </xsl:copy>
	</xsl:template>
	
	<xsl:template match="gex:EX_GeographicBoundingBox">
        <xsl:copy>
          <xsl:apply-templates select="gex:westBoundLongitude"/>
        	<xsl:apply-templates select="gex:southBoundLatitude"/>
        	<xsl:apply-templates select="gex:eastBoundLongitude"/>
        	<xsl:apply-templates select="gex:northBoundLatitude"/>
        </xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="cit:CI_Citation">
        <xsl:copy>
        	<xsl:apply-templates select="cit:title"/>
        </xsl:copy>
    </xsl:template>
	
	<!-- === copy template ================================================= -->

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

</xsl:stylesheet>
