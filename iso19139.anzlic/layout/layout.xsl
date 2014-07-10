<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core" 
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>

  <xsl:variable name="iso19139.anzlicschema" select="/root/gui/schemas/iso19139.anzlic"/>
  <xsl:variable name="iso19139.anzliclabels" select="$iso19139.anzlicschema/labels"/>
  <xsl:variable name="iso19139.anzliccodelists" select="$iso19139.anzlicschema/codelists"/>
  <xsl:variable name="iso19139.anzlicstrings" select="$iso19139.anzlicschema/strings"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19139.anzlic" match="*|@*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$iso19139.anzliclabels" required="no"/>

    <xsl:apply-templates mode="mode-iso19139" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Match codelist values. Must use iso19139.anzlic because some 
	     19139 codelists are extended in anzlic - if the codelist exists in
			 iso19139.anzlic then use that otherwise use iso19139 codelists 
  
  eg. 
  <gmd:CI_RoleCode codeList="./resources/codeList.xml#CI_RoleCode" codeListValue="pointOfContact">
    <geonet:element ref="42" parent="41" uuid="gmd:CI_RoleCode_e75c8ec6-b994-4e98-b7c8-ecb48bda3725" min="1" max="1"/>
    <geonet:attribute name="codeList"/>
    <geonet:attribute name="codeListValue"/>
    <geonet:attribute name="codeSpace" add="true"/>
  
  -->
  <xsl:template mode="mode-iso19139" priority="30000" match="*[*/@codeList and $schema='iso19139.anzlic']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$iso19139.anzliccodelists" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>

		<!-- check iso19139.anzlic first, then fall back to iso19139 -->
		<xsl:variable name="listOfValues" as="node()">
			<xsl:variable name="anzlicList" as="node()" select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
			<xsl:choose>
				<xsl:when test="count($anzlicList/*)=0"> <!-- do iso19139 -->
					<xsl:copy-of select="gn-fn-metadata:getCodeListValues('iso19139', name(*[@codeListValue]), $iso19139codelists, .)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$anzlicList"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>				

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="value" select="*/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
        select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues" select="$listOfValues"/>
      <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>

  </xsl:template>

	<!--
    Take care of enumerations. Same as for codelists, check iso19139.anzlic
		first and if not found there, then check iso19139.
    
    In the metadocument an enumeration provide the list of possible values:
  <gmd:topicCategory>
    <gmd:MD_TopicCategoryCode>
    <geonet:element ref="69" parent="68" uuid="gmd:MD_TopicCategoryCode_0073afa8-bc8f-4c52-94f3-28d3aa686772" min="1" max="1">
      <geonet:text value="farming"/>
      <geonet:text value="biota"/>
      <geonet:text value="boundaries"/
  -->
  <xsl:template mode="mode-iso19139" priority="30000" match="*[gn:element/gn:text and $schema='iso19139.anzlic']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$iso19139.anzliccodelists" required="no"/>

		<!-- check iso19139.anzlic first, then fall back to iso19139 -->
		<xsl:variable name="listOfValues" as="node()">
			<xsl:variable name="anzlicList" as="node()" select="gn-fn-metadata:getCodeListValues($schema, name(), $codelists, .)"/>
			<xsl:choose>
				<xsl:when test="count($anzlicList/*)=0"> <!-- do iso19139 -->
					<xsl:copy-of select="gn-fn-metadata:getCodeListValues('iso19139', name(), $iso19139codelists, .)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$anzlicList"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>				

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(..), $labels, name(../..), '', '')/label"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="listOfValues" select="$listOfValues"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
