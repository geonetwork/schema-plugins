<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:sdn="http://www.seadatanet.org" xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="#all">

  <!-- Simple views is ISO19139 -->
  <xsl:template name="metadata-iso19139.sdn-cdiview-simple">
    <xsl:call-template name="metadata-iso19139view-simple"/>
  </xsl:template>

  <xsl:template name="view-with-header-iso19139.sdn-cdi">
    <xsl:param name="tabs"/>

    <xsl:call-template name="view-with-header-iso19139">
      <xsl:with-param name="tabs" select="$tabs"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="metadata-iso19139.sdn-cdi" match="metadata-iso19139.sdn-cdi">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

    <!-- process in profile mode first -->
    <xsl:variable name="profileElements">
      <xsl:apply-templates mode="iso19139.sdn-cdi" select=".">
        <xsl:with-param name="schema" select="$schema"/>
        <xsl:with-param name="edit" select="$edit"/>
        <xsl:with-param name="embedded" select="$embedded"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:choose>
      <!-- if we got a match in profile mode then show it -->
      <xsl:when test="count($profileElements/*)>0">
        <xsl:copy-of select="$profileElements"/>
      </xsl:when>
      <!-- otherwise process in base iso19139 mode -->
      <xsl:otherwise>
        <xsl:apply-templates mode="iso19139" select=".">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="embedded" select="$embedded"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template mode="iso19139.sdn-cdi" match="sdn:*[gco:Integer|gco:Decimal|gco:Boolean|gco:Real]">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="iso19139.sdn-cdi" match="sdn:SDN_ParameterDiscoveryCode|sdn:SDN_DeviceCategoryCode|sdn:SDN_PlatformCategoryCode">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>
  

  <xsl:template mode="iso19139.sdn-cdi" match="sdn:*"/>

  <xsl:template name="iso19139.sdn-cdiCompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>
    <xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>
  </xsl:template>



  <!-- FIXIME : this could be iso19139 ? -->
  <xsl:template mode="iso19139.sdn-cdi" match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']"
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

      <!-- INSPIRE tab -->
      <xsl:when test="$currTab='inspire'">
        <xsl:call-template name="inspiretabs">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
        </xsl:call-template>
      </xsl:when>
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
  
  
  
  
  <!-- Properly display sdn codelist ?
  sdn:SDN_EDMEDCode
  sdn:SDN_FormatNameCode
  -->
  
  
  
  
  <!-- Properly display sdn:* in gmd:keywords -->
  <xsl:template mode="iso19139.sdn-cdi" match="gmd:MD_Keywords" priority="90">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:choose>
      <xsl:when test="$edit=true()">
        <xsl:apply-templates mode="iso19139" select=".">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        
        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="title">
            <xsl:call-template name="getTitle">
              <xsl:with-param name="name" select="name(.)"/>
              <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
            <xsl:if test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString">
              (<xsl:value-of
                select="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>)
            </xsl:if>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:call-template name="keyword-make-list"/>
          </xsl:with-param>
        </xsl:apply-templates>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template mode="block" match="gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords"
    priority="91">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
        
        <xsl:if test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString">
          (<xsl:value-of
            select="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>)
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="helpLink">
        <xsl:call-template name="getHelpLink">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="name" select="name(.)"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:call-template name="keyword-make-list"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template name="keyword-make-list">
    <xsl:for-each select="gmd:keyword">
      <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
      
      
      <xsl:choose>
        <xsl:when test="gmx:Anchor">
          <a href="{gmx:Anchor/@xlink:href}"><xsl:value-of select="if (gmx:Anchor/text()) then gmx:Anchor/text() else gmx:Anchor/@xlink:href"/></a>
        </xsl:when>
        <xsl:when test="sdn:*">
          <xsl:value-of select="*/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="translatedString">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="langId">
              <xsl:call-template name="getLangId">
                <xsl:with-param name="langGui" select="/root/gui/language"/>
                <xsl:with-param name="md" select="ancestor-or-self::*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']" />
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:for-each>
    <xsl:if test="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue">
      (<xsl:value-of
        select="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/>)
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
