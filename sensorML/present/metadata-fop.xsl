<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
	xmlns:swe="http://www.opengis.net/swe/1.0.1" 
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:exslt="http://exslt.org/common"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:ns2="http://www.w3.org/2004/02/skos/core#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"  
	exclude-result-prefixes="sml swe gml exslt geonet xlink rdf ns2 rdfs skos xs"
  version="2.0">
  
  <xsl:template name="metadata-fop-sensorML">
    <xsl:param name="schema"/>

		<!-- Metadata identifier -->
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block">
      	<xsl:apply-templates mode="simpleElementFop-sensorML"
        	select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name=$ogcID]">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'GeoNetwork-UUID'"/>
				</xsl:apply-templates>
			</xsl:with-param>
    </xsl:call-template>
    
		<!-- Effective date -->
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block">
      	<xsl:apply-templates mode="simpleElementFop"
        	select="sml:member/sml:System/sml:validTime/gml:TimeInstant/gml:timePosition">
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>
			</xsl:with-param>
    </xsl:call-template>

		<!-- Abstract -->
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block">
      	<xsl:apply-templates mode="simpleElementFop-sensorML"
        	select="sml:member/sml:System/gml:description">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="'abstract'"/>
				</xsl:apply-templates>
			</xsl:with-param>
    </xsl:call-template>

		<!-- Title -->
    <xsl:call-template name="blockElementFop">
      <xsl:with-param name="block">
      	<xsl:apply-templates mode="simpleElementFop-sensorML"
        	select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteFullName']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'siteFullName'"/>
				</xsl:apply-templates>
			</xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>

  <xsl:template mode="simpleElementFop-sensorML" match="*">
		<xsl:param name="schema"/>
		<xsl:param name="id"/>

		<xsl:apply-templates mode="simpleElementFop" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
				  <xsl:with-param name="name"   select="name()"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="$id"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="text" select="normalize-space(string())"/>
    </xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
