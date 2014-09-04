<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmx="http://www.isotc211.org/2005/gmx"
										xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<xsl:param name="displayInfo"/>

	<!-- ============================================================================= -->

	<xsl:template match="mcp:MD_Metadata">
		<xsl:variable name="info" select="geonet:info"/>
		<csw:SummaryRecord>

			<xsl:for-each select="gmd:fileIdentifier">
				<dc:identifier><xsl:value-of select="gco:CharacterString"/></dc:identifier>
			</xsl:for-each>

			<!-- DataIdentification -->

			<xsl:for-each select="gmd:identificationInfo/mcp:MD_DataIdentification">

				<xsl:for-each select="gmd:citation/*/gmd:title/gco:CharacterString">
					<dc:title><xsl:value-of select="."/></dc:title>
				</xsl:for-each>
	
				<xsl:for-each select="gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
					<dc:subject><xsl:value-of select="."/></dc:subject>
				</xsl:for-each>

				<xsl:for-each select="gmd:abstract/gco:CharacterString">
					<dct:abstract><xsl:value-of select="."/></dct:abstract>
				</xsl:for-each>

				<xsl:for-each select="gmd:citation/*/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='revision']/gmd:date/gco:Date">
					<dct:modified><xsl:value-of select="."/></dct:modified>
				</xsl:for-each>

			</xsl:for-each>

			<!-- Type -->

			<xsl:for-each select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue">
				<dc:type><xsl:value-of select="."/></dc:type>
			</xsl:for-each>

			<!-- Distribution -->

			<xsl:comment>Distribution info</xsl:comment>
			<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
				<xsl:for-each select="gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString">
					<dc:format><xsl:value-of select="."/></dc:format>
				</xsl:for-each>

				<xsl:for-each select="gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
					<xsl:comment>Resource mimetype in dc:type and URL in dc:relation</xsl:comment>
					<dc:type><xsl:value-of select="gmd:name/gmx:MimeFileType/@type"/></dc:type>
					<dc:relation><xsl:value-of select="gmd:linkage/gmd:URL"/></dc:relation>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:comment>End Distribution info</xsl:comment>

			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</csw:SummaryRecord>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
