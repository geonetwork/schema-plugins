<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
										xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
										xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
										xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
										xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
										xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
                    xmlns:mco="http://www.isotc211.org/2005/mco/1.0/2013-03-28"
                    xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2013-03-28"
                    xmlns:mrs="http://www.isotc211.org/2005/mrs/1.0/2013-03-28"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork"
	exclude-result-prefixes="mds mri cit mcc gex srv mco mcc mrd mrs gco">

	<xsl:param name="displayInfo"/>
	<xsl:param name="lang"/>
	
	<xsl:include href="../metadata-utils.xsl"/>
	
	<!-- ============================================================================= -->

	<xsl:template match="mds:MD_Metadata|*[contains(@gco:isoType,'gmd:MD_Metadata')]">
		
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:variable name="langId">
			<xsl:call-template name="getLangId19115-1-2013">
				<xsl:with-param name="langGui" select="$lang"/>
				<xsl:with-param name="md" select="."/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="identification" select="mds:identificationInfo/mri:MD_DataIdentification|
			mds:identificationInfo/*[contains(@gco:isoType, 'MD_DataIdentification')]|
			mds:identificationInfo/srv:SV_ServiceIdentification"/>
		
		
		<csw:BriefRecord>

			<xsl:for-each select="mds:metadataIdentifier[mcc:MD_Identifier/mcc:codeSpace='urn:uuid']">
				<dc:identifier><xsl:value-of select="mcc:MD_Identifier/mcc:code/gco:CharacterString"/></dc:identifier>
			</xsl:for-each>
			
			<!-- DataIdentification -->
			<xsl:for-each select="$identification/mri:citation/cit:CI_Citation">    
				<xsl:for-each select="cit:title">
					<dc:title>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:title>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each select="mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue">
				<dc:type><xsl:value-of select="."/></dc:type>
			</xsl:for-each>
			
			<!-- bounding box -->
			<xsl:for-each select="$identification/mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox|
				$identification/srv:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox">
				<xsl:variable name="rsi"  select="/mds:MD_Metadata/mds:referenceSystemInfo/mrs:MD_ReferenceSystem/
					mrs:referenceSystemIdentifier/mcc:MD_Identifier|/mds:MD_Metadata/mds:referenceSystemInfo/
					*[contains(@gco:isoType, 'MD_ReferenceSystem')]/mrs:referenceSystemIdentifier/mcc:MD_Identifier"/>
				<xsl:variable name="auth" select="$rsi/mcc:codeSpace/gco:CharacterString"/>
				<xsl:variable name="id"   select="$rsi/mcc:code/gco:CharacterString"/>
				
				<ows:BoundingBox crs="{$auth}::{$id}">
					<ows:LowerCorner>
						<xsl:value-of select="concat(gex:eastBoundLongitude/gco:Decimal, ' ', gex:southBoundLatitude/gco:Decimal)"/>
					</ows:LowerCorner>
					
					<ows:UpperCorner>
						<xsl:value-of select="concat(gex:westBoundLongitude/gco:Decimal, ' ', gex:northBoundLatitude/gco:Decimal)"/>
					</ows:UpperCorner>
				</ows:BoundingBox>
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
