<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:dc ="http://purl.org/dc/elements/1.1/"
  xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:ows="http://www.opengis.net/ows"
  xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">
  
  <xsl:param name="displayInfo"/>
  <xsl:param name="lang"/>
  
 	<!-- full record - should we try encode prov relationships into dct:relation -->

  <xsl:include href="../metadata-utils.xsl"/>
  
  <xsl:template match="prov:document">
    <xsl:variable name="info" select="geonet:info"/>
    
    <csw:Record>
      <xsl:copy-of select="prov:other/dc:identifier"/>
      <xsl:copy-of select="prov:other/dc:title"/>
      
      <!-- Type -->
      <dc:type>provenanceDocument</dc:type>
      
      <!-- bounding box -->
			<xsl:variable name="box">
				<xsl:call-template name="extractDCMIBox">
					<xsl:with-param name="coverage" select="prov:other/dc:coverage"/>
				</xsl:call-template>
			</xsl:variable>
      <ows:BoundingBox>
        <ows:LowerCorner><xsl:value-of select="concat($box/box/eastBL, ' ', $box/box/northBL)"/></ows:LowerCorner>
        <ows:UpperCorner><xsl:value-of select="concat($box/box/westBL, ' ', $box/box/southBL)"/></ows:UpperCorner>
      </ows:BoundingBox>
      
      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
      
    </csw:Record>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>
</xsl:stylesheet>
