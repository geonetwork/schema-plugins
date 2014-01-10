<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:ows="http://www.opengis.net/ows"

                xmlns:dc ="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"

                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"

                xmlns:geonet="http://www.fao.org/geonetwork"

                exclude-result-prefixes="geonet dc dct  ows">


	<xsl:param name="displayInfo"/>

	<!-- ================================================================= -->

	<!-- Metadata root elem: set sane namespaces -->

	<xsl:template match="gmd:MD_Metadata">
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
			<xsl:apply-templates select="child::* except (gmd:fileIdentifier|gmd:language|gmd:characterSet)"/>
			<!-- <xsl:apply-templates select="//*[not(self::gmd:fileIdentifier)|not(self::gmd:language)|not(self::gmd:characterSet)]"/> -->
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<!-- Generic node -->

	<xsl:template match="@*|node()">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>

			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</xsl:copy>
	</xsl:template>

	<!-- Remove comments -->

	<xsl:template match="comment()" priority="100"/>

	<!-- Remove geonet's own stuff -->

	<xsl:template match="geonet:info" priority="100"/>

	<!-- Fix the namespace URI -->

	<xsl:template match="*[namespace-uri()='http://www.opengis.net/gml/3.2']" priority="100">
		<xsl:element name="{local-name(.)}" namespace="http://www.opengis.net/gml">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@*[namespace-uri()='http://www.opengis.net/gml/3.2']" priority="100">
		<xsl:attribute name="{local-name(.)}">
			<xsl:copy/>
		</xsl:attribute>
	</xsl:template>


	<!-- ================================================================= -->

	<!-- Replace RNDT metadata standard name/version -->

	<xsl:template match="gmd:metadataStandardName">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="gmd:metadataStandardVersion">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>1.0</gco:CharacterString>
		</xsl:copy>
	</xsl:template>
	<!-- =================================================================== -->


	<!-- ================================================================= -->

	<xsl:template match="*[@gco:isoType]" priority="100">
		<xsl:variable name="elemName" select="@gco:isoType"/>

		<xsl:element name="{$elemName}">
			<xsl:apply-templates select="@*[name()!='gco:isoType']"/>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
