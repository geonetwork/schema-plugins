<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gco="http://www.isotc211.org/2005/gco" 
	xmlns:gmi="http://sdi.eurac.edu/metadata/iso19139-2/schema/gmi"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" exclude-result-prefixes="gmd">

	<!-- ================================================================= -->

	<xsl:template match="/root">
		<xsl:apply-templates select="gmi:MI_Metadata" />
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmi:MI_Metadata">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<gmd:fileIdentifier>
				<gco:CharacterString>
					<xsl:value-of select="/root/env/uuid" />
				</gco:CharacterString>
			</gmd:fileIdentifier>
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmd:fileIdentifier" />

	<!-- ================================================================= -->

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

</xsl:stylesheet>
