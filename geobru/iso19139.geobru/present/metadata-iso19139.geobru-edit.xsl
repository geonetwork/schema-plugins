<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:geobru="http://geobru.irisnet.be"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="gmx xsi gmd gco gml gts srv xlink exslt geonet">

	<xsl:include href="metadata-iso19139.geobru-view.xsl"/>

	<!-- heikki: changed name to iso19139.geobruCompleteTab -->
	<xsl:template name="iso19139.geobruCompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>
			
		<xsl:call-template name="iso19139CompleteTab">
		  <xsl:with-param name="tabLink" select="$tabLink"/>
		  <xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>
    
	</xsl:template>
  
	<xsl:template mode="iso19139" match="geobru:*[gco:CharacterString|gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>
 <xsl:template name="metadata-iso19139.geobru">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>
		
		<xsl:apply-templates mode="iso19139" select="." >
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded" />
		</xsl:apply-templates>
	</xsl:template> 
</xsl:stylesheet>
