<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="geonet gml">

	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<!-- ================================================================= -->

	<!-- skip the root element -->
	<xsl:template match="/root">
		<xsl:apply-templates select="gmd:MD_Metadata"/>
	</xsl:template>

	<!-- ================================================================= -->

	<!-- sanitize namespaces -->

	<xsl:template match="gmd:MD_Metadata" priority="400">
		<xsl:element name="gmd:MD_Metadata">
			<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
			<xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
			<xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
			<xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			<xsl:copy-of select="@*[name()!='xsi:schemaLocation' and name()!='gco:isoType']"/>
			<xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:attribute>
			<xsl:apply-templates select="gmd:fileIdentifier"/>
			<xsl:apply-templates select="gmd:language"/>
			<xsl:apply-templates select="gmd:characterSet"/>
			<gmd:parentIdentifier>
				<gco:CharacterString>
					<xsl:choose>
						<xsl:when test="//gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString != '' ">
							<xsl:value-of select="//gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./gmd:fileIdentifier/gco:CharacterString"/>
						</xsl:otherwise>
					</xsl:choose>					
				</gco:CharacterString>
			</gmd:parentIdentifier>
			<xsl:apply-templates select="child::* except (gmd:fileIdentifier|gmd:language|gmd:characterSet|gmd:parentIdentifier)"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- Convert gml URI -->

	<xsl:template match="gml:*">
		<xsl:element name="{concat('gml:', local-name(.))}" namespace="http://www.opengis.net/gml/3.2">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:element>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- Fix gmd:parentIdentifier -->
<!-- 	<xsl:template match="gmd:parentIdentifier">
		<xsl:copy>
			<gmd:parentIdentifier>
				<gco:CharacterString>
					<xsl:value-of select="../gmd:fileIdentifier"/>
				</gco:CharacterString>
			</gmd:parentIdentifier>
		</xsl:copy>
	</xsl:template> -->
	<!-- =================================================================== -->

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<!-- Remove geonet's own stuff -->
	<xsl:template match="geonet:info" priority="100"/>

	<!-- ================================================================= -->

</xsl:stylesheet>
