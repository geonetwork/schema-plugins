<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:sdn="http://www.seadatanet.org"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- Convert to character string -->
    <xsl:template
        match="sdn:SDN_EDMOCode|sdn:SDN_CountryCode|sdn:SDN_PortCode|sdn:SDN_CRSCode|
        sdn:SDN_PlatformCode|sdn:SDN_PlatformCategoryCode|sdn:SDN_EDMERPCode|
        sdn:SDN_WaterBodyCode|sdn:SDN_MarsdenCode|sdn:SDN_ParameterDiscoveryCode|
        sdn:SDN_DeviceCategoryCode|sdn:SDN_DataCategoryCode|sdn:SDN_HierarchyLevelNameCode|
        sdn:SDN_FormatNameCode">
        <gco:CharacterString>
            <xsl:value-of select="text()"/>
        </gco:CharacterString>
    </xsl:template>

    <!-- Remove sdn:additionalDocumentation, sdn:SDN_SamplingActivity -->
    <xsl:template match="sdn:additionalDocumentation|sdn:SDN_SamplingActivity"/>

    <!-- Convert to data identification -->
    <xsl:template match="sdn:SDN_DataIdentification">
        <gmd:MD_DataIdentification>
            <xsl:apply-templates select="*"/>
        </gmd:MD_DataIdentification>
    </xsl:template>

    <!-- Convert to MI_Objective -->
    <xsl:template match="sdn:SDN_Objective">
        <gmi:MI_Objective>
            <xsl:apply-templates select="*"/>
        </gmi:MI_Objective>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
