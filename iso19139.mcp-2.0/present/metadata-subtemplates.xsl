<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="mcp gmd gco geonet">
  
  <!-- Subtemplate mode - overrides for iso19139 are placed in here
	     -->
  <xsl:template name="iso19139.mcp-2.0-subtemplate">
		<xsl:variable name="mcpElements">
			<xsl:apply-templates mode="iso19139.mcp-2.0-subtemplate" select="."/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(geonet:info/title)!=''">
				<title><xsl:value-of select="geonet:info/title"/></title>
			</xsl:when>
			<xsl:when test="count($mcpElements/*)>0">
				<xsl:copy-of select="$mcpElements"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="iso19139-subtemplate" select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template mode="iso19139.mcp-2.0-subtemplate" match="*"/>
  
</xsl:stylesheet>
