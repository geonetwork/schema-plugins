<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl-multilingual.xsl"/>

	<xsl:template name="get-prov-xml-is-service">
		<xsl:value-of select="false()"/>
	</xsl:template>

  <xsl:template name="get-prov-xml-extents-as-json">[]</xsl:template>

  <xsl:template name="get-prov-xml-online-source-config">
    <xsl:param name="pattern"/>
    <config></config>
  </xsl:template>
</xsl:stylesheet>
