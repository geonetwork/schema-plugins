<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
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

	<!--<xsl:template match="gml:*">
		<xsl:element name="{concat('gml:', local-name(.))}" namespace="http://www.opengis.net/gml/3.2">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:element>
	</xsl:template>-->
	
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

	<!-- ================================================================= -->
	
	<!-- Remove geonet's own stuff -->
	<xsl:template match="geonet:info" priority="100"/>

	<!-- ================================================================= -->
	<!-- Manage the gmd:pass -->
	
    <!--<xsl:template match="gmd:DQ_ConformanceResult">
		<xsl:choose>
			<xsl:when test="not(exists(gmd:pass))">
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
					<xsl:element name="gmd:pass">
						<xsl:text></xsl:text>
						<xsl:attribute name="nilReason">unknown</xsl:attribute>
					</xsl:element>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="pass">
					<xsl:value-of select="gmd:pass"/>
				</xsl:variable>
				<xsl:if test="$pass = ''">
					<xsl:copy>
						<xsl:apply-templates select="@*|gmd:specification"/>
						<xsl:apply-templates select="@*|gmd:explanation"/>
						<xsl:element name="gmd:pass">
							<xsl:text></xsl:text>
							<xsl:attribute name="nilReason">unknown</xsl:attribute>
						</xsl:element>
					</xsl:copy>				    	
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	
	<!-- Use 'nilReason' to unknown for the pass element in un-compiled conformance 	
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass">
		<xsl:choose>
			<xsl:when test="../gmd:explanation/gco:CharacterString='non valutato'">
				<xsl:copy>
					<xsl:attribute name="nilReason">unknown</xsl:attribute>
				</xsl:copy>
				<xsl:comment>Conformance non compilata</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	
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
				<xsl:comment>descriptiveKeywords vuota</xsl:comment>
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
				<xsl:comment>Keyword vuota</xsl:comment>
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
