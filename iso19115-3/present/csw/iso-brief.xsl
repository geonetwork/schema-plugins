<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:mdb="http://www.isotc211.org/2005/mdb/1.0/2013-06-24"
  xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-06-24"
  xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-06-24"
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-06-24"
  xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-06-24"
  xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-06-24"
  xmlns:mco="http://www.isotc211.org/2005/mco/1.0/2013-06-24"
  xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2013-06-24"
  xmlns:lan="http://www.isotc211.org/2005/lan/1.0/2013-06-24"
  xmlns:mrl="http://www.isotc211.org/2005/mrl/1.0/2013-06-24"
  xmlns:mrs="http://www.isotc211.org/2005/mrs/1.0/2013-06-24"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:ows="http://www.opengis.net/ows"
  xmlns:gn="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">
  
  <xsl:import href="../../convert/ISO19115-3toISO19139.xsl"/>
  
  <xsl:param name="displayInfo"/>
  
  <xsl:template match="/">
    <xsl:for-each select="/*">
      <xsl:variable name="info" select="gn:info"/>
      <xsl:variable name="nameSpacePrefix">
        <xsl:call-template name="getNamespacePrefix"/>
      </xsl:variable>
      <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
        <xsl:call-template name="add-namespaces"/>
        
        <xsl:apply-templates select="mdb:metadataIdentifier"/>
        <xsl:apply-templates select="mdb:metadataScope"/>
        <xsl:apply-templates select="mdb:identificationInfo"/>
        
        <xsl:if test="$displayInfo = 'true'">
          <xsl:copy-of select="$info"/>
        </xsl:if>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="mdb:identificationInfo">
    <gmd:identificationInfo>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="./*">
        <xsl:variable name="nameSpacePrefix">
          <xsl:call-template name="getNamespacePrefix"/>
        </xsl:variable>
        <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="mri:citation"/>
          <xsl:apply-templates select="mri:graphicOverview"/>
          <xsl:apply-templates select="mri:extent[child::gex:EX_Extent[child::gex:geographicElement]]|
            srv:extent[child::gex:EX_Extent[child::gex:geographicElement]]"/>
          <xsl:apply-templates select="srv:serviceType"/>
          <xsl:apply-templates select="srv:serviceTypeVersion"/>
        </xsl:element>
      </xsl:for-each>
    </gmd:identificationInfo>
  </xsl:template>
  
  
  <xsl:template match="mcc:MD_BrowseGraphic">
    <xsl:variable name="nameSpacePrefix">
      <xsl:call-template name="getNamespacePrefix"/>
    </xsl:variable>
    <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
      <xsl:apply-templates select="mcc:fileName"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="gex:EX_Extent">
    <xsl:variable name="nameSpacePrefix">
      <xsl:call-template name="getNamespacePrefix"/>
    </xsl:variable>
    <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
      <xsl:apply-templates select="gex:geographicElement[child::gex:EX_GeographicBoundingBox]"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="gex:EX_GeographicBoundingBox">
    <xsl:variable name="nameSpacePrefix">
      <xsl:call-template name="getNamespacePrefix"/>
    </xsl:variable>
    <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
      <xsl:apply-templates select="gex:westBoundLongitude"/>
      <xsl:apply-templates select="gex:southBoundLatitude"/>
      <xsl:apply-templates select="gex:eastBoundLongitude"/>
      <xsl:apply-templates select="gex:northBoundLatitude"/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="cit:CI_Citation">
    <xsl:variable name="nameSpacePrefix">
      <xsl:call-template name="getNamespacePrefix"/>
    </xsl:variable>
    <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
      <xsl:apply-templates select="cit:title"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>