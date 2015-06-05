<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:dc="http://purl.org/dc/elements/1.1/"
								xmlns:dct="http://purl.org/dc/terms/"
								xmlns:prov="http://www.w3.org/ns/prov#"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="#all">

	<xsl:include href="metadata-utils.xsl"/>
  <xsl:include href="metadata-subtemplates.xsl"/>
  <xsl:include href="metadata-view.xsl"/>

  <xsl:template name="prov-xmlCompleteTab"/>

  <!-- main template - the way into processing prov-xml -->
  <xsl:template name="metadata-prov-xml">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

    <xsl:apply-templates mode="prov-xml" select="." >
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="embedded" select="$embedded" />
    </xsl:apply-templates>
  </xsl:template>

	<!-- =================================================================== -->
	<!-- default: in simple mode just a flat list -->
	<!-- =================================================================== -->

	<xsl:template mode="prov-xml" match="*|@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<!-- do not show empty elements in view mode -->
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:apply-templates mode="element" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="true()"/>
					<xsl:with-param name="flat"   select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise>
				<xsl:variable name="empty">
					<xsl:apply-templates mode="prov-xmlIsEmpty" select="."/>
				</xsl:variable>

				<xsl:if test="$empty!=''">
					<xsl:apply-templates mode="element" select=".">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="false()"/>
						<xsl:with-param name="flat"   select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
					</xsl:apply-templates>
				</xsl:if>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<xsl:template mode="prov-xml" priority="199" match="*[geonet:element and text()='']"/>
	
	<!-- ===================================================================== -->
	<!-- these elements should be boxed - basically everything with children   -->
	<!-- ===================================================================== -->

	<xsl:template mode="prov-xml" match="prov:*[count(prov:*)>0]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- some elements have only a prov:ref attribute                      -->
	<!-- ================================================================= -->

	<xsl:template mode="prov-xml" match="prov:*[@prov:ref]" priority="100">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="content">
				<xsl:apply-templates mode="simpleAttribute" select="@prov:ref">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
		</xsl:variable>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"   select="$schema"/>
			<xsl:with-param name="edit"   	select="$edit"/>
			<xsl:with-param name="content">
				<xsl:copy-of select="$content"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="prov-xml" match="prov:time|prov:startTime|prov:endTime" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema"  select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="text">
						<xsl:variable name="ref" select="geonet:element/@ref"/>
						<xsl:variable name="format">
							<xsl:text>%Y-%m-%dT%H:%M:00</xsl:text>
						</xsl:variable>

						<xsl:call-template name="calendar">
							<xsl:with-param name="ref" select="$ref"/>
							<xsl:with-param name="date" select="text()"/>
							<xsl:with-param name="format" select="$format"/>
						</xsl:call-template>

					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema"  select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- subtemplates -->
	<!-- =================================================================== -->

	<xsl:template mode="prov-xml" match="*[geonet:info/isTemplate='s']" priority="3">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="element" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->
	<!-- Document -->
	<!-- ==================================================================== -->

	<xsl:template mode="prov-xml" match="prov:document">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded"/>

		<xsl:call-template name="prov-xmlComplete">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================== -->
	<!-- complete mode we just display everything - tab = complete          -->
	<!-- ================================================================== -->

	<xsl:template name="prov-xmlComplete">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="prov:entity|geonet:child[string(@name)='entity']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:activity|geonet:child[string(@name)='activity']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:person|geonet:child[string(@name)='person']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:organization|geonet:child[string(@name)='organization']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:softwareAgent|geonet:child[string(@name)='softwareAgent']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasAssociatedWith|geonet:child[string(@name)='wasAssociatedWith']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasGeneratedBy|geonet:child[string(@name)='wasGeneratedBy']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:used|geonet:child[string(@name)='used']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasInformedBy|geonet:child[string(@name)='wasInformedBy']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasStartedBy|geonet:child[string(@name)='wasStartedBy']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasEndedBy|geonet:child[string(@name)='wasEndedBy']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasInvalidatedBy|geonet:child[string(@name)='wasInvalidatedBy']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasDerivedFrom|geonet:child[string(@name)='wasDerivedFrom']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasRevisionOf|geonet:child[string(@name)='wasRevisionOf']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:wasQuotedFrom|geonet:child[string(@name)='wasQuotedFrom']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:hadPrimarySource|geonet:child[string(@name)='hadPrimarySource']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="prov:other|geonet:child[string(@name)='other']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

	</xsl:template>


	<!-- ===================================================================== -->
	<!-- === prov-xml brief formatting === -->
	<!-- ===================================================================== -->
	<xsl:template mode="superBrief" match="prov:document" priority="2">

    <id><xsl:value-of select="geonet:info/id"/></id>
    <uuid><xsl:value-of select="geonet:info/uuid"/></uuid>
    <title></title>
    <abstract></abstract>
  </xsl:template>

	<xsl:template name="prov-xmlBrief">
		<metadata>
			<xsl:choose>
				<xsl:when test="geonet:info/isTemplate='s'">
					<xsl:call-template name="prov-xml-subtemplate"/>
					<xsl:copy-of select="geonet:info" copy-namespaces="no"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="prov-xml-brief"/>
				</xsl:otherwise>
			</xsl:choose>
		</metadata>
	</xsl:template>


	<xsl:template name="prov-xml-brief">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:variable name="id" select="$info/id"/>
		<xsl:variable name="uuid" select="$info/uuid"/>

		<metadatacreationdate>
			<xsl:value-of select="prov:other/dct:created"/>
		</metadatacreationdate>

		<geonet:info>
			<xsl:copy-of select="geonet:info/*[name(.)!='edit']"/>
			<xsl:choose>
				<xsl:when test="/root/gui/env/harvester/enableEditing='false' and geonet:info/isHarvested='y'">
					<edit>false</edit>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="geonet:info/edit"/>
				</xsl:otherwise>
			</xsl:choose>
			<category internal="true">provenance</category>
		</geonet:info>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- utilities -->
	<!-- ============================================================================= -->

	<xsl:template mode="prov-xmlIsEmpty" match="*|@*|text()">
		<xsl:choose>
			<!-- normal element -->
			<xsl:when test="*">
				<xsl:apply-templates mode="prov-xmlIsEmpty"/>
			</xsl:when>
			<!-- text element -->
			<xsl:when test="text()!=''">txt</xsl:when>
			<xsl:otherwise>
				<!-- attributes -->
				<xsl:if test="string-length(.)!=0">att</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="prov-xml-javascript"/>

</xsl:stylesheet>
