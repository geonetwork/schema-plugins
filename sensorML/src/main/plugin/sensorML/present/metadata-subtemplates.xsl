<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="mcp gmd gco geonet">
  
  <!-- Subtemplate mode -->
  <xsl:template name="sensorML-subtemplate">
		<xsl:variable name="sensorMLElements">
			<xsl:apply-templates mode="sensorML-subtemplate" select="."/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(geonet:info/title)!=''">
				<title><xsl:value-of select="geonet:info/title"/></title>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$sensorMLElements"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template mode="sensorML-subtemplate" match="*"/>
  
</xsl:stylesheet>
