<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
								xmlns:dc="http://purl.org/dc/elements/1.1/"
								xmlns:dct="http://purl.org/dc/terms/"
								xmlns:prov="http://www.w3.org/ns/prov#"
  							xmlns:gn="http://www.fao.org/geonetwork"
  							exclude-result-prefixes="#all">

	 <!-- ================================================================= -->
  
  <xsl:template match="/root">
    <xsl:apply-templates select="prov:document"/>
  </xsl:template>
  
  <xsl:template match="prov:document">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      
			<xsl:apply-templates select="prov:entity"/>
      <xsl:apply-templates select="prov:activity"/>
      <xsl:apply-templates select="prov:wasGeneratedBy"/>
      <xsl:apply-templates select="prov:used"/>
      <xsl:apply-templates select="prov:wasInformedBy"/>
      <xsl:apply-templates select="prov:wasStartedBy"/>
      <xsl:apply-templates select="prov:wasEndedBy"/>
      <xsl:apply-templates select="prov:wasInvalidatedBy"/>
      <xsl:apply-templates select="prov:wasDerivedFrom"/>
      <xsl:apply-templates select="prov:wasRevisionOf"/>
      <xsl:apply-templates select="prov:wasQuotedFrom"/>
      <xsl:apply-templates select="prov:hadPrimarySource"/>
      <xsl:apply-templates select="prov:agent"/>
      <xsl:apply-templates select="prov:person"/>
      <xsl:apply-templates select="prov:organization"/>
      <xsl:apply-templates select="prov:softwareAgent"/>
      <xsl:apply-templates select="prov:wasAttributedTo"/>
      <xsl:apply-templates select="prov:wasAssociatedWith"/>
      <xsl:apply-templates select="prov:actedOnBehalfOf"/>
      <xsl:apply-templates select="prov:wasInfluencedBy"/>
      <xsl:apply-templates select="prov:bundle"/>
      <xsl:apply-templates select="prov:specializationOf"/>
      <xsl:apply-templates select="prov:alternateOf"/>
      <xsl:apply-templates select="prov:collection"/>
      <xsl:apply-templates select="prov:emptyCollection"/>
      <xsl:apply-templates select="prov:hadMember"/>
      <xsl:apply-templates select="prov:plan"/>
      <xsl:choose>
        <xsl:when test="prov:other">
          <xsl:apply-templates select="prov:other"/>
        </xsl:when>
        <xsl:otherwise>
          <prov:other>
            <xsl:call-template name="fill"/>
          </prov:other>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="prov:internalElement"/>
    </xsl:copy>
  </xsl:template>

	 <!-- ================================================================= -->

  <xsl:template match="prov:other">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="dc:identifier"/>
      <xsl:apply-templates select="dc:title"/>
      <xsl:apply-templates select="dc:description"/>
      <xsl:apply-templates select="dc:coverage"/>
      <xsl:apply-templates select="dc:subject"/>
      <xsl:apply-templates select="dct:created"/>
      <xsl:apply-templates select="dct:modified"/>
      <xsl:call-template name="fill"/>
    </xsl:copy>
  </xsl:template>	
     
	 <!-- ================================================================= -->

	<xsl:template name="fill"> 
      <!-- Add identifier, creation and modified if they don't exist -->
      <xsl:if test="not(dc:identifier) and /root/env/uuid">
        <dc:identifier><xsl:value-of select="/root/env/uuid"/></dc:identifier>
      </xsl:if>
      <xsl:if test="not(dct:created) and /root/env/changeDate">
        <dct:created><xsl:value-of select="/root/env/changeDate"/></dct:created>
      </xsl:if>
      <xsl:if test="not(dct:modified) and /root/env/changeDate">
        <dct:modified><xsl:value-of select="/root/env/changeDate"/></dct:modified>
      </xsl:if>
	</xsl:template>
  
	 <!-- ================================================================= -->
  
  <!-- Update revision date -->
  <xsl:template match="dct:modified">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="/root/env/changeDate">
          <xsl:value-of select="/root/env/changeDate"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
	 <!-- ================================================================= -->
  
  <!-- copy everything else as is -->
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
