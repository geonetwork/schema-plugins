<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:naplio="http://www.lio.ontario.ca/naplio"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco" version="2.0">
	<xsl:import href="../../../iso19139/present/csw/iso-full.xsl"/>

  <!-- Remap schema element -->
  <xsl:template match="*[@gco:isoType]" priority="100">
    <xsl:element name="{@gco:isoType}">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <!-- Remove NAPLIO information -->
  <xsl:template match="naplio:opsExtensions" />
</xsl:stylesheet>