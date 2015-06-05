<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  exclude-result-prefixes="#all">

  <!-- Get the main metadata languages -->
  <xsl:template name="get-prov-xml-language">
    <xsl:value-of select="'eng'"/>
		<!-- Could look for xml:lang values (2 char) and convert to 3 char? -->
  </xsl:template>

  <!-- Get the list of other languages in JSON -->
  <xsl:template name="get-prov-xml-other-languages-as-json">
		<!-- Could look for xml:lang values (2 char) and convert to 3 char? -->
    <xsl:text>{ 'eng' }</xsl:text>
  </xsl:template>

  <!-- Get the list of other languages -->
  <xsl:template name="get-prov-xml-other-languages">
  </xsl:template>

</xsl:stylesheet>
