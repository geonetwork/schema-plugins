<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
    xmlns:geonet="http://www.fao.org/geonetwork" 
    version="2.0">
    
    <xsl:param name="pattern" select="'http://geoserver-123.aodn.org.au'"/>
    <xsl:param name="replacement" select="'http://geoserver-rc.aodn.org.au'"/>
 
    <!-- default action is to copy -->
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
  <!-- Always remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

    <!-- replace pattern with replacement in any gmd:url elements -->
    
    <xsl:template match="gmd:URL[normalize-space($pattern) != '' and matches(text(), $pattern)]">
        <xsl:copy>
            <xsl:value-of select="replace(text(), $pattern, $replacement)"/> 
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
