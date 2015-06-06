<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">

  <xsl:template name="view-with-header-prov-xml">
    <xsl:param name="tabs"/>
		<xsl:call-template name="md-content">
      <xsl:with-param name="title" select="prov:other/dc:title"/>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract" select="prov:other/dc:description"/>
      <xsl:with-param name="logo"/>
      <xsl:with-param name="relatedResources"/>
      <xsl:with-param name="tabs" select="$tabs"/>
    </xsl:call-template>
  </xsl:template>

  <!-- View templates are available only in view mode and does not provide editing
  capabilities. Template MUST start with "view". -->
  <!-- ===================================================================== -->
  <!-- prov-xml-simple -->
  <xsl:template name="metadata-prov-xmlview-simple" match="metadata-prov-xmlview-simple">

    <xsl:call-template name="view-with-header-prov-xml">
      <xsl:with-param name="tabs">

				<xsl:apply-templates mode="prov-element" select="prov:entity"/>
				<xsl:apply-templates mode="prov-element" select="prov:activity"/>
				<xsl:apply-templates mode="prov-element" select="prov:person"/>
				<xsl:apply-templates mode="prov-element" select="prov:organization"/>
				<xsl:apply-templates mode="prov-element" select="prov:softwareAgent"/>

				<xsl:apply-templates mode="prov-element" select="prov:wasAssociatedWith"/>
				<xsl:apply-templates mode="prov-element" select="prov:wasAttributedTo"/>
				<xsl:apply-templates mode="prov-element" select="prov:actedOnBehalfOf"/>

				<xsl:apply-templates mode="prov-element" select="prov:used"/>
				<xsl:apply-templates mode="prov-element" select="prov:wasGeneratedBy"/>
				<xsl:apply-templates mode="prov-element" select="prov:wasAssociatedWith"/>

				<xsl:apply-templates mode="prov-element" select="prov:wasDerivedFrom"/>

				<xsl:apply-templates mode="prov-element" select="prov:wasStartedBy"/>
				<xsl:apply-templates mode="prov-element" select="prov:wasEndedBy"/>

				<xsl:apply-templates mode="prov-element" select="prov:wasDerivedFrom"/>
				<xsl:apply-templates mode="prov-element" select="prov:specializationOf"/>
				<xsl:apply-templates mode="prov-element" select="prov:alternateOf"/>

				<xsl:apply-templates mode="prov-element" select="prov:other"/>

        <xsl:variable name="modifiedDate" select="prov:other/dct:modified"/>
        <span class="madeBy">
          <xsl:value-of select="/root/gui/strings/changeDate"/>&#160;<xsl:value-of select="$modifiedDate"/> | 
          <xsl:value-of select="/root/gui/strings/uuid"/>&#160;
          <xsl:value-of select="prov:other/dc:identifier"/>
        </span>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

	<!-- box prov container elements with their prov:id and children -->
	<xsl:template mode="prov-element" match="*">
		<xsl:call-template name="complexElementSimpleGui">
			<xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name()"/>
          <xsl:with-param name="schema" select="'prov-xml'"/>
        </xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
      	<xsl:apply-templates mode="prov-xml-simpleattribute" select="@prov:id"/>
        <xsl:apply-templates mode="prov-xml-simpleviewmode" select="*"/>
      </xsl:with-param>
    </xsl:call-template>
	</xsl:template>

	<!-- simple prov elements - may have text or be a reference to a prov container element -->
  <xsl:template mode="prov-xml-simpleviewmode" match="*">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name()"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="helpLink">
        <xsl:call-template name="getHelpLink">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="name" select="name()"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
				<xsl:choose>
					<xsl:when test="@prov:ref">
						<xsl:value-of select="@prov:ref"/>
					</xsl:when>
					<xsl:otherwise>
        		<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <!-- Do not display date modified in this mode as it appears in the footer -->
  <xsl:template mode="prov-xml-simpleviewmode" match="dct:modified"/>

  <!-- prov attributes -->
  <xsl:template mode="prov-xml-simpleattribute" match="@*">
    <xsl:call-template name="simpleElement">
      <xsl:with-param name="id" select="generate-id()"/>
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name()"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="help"></xsl:with-param>
      <xsl:with-param name="content">
				<xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
