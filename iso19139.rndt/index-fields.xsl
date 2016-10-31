<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:srv="http://www.isotc211.org/2005/srv"
        xmlns:gco="http://www.isotc211.org/2005/gco">


    <xsl:import href="../iso19139/index-fields.xsl"/>

    <xsl:template mode="index" match="gmd:fileIdentifier/gco:CharacterString">

        <xsl:variable name="fileId"><xsl:value-of select="text()"/></xsl:variable>

        <xsl:variable name="ipaDefined" select="contains($fileId, ':')"/>

        <xsl:if test="$ipaDefined">
            <xsl:variable name="ipa" select="substring-before($fileId, ':')"/>
            <Field name="ipa" string="{$ipa}" store="false" index="true"/>
        </xsl:if>
    </xsl:template>


    <xsl:template mode="index" match="gmd:identificationInfo//gmd:MD_DataIdentification|
			gmd:identificationInfo//*[contains(@gco:isoType, 'MD_DataIdentification')]|
			gmd:identificationInfo/srv:SV_ServiceIdentification">

        <xsl:variable name="obsolete" select="count(gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='obsoleto'])>0"/>

        <xsl:message>OBSOLETO <xsl:value-of select="$obsolete"/></xsl:message>

        <xsl:choose>
            <xsl:when test="$obsolete">
                <Field name="RNDTobsoleto" string="true" store="false" index="true"/>
            </xsl:when>
            <xsl:otherwise>
                <Field name="RNDTobsoleto" string="false" store="false" index="true"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
