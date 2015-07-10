<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
  xmlns:gn="http://www.fao.org/geonetwork"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core" 
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>
  <xsl:include href="layout-custom-fields.xsl"/>

  <!-- Visit all XML tree recursively - prov and proviso namespaces get funnelled off in mode-prov-xml -->
  <xsl:template mode="mode-prov-xml" match="prov:*|dct:*|dc:*" priority="2">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-prov-xml" select="*|@*">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Ignore all gn element -->
  <xsl:template mode="mode-prov-xml" match="gn:*|@gn:*|@*" priority="1000"/>


  <!-- Template to display non existing element ie. geonet:child element
	of the metadocument. Display in editing mode only and if
  the editor mode is not flat mode. -->
  <xsl:template mode="mode-prov-xml" match="gn:child" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

		<xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
		<xsl:variable name="flatModeException" select="gn-fn-metadata:getFieldFlatModeException($viewConfig, $name)"/>

    <!-- TODO: this should be common to all schemas -->
    <xsl:if test="$isEditing and (not($isFlatMode) or $flatModeException)">

      <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>

      <xsl:call-template name="render-element-to-add">
        <!-- TODO: add xpath and isoType to get label ? -->
        <xsl:with-param name="label"
                        select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
        <xsl:with-param name="directive" select="$directive"/>
				<xsl:with-param name="directiveAttributes" select="gn-fn-metadata:getFieldDirectiveAttributes($editorConfig, $name)"/>
        <xsl:with-param name="childEditInfo" select="."/>
        <xsl:with-param name="parentEditInfo" select="../gn:element"/>
        <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Boxed element

      Details about the last line :
      * namespace-uri(.) != $gnUri: Only take into account profile's element
      * and $isFlatMode = false(): In flat mode, don't box any
  -->
  <xsl:template mode="mode-prov-xml" priority="200"
                match="*[name() = $editorConfig/editor/fieldsWithFieldset/name]|
                        *[namespace-uri(.) != $gnUri and $isFlatMode = false()]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>

    <xsl:variable name="attributes">
      <!-- Create form for all existing attribute (not in gn namespace)
      and all non existing attributes not already present. -->
      <xsl:apply-templates mode="render-for-field-for-attribute" select="@*|gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="gn:element/@ref"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
                      select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <!-- Process child of those element. Propagate schema
        and labels to all subchilds (eg. needed like iso19110 elements
        contains gmd:* child. -->
        <xsl:apply-templates mode="mode-prov-xml" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="mode-prov-xml" priority="400" match="prov:time|prov:startTime|prov:endTime">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels)"/>

    <div data-gn-date-picker="{.}"
				 data-tag-name=""
         data-label="{$labelConfig/label}"
         data-element-name="{name()}"
         data-element-ref="{concat('_', gn:element/@ref)}"
				 data-namespaces='{{ "prov": "http://www.w3.org/ns/prov#" }}'>
    </div>
  </xsl:template>


  <!-- prov: elements that don't have children -->
  <xsl:template mode="mode-prov-xml" match="prov:*[count(.//gn:element) = 1]|dc:*|dct:*" priority="200">
    <xsl:variable name="name" select="name(.)"/>

    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, $name, $labels)"/>
    <xsl:variable name="helper" select="gn-fn-metadata:getHelper($labelConfig/helper, .)"/>

    <xsl:variable name="added" select="parent::node()/parent::node()/@gn:addedObj"/>
    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig/label"/>
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '')"/>
      <xsl:with-param name="name" select="if ($isEditing) then gn:element/@ref else ''"/>
      <xsl:with-param name="editInfo"
                      select="gn:element"/>
      <xsl:with-param name="listOfValues" select="$helper"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
