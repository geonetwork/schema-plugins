<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:grg="http://www.isotc211.org/2005/grg"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" 
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:date="http://exslt.org/dates-and-times" 
	xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="xs"
  version="2.0">

	
  <xsl:template name="metadata-fop-iso19135-unused">
    <xsl:param name="schema"/>
    
    <!-- TODO improve block level element using mode -->
    <xsl:for-each select="*[namespace-uri(.)!=$geonetUri]">
      
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block">
          <xsl:choose>
            <xsl:when test="count(*/*) > 1">
              <xsl:for-each select="*">
                <xsl:call-template name="blockElementFop">
                  <xsl:with-param name="label">
                    <xsl:call-template name="getTitle">
                      <xsl:with-param name="name"   select="name()"/>
                      <xsl:with-param name="schema" select="$schema"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="block">
                    <xsl:apply-templates mode="elementFop" select=".">
                      <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="elementFop" select=".">
                <xsl:with-param name="schema" select="$schema"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="metadata-fop-iso19135">
    <xsl:param name="schema"/>

    <!-- Title -->
    <xsl:variable name="title">
      <xsl:apply-templates mode="elementFop"
        select="grg:name">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$title"/>
    </xsl:call-template>

    <!-- Date -->
    <xsl:variable name="date">
      <xsl:apply-templates mode="elementFop"
        select="grg:version/*/grg:versionDate|grg:dateOfLastChange">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$date"/>
    </xsl:call-template>

    <!-- Abstract -->
    <xsl:variable name="abstract">
      <xsl:apply-templates mode="elementFop" select="grg:contentSummary">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$abstract"/>
    </xsl:call-template>

    <!-- Language -->
    <xsl:variable name="lang">
      <xsl:apply-templates mode="elementFop" select="grg:operatingLanguage/*/grg:language">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$lang"/>
    </xsl:call-template>

    <!-- Charset Encoding -->
    <xsl:variable name="lang">
      <xsl:apply-templates mode="elementFop" select="grg:operatingLanguage/*/grg:characterEncoding">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$lang"/>
    </xsl:call-template>

    <!-- Source Online -->
    <xsl:variable name="online">
      <xsl:apply-templates mode="elementFop"
        select="grg:uniformResourceIdentifier/gmd:CI_OnlineResource/gmd:linkage">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$online"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='grg:uniformResourceIdentifier']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Contact -->
    <xsl:variable name="poc">
      <xsl:apply-templates mode="elementFop"
        select="grg:manager/*/grg:contact/gmd:CI_ResponsibleParty/gmd:individualName           |
                grg:manager/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName         |
                grg:manager/*/grg:contact/gmd:CI_ResponsibleParty/gmd:positionName             |
                grg:manager/*/grg:contact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$poc"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='grg:contact']/label"
        />
      </xsl:with-param>
    </xsl:call-template>

    <!-- Keywords -->
    <xsl:variable name="keyword">
      <xsl:apply-templates mode="elementFop" select="grg:containedItem/*[grg:status/grg:RE_ItemStatus='valid']/grg:name">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$keyword"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='grg:containedItem']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Identifier -->
    <xsl:variable name="identifier">
      <xsl:apply-templates mode="elementFop" select="@uuid">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$identifier"/>
			<xsl:with-param name="label" select="'Identifier'"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
