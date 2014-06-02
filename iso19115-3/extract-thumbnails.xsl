<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-06-24"
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-06-24"
  xmlns:mdb="http://www.isotc211.org/2005/mdb/1.0/2013-06-24">
  
  <xsl:template match="mdb:MD_Metadata|*[contains(@gco:isoType, 'MD_Metadata')]">
    <thumbnail>
      <xsl:for-each 
        select="mdb:identificationInfo/*/mri:graphicOverview/mcc:MD_BrowseGraphic">
        <xsl:choose>
          <xsl:when
            test="mcc:fileDescription/gco:CharacterString = 'large_thumbnail' and
                  mcc:fileName/gco:CharacterString != ''">
            <large>
              <xsl:value-of select="mcc:fileName/gco:CharacterString"/>
            </large>
          </xsl:when>
          <xsl:when
            test="mcc:fileDescription/gco:CharacterString = 'thumbnail' and
                  mcc:fileName/gco:CharacterString != ''">
            <small>
              <xsl:value-of select="mcc:fileName/gco:CharacterString"/>
            </small>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </thumbnail>
  </xsl:template>
</xsl:stylesheet>