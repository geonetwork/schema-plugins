<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- Redirect to iso19139 default layout first then MCP specific stuff -->
  <xsl:template name="metadata-fop-iso19139.mcp-1.4">
    <xsl:param name="schema"/>
    
    <xsl:call-template name="metadata-fop-iso19139.mcp">
      <xsl:with-param name="schema" select="'iso19139'"/>
    </xsl:call-template>

  </xsl:template>
  
</xsl:stylesheet>
