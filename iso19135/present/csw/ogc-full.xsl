<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
	xmlns:dc ="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:grg="http://www.isotc211.org/2005/grg"
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
		
		<csw:Record>
			
			<dc:identifier><xsl:value-of select="@uuid"/></dc:identifier>

			<dc:title>
				<xsl:apply-templates mode="localised" select="grg:name/*">
					<xsl:with-param name="langId" select="$langId"/>
				</xsl:apply-templates>
			</dc:title>
				
			<!-- Type -->
			<dc:type>register</dc:type>
		
			<!-- Put valid register items out as dc:subject keywords -->
			<xsl:for-each select="grg:containedItem[grg:RE_RegisterItem/grg:status/grg:RE_ItemStatus='valid']">
				<dc:subject>
					<xsl:apply-templates mode="localised" select="grg:RE_RegisterItem/grg:name/*">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>
				</dc:subject>
			</xsl:for-each>
				
			<!-- either versionDate or dateOfLastChange -->
			<xsl:for-each select="grg:version/grg:RE_Version/grg:versionDate/gco:Date|grg:dateOfLastChange/gco:Date">
				<dct:modified><xsl:value-of select="."/></dct:modified>
			</xsl:for-each>
				
			<!-- contentSummary is the abstract -->
			<xsl:for-each select="grg:contentSummary/gco:CharacterString">
				<dct:abstract>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>
				</dct:abstract>
				<dc:description>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>				
				</dc:description>
			</xsl:for-each>
				
			<!-- any owners are shown as dc:creator -->
			<xsl:for-each select="grg:owner/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName">
				<dc:creator>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>
				</dc:creator>
			</xsl:for-each>

			<!-- any managers are shown as dc:publisher -->
			<xsl:for-each select="grg:manager/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName">
				<dc:publisher>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>
				</dc:publisher>
			</xsl:for-each>

			<!-- any submitters are shown as dc:contributor -->
			<xsl:for-each select="grg:submitter/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName">
				<dc:contributor>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>					
				</dc:contributor>
			</xsl:for-each>

			<!-- language -->
			<xsl:for-each select="*/grg:RE_Locale/grg:language/gco:CharacterString">
				<dc:language><xsl:value-of select="."/></dc:language>
			</xsl:for-each>
		
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
			
		</csw:Record>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
