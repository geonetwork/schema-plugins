<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:geonet="http://www.fao.org/geonetwork"

  exclude-result-prefixes="xsl mcp gco gmd gmx geonet"
>

  <xsl:template match="mcp:MD_Metadata/gmd:identificationInfo/mcp:MD_DataIdentification/mcp:dataParameters/mcp:DP_DataParameters/mcp:dataParameter/mcp:DP_DataParameter/*/mcp:DP_Term">

    <mcp:DP_Term>

      <!-- common for both controlled and uncontrolled -->
      <xsl:copy-of select="mcp:term"/>
      <xsl:copy-of select="mcp:type"/>

      <xsl:choose>
        <xsl:when test="mcp:usedInDataset">
          <xsl:copy-of select="mcp:usedInDataset"/>
        </xsl:when>
        <xsl:otherwise>
          <mcp:usedInDataset>
            <gco:Boolean>false</gco:Boolean>
          </mcp:usedInDataset>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <!-- controlled term -->
        <xsl:when test="mcp:vocabularyRelationship/mcp:DP_VocabularyRelationship/mcp:relationshipType/mcp:DP_RelationshipTypeCode">
          <mcp:vocabularyTermURL>
            <gmd:URL>
              <xsl:copy-of select="mcp:vocabularyRelationship/mcp:DP_VocabularyRelationship/mcp:vocabularyTermURL/gmd:URL/text()"/>
            </gmd:URL>
          </mcp:vocabularyTermURL>
        </xsl:when>
        <!-- make idempotent if already updated -->
        <xsl:when test="mcp:vocabularyTermURL">
          <xsl:copy-of select="mcp:vocabularyTermURL"/>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

    </mcp:DP_Term>

  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>



