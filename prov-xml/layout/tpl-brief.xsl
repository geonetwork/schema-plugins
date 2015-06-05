<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

  <xsl:include href="utility-fn.xsl"/>
  <xsl:include href="utility-tpl.xsl"/>

  <xsl:template mode="superBrief" match="prov:document" priority="2">
    <id><xsl:value-of select="gn:info/id"/></id>
    <uuid><xsl:value-of select="gn:info/uuid"/></uuid>
  </xsl:template>

  <xsl:template name="prov-xmlBrief">
    <metadata><xsl:call-template name="prov-xml-brief"/></metadata>
  </xsl:template>

  <xsl:template name="prov-xml-brief">
    <xsl:call-template name="prov-xml-brief"/>
  </xsl:template>
</xsl:stylesheet>
