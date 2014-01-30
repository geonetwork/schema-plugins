<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" 
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" 
	xmlns:gmx="http://www.isotc211.org/2005/gmx" 
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork" 
	xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">

  <xsl:import href="metadata-fop.xsl"/>
  <xsl:include href="metadata-rndt.xsl"/>
  <xsl:include href="metadata-view.xsl"/>  
  <xsl:include href="metadata-ovr.xsl"/>
	
  <xsl:template name="iso19139.rndtCompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>
  	
  	<!-- RNDT tab -->
  	<xsl:call-template name="displayTab">
  		<xsl:with-param name="tab"     select="'rndt'"/>
  		<xsl:with-param name="text"    select="/root/gui/schemas/iso19139.rndt/strings/rndtTab"/>
  		<xsl:with-param name="tabLink" select="$tabLink"/>
  	</xsl:call-template>  	
  	
    <xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
