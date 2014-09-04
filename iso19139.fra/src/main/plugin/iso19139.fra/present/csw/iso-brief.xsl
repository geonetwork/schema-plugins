<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:srv="http://www.isotc211.org/2005/srv"
                    xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork"
                    exclude-result-prefixes="#all">
	
	<xsl:param name="displayInfo"/>
  <xsl:variable name="schemaLocation">http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:variable>

  <!-- root element  -->
  <xsl:template match="gmd:MD_Metadata" priority="1000">
    <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <xsl:attribute name="xsi:schemaLocation">
        <xsl:value-of select="$schemaLocation"/>
      </xsl:attribute>

      <xsl:apply-templates select="*"/>
    </gmd:MD_Metadata>
  </xsl:template>


	<xsl:template match="*[@gco:isoType]" priority="100">
		<xsl:element name="{@gco:isoType}">
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>

  <xsl:template match="fra:*[not(@gco:isoType)]" priority="150"/>

	<xsl:template match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy>
			<xsl:apply-templates select="gmd:fileIdentifier"/>
			<xsl:apply-templates select="gmd:hierarchyLevel"/>
			<xsl:apply-templates select="gmd:identificationInfo"/>
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
			
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="gmd:MD_DataIdentification|
		*[@gco:isoType='gmd:MD_DataIdentification']|
		srv:SV_ServiceIdentification|
		*[@gco:isoType='srv:SV_ServiceIdentification']
		">
		<xsl:copy>
			<xsl:apply-templates select="gmd:citation"/>
			<xsl:apply-templates select="gmd:graphicOverview"/>
			<xsl:apply-templates select="gmd:extent[child::gmd:EX_Extent[child::gmd:geographicElement]]|
				srv:extent[child::gmd:EX_Extent[child::gmd:geographicElement]]"/>
			<xsl:apply-templates select="srv:serviceType"/>
			<xsl:apply-templates select="srv:serviceTypeVersion"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="gmd:MD_BrowseGraphic">
		<xsl:copy>
			<xsl:apply-templates select="gmd:fileName"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gmd:EX_Extent">
        <xsl:copy>
        	<xsl:apply-templates select="gmd:geographicElement[child::gmd:EX_GeographicBoundingBox]"/>
        </xsl:copy>
	</xsl:template>
	
	<xsl:template match="gmd:EX_GeographicBoundingBox">
        <xsl:copy>
            <xsl:apply-templates select="gmd:westBoundLongitude"/>
        	<xsl:apply-templates select="gmd:southBoundLatitude"/>
        	<xsl:apply-templates select="gmd:eastBoundLongitude"/>
        	<xsl:apply-templates select="gmd:northBoundLatitude"/>
        </xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gmd:CI_Citation">
        <xsl:copy>
        	<xsl:apply-templates select="gmd:title"/>
        </xsl:copy>
    </xsl:template>

  <!-- Element to skip -->
  <xsl:template match="geonet:info" priority="50"/>

  <!-- Copy all -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>



