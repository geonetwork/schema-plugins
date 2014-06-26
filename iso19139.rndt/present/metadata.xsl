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

  <!-- ===================================================================== -->
  <!-- Overrides iso19139/metadata template at #1304                         -->
  <!-- Forces format to date only (no time)                                  -->
  <!-- gml:TimePeriod (format = %Y-%m-%d)                                    -->
  <!-- ===================================================================== -->

	<xsl:template mode="iso19139" match="gml:*[gml:beginPosition|gml:endPosition]|gml:TimeInstant[gml:timePosition]" priority="3">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="$edit=true() and (name(.)='gml:beginPosition' or name(.)='gml:endPosition' or name(.)='gml:timePosition')">
					<xsl:apply-templates mode="simpleElement" select=".">
						<xsl:with-param name="schema"  select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="editAttributes" select="$currTab!='rndt' and $currTab!='simple' "/>
						<xsl:with-param name="text">
							<xsl:variable name="ref" select="geonet:element/@ref"/>
							<xsl:variable name="format" select="'%Y-%m-%d'"/>

							<xsl:call-template name="calendar">
								<xsl:with-param name="ref" select="$ref"/>
								<xsl:with-param name="date" select="text()"/>
								<xsl:with-param name="format" select="$format"/>
							</xsl:call-template>

						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="name(.)='gml:timeInterval'">
					<xsl:apply-templates mode="iso19139" select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="simpleElement" select=".">
						<xsl:with-param name="schema"  select="$schema"/>
						<xsl:with-param name="text">
							<xsl:value-of select="text()"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
