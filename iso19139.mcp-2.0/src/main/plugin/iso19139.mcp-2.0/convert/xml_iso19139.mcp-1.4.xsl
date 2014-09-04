<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
						xmlns:gml="http://www.opengis.net/gml"
						xmlns:srv="http://www.isotc211.org/2005/srv"
						xmlns:gmx="http://www.isotc211.org/2005/gmx"
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
						xmlns:xlink="http://www.w3.org/1999/xlink"
						xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
						xmlns:gmd="http://www.isotc211.org/2005/gmd">


	<xsl:variable name="metadataStandardName" select="'Australian Marine Community Profile of ISO 19115:2005/19139'"/>
	<xsl:variable name="metadataStandardVersion" select="'1.4'"/>

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="mcp:MD_Metadata"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="mcp:MD_Metadata">
		 <xsl:copy>
		 	<xsl:copy-of select="@*[name()!='xsi:schemaLocation']"/>
			<xsl:if test="not(@gco:isoType)">
				<xsl:attribute name="gco:isoType">gmd:MD_Metadata</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="xsi:schemaLocation">http://bluenet3.antcrc.utas.edu.au/mcp http://bluenet3.antcrc.utas.edu.au/mcp-1.4/schema.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:attribute>
			<xsl:comment>
Sort of convert 2.0 to 1.4 by:
- replacing standard name and standard version
- excluding dwc:Taxon 

TODO:
- convert mcp:DP_DataParameter to 1.4 version of mcp:DP_DataParameter
- codelists? how to map 2.0 codelists to 1.4?
			</xsl:comment>
			<xsl:apply-templates select="gmd:fileIdentifier"/>
      <xsl:apply-templates select="gmd:language"/>
      <xsl:apply-templates select="gmd:characterSet"/>
      <xsl:apply-templates select="gmd:parentIdentifier"/>
      <xsl:apply-templates select="gmd:hierarchyLevel"/>
      <xsl:apply-templates select="gmd:hierarchyLevelName"/>
      <xsl:apply-templates select="gmd:contact"/>
      <xsl:apply-templates select="gmd:dateStamp"/>
      <gmd:metadataStandardName>
        <gco:CharacterString><xsl:value-of select="$metadataStandardName"/></gco:CharacterString>
      </gmd:metadataStandardName>
      <gmd:metadataStandardVersion>
        <gco:CharacterString><xsl:value-of select="$metadataStandardVersion"/></gco:CharacterString>
      </gmd:metadataStandardVersion>
      <xsl:apply-templates select="gmd:dataSetURI"/>
      <xsl:apply-templates select="gmd:locale"/>
      <xsl:apply-templates select="gmd:spatialRepresentationInfo"/>
      <xsl:apply-templates select="gmd:referenceSystemInfo"/>
      <xsl:apply-templates select="gmd:metadataExtensionInfo"/>
      <xsl:apply-templates select="gmd:identificationInfo"/>
			<xsl:apply-templates select="gmd:contentInfo"/>
			<xsl:apply-templates select="gmd:distributionInfo"/>
			<xsl:apply-templates select="gmd:dataQualityInfo"/>
      <xsl:apply-templates select="gmd:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="gmd:metadataConstraints"/>
      <xsl:apply-templates select="gmd:applicationSchemaInfo"/>
      <xsl:apply-templates select="gmd:metadataMaintenance"/>
      <xsl:apply-templates select="gmd:series"/>
      <xsl:apply-templates select="gmd:describes"/>
      <xsl:apply-templates select="gmd:propertyType"/>
      <xsl:apply-templates select="gmd:featureType"/>
      <xsl:apply-templates select="gmd:featureAttribute"/>
			<xsl:apply-templates select="mcp:revisionDate"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- just exclude these as they are either overwritten or have no mapping
	     in 1.4 -->

  <xsl:template match="gmd:metadataStandardName"/>
  <xsl:template match="gmd:metadataStandardVersion"/>

	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

</xsl:stylesheet>
