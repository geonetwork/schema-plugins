<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:grg="http://www.isotc211.org/2005/grg"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">


  <xsl:template name="get-iso19135-online-source-config">
    <xsl:param name="pattern"/>
    <config/>
  </xsl:template>

  <xsl:template name="get-iso19135-language">
    <xsl:value-of select="$metadata/grg:operatingLanguage/grg:RE_Locale/grg:language/gco:CharacterString|
      $metadata/grg:operatingLanguage/grg:RE_Locale/grg:LanguageCode/@codeListValue"></xsl:value-of>
  </xsl:template>

  <xsl:template name="get-iso19135-other-languages-as-json">
    {}
    <!-- TODO -->
  </xsl:template>

  <xsl:template name="get-iso19135-other-languages">
    <!-- TODO -->
  </xsl:template>
</xsl:stylesheet>
