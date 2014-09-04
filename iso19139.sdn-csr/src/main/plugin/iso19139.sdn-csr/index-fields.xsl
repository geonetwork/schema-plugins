<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gml="http://www.opengis.net/gml"
    xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#">

    <xsl:include href="../iso19139/index-fields.xsl"/>

    <xsl:template match="/" priority="2">
        <xsl:variable name="isoLangId">
            <xsl:call-template name="langId19139"/>
        </xsl:variable>

        <Document locale="{$isoLangId}">
            <Field name="_locale" string="{$isoLangId}" store="true" index="true"/>

            <Field name="_docLocale" string="{$isoLangId}" store="true" index="true"/>


            <xsl:variable name="_defaultTitle">
                <xsl:call-template name="defaultTitle">
                    <xsl:with-param name="isoDocLangId" select="$isoLangId"/>
                </xsl:call-template>
            </xsl:variable>
            <Field name="_defaultTitle" string="{string($_defaultTitle)}" store="true" index="true"/>
            <!-- not tokenized title for sorting, needed for multilingual sorting -->
            <Field name="_title" string="{string($_defaultTitle)}" store="true" index="true"/>

            <xsl:apply-templates
                select="*[name(.)='gmi:MI_Metadata' or @gco:isoType='gmi:MI_Metadata']"
                mode="metadata"/>

            <xsl:apply-templates mode="index"
                select="*[name(.)='gmi:MI_Metadata' or @gco:isoType='gmi:MI_Metadata']"/>

        </Document>
    </xsl:template>
</xsl:stylesheet>
