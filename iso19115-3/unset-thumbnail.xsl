<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gn="http://www.fao.org/geonetwork" 
  xmlns:mdb="http://www.isotc211.org/2005/mdb/1.0/2013-06-24"
  xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-06-24"
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-06-24">
  
  <xsl:template match="/root">
    <xsl:apply-templates select="mdb:MD_Metadata|*[contains(@gco:isoType, 'MD_Metadata')]"/>
  </xsl:template>
  
  <xsl:template match="mri:graphicOverview[mcc:MD_BrowseGraphic/mcc:fileDescription/gco:CharacterString = /root/env/type]"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="gn:info" priority="2"/>
</xsl:stylesheet>
