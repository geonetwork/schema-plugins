<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:exslt="http://exslt.org/common"
  xmlns:napm="http://www.geoconnections.org/nap/napMetadataTools/napXsd/napm"
  xmlns:naplio="http://www.lio.ontario.ca/naplio"
  exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet napm naplio">

  <!-- Simple views is ISO19139 -->
  <xsl:template name="metadata-iso19139.naplio-datasetview-simple">
    <xsl:call-template name="metadata-iso19139view-simple"/>
  </xsl:template>

  <xsl:template name="view-with-header-iso19139.naplio-dataset">
    <xsl:param name="tabs"/>

    <xsl:call-template name="view-with-header-iso19139">
      <xsl:with-param name="tabs" select="$tabs"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Tab configuration -->
  <xsl:template name="iso19139.naplio-datasetCompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>

    <!-- Add custom tab if a custom view is needed -->
    <!--<xsl:call-template name="mainTab">
      <xsl:with-param name="title" select="/root/gui/schemas/*[name()=$schema]/strings/xyzTab"/>
      <xsl:with-param name="default">xyzTabDiscovery</xsl:with-param>
      <xsl:with-param name="menu">
        <item label="xyzTabDiscovery">xyzTabDiscovery</item>
        ...
      </xsl:with-param>
    </xsl:call-template>
    -->


    <!-- Don't delegate to iso19139 complete tabs  to avoid displaying INSPIRE view -->
    <!--<xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>-->

    <xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byGroup"/>
        <xsl:with-param name="default">ISOCore</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="isoMinimum">ISOMinimum</item>
          <item label="isoCore">ISOCore</item>
          <item label="isoAll">ISOAll</item>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>



    <xsl:if test="/root/gui/config/metadata-tab/advanced">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byPackage"/>
        <xsl:with-param name="default">identification</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="metadata">metadata</item>
          <item label="identificationTab">identification</item>
          <item label="maintenanceTab">maintenance</item>
          <item label="constraintsTab">constraints</item>
          <item label="spatialTab">spatial</item>
          <item label="refSysTab">refSys</item>
          <item label="distributionTab">distribution</item>
          <item label="dataQualityTab">dataQuality</item>
          <item label="appSchInfoTab">appSchInfo</item>
          <item label="porCatInfoTab">porCatInfo</item>
          <item label="contentInfoTab">contentInfo</item>
          <item label="extensionInfoTab">extensionInfo</item>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <!-- Based template for dispatching each tabs -->
  <xsl:template mode="iso19139.naplio-dataset" match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']"
    priority="3">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="embedded"/>

    <xsl:variable name="dataset"
      select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>
    <xsl:choose>

      <!-- metadata tab -->
      <xsl:when test="$currTab='metadata'">
        <xsl:call-template name="iso19139Metadata">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:call-template>
      </xsl:when>

      <!-- identification tab -->
      <xsl:when test="$currTab='identification'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- maintenance tab -->
      <xsl:when test="$currTab='maintenance'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- constraints tab -->
      <xsl:when test="$currTab='constraints'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- spatial tab -->
      <xsl:when test="$currTab='spatial'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- refSys tab -->
      <xsl:when test="$currTab='refSys'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- distribution tab -->
      <xsl:when test="$currTab='distribution'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- embedded distribution tab -->
      <xsl:when test="$currTab='distribution2'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- dataQuality tab -->
      <xsl:when test="$currTab='dataQuality'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- appSchInfo tab -->
      <xsl:when test="$currTab='appSchInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- porCatInfo tab -->
      <xsl:when test="$currTab='porCatInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- contentInfo tab -->
      <xsl:when test="$currTab='contentInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- extensionInfo tab -->
      <xsl:when test="$currTab='extensionInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- ISOMinimum tab -->
      <xsl:when test="$currTab='ISOMinimum'">
        <xsl:call-template name="isotabs">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
          <xsl:with-param name="core" select="false()"/>
        </xsl:call-template>
      </xsl:when>

      <!-- ISOCore tab -->
      <xsl:when test="$currTab='ISOCore'">
        <xsl:call-template name="isotabs">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
          <xsl:with-param name="core" select="true()"/>
        </xsl:call-template>
      </xsl:when>

      <!-- ISOAll tab -->
      <xsl:when test="$currTab='ISOAll'">
        <xsl:call-template name="iso19139Complete">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:call-template>
      </xsl:when>

      <!--
        Register your custom tabs here and create the related template
        <xsl:when test="$currTab='xyzTabDiscovery'">
        <xsl:call-template name="xyzTabDiscovery">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
        </xsl:call-template>
      </xsl:when>-->
      <!-- default -->
      <xsl:otherwise>
        <xsl:call-template name="iso19139Simple">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="flat"
            select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Custom tab -->
  <!--<xsl:template name="xyzTabDiscovery">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="dataset"/>
    <xsl:param name="core"/>
    
    <!-\- Do something ... -\->
  </xsl:template>
-->

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

    <!-- Define a class variable if form element as
      to be a textarea instead of a simple text input.
      This parameter define the class of the textarea (see CSS). -->
    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="name(.)='gmd:title' and name(../../../..)='gmd:identificationInfo'">title</xsl:when>
        <xsl:when test="name(.)='gmd:abstract'
          or name(.)='gmd:maintenanceNote'
        	or name(.)='gmd:useLimitation'
        	or name(.)='gmd:otherConstraints'
          or name(.)='gmd:userNote'">large</xsl:when>
        <xsl:when test="name(.)='gmd:supplementalInformation'
          or name(.)='gmd:purpose'
          or name(.)='gmd:orderingInstructions'
          or name(.)='gmd:statement'">medium</xsl:when>
        <xsl:when test="name(.)='gmd:description'
          or name(.)='gmd:specificUsage'
          or name(.)='gmd:explanation'
          or name(.)='gmd:credit'
          or name(.)='gmd:evaluationMethodDescription'
          or name(.)='gmd:measureDescription'
          or name(.)='gmd:handlingDescription'
          or name(.)='gmd:checkPointDescription'
          or name(.)='gmd:evaluationMethodDescription'
          or name(.)='gmd:measureDescription'
          or name(.)='gmd:organisationName'
          ">small</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="localizedCharStringField">
      <xsl:with-param name="schema" select="$schema" />
      <xsl:with-param name="edit" select="$edit" />
      <xsl:with-param name="class" select="$class" />
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
