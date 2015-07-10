<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:proviso="http://geonetwork-opensource.org/schemas/prov-xml/proviso/1.0/2015-04-14"
  xmlns:geonet="http://www.fao.org/geonetwork" 
  exclude-result-prefixes="dc dct geonet">
  
  <!-- Compute title for all type of subtemplates. If none defined, 
  the title from the metadata title column is used. -->
  <xsl:template name="prov-xml-subtemplate">
    
    <xsl:variable name="subTemplateTitle">
      <xsl:apply-templates mode="prov-xml-subtemplate" select="."/>
    </xsl:variable>
    
    <title>
      <xsl:choose>
        <xsl:when test="normalize-space($subTemplateTitle)!=''">
          <xsl:value-of select="$subTemplateTitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="geonet:info/title"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>
  </xsl:template>
  
  <!-- Subtemplate mode -->
  <xsl:template mode="prov-xml-subtemplate" match="prov:*">
    <xsl:value-of select="@prov:id"/>
  </xsl:template>
  
</xsl:stylesheet>
