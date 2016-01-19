<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <!-- Readonly element -->
  <xsl:template mode="mode-iso19139" priority="2000" match="mcp:revisionDate">

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="*"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '')"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
    </xsl:call-template>

  </xsl:template>

	
  <!-- Custom rendering of resource constraints section 
    * gmd:resourceConstraints is boxed element and the title 
    * of the fieldset is the creative commons license name
  -->
  <xsl:template mode="mode-iso19139" priority="33000" match="gmd:resourceConstraints">
    <xsl:param name="schema" select="'iso19139.mcp'" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
		<!-- where is /root/gui/schemas/iso19139.mcp/strings? -->
    <xsl:variable name="resourceConstraintsTitle"
      select="if (mcp:MD_Commons) then 'Creative Commons License' else ''"/>

    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!-- Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. -->
        <xsl:apply-templates mode="render-for-field-for-attribute"
          select="
          @*|
          gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
        select="if ($resourceConstraintsTitle!='') 
                then $resourceConstraintsTitle 
                else gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:apply-templates mode="mode-iso19139" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Creative Commons License Picker -->
  <xsl:template mode="mode-iso19139" match="mcp:MD_Commons" priority="33000">
    <xsl:param name="schema" select="'iso19139.mcp'" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="jurisdictionUrl"
      select="mcp:jurisdictionLink/gmd:URL"/>
    <xsl:variable name="licenseUrl"
      select="mcp:licenseLink/gmd:URL"/>
    <xsl:variable name="licenseImageUrl"
      select="mcp:imageLink/gmd:URL"/>
    <xsl:variable name="licenseName"
      select="mcp:licenseName/gco:CharacterString"/>


    <xsl:variable name="parentName" select="name(..)"/>

		<div>
		 	<label class="col-sm-2 control-label" data-gn-field-tooltip="{$schema}|{name()}|{name(..)}|"><xsl:value-of select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/></label>
		</div>
    <!-- Create a div with the angular directive configuration
            * elementRef: the element ref to edit
            * jurisdictionUrl: current jurisdiction
            * namespace: current mcp namespace
            * licenseName: current license name
            * licenseUrl: current license url
            * licenseImageUrl: current license image url
     -->
    <div data-gn-commons-jurisdiction-selector=""
          data-metadata-id="{$metadataId}"
          data-element-ref="{../gn:element/@ref}"
          data-jurisdiction-url="{$jurisdictionUrl}"
          data-namespace="{namespace-uri()}"
          data-license-name="{$licenseName}"
          data-license-url="{$licenseUrl}"
          data-license-image-url="{$licenseImageUrl}">
		</div>

  </xsl:template>

	<!-- FIXME: Add custom handling for mcp:dataParameters, 
	mcp:metadataContactInfo, mcp:resourceContactInfo
	-->

</xsl:stylesheet>
