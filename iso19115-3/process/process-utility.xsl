<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common" xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0" 
	xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0" exclude-result-prefixes="exslt">
  
  <!-- Create an ISO 19139 extent fragment -->
  <xsl:function name="geonet:make-iso19115-3-extent" as="node()">
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
