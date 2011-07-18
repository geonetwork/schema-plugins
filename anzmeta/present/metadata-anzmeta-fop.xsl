<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:date="http://exslt.org/dates-and-times" 
	xmlns:exslt="http://exslt.org/common"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="xs" version="2.0">

  <xsl:template name="metadata-fop-anzmeta-unused">
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


  <xsl:template name="metadata-fop-anzmeta">
    <xsl:param name="schema"/>

    <!-- Title -->
    <xsl:variable name="title">
      <xsl:apply-templates mode="elementFop" select="citeinfo/title">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$title"/>
    </xsl:call-template>

    <!-- Date -->
    <xsl:apply-templates mode="elementFop" select="metainfo/metd/date">
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:apply-templates>

    <!-- Abstract -->
    <xsl:variable name="abstract">
      <xsl:apply-templates mode="elementFop" select="descript/abstract">
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

    <!-- Contact -->
    <xsl:variable name="poc">
      <xsl:apply-templates mode="elementFop" select="cntinfo">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$poc"/>
      <xsl:with-param name="label">
        <xsl:value-of select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='cntinfo']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- KeywordSet -->
    <xsl:variable name="keyword">
			<xsl:for-each select="descript/theme">
      	<xsl:apply-templates mode="elementFop" select="keyword">
        	<xsl:with-param name="schema" select="$schema"/>
      	</xsl:apply-templates>
			</xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$keyword"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='theme']/label"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Extents - geographical, temporal and taxonomic -->
    <xsl:variable name="geoBbox">
      <xsl:apply-templates mode="elementFop"
        select="descript/spdom/bounding">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="timeExtent">
      <xsl:apply-templates mode="elementFop"
        select="timeperd">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="extent">
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$geoBbox"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='bounding']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$timeExtent"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='timeperd']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$extent"/>
      <xsl:with-param name="label">
        <xsl:value-of select="'Extent'"/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- Constraints -->
    <xsl:variable name="constraints">
    	<xsl:apply-templates mode="elementFop" select="distinfo/accconst">
    		<xsl:with-param name="schema" select="$schema"/>
    	</xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$constraints"/>
    </xsl:call-template>

    <!-- Identifier -->
    <xsl:variable name="identifier">
      <xsl:apply-templates mode="elementFop" select="citeinfo/uniqueid">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$identifier"/>
    </xsl:call-template>

    <!-- metadataProvider  -->
    <xsl:variable name="contact">
      <xsl:apply-templates mode="elementFop"
        select="citeinfo/origin">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block" select="$contact"/>
      <xsl:with-param name="label">
        <xsl:value-of
          select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='origin']/label"/>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
