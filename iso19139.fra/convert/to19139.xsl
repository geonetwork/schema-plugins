<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gml="http://www.opengis.net/gml" xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="fra gmi" xmlns:srv="http://www.isotc211.org/2005/srv">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


  <!-- root element  -->
  <xsl:template match="gmd:MD_Metadata">
    <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
                     xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi"
                     xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts"
                     xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <xsl:apply-templates select="*"/>
    </gmd:MD_Metadata>
  </xsl:template>

  <!-- Copy all -->
  <xsl:template match="@*|node()" priority="-10">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <!-- Remap schema element -->
  <xsl:template match="*[@gco:isoType]" priority="100">
    <xsl:element name="{@gco:isoType}">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="gmd:metadataStandardName">
    <gmd:metadataStandardName>
      <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
    </gmd:metadataStandardName>
  </xsl:template>

  <xsl:template match="gmd:metadataStandardVersion">
    <gmd:metadataStandardVersion>
      <gco:CharacterString>1.0</gco:CharacterString>
    </gmd:metadataStandardVersion>
  </xsl:template>

  <!-- handle FRA_DataIdentification-->
  <xsl:template match="fra:FRA_DataIdentification">
    <gmd:MD_DataIdentification>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_DataIdentification>
  </xsl:template>

  <!-- handle FRA_Constraints-->
  <xsl:template match="fra:FRA_Constraints">
    <gmd:MD_Constraints>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_Constraints>
  </xsl:template>

  <xsl:template match="fra:FRA_LegalConstraints">
    <gmd:MD_LegalConstraints>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_LegalConstraints>
  </xsl:template>

  <xsl:template match="fra:FRA_SecurityConstraints">
    <gmd:MD_SecurityConstraints>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_SecurityConstraints>
  </xsl:template>

  <!--handle CRS-->
  <xsl:template match="fra:FRA_IndirectReferenceSystem">
    <gmd:MD_ReferenceSystem>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_ReferenceSystem>
  </xsl:template>
  <xsl:template match="fra:FRA_DirectReferenceSystem">
    <gmd:MD_ReferenceSystem>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_ReferenceSystem>
  </xsl:template>

  <!--Removed Citation added for DataIdentification, Constraints -->
  <xsl:template match="fra:relatedCitation">
  </xsl:template>

  <xsl:template match="fra:FRA_Constraints/fra:citation">
  </xsl:template>

  <xsl:template match="fra:FRA_LegalConstraints/fra:citation">
  </xsl:template>

  <xsl:template match="fra:FRA_SecurityConstraints/fra:citation">
  </xsl:template>

  <!-- Removed Validity values and UseBy for dates-->
  <xsl:template match="gmd:date[CI_Date/dateType/CI_DateTypeCode/@codeListValue='validity']">
  </xsl:template>

  <xsl:template match="gmd:date[CI_Date/dateType/CI_DateTypeCode/@codeListValue='useBy']">
  </xsl:template>

  <!-- QEUsability element removed -->
  <xsl:template match="gmi:QE_Usability"/>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
