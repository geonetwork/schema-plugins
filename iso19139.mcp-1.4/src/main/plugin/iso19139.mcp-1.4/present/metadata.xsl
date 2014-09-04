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

	<xsl:import href="metadata-fop.xsl"/>

	<!-- main template - the way into processing iso19139.mcp-1.4 -->
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

		<xsl:call-template name="displayTab"> <!-- non existent tab - by profile -->
			<xsl:with-param name="tab"     select="''"/>
			<xsl:with-param name="text"    select="/root/gui/strings/byGroup"/>
			<xsl:with-param name="tabLink" select="''"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'mcpMinimum'"/>
			<xsl:with-param name="text"    select="'MCP Minimum'"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'mcpCore'"/>
			<xsl:with-param name="text"    select="'MCP Core'"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'complete'"/>
			<xsl:with-param name="text"    select="'MCP All'"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab"> <!-- non existent tab - by groups -->
			<xsl:with-param name="tab"     select="''"/>
			<xsl:with-param name="text"    select="/root/gui/strings/byPackage"/>
			<xsl:with-param name="tabLink" select="''"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'metadata'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/metadata"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'identification'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/identificationTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'temporalExtent'"/>
			<xsl:with-param name="text"    select="/root/gui/schemas/iso19139.mcp-1.4/strings/temporalExtentTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
			<xsl:with-param name="highlighted" select="true()"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'spatialExtent'"/>
			<xsl:with-param name="text"    select="/root/gui/schemas/iso19139.mcp-1.4/strings/spatialExtentTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
			<xsl:with-param name="highlighted" select="true()"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'maintenance'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/maintenanceTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'constraints'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/constraintsTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'spatial'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/spatialTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'refSys'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/refSysTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'distribution'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/distributionTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'dataQuality'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/dataQualityTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'appSchInfo'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/appSchInfoTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'porCatInfo'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/porCatInfoTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'contentInfo'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/contentInfoTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="displayTab">
			<xsl:with-param name="tab"     select="'extensionInfo'"/>
			<xsl:with-param name="text"    select="/root/gui/strings/extensionInfoTab"/>
			<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ===================================================================== -->
  <!-- === iso19139.mcp-1.4 brief formatting - same as iso19139.mcp      === -->
  <!-- ===================================================================== -->

	<xsl:template name="iso19139.mcp-1.4Brief">
		<metadata>
				<xsl:choose>
					<xsl:when test="geonet:info/isTemplate='s'">
						<xsl:call-template name="iso19139.mcp-subtemplate"/>
						<xsl:copy-of select="geonet:info" copy-namespaces="no"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- call iso19139 brief -->
	 					<xsl:call-template name="iso19139-brief"/>
						<!-- now brief elements for mcp specific elements -->
						<xsl:call-template name="iso19139.mcp-brief"/>
					</xsl:otherwise>
				</xsl:choose>
		</metadata>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT          -->
	<!-- =================================================================== -->
	<xsl:template name="iso19139.mcp-1.4-javascript">
		<xsl:call-template name="iso19139.mcp-javascript"/>
	</xsl:template>

</xsl:stylesheet>
