<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:grg="http://www.isotc211.org/2005/grg"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                exclude-result-prefixes="#all">


  <!-- Create a table of content of list of items

  TODO: Create a TOC based on status ?
  -->

	<xsl:variable name="requestParameters">
		<tocIndex></tocIndex> <!-- empty for now -->
	</xsl:variable>

  <xsl:template name="iso19135-table-of-content">
    <hr/>
    <xsl:variable name="items" select="$metadata//grg:RE_RegisterItem/grg:name/gco:CharacterString"/>
    <xsl:variable name="currentLetter"
                  select="if ($requestParameters/tocIndex != '' and
                            count($metadata//grg:RE_RegisterItem[
                              starts-with(grg:name/gco:CharacterString, $requestParameters/tocIndex)]) > 0)
                          then $requestParameters/tocIndex
                          else substring(upper-case($items[1]), 1, 1)"/>

    <xsl:for-each-group select="$items"
                        group-by="substring(upper-case(.), 1, 1)">
      <xsl:sort select="current-grouping-key()"/>

      <xsl:variable name="label">
        <xsl:value-of select="current-grouping-key()"/>(<xsl:value-of select="count(current-group())"/>)
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="current-grouping-key() = $currentLetter">
          <xsl:value-of select="$label"/>
        </xsl:when>
        <xsl:otherwise>
          <a data-ng-click="tocIndex = '{current-grouping-key()}'"><xsl:value-of select="$label"/></a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="position() != last()"> - </xsl:if>
    </xsl:for-each-group>
    <hr/>
    <input name="tocIndex" type="text" class="hidden" value="{$currentLetter}"
           data-ng-model="tocIndex"/>



    <!-- Display items according to the letter -->
    <xsl:apply-templates
        select="$metadata//grg:containedItem[starts-with(grg:RE_RegisterItem/grg:name/gco:CharacterString, $currentLetter)]"
        mode="mode-iso19135"
        />
  </xsl:template>


  <!-- TODO : improve editor in simple mode -->
  <xsl:template mode="mode-iso19135"
                match="grg:fieldOfApplication[$tab='default']"
                priority="2000"
      ></xsl:template>

  <xsl:template mode="mode-iso19135"
                match="grg:specificationLineage[$tab='default']"
                priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$codelists" required="no"/>

    <xsl:variable name="listOfRelations"
                  select="gn-fn-metadata:getCodeListValues($schema, 'grg:RE_SimilarityToSource', $codelists, .)"/>
    <xsl:variable name="typeOfRelation"
                  select="grg:RE_Reference/grg:similarity/grg:RE_SimilarityToSource"/>
    <xsl:variable name="itemIdentifier" select="grg:RE_Reference/grg:itemIdentifierAtSource/gco:CharacterString"/>

    <div class="form-group">
      <label class="col-sm-2 control-label">
        <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'grg:specificationLineage', $labels)/label"/>
      </label>
      <div class="col-sm-3">
        <xsl:value-of select="$typeOfRelation"/>
        <select name="_{$typeOfRelation/gn:element/@ref}_codeListValue">
          <xsl:for-each select="$listOfRelations/entry">
            <option value="{code}">
              <xsl:if test="code = $typeOfRelation/@codeListValue">
                <xsl:attribute name="selected" select="'selected'"/>
              </xsl:if>
              <xsl:value-of select="label"/>
            </option>
          </xsl:for-each>
        </select>
      </div>
      <div class="col-sm-5">
        <select name="_{$itemIdentifier/gn:element/@ref}">
          <xsl:for-each select="$metadata//grg:RE_RegisterItem">
            <option value="{grg:itemIdentifier/gco:Integer/text()}">
              <xsl:if test="$itemIdentifier/text() = grg:itemIdentifier/gco:Integer/text()">
                <xsl:attribute name="selected" select="'selected'"/>
              </xsl:if>
              <xsl:value-of select="grg:name/gco:CharacterString"/>
            </option>
          </xsl:for-each>
        </select>
      </div>
      <div class="col-sm-2 gn-control">

      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
