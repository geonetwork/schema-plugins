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

				xmlns:gml="http://www.opengis.net/gml"

                exclude-result-prefixes="geonet dc dct ows srv">


	<xsl:param name="displayInfo"/>


    <xsl:variable name="isSrv" select="boolean(//srv:*)"/>

	<!-- ================================================================= -->

	<!-- Metadata root elem: set sane namespaces -->

	<xsl:template match="gmd:MD_Metadata">
		<xsl:element name="gmd:MD_Metadata">
			<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
			<xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
			<xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
            <xsl:if test="$isSrv">
                <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
            </xsl:if>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			<xsl:copy-of select="@*[name()!='xsi:schemaLocation' and name()!='gco:isoType']"/>

            <xsl:choose>
                <xsl:when test="$isSrv">
                    <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

			<xsl:apply-templates select="*"/>
            
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

	<!-- Fix the GML namespace URI -->

    <xsl:template match="@*[namespace-uri()='http://www.opengis.net/gml']">
        <xsl:attribute name="gml:{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="*[namespace-uri()='http://www.opengis.net/gml']">
        <xsl:element name="gml:{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

	<!-- ================================================================= -->

	<!-- Replace metadata standard name/version -->

<!--	<xsl:template match="gmd:metadataStandardName">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="gmd:metadataStandardVersion">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>1.0</gco:CharacterString>
		</xsl:copy>
	</xsl:template>-->

	<!-- ================================================================= -->

	<xsl:template match="*[@gco:isoType]" priority="100">
		<xsl:variable name="elemName" select="@gco:isoType"/>

		<xsl:element name="{$elemName}">
			<xsl:apply-templates select="@*[name()!='gco:isoType']"/>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<!-- Remove empty keywords
         1) remove parent <gmd:descriptiveKeywords> if all <gmd:MD_Keywords> are empty
         2) remove <gmd:keyword> if empty
    -->
	<!--
        <gmd:identificationInfo>
            <srv:SV_ServiceIdentification | gmd:MD_DataIdentification >
                <gmd:descriptiveKeywords>   0..n, insieme di keywords da un determinato thesaurus
                    <gmd:MD_Keywords>       1..1
                        <gmd:keyword>
                            <gco:CharacterString/>
                        </gmd:keyword>
                    </gmd:MD_Keywords>
                </gmd:descriptiveKeywords>
    -->

	<!-- Remove empty keywords 1) remove parent <gmd:descriptiveKeywords> if all <gmd:MD_Keywords> are empty -->

	<xsl:template match="gmd:identificationInfo/*/gmd:descriptiveKeywords">
		<xsl:variable name="concatkw">
			<xsl:call-template name="extract_keywords_text"/>
		</xsl:variable>

		<!--<xsl:comment>lista keyword: [<xsl:copy-of select="$concatkw" />]</xsl:comment>-->

		<xsl:choose>
			<xsl:when test="not(string($concatkw))">
				<xsl:comment>emtpy descriptiveKeywords vuota</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Remove empty keywords 2) remove <gmd:keyword> if empty -->

	<xsl:template match="gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword">
		<xsl:choose>
			<xsl:when test="not(string(gco:CharacterString))">
				<xsl:comment>empty Keyword</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="extract_keywords_text">
		<xsl:for-each select="gmd:MD_Keywords/gmd:keyword"><xsl:copy-of select="gco:CharacterString" /></xsl:for-each>
	</xsl:template>

	<!-- ================================================================= -->

</xsl:stylesheet>
