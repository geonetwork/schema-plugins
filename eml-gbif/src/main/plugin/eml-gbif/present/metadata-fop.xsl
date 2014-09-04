<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dc="http://purl.org/dc/terms/" 
	xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
  xmlns:date="http://exslt.org/dates-and-times" 
	xmlns:exslt="http://exslt.org/common"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="xs" version="2.0">

  <xsl:template name="metadata-fop-eml-gbif-unused">
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


  <xsl:template name="metadata-fop-eml-gbif">
    <xsl:param name="schema"/>

    <!-- Title -->
    <xsl:variable name="title">
      <xsl:apply-templates mode="elementFop" select="dataset/title[1]">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$title"/>
    </xsl:call-template>

    <!-- Date -->
    <xsl:apply-templates mode="elementFop" select="dataset/pubDate">
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:apply-templates>

    <!-- Language -->
    <xsl:apply-templates mode="elementFop" select="dataset/language">
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:apply-templates>

    <!-- Abstract -->
    <xsl:variable name="abstract">
      <xsl:apply-templates mode="elementFop" select="dataset/abstract/para">
       	<xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
		</xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$abstract"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='abstract']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Source Online -->
    <xsl:variable name="online">
      <xsl:apply-templates mode="elementFop" 
			          select="dataset/distribution/online|
								        additionalMetadata/metadata/physical/distribution/online">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$online"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='online']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Contact -->
    <xsl:variable name="poc">
      <xsl:apply-templates mode="elementFop"
        select="dataset/associatedParty[role='pointOfContact']
				       |dataset/contact">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$poc"/>
      <xsl:with-param name="label">
        <xsl:value-of select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='contact']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- KeywordSet -->
    <xsl:variable name="keyword">
			<xsl:for-each select="dataset/keywordSet">
      	<xsl:apply-templates mode="elementFop" select="dataset/keywordSet/keyword">
        	<xsl:with-param name="schema" select="$schema"/>
      	</xsl:apply-templates>
			</xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$keyword"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='keyword']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Extents - geographical, temporal and taxonomic -->
    <xsl:variable name="geoBbox">
      <xsl:apply-templates mode="elementFop"
        select="dataset/coverage/geographicCoverage/boundingCoordinates">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="timeExtent">
      <xsl:apply-templates mode="elementFop"
        select="dataset/coverage/temporalCoverage/rangeOfDates">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="taxonExtent">
      <xsl:apply-templates mode="elementFop"
        select="dataset/coverage/taxonomicCoverage">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="extent">
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$geoBbox"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='boundingCoordinates']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$timeExtent"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='temporalCoverage']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$taxonExtent"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='taxonomicCoverage']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$extent"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='coverage']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Constraints -->
    <xsl:variable name="constraints">
      <xsl:apply-templates mode="elementFop"
        select="dataset/intellectualRights/para">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$constraints"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='intellectualRights']/label"
        />
      </xsl:with-param>
    </xsl:call-template>

    <!-- Identifier -->
    <xsl:variable name="identifier">
      <xsl:apply-templates mode="elementFop" select="dataset/alternateIdentifier">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$identifier"/>
    </xsl:call-template>

    <!-- Language -->
    <xsl:variable name="language">
      <xsl:apply-templates mode="elementFop" select="dataset/language">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$language"/>
    </xsl:call-template>

    <!-- metadataProvider  -->
    <xsl:variable name="contact">
      <xsl:apply-templates mode="elementFop"
        select="dataset/metadataProvider">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$contact"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='metadataProvider']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Date stamp -->
    <xsl:variable name="dateStamp">
      <xsl:apply-templates mode="elementFop" select="additionalMetadata/metadata/gbif/dateStamp">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$dateStamp"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
