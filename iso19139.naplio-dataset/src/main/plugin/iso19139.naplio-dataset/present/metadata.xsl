<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
	xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:napm="http://www.geoconnections.org/nap/napMetadataTools/napXsd/napm"
  xmlns:naplio="http://www.lio.ontario.ca/naplio"
	xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="#all">
	
	<xsl:import href="../../iso19139/present/metadata-fop.xsl"/>
	
	<xsl:template name="iso19139.naplio-datasetBrief">
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
	
	
	<xsl:template name="iso19139.naplio-datasetCompleteTab">
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
	
	
	<xsl:template name="metadata-iso19139.naplio-dataset">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>
		
		<xsl:apply-templates mode="iso19139" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template name="iso19139.naplio-dataset-javascript"/>

  <!-- ================================================================= -->
  <!-- Customize size of controls  -->
  <!-- ================================================================= -->

  <!--
  =====================================================================
  * All elements having gco:CharacterString or gmd:PT_FreeText elements
  have to display multilingual editor widget. Even if default language
  is set, an element could have gmd:PT_FreeText and no gco:CharacterString
  (ie. no value for default metadata language) .
-->
  <xsl:template mode="iso19139"
                match="gmd:*[gco:CharacterString or gmd:PT_FreeText]|
		srv:*[gco:CharacterString or gmd:PT_FreeText]|
		gco:aName[gco:CharacterString]"
      >
    <xsl:param name="schema" />
    <xsl:param name="edit" />

    <!-- Define a rows variable if form element as
      to be a textarea instead of a simple text input.
      This parameter define the number of rows of the textarea. -->
    <xsl:variable name="rows">
      <xsl:choose>
        <xsl:when test="name(.)='gmd:abstract'
        	or name(.)='gmd:maintenanceNote'
        	or name(.)='gmd:useLimitation'
        	or name(.)='gmd:otherConstraints'
          or name(.)='gmd:userNote'">10</xsl:when>
        <xsl:when test="name(.)='gmd:supplementalInformation'
					or name(.)='gmd:purpose'
					or name(.)='gmd:statement'">5</xsl:when>
        <xsl:when test="name(.)='gmd:description'
					or name(.)='gmd:specificUsage'
					or name(.)='gmd:explanation'
					or name(.)='gmd:evaluationMethodDescription'
					or name(.)='gmd:measureDescription'
					or name(.)='gmd:credit'
					or name(.)='gmd:handlingDescription'
					or name(.)='gmd:checkPointDescription'
					or name(.)='gmd:evaluationMethodDescription'
					or name(.)='gmd:measureDescription'
					or name(.)='gmd:organisationName'
					">3</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="localizedCharStringField">
      <xsl:with-param name="schema" select="$schema" />
      <xsl:with-param name="edit" select="$edit" />
      <xsl:with-param name="rows" select="$rows" />
    </xsl:call-template>
  </xsl:template>

  <!-- ================================================================= -->
  <!-- NAPLIO extensions  -->
  <!-- ================================================================= -->

  <xsl:template mode="iso19139" match="naplio:NAPLIO_DataIdentification" priority="10">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:apply-templates mode="complexElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template mode="iso19139" match="naplio:OPS_Extensions">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:apply-templates mode="complexElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="iso19139" match="naplio:*[gco:CharacterString|gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType]">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="iso19139" match="naplio:*[geonet:child/@prefix='gco']">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="iso19139" match="naplio:*[*/@codeList]">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:call-template name="iso19139Codelist">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
