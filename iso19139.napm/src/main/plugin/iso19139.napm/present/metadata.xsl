<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
	xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:napm="http://www.geoconnections.org/nap/napMetadataTools/napXsd/napm"
	xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="#all">
	
	<xsl:import href="../../iso19139/present/metadata-iso19139-fop.xsl"/>
	
	<xsl:template name="iso19139.napmBrief">
		<metadata>
			<xsl:choose>
				<xsl:when test="geonet:info/isTemplate='s'">
					<xsl:call-template name="iso19139-subtemplate"/>
					<xsl:copy-of select="geonet:info" copy-namespaces="no"/>
				</xsl:when>
				<xsl:otherwise>
					
					<!-- call iso19139 brief -->
					<xsl:call-template name="iso19139-brief"/>
				</xsl:otherwise>
			</xsl:choose>
		</metadata>
	</xsl:template>
	
	
	<xsl:template name="iso19139.napmCompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

    <!--<xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>-->

    <!-- Don't delegate to iso19139, to don't display the INSPIRE view, even if enabled in settings -->
    <xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
      <xsl:call-template name="displayTab">
        <xsl:with-param name="tab"     select="'groups'"/> <!-- just a non-existing tab -->
        <xsl:with-param name="text"    select="/root/gui/strings/byGroup"/>
        <xsl:with-param name="tabLink" select="''"/>
      </xsl:call-template>

      <xsl:call-template name="displayTab">
        <xsl:with-param name="tab"     select="'ISOMinimum'"/>
        <xsl:with-param name="text"    select="/root/gui/strings/isoMinimum"/>
        <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
        <xsl:with-param name="tabLink" select="$tabLink"/>
      </xsl:call-template>

      <xsl:call-template name="displayTab">
        <xsl:with-param name="tab"     select="'ISOCore'"/>
        <xsl:with-param name="text"    select="/root/gui/strings/isoCore"/>
        <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
        <xsl:with-param name="tabLink" select="$tabLink"/>
      </xsl:call-template>

      <xsl:call-template name="displayTab">
        <xsl:with-param name="tab"     select="'ISOAll'"/>
        <xsl:with-param name="text"    select="/root/gui/strings/isoAll"/>
        <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
        <xsl:with-param name="tabLink" select="$tabLink"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="/root/gui/config/metadata-tab/advanced">
      <xsl:call-template name="displayTab">
        <xsl:with-param name="tab"     select="'packages'"/> <!-- just a non-existing tab -->
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
    </xsl:if>
	</xsl:template>
	
	
	<xsl:template name="metadata-iso19139.napli">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>
		
		<xsl:apply-templates mode="iso19139" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template name="iso19139.napm-javascript"/>
</xsl:stylesheet>
