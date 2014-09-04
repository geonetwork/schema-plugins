<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco" 
                xmlns:gmx="http://www.isotc211.org/2005/gmx" 
                xmlns:gml="http://www.opengis.net/gml/3.2"
                version="1.0"  >

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
   		<extractedCodelists>
            <codelists>
            	<xsl:apply-templates/>
            </codelists>
            <labels>
            	<xsl:apply-templates mode="labels"/>
            </labels>
   		</extractedCodelists>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*" mode="labels">
        <xsl:apply-templates mode="labels"/>
    </xsl:template>

    <xsl:template match="text()"/>
    <xsl:template match="text()" mode="labels"/>

<!--	<codelist name="ngmp:NGMP_GeospatialInformationTypeCode">
		<entry>
			<code>mapSheet</code>
			<label>Map Sheet</label>
			<description>zzzz</description>
		</entry>    -->

    <xsl:template match="gmx:codelistItem/gmx:CodeListDictionary">
        <codelist>
            <xsl:attribute name="name">ngmp:<xsl:value-of select="@gml:id"/></xsl:attribute>
                <xsl:apply-templates/>
            </codelist>

    </xsl:template>


    <xsl:template match="gmx:codeEntry/gmx:CodeDefinition">
        <entry>
            <code><xsl:value-of select="gml:identifier"/></code>
            <label><xsl:value-of select="./gml:name"/></label>
            <description><xsl:value-of select="gml:description"/></description>
        </entry>
    </xsl:template>


<!--	<element name="gmd:cameraCalibrationInformationAvailability"
		id="253.0">
		<label>Camera calibration information availability</label>
		<description>Indication of whether or not constants are available which allow for camera
            calibration corrections</description>
	</element>-->

    <xsl:template match="gmx:codelistItem/gmx:CodeListDictionary" mode="labels">
        <element>
            <xsl:attribute name="name">ngmp:<xsl:value-of select="@gml:id"/></xsl:attribute>

            <label><xsl:value-of select="./gml:name"/></label>
            <description><xsl:value-of select="gml:description"/></description>
        </element>
    </xsl:template>


</xsl:stylesheet>
