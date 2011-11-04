<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:exslt="http://exslt.org/common"
	xmlns:geonet="http://www.fao.org/geonetwork"
	exclude-result-prefixes="gmx gmd gco gml srv xlink exslt geonet">

	<!-- main template - the way into processing iso19139.mcp-1.4 -->
	<xsl:template name="metadata-iso19139.mcp-1.4-simple">
	  <xsl:call-template name="metadata-iso19139view-simple"/>
	</xsl:template>

  <xsl:template name="metadata-iso19139.mcp-1.4">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

		<!-- process in iso19139.mcp profile mode first -->
    <xsl:variable name="mcpElements">
      <xsl:apply-templates mode="iso19139.mcp" select="." >
        <xsl:with-param name="schema" select="$schema"/>
        <xsl:with-param name="edit"   select="$edit"/>
        <xsl:with-param name="embedded" select="$embedded" />
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:choose>

      <!-- if we got a match in profile mode then show it -->
      <xsl:when test="count($mcpElements/*)>0">
        <xsl:copy-of select="$mcpElements"/>
      </xsl:when>

      <!-- otherwise process in base iso19139 mode -->
      <xsl:otherwise>
        <xsl:apply-templates mode="iso19139" select="." >
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
          <xsl:with-param name="embedded" select="$embedded" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

	<!-- CompleteTab template - iso19139.mcp-1.4 has its own set of tabs - same 
	     as iso19139.mcp -->
	<xsl:template name="iso19139.mcp-1.4CompleteTab">
		<xsl:param name="tabLink"/>

		<xsl:call-template name="iso19139.mcpCompleteTab">
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ===================================================================== -->
  <!-- === iso19139.mcp-1.4 brief formatting - same as iso19139.mcp      === -->
  <!-- ===================================================================== -->

	<xsl:template match="iso19139.mcp-1.4Brief">
		<metadata>
   		<xsl:for-each select="/metadata/*[1]">
				<!-- call iso19139 brief -->
	 			<xsl:call-template name="iso19139-brief"/>
				<!-- now brief elements for mcp specific elements -->
				<xsl:call-template name="iso19139.mcp-brief"/>
	 		</xsl:for-each>
		</metadata>
	</xsl:template>

</xsl:stylesheet>
