<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:sdn="http://www.seadatanet.org"
  version="2.0">

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <xsl:template match="gmd:MD_Metadata">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>

      <!-- urn:SDN:CSR:LOCAL:EDMO-code_Local-CSR-ID -->
      <xsl:variable name="needle" select="'LOCAL:'"/>
      <xsl:variable name="prefix" select="substring-before(gmd:fileIdentifier, $needle)"/>
      <xsl:variable name="localCode" select="substring-after(gmd:fileIdentifier, $needle)"/>
      <xsl:variable name="edmoCodeInRecord" select="gmd:contact[1]/gmd:CI_ResponsibleParty[1]/
        gmd:organisationName[1]/sdn:SDN_EDMOCode[1]/@codeListValue"/>
      <xsl:variable name="edmoCode"
                    select="if ($edmoCodeInRecord != '')
                      then $edmoCodeInRecord
                      else 'unknown'"/>
      <gmd:fileIdentifier>
        <gco:CharacterString>
          <xsl:value-of select="concat($prefix, $needle, $edmoCode, '_', $localCode)"/>
        </gco:CharacterString>
      </gmd:fileIdentifier>

      <xsl:apply-templates select="node()[not(self::gmd:fileIdentifier)]"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
