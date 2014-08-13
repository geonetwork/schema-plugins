<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
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
    <xsl:param name="schema" select="'iso19139.mcp-2.0'" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
		<!-- where is /root/gui/schemas/iso19139.mcp-2.0/strings? -->
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
    <xsl:param name="schema" select="'iso19139.mcp-2.0'" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="jurisdictionUrl"
      select="mcp:jurisdictionLink/gmd:URL"/>
    <xsl:variable name="licenseUrl"
      select="mcp:licenseLink/gmd:URL"/>
    <xsl:variable name="licenseImageUrl"
      select="mcp:imageLink/gmd:URL"/>
    <xsl:variable name="licenseName"
      select="mcp:licenseName/gco:CharacterString"/>


    <!-- Create custom widget: 
              * '' for item selector, 
              * 'tagsinput' for tags
              * 'tagsinput' and maxTags = 1 for only one tag
              * 'multiplelist' for multiple selection list
    -->
    <xsl:variable name="widgetMode" select="'tagsinput'"/>
    <xsl:variable name="maxTags" select="'1'"/>

		<div>
		 	<label class="col-sm-2 control-label" data-gn-field-tooltip="{$schema}|{name()}|{name(..)}|"><xsl:value-of select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/></label>
		</div>
    <!-- Create a div with the angular directive configuration
            * widgetMode: the layout to use
            * elementRef: the element ref to edit
            * jurisdictionUrl: current jurisdiction
            * licenseName: current license name
            * licenseUrl: current license url
            * licenseImageUrl: current license image url
     -->
    <div data-gn-commons-jurisdiction-selector="{$widgetMode}"
          data-metadata-id="{$metadataId}"
          data-element-ref="{../gn:element/@ref}"
          data-jurisdiction-url="{$jurisdictionUrl}"
          data-license-name="{$licenseName}"
          data-license-url="{$licenseUrl}"
          data-license-image-url="{$licenseImageUrl}">
		</div>

  </xsl:template>

<!--
				<mcp:parameterName>
          <mcp:DP_Term>
            <mcp:term>
              <gco:CharacterString>t</gco:CharacterString>
            </mcp:term>
            <mcp:type>
              <mcp:DP_TypeCode
          codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_TypeCode"
          codeListValue="shortName">shortName</mcp:DP_TypeCode>
            </mcp:type>
            <mcp:usedInDataset>
              <gco:Boolean>1</gco:Boolean>
            </mcp:usedInDataset>
            <mcp:vocabularyRelationship>
              <mcp:DP_VocabularyRelationship>
                <mcp:relationshipType>
                  <mcp:DP_RelationshipTypeCode
          codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_RelationshipTypeCode"
          codeListValue="skos:exactmatch">skos:exactmatch</mcp:DP_RelationshipTypeCode>
                </mcp:relationshipType>
                <mcp:vocabularyTermURL>
                 <gmd:URL>http://www.imos.org.au/vocabserver?code=temperature&vocab=oceanography</gmd:URL>
                </mcp:vocabularyTermURL>
                <mcp:vocabularyListURL>
                 <gmd:URL>http://www.imos.org.au/vocabserver?vocab=oceanography</gmd:URL>
                </mcp:vocabularyListURL>
                <mcp:vocabularyListVersion>
                  <gco:CharacterString>3.6</gco:CharacterString>
                </mcp:vocabularyListVersion>
              </mcp:DP_VocabularyRelationship>
            </mcp:vocabularyRelationship>
          </mcp:DP_Term>
        </mcp:parameterName>
-->
	
  <!-- Custom rendering of mcp:parameterName|mcp:parameterUnits section 
    * mcp:parameterName|mcp:parameterUnits is boxed element and the title 
    of the fieldset is mcp:parameterName (thesaurus title) or 
    mcp:parameterUnits (thesaurus title)
    * if the thesaurus is available in the catalog, display
    the advanced editor which provides easy selection of 
    keywords.
  
  -->


  <xsl:template mode="mode-iso19139" priority="9999999" match="mcp:parameterName|mcp:parameterUnits">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="thesaurusUrl"
      select="mcp:DP_Term/mcp:vocabularyRelationship/mcp:DP_VocabularyRelationship/mcp:vocabularyListURL/gmd:URL"/>

    <xsl:variable name="isThesaurusAvailable"
      select="count($listOfThesaurus/thesaurus[url=$thesaurusUrl]) > 0"/>

		<xsl:variable name="thesaurusTitle" select="if ($isThesaurusAvailable) then
									$listOfThesaurus/thesaurus[url=$thesaurusUrl]/title
									else 'Thesaurus Not Available'"/>

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
        select="concat(gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label,' (',$thesaurusTitle,')')"/>
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

	<!-- Offer a thesaurus picker for mcp:DP_Term -->

  <xsl:template mode="mode-iso19139" match="mcp:DP_Term" priority="9999999">

    <xsl:variable name="thesaurusUrl"
      select="mcp:vocabularyRelationship/mcp:DP_VocabularyRelationship/mcp:vocabularyListURL/gmd:URL"/>

    <xsl:variable name="isThesaurusAvailable"
      select="count($listOfThesaurus/thesaurus[url=$thesaurusUrl]) > 0"/>
    <xsl:choose>
      <xsl:when test="$isThesaurusAvailable">

        <!-- The thesaurus key is in the list of thesauri based on its url -->
        <xsl:variable name="thesaurusInternalKey"
          select="$listOfThesaurus/thesaurus[url=$thesaurusUrl]/key"/>
        <xsl:variable name="thesaurusKey"
                      select="if (starts-with($thesaurusInternalKey, 'geonetwork.thesaurus.'))
                      then substring-after($thesaurusInternalKey, 'geonetwork.thesaurus.')
                      else $thesaurusInternalKey"/>

        <xsl:variable name="params" select="string-join(mcp:term/*[1], '`')"/>

        <!-- Define the list of transformation mode available. -->
        <xsl:variable name="transformations">to-mcp-dataparameterterm</xsl:variable>

        <!-- Get current transformation mode (could be based on XML fragment 
             analysis but not in this case - only one mode) -->
				<!-- default if no keywords (ie. new block) is to-mcp-dataparameterterm -->
        <xsl:variable name="transformation" select="'to-mcp-dataparameterterm'"/> 

        <!-- Create custom widget: 
              * '' for item selector, 
              * 'tagsinput' for tags
              * 'tagsinput' and maxTags = 1 for only one tag
              * 'multiplelist' for multiple selection list
        -->
        <xsl:variable name="widgetMode" select="'tagsinput'"/>
        <xsl:variable name="maxTags" select="'1'"/>

        <!-- Create a div with the directive configuration
            * widgetMod: the layout to use
            * elementRef: the element ref to edit
            * elementName: the element name
            * thesaurusName: the thesaurus title to use
            * thesaurusKey: the thesaurus identifier
            * keywords: list of keywords in the element
            * transformations: list of transformations
            * transformation: current transformation
          -->
        <div data-gn-keyword-selector="{$widgetMode}"
          data-metadata-id="{$metadataId}"
          data-element-ref="{concat('_X', ../gn:element/@ref)}"
          data-thesaurus-title="{$thesaurusKey}"
          data-thesaurus-key="{$thesaurusKey}"
          data-keywords="{$params}" data-transformations="{$transformations}"
          data-current-transformation="{$transformation}"
          data-max-tags="{$maxTags}">
        </div>

      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mode-iso19139" select="*"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
