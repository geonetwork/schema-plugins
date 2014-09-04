<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:geonet="http://www.fao.org/geonetwork"
    version="2.0">
    <xsl:import href="../../../iso19139/present/csw/iso-summary.xsl"/>

    <xsl:template match="gmi:MI_Metadata|*[@gco:isoType='gmi:MI_Metadata']">
        <xsl:variable name="info" select="geonet:info"/>
        <xsl:copy>
            <xsl:apply-templates select="gmd:fileIdentifier"/>
            <xsl:apply-templates select="gmd:language"/>
            <xsl:apply-templates select="gmd:characterSet"/>
            <xsl:apply-templates select="gmd:parentIdentifier"/>
            <xsl:apply-templates select="gmd:hierarchyLevel"/>
            <xsl:apply-templates select="gmd:hierarchyLevelName"/>
            <xsl:apply-templates select="gmd:dateStamp"/>
            <xsl:apply-templates select="gmd:metadataStandardName"/>
            <xsl:apply-templates select="gmd:metadataStandardVersion"/>
            <xsl:apply-templates select="gmd:referenceSystemInfo"/>
            <xsl:apply-templates select="gmd:identificationInfo"/>
            <xsl:apply-templates select="gmd:distributionInfo"/>
            <xsl:apply-templates select="gmd:dataQualityInfo"/>

            <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
            <xsl:if test="$displayInfo = 'true'">
                <xsl:copy-of select="$info"/>
            </xsl:if>

        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
