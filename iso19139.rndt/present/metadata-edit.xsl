<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="#all">

	<xsl:include href="metadata-view.xsl"/>
	<xsl:include href="metadata-rndt.xsl"/>

  <xsl:template name="iso19139.rndtCompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>

    <!-- RNDT tab -->
    <xsl:call-template name="mainTab">
      <xsl:with-param name="title" select="/root/gui/schemas/iso19139.rndt/strings/rndtTab"/>
      <xsl:with-param name="default">rndt</xsl:with-param>
      <xsl:with-param name="menu">
        <item label="rndtTab">rndt</item>
      </xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>

  </xsl:template>  
		
	
	<xsl:template name="view-with-header-iso19139.rndt">
		<xsl:param name="tabs"/>
		<xsl:call-template name="md-content">
			<xsl:with-param name="title">
				<xsl:apply-templates mode="localised"
          select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title">
					<xsl:with-param name="langId" select="$langId"/>
				</xsl:apply-templates>
			</xsl:with-param>
			<xsl:with-param name="exportButton"/>
			<xsl:with-param name="abstract">
				<xsl:call-template name="addLineBreaksAndHyperlinks">
					<xsl:with-param name="txt">
						<xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:abstract">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="logo">
				<img src="../../images/logos/{//geonet:info/source}.gif" alt="logo" class="logo"/>
			</xsl:with-param>
			<xsl:with-param name="relatedResources">
				<xsl:apply-templates mode="relatedResources"
          select="gmd:distributionInfo"
        />
			</xsl:with-param>
			<xsl:with-param name="tabs" select="$tabs"/>
		</xsl:call-template>
	</xsl:template>

	<!-- View templates are available only in view mode and does not provide editing
		 capabilities. Template MUST start with "view". -->
	<!-- ===================================================================== -->
	<!-- iso19139-simple -->
	<xsl:template name="metadata-iso19139.rndtview-simple" match="metadata-iso19139.rndtview-simple">
		<xsl:call-template name="view-with-header-iso19139">
			<xsl:with-param name="tabs">
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title"
            select="/root/gui/schemas/iso19139/strings/understandResource"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block"
              select="
                gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date[1]
                |gmd:identificationInfo/*/gmd:extent/*/gmd:temporalElement
                "/>
						<xsl:apply-templates mode="block"
                  select="
                  gmd:identificationInfo/*/gmd:language
                  |gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:edition
                  |gmd:topicCategory
                  |gmd:identificationInfo/*/gmd:descriptiveKeywords
                  |gmd:identificationInfo/*/gmd:graphicOverview[1]
                  |gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:geographicElement
                  "/>
						<xsl:apply-templates mode="block"
              select="gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/contactInfo"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block"
              select="gmd:identificationInfo/*/gmd:pointOfContact"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/mdContactInfo"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block"
              select="gmd:contact"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/techInfo"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block"
              select="
              gmd:identificationInfo/*/gmd:spatialResolution[1]
              |gmd:identificationInfo/*/gmd:spatialRepresentationType
              |gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage
              |gmd:identificationInfo/*/gmd:resourceConstraints[1]
              "
            />
					</xsl:with-param>
				</xsl:call-template>
				<span class="madeBy">
					<xsl:value-of select="/root/gui/strings/changeDate"/>
					<xsl:value-of select="substring-before(gmd:dateStamp, 'T')"/> | 
					<xsl:value-of select="/root/gui/strings/uuid"/>
					<xsl:value-of select="gmd:fileIdentifier"/>
				</span>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
