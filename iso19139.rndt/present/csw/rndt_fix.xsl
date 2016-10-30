<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:srv="http://www.isotc211.org/2005/srv" 
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gco="http://www.isotc211.org/2005/gco" 
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    exclude-result-prefixes="#all">

    <xsl:output indent="yes"/>

    <!-- skip elements in non-copy mode -->
    <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()" />
    </xsl:template>

    <!--  enter copy mode when first CSW element is found -->
    <xsl:template match="*[namespace-uri()='http://www.opengis.net/cat/csw/2.0.2']">
       <xsl:copy>
           <xsl:apply-templates select="@*|node()" mode="copy"/>
       </xsl:copy>
    </xsl:template>

    <!--  skip request provided by GN context -->
    <xsl:template match="csw:request" priority="5">
    </xsl:template>

    <!-- copy elements in copy mode -->
    <xsl:template match="@*|node()" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="gmx:MimeFileType" mode="copy">
       <gco:CharacterString><xsl:value-of select="text()"/></gco:CharacterString>
    </xsl:template>

</xsl:stylesheet>
