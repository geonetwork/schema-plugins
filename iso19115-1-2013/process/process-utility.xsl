<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  xmlns:gco="http://www.isotc211.org/2005/gco" 
  xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:iso19115-1-2013="http://www.fao.org/geonetwork/iso19115-1-2013"
  version="2.0" exclude-result-prefixes="exslt">
  
  <!-- Create an ISO 19115-1-2013 extent fragment -->
  <xsl:function name="iso19115-1-2013:make-iso-extent" as="node()">
    <xsl:param name="w" as="xs:string"/>
    <xsl:param name="s" as="xs:string"/>
    <xsl:param name="e" as="xs:string"/>
    <xsl:param name="n" as="xs:string"/>
    <xsl:param name="description" as="xs:string?"/>

    <gex:EX_Extent>
      <xsl:if test="normalize-space($description)!=''">
        <gex:description>
          <gco:CharacterString>
            <xsl:value-of select="$description"/>
          </gco:CharacterString>
        </gex:description>
      </xsl:if>
      <gex:geographicElement>
        <gex:EX_GeographicBoundingBox>
          <gex:westBoundLongitude>
            <gco:Decimal>
              <xsl:value-of select="$w"/>
            </gco:Decimal>
          </gex:westBoundLongitude>
          <gex:eastBoundLongitude>
            <gco:Decimal>
              <xsl:value-of select="$e"/>
            </gco:Decimal>
          </gex:eastBoundLongitude>
          <gex:southBoundLatitude>
            <gco:Decimal>
              <xsl:value-of select="$s"/>
            </gco:Decimal>
          </gex:southBoundLatitude>
          <gex:northBoundLatitude>
            <gco:Decimal>
              <xsl:value-of select="$n"/>
            </gco:Decimal>
          </gex:northBoundLatitude>
        </gex:EX_GeographicBoundingBox>
      </gex:geographicElement>
    </gex:EX_Extent>
  </xsl:function>

</xsl:stylesheet>
