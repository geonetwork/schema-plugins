<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
  xmlns:gco="http://standards.iso.org/19139/gco/1.0/2014-12-25"
  xmlns:mcc="http://standards.iso.org/19115/-3/mcc/1.0/2014-12-25"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:proviso="http://geonetwork-opensource.org/schemas/prov-xml/proviso/1.0/2015-04-14">

	<!-- TODO: Extract 19115-3 metadata record from ex:documentMetadata and apply templates to that metadata record -->

  <xsl:template match="/">
    <thumbnail>
      <xsl:for-each 
        select="prov:document/proviso:graphicOverview/mcc:MD_BrowseGraphic">
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
