<?xml version="1.0" encoding="UTF-8"?>
<!-- FIXME: Use latest mcc:linkage to hold reference to browse graphic -->
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
						xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
						xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
						xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		<xsl:apply-templates select="mds:MD_Metadata|*[contains(@gco:isoType, 'MD_Metadata')]"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="mds:MD_Metadata|*[contains(@gco:isoType, 'MD_Metadata')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mds:metadataIdentifier"/>
			<xsl:apply-templates select="mds:defaultLocale"/>
			<xsl:apply-templates select="mds:parentMetadata"/>
			<xsl:apply-templates select="mds:metadataScope"/>
			<xsl:apply-templates select="mds:contact"/>
			<xsl:apply-templates select="mds:dateStamp"/>
			<xsl:apply-templates select="mds:dateInfo"/>
			<xsl:apply-templates select="mds:metadataStandard"/>
			<xsl:apply-templates select="mds:metadataProfile"/>
			<xsl:apply-templates select="mds:alternativeMetadataReference"/>
			<xsl:apply-templates select="mds:otherLocale"/>
			<xsl:apply-templates select="mds:metadataLinkage"/>
			<xsl:apply-templates select="mds:spatialRepresentationInfo"/>
			<xsl:apply-templates select="mds:referenceSystemInfo"/>
			<xsl:apply-templates select="mds:metadataExtensionInfo"/>

			<xsl:choose>
				<xsl:when test="not(mds:identificationInfo)">
		 			<mds:identificationInfo>
						<mri:MD_DataIdentification>
							<xsl:call-template name="fill"/>
						</mri:MD_DataIdentification>
					</mds:identificationInfo>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="mds:identificationInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="mds:contentInfo"/>
			<xsl:apply-templates select="mds:distributionInfo"/>
			<xsl:apply-templates select="mds:dataQualityInfo"/>
			<xsl:apply-templates select="mds:resourceLineage"/>
			<xsl:apply-templates select="mds:portrayalCatalogueInfo"/>
			<xsl:apply-templates select="mds:metadataConstraints"/>
			<xsl:apply-templates select="mds:applicationSchemaInfo"/>
			<xsl:apply-templates select="mds:metadataMaintenance"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="mri:MD_DataIdentification|*[contains(@gco:isoType, 'MD_DataIdentification')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mri:citation"/>
			<xsl:apply-templates select="mri:abstract"/>
			<xsl:apply-templates select="mri:purpose"/>
			<xsl:apply-templates select="mri:credit"/>
			<xsl:apply-templates select="mri:status"/>
			<xsl:apply-templates select="mri:pointOfContact"/>
			<xsl:apply-templates select="mri:spatialRepresentationType"/>
			<xsl:apply-templates select="mri:spatialResolution"/>
			<xsl:apply-templates select="mri:temporalResolution"/>
			<xsl:apply-templates select="mri:topicCategory"/>
			<xsl:apply-templates select="mri:extent"/>
			<xsl:apply-templates select="mri:additionalDocumentation"/>
			<xsl:apply-templates select="mri:processingLevel"/>
			<xsl:apply-templates select="mri:resourceMaintenance"/>
			<xsl:apply-templates select="mri:graphicOverview[not(mcc:MD_BrowseGraphic/mcc:fileDescription) or mcc:MD_BrowseGraphic/mcc:fileDescription/gco:CharacterString != /root/env/type]"/>
		 	
			<xsl:call-template name="fill"/>
		
			<xsl:apply-templates select="mri:resourceFormat"/>
			<xsl:apply-templates select="mri:descriptiveKeywords"/>
			<xsl:apply-templates select="mri:resourceSpecificUsage"/>
			<xsl:apply-templates select="mri:resourceConstraints"/>
			<xsl:apply-templates select="mri:associatedResource"/>
			<xsl:apply-templates select="mri:defaultLocale"/>
			<xsl:apply-templates select="mri:otherLocale"/>
			<xsl:apply-templates select="mri:environmentDescription"/>
			<xsl:apply-templates select="mri:supplementalInformation"/>
			
			<xsl:copy-of select="*[namespace-uri()!='http://www.isotc211.org/2005/mds/1.0/2013-03-28']"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="srv:SV_ServiceIdentification|*[contains(@gco:isoType, 'SV_ServiceIdentification')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mri:citation"/>
			<xsl:apply-templates select="mri:abstract"/>
			<xsl:apply-templates select="mri:purpose"/>
			<xsl:apply-templates select="mri:credit"/>
			<xsl:apply-templates select="mri:status"/>
			<xsl:apply-templates select="mri:pointOfContact"/>
			<xsl:apply-templates select="mri:spatialRepresentationType"/>
			<xsl:apply-templates select="mri:spatialResolution"/>
			<xsl:apply-templates select="mri:temporalResolution"/>
			<xsl:apply-templates select="mri:topicCategory"/>
			<xsl:apply-templates select="mri:extent"/>
			<xsl:apply-templates select="mri:additionalDocumentation"/>
			<xsl:apply-templates select="mri:processingLevel"/>
			<xsl:apply-templates select="mri:resourceMaintenance"/>
			<xsl:apply-templates select="mri:graphicOverview[not(mcc:MD_BrowseGraphic/mcc:fileDescription) or mcc:MD_BrowseGraphic/mcc:fileDescription/gco:CharacterString != /root/env/type]"/>
		 	
			<xsl:call-template name="fill"/>
		
			<xsl:apply-templates select="mri:resourceFormat"/>
			<xsl:apply-templates select="mri:descriptiveKeywords"/>
			<xsl:apply-templates select="mri:resourceSpecificUsage"/>
			<xsl:apply-templates select="mri:resourceConstraints"/>
			<xsl:apply-templates select="mri:associatedResource"/>
			
			<xsl:apply-templates select="srv:*"/>
			
			<xsl:copy-of select="*[namespace-uri()!='http://www.isotc211.org/2005/mds/1.0/2013-03-28']' and namespace-uri()!='http://www.isotc211.org/2005/srv/2.0/2013-03-28']"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- ================================================================= -->
	
	<xsl:template name="fill">
		<mri:graphicOverview>
			<mcc:MD_BrowseGraphic>
				<mcc:fileName>
					<xsl:variable name="metadataId"   select="/root/*/gmd:fileIdentifier/gco:CharacterString/text()" />
					<xsl:variable name="serverHost"   select="/root/env/host" />
					<xsl:variable name="serverPort"   select="/root/env/port" />
					<xsl:variable name="baseUrl"   select="/root/env/baseUrl" />
					<xsl:variable name="serverPrefix" select="concat('http://',$serverHost,':',$serverPort, $baseUrl, '/srv/eng/resources.get?')"/>
					<gco:CharacterString>
						<xsl:value-of select="$serverPrefix"/><xsl:text>uuid=</xsl:text><xsl:value-of select="$metadataId" /><xsl:text>&amp;fname=</xsl:text><xsl:value-of select="/root/env/file"/>
					</gco:CharacterString>
				</mcc:fileName>

				<mcc:fileDescription>
					<gco:CharacterString><xsl:value-of select="/root/env/type"/></gco:CharacterString>
				</mcc:fileDescription>
				<mcc:fileType>
					<gco:CharacterString><xsl:value-of select="/root/env/ext"/></gco:CharacterString>
				</mcc:fileType>
			</mcc:MD_BrowseGraphic>
		</mri:graphicOverview>
	</xsl:template>
	
	<!-- ================================================================= -->

	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
</xsl:stylesheet>
