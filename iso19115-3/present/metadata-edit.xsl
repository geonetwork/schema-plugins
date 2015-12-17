<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
							  xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml/3.2"	
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:exslt="http://exslt.org/common"
								xmlns:saxon="http://saxon.sf.net/"
                exclude-result-prefixes="#all">

	<xsl:include href="metadata-utils.xsl"/>
	<xsl:include href="metadata-geo.xsl"/>
  <xsl:include href="metadata-subtemplates.xsl"/>
  <xsl:include href="metadata-view.xsl"/>

  <xsl:template name="iso19115-3CompleteTab"/>

  <!-- main template - the way into processing iso19139 -->
  <xsl:template name="metadata-iso19115-3">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

		<!-- <xsl:message>TOP <xsl:value-of select="name()"/></xsl:message> -->

    <xsl:apply-templates mode="iso19115-3" select="." >
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="embedded" select="$embedded" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="iso19115-3GetIsoLanguage" mode="iso19115-3GetIsoLanguage" match="*">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="value"/>
    <xsl:param name="ref"/>

    <xsl:variable name="lang" select="/root/gui/language"/>

    <xsl:value-of select="/root/gui/isoLang/record[code=$value]/label/child::*[name() = $lang]"/>
  </xsl:template>

	<!-- =================================================================== -->
	<!-- default: in simple mode just a flat list -->
	<!-- =================================================================== -->

	<xsl:template mode="iso19115-3" match="*|@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<!-- <xsl:message>PROCESSING <xsl:value-of select="name()"/></xsl:message> -->

		<!-- do not show empty elements in view mode -->
		<xsl:variable name="empty">
			<xsl:apply-templates mode="iso19115-3IsEmpty" select="."/>
		</xsl:variable>

		<xsl:if test="$empty!=''">
			<xsl:apply-templates mode="element" select=".">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="flat"   select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
			</xsl:apply-templates>
		</xsl:if>

	</xsl:template>


	<!--=====================================================================-->
	<!-- these elements should not be displayed 
		* do not display graphicOverview managed by GeoNetwork (ie. having a 
		fileDescription set to thumbnail or large_thumbnail). Those thumbnails
		are managed in then thumbnail popup. Others could be valid URL pointing to
		an image available on the Internet.
	-->
	<!--=====================================================================-->

	<xsl:template mode="iso19115-3"
		match="mdb:graphicOverview[mcc:MD_BrowseGraphic/mcc:fileDescription/gco:CharacterString='thumbnail' or mcc:MD_BrowseGraphic/mcc:fileDescription/gco:CharacterString='large_thumbnail']"
		priority="20" />

	<xsl:template mode="iso19115-3" priority="199" match="*[@gco:nilReason='missing' and geonet:element and count(*)=1]"/>

	<xsl:template mode="iso19115-3" priority="199" match="*[geonet:element and count(*)=1 and text()='']"/>
	
	<!-- ===================================================================== -->
	<!-- these elements should be boxed -->
	<!-- ===================================================================== -->

	<xsl:template mode="iso19115-3" match="mdb:identificationInfo|mdb:distributionInfo|mri:descriptiveKeywords|mri:thesaurusName|mdb:spatialRepresentationInfo|mri:pointOfContact|mdb:dataQualityInfo|mdb:resourceLineage|mdb:referenceSystemInfo|mri:equivalentScale|msr:projection|mdb:extent|cit:extent|gex:geographicBox|gex:EX_TemporalExtent|mrd:MD_Distributor|srv:containsOperations|srv:SV_CoupledResource|mdb:metadataConstraints|srv:serviceType|srv:serviceTypeVersion|srv:parameter|mco:MD_LegalConstraints|mco:MD_SecurityConstraints|mdb:alternativeMetadataReference|mdb:metadataStandard|mdb:metadataProfile|mdb:metadataLinkage">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<!-- <xsl:message>BOXED <xsl:value-of select="name()"/></xsl:message> -->

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ===================================================================== -->
	<!-- some gco: elements and gcx:MimeFileType are swallowed -->
	<!-- ===================================================================== -->

	<xsl:template mode="iso19115-3" match="*[gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType|gcx:MimeFileType|gco:CharacterString]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="iso19115-3String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-3" match="gco:ScopedName|gco:LocalName">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="text">
			<xsl:call-template name="getElementText">
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"   select="$schema"/>
			<xsl:with-param name="edit"     select="$edit"/>
			<xsl:with-param name="title"    select="'Name'"/>
			<xsl:with-param name="text"     select="$text"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- GML time interval -->
	<xsl:template mode="iso19115-3" match="gml:timeInterval">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

				<xsl:variable name="text">
					<xsl:choose>
						<xsl:when test="@radix and @factor"><xsl:value-of select=". * @factor div @radix"/>&#160;<xsl:value-of select="@unit"/></xsl:when>
						<xsl:when test="@factor"><xsl:value-of select=". * @factor"/>&#160;<xsl:value-of select="@unit"/></xsl:when>
						<xsl:when test="@radix"><xsl:value-of select=". div @radix"/>&#160;<xsl:value-of select="@unit"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="."/>&#160;<xsl:value-of select="@unit"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="edit"     select="$edit"/>
					<xsl:with-param name="title"    select="/root/gui/schemas/iso19139/labels/element[@name='gml:timeInterval']/label"/>
					<xsl:with-param name="text"     select="$text"/>
				</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-3" match="cit:linkage" priority="30">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"   select="$schema"/>
			<xsl:with-param name="edit"     select="$edit"/>
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="gcx:Anchor">
						<xsl:choose>
							<xsl:when test="normalize-space(gcx:Anchor/text())!=''">
								<b><xsl:value-of select="gcx:Anchor/text()"/></b>
							</xsl:when>
							<xsl:otherwise>
								<a href="{gcx:Anchor/@xlink:href}"><xsl:value-of select="gcx:Anchor/@xlink:href"/></a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="gco:*">
						<xsl:variable name="gcoText" select="string(gco:*)"/>
						<xsl:choose>
							<xsl:when test="starts-with($gcoText,'http:')"><a href="{$gcoText}"><xsl:value-of select="$gcoText"/></a></xsl:when>
							<xsl:otherwise><xsl:value-of select="$gcoText"/></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-3" match="srv:operatesOn" priority="30">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"   select="$schema"/>
			<xsl:with-param name="edit"   	select="$edit"/>
			<xsl:with-param name="content">

				<xsl:apply-templates mode="simpleAttribute" select="@uuidref">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:variable name="title" select="@xlink:title"/>
				<xsl:variable name="href" select="@xlink:href"/>

				<xsl:apply-templates mode="simpleAttribute" select="@xlink:href">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="edit"     select="$edit"/>
					<xsl:with-param name="text">
						<xsl:choose>
							<xsl:when test="normalize-space($title)"><a href="{$href}"><xsl:value-of select="$title"/></a></xsl:when>
							<xsl:otherwise><a href="{$href}"><xsl:value-of select="$href"/></a></xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>

			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="simpleAttribute" match="@xsi:type" priority="99"/>

	<!-- ================================================================= -->
	<!-- some elements that have both attributes and content               -->
	<!-- ================================================================= -->

	<xsl:template mode="iso19115-3" match="gml:identifier|gml:axisDirection|gml:descriptionReference">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"   select="$schema"/>
			<xsl:with-param name="edit"   	select="$edit"/>
			<xsl:with-param name="content">

				<!-- existing attributes -->
				<xsl:apply-templates mode="simpleElement" select="@*">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<!-- existing content -->
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- codelists -->
	<!-- ================================================================= -->

	<xsl:template mode="iso19115-3" match="*[*/@codeList]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="iso19115-3Codelist">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="iso19115-3Codelist">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text">
				<xsl:apply-templates mode="iso19115-3GetAttributeText" select="*/@codeListValue">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3GetAttributeText" match="@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="name"     select="local-name(..)"/>
		<xsl:variable name="qname"    select="name(..)"/>
		<xsl:variable name="value"    select="../@codeListValue"/>

		<xsl:choose>
			<xsl:when test="$qname='lan:LanguageCode'">
			<!-- Not interested in languages
				<xsl:apply-templates mode="iso19115-3" select="..">
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>
			-->
			</xsl:when>
			<xsl:otherwise>
				<!--
					Get codelist from profile first and use use default one if not
					available.
				-->
				<xsl:variable name="codelistProfile">
					<xsl:choose>
						<xsl:when test="starts-with($schema,'iso19115-3.')">
							<xsl:copy-of
								select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $qname]/*" />
						</xsl:when>
						<xsl:otherwise />
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="codelistCore">
					<xsl:choose>
						<xsl:when test="normalize-space($codelistProfile)!=''">
							<xsl:copy-of select="$codelistProfile" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of
								select="/root/gui/schemas/*[name(.)='iso19115-3']/codelists/codelist[@name = $qname]/*" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="codelist" select="exslt:node-set($codelistCore)" />
				<xsl:variable name="isXLinked" select="count(ancestor-or-self::node()[@xlink:href]) > 0" />

				<!-- codelist in view mode -->
				<xsl:if test="normalize-space($value)!=''">
					<b><xsl:value-of select="$codelist/entry[code = $value]/label"/></b>
					<xsl:value-of select="concat(': ',$codelist/entry[code = $value]/description)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3" match="mdb:metadataIdentifier[mcc:MD_Identifier/mcc:codeSpace/gco:CharacterString='urn:uuid']" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="false()"/>
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="normalize-space(mcc:MD_Identifier/mcc:code/gco:*)=''">
						<span class="info">
							- <xsl:value-of select="/root/gui/strings/setOnSave"/> - 
						</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="mcc:MD_Identifier/mcc:code/gco:*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3" match="cit:identifier">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="false()"/>
			<xsl:with-param name="text">
				<xsl:value-of select="mcc:MD_Identifier/mcc:code/gco:*"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3" match="cit:date[gco:DateTime|gco:Date]|cit:editionDate" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="iso19115-3String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ============================================================================= -->

  <xsl:template name="iso19115-3String">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<!-- <xsl:message><xsl:value-of select="saxon:print-stack()"/></xsl:message> -->

    <xsl:variable name="title">
      <xsl:call-template name="getTitle">
        <xsl:with-param name="name"   select="name(.)"/>
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="helpLink">
      <xsl:call-template name="getHelpLink">
        <xsl:with-param name="name"   select="name(.)"/>
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="$edit">
					<span>
						<xsl:for-each select="gco:*">
							<xsl:call-template name="getElementText">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="true()" />
								<xsl:with-param name="class" select="''" />
							</xsl:call-template>
						</xsl:for-each>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
    <xsl:variable name="attrs">
      <xsl:for-each select="gco:*/@*">
        <xsl:value-of select="name(.)"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:choose>
    <xsl:when test="normalize-space($attrs)!=''">
      <xsl:apply-templates mode="complexElement" select=".">
        <xsl:with-param name="schema"   select="$schema"/>
        <xsl:with-param name="edit"     select="$edit"/>
        <xsl:with-param name="title"    select="$title"/>
        <xsl:with-param name="helpLink" select="$helpLink"/>
        <xsl:with-param name="content">

        <!-- existing attributes -->
        <xsl:for-each select="gco:*/@*">
          <xsl:apply-templates mode="simpleElement" select=".">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
          </xsl:apply-templates>
        </xsl:for-each>

        <!-- existing content -->
        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema"   select="$schema"/>
          <xsl:with-param name="edit"     select="$edit"/>
          <xsl:with-param name="title"    select="$title"/>
          <xsl:with-param name="helpLink" select="$helpLink"/>
          <xsl:with-param name="text"     select="$text"/>
        </xsl:apply-templates>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="simpleElement" select=".">
        <xsl:with-param name="schema"   select="$schema"/>
        <xsl:with-param name="edit"     select="$edit"/>
        <xsl:with-param name="title"    select="$title"/>
        <xsl:with-param name="helpLink" select="$helpLink"/>
        <xsl:with-param name="text"     select="$text"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

	<!-- ===================================================================== -->
	<!-- gml:TimePeriod (format = %Y-%m-%dThh:mm:ss) -->
	<!-- ===================================================================== -->

	<xsl:template mode="iso19115-3" match="gml:*[gml:beginPosition|gml:endPosition]|gml:TimeInstant[gml:timePosition]" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.)='gml:timeInterval'">
					<xsl:apply-templates mode="iso19115-3" select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="simpleElement" select=".">
						<xsl:with-param name="schema"  select="$schema"/>
						<xsl:with-param name="text">
							<xsl:value-of select="text()"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- subtemplates -->
	<!-- =================================================================== -->

	<xsl:template mode="iso19115-3" match="*[geonet:info/isTemplate='s']" priority="3">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="element" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-3" match="@gco:isoType"/>

	<!-- ==================================================================== -->
	<!-- Metadata -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-3" match="mdb:MD_Metadata|*[@gco:isoType='mdb:MD_Metadata']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded"/>

		<xsl:variable name="dataset" select="mdb:metadataScope/mcc:MD_ScopeCode/@codeListValue='dataset' or normalize-space(mdb:metadataScope/mcc:MD_ScopeCode/@codeListValue)=''"/>

		<xsl:choose>

			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19115-3Metadata">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>

			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="mdb:identificationInfo">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="mdb:metadataMaintenance">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="mdb:metadataConstraints">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="mdb:spatialRepresentationInfo">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="mdb:referenceSystemInfo">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="mdb:distributionInfo">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="mdb:dataQualityInfo">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- lineage tab -->
			<xsl:when test="$currTab='resourceLineage'">
				<xsl:apply-templates mode="elementEP" select="mdb:resourceLineage">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- default -->
			<xsl:otherwise>
				<xsl:call-template name="iso19115-3Simple">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="iso19115-3Metadata">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="ref" select="concat('#_',geonet:element/@ref)"/>
		<xsl:variable name="validationLink">
			<xsl:call-template name="validationLink">
				<xsl:with-param name="ref" select="$ref"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="complexElementGui">
			<xsl:with-param name="title" select="/root/gui/strings/metadata"/>
			<xsl:with-param name="validationLink" select="$validationLink"/>

			<xsl:with-param name="helpLink">
			  <xsl:call-template name="getHelpLink">
			      <xsl:with-param name="name" select="name(.)"/>
			      <xsl:with-param name="schema" select="$schema"/>
			  </xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="edit" select="true()"/>
			<xsl:with-param name="content">

				<!-- if the parent is root then display fields not in tabs -->
				<xsl:choose>
					<xsl:when test="name(..)='root'">
						<xsl:apply-templates mode="elementEP" select="mdb:metadataIdentifier">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:defaultLocale">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:otherLocale">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:parentMetadata">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:metadataScope">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:dateInfo">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:metadataStandard">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:metadataProfile">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:alternativeMetadataReference">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mdb:metadataLinkage">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

					</xsl:when>
					<!-- otherwise, display everything because we have embedded MD_Metadata -->
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="*">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:with-param>
			<xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ============================================================================= -->

	<!-- Blank out mrd:onLine -->
	<xsl:template mode="iso19115-3" match="mrd:onLine"/>

	<!-- ============================================================================= -->

	<xsl:template name="iso19115-3Simple">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="mdb:identificationInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:distributionInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:spatialRepresentationInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:referenceSystemInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:applicationSchemaInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:portrayalCatalogueInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:dataQualityInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:resourceLineage">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:call-template name="complexElementGui">
			<xsl:with-param name="title" select="/root/gui/strings/metadata"/>
			<xsl:with-param name="content">
				<xsl:call-template name="iso19115-3Simple2">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>

		<xsl:apply-templates mode="elementEP" select="mdb:contentInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataExtensionInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="iso19115-3Simple2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataIdentifier">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<!--
		<xsl:apply-templates mode="elementEP" select="mdb:defaultLocale">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:otherLocale">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
		-->

		<xsl:apply-templates mode="elementEP" select="mdb:parentMetadata">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataScope">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataStandard">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataProfile">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:alternativeMetadataReference">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataLinkage">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataConstraints">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:metadataMaintenance">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mdb:contact">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3" match="mri:pointOfContact|mdb:contact|cit:citedResponsibleParty">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit">

		<!-- Leave editing available for Responsibility elements -->

		<xsl:apply-templates mode="elementEP" select="cit:CI_Responsibility">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
		</xsl:apply-templates>

			</xsl:when>
			<xsl:otherwise>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content">

				<xsl:apply-templates mode="iso19115-3" select="cit:CI_Responsibility/cit:role">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="iso19115-3-view" select="cit:CI_Responsibility/cit:party/cit:CI_Organisation|cit:CI_Responsibility/cit:party/cit:CI_Individual">
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>

			</xsl:with-param>
		</xsl:apply-templates>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

  <!-- =================================================================== -->
  <!-- descriptiveKeywords -->
  <!-- =================================================================== -->

  <xsl:template mode="iso19115-3" match="mri:descriptiveKeywords">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="title">
            <xsl:call-template name="getTitle">
              <xsl:with-param name="name" select="name(.)"/>
              <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
            <xsl:if test="mri:MD_Keywords/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString">
              (<xsl:value-of
                select="mri:MD_Keywords/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString"/>)
            </xsl:if>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:variable name="value">
              <xsl:for-each select="mri:MD_Keywords/mri:keyword">
                <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
								<xsl:choose>
									<xsl:when test="gcx:Anchor">
										<xsl:choose>
											<xsl:when test="normalize-space(gcx:Anchor/text())!=''">
												<b><xsl:value-of select="gcx:Anchor/text()"/></b>
											</xsl:when>
											<xsl:otherwise>
												<a href="{gcx:Anchor/@xlink:href}"><xsl:value-of select="gcx:Anchor/@xlink:href"/></a>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<b><xsl:value-of select="."/></b>
									</xsl:otherwise>
								</xsl:choose>
              </xsl:for-each>

              <xsl:variable name="type" select="mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue"/>
              <xsl:if test="$type">
                (<xsl:value-of
                  select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = 'mri:MD_KeywordTypeCode']/
                  entry[code = $type]/label"/>)
              </xsl:if>
              <xsl:text>.</xsl:text>
            </xsl:variable>
            <xsl:copy-of select="$value"/>
          </xsl:with-param>
    </xsl:apply-templates>

  </xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3-view" match="cit:CI_Individual">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content">

				<xsl:variable name="individualName" select="cit:name/*"/>
				<ul>
		  		<li style="list-style-type: none;"><xsl:value-of select="$individualName"/></li>
				</ul>
				<xsl:apply-templates mode="iso19115-3-html" select="cit:contactInfo"/>

			</xsl:with-param>
		</xsl:apply-templates>
			
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3-html" match="cit:individual">
		<ul>
			<li style="list-style-type: none;">
				<xsl:choose>
					<xsl:when test="normalize-space(descendant::cit:name/*)">
						<xsl:value-of select="descendant::cit:name/*"/>
						<xsl:if test="normalize-space(descendant::cit:positionName/*)">
							<xsl:value-of select="concat(', ',descendant::cit:positionName/*)"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="normalize-space(descendant::cit:positionName/*)">
						<xsl:value-of select="descendant::cit:positionName/*"/>
					</xsl:when>
				</xsl:choose>
			</li>
		</ul>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3-html" match="cit:contactInfo">

		<ul>
			<li style="list-style-type: none;"><xsl:value-of select="descendant::cit:deliveryPoint/*"/></li>
			<li style="list-style-type: none;"><xsl:value-of select="descendant::cit:city/*"/></li>
			<li style="list-style-type: none;"><xsl:value-of select="descendant::cit:administrativeArea/*"/></li>
			<li style="list-style-type: none;"><xsl:value-of select="concat(descendant::cit:country/*,' ',descendant::cit:postalCode/*)"/></li>
			<xsl:if test="normalize-space(descendant::cit:electronicMailAddress/*)">
				<li style="list-style-type: none;margin-top: 3px;"><xsl:value-of select="concat('Email: ',descendant::cit:electronicMailAddress/*)"/></li>
			</xsl:if>
			<xsl:for-each select="descendant::cit:phone[descendant::cit:CI_TelephoneTypeCode/@codeListValue='voice']">
				<li style="list-style-type: none;margin-top: 3px;"><xsl:value-of select="concat('Phone: ',descendant::cit:number/*)"/></li>
			</xsl:for-each>
			<xsl:for-each select="descendant::cit:phone[descendant::cit:CI_TelephoneTypeCode/@codeListValue='facsimile']">
				<li style="list-style-type: none;margin-top: 3px;"><xsl:value-of select="concat('Fax: ',descendant::cit:number/*)"/></li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3-view" match="cit:CI_Organisation">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content">

				<xsl:variable name="organisationName" select="cit:name/*"/>
				<xsl:apply-templates mode="iso19115-3-html" select="cit:individual"/>
				<ul>
				  <li style="list-style-type: none;"><xsl:value-of select="$organisationName"/></li>
				</ul>
				<xsl:apply-templates mode="iso19115-3-html" select="cit:contactInfo"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ===================================================================== -->
	<!-- === iso19115-3 brief formatting === -->
	<!-- ===================================================================== -->

	<xsl:template mode="superBrief" match="mdb:MD_Metadata|*[@gco:isoType='mdb:MD_Metadata']" priority="2">
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId">
        <xsl:with-param name="langGui" select="/root/gui/language"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <id><xsl:value-of select="geonet:info/id"/></id>
    <uuid><xsl:value-of select="geonet:info/uuid"/></uuid>
    <title>
      <xsl:apply-templates mode="localised" select="mdb:identificationInfo/*/mri:citation/*/cit:title">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
    </title>
    <abstract>
      <xsl:apply-templates mode="localised" select="mdb:identificationInfo/*/mri:abstract">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
    </abstract>
  </xsl:template>

	<xsl:template name="iso19115-3Brief">
		<metadata>
			<xsl:choose>
				<xsl:when test="geonet:info/isTemplate='s'">
					<xsl:call-template name="iso19115-3-subtemplate"/>
					<xsl:copy-of select="geonet:info" copy-namespaces="no"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="iso19115-3-brief"/>
				</xsl:otherwise>
			</xsl:choose>
		</metadata>
	</xsl:template>


	<xsl:template name="iso19115-3-brief">
		<xsl:variable name="download_check"><xsl:text>&amp;fname=&amp;access</xsl:text></xsl:variable>
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:variable name="id" select="$info/id"/>
		<xsl:variable name="uuid" select="$info/uuid"/>

		<xsl:if test="normalize-space(mdb:parentMetadata/mcc:MD_Identifier/mcc:code/*)!=''">
			<parentId><xsl:value-of select="mdb:parentMetadata/mcc:MD_Identifier/mcc:code/*"/></parentId>
		</xsl:if>

		<xsl:variable name="langId">
			<xsl:call-template name="getLangId19115-3">
				<xsl:with-param name="langGui" select="/root/gui/language"/>
				<xsl:with-param name="md" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="briefster" select="mdb:identificationInfo/*">
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="langId" select="$langId"/>
			<xsl:with-param name="info" select="$info"/>
		</xsl:apply-templates>

		<xsl:for-each select="mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource">
			<xsl:variable name="protocol" select="cit:protocol[1]/gco:CharacterString"/>
			<xsl:variable name="linkage"  select="normalize-space(cit:linkage/*)"/>
			<xsl:variable name="name">
				<xsl:choose>
					<xsl:when test="cit:name/gcx:MimeFileType">
						<xsl:value-of select="cit:name/gcx:MimeFileType/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="cit:name">
							<xsl:call-template name="localised19115-3">
								<xsl:with-param name="langId" select="$langId"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="mimeType" select="normalize-space(cit:name/gcx:MimeFileType/@type)"/>

			<xsl:variable name="desc">
				<xsl:for-each select="cit:description">
					<xsl:call-template name="localised19115-3">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>

			<xsl:if test="string($linkage)!=''">

				<xsl:element name="link">
					<xsl:attribute name="title"><xsl:value-of select="$desc"/></xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="$linkage"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
					<xsl:attribute name="protocol"><xsl:value-of select="$protocol"/></xsl:attribute>
					<xsl:attribute name="type" select="geonet:protocolMimeType($linkage, $protocol, $mimeType)"/>
				</xsl:element>

			</xsl:if>

			<!-- Generate a KML output link for a WMS service -->
			<xsl:if test="string($linkage)!='' and starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-map') and string($name)!=''">

				<xsl:element name="link">
					<xsl:attribute name="title"><xsl:value-of select="$desc"/></xsl:attribute>
					<xsl:attribute name="href">
						<xsl:value-of select="concat(/root/gui/env/server/protocol,'://',/root/gui/env/server/host,':',/root/gui/env/server/port,/root/gui/locService,'/google.kml?uuid=',$uuid,'&amp;layers=',$name)"/>
					</xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
					<xsl:attribute name="type">application/vnd.google-earth.kml+xml</xsl:attribute>
				</xsl:element>
			</xsl:if>

			<!-- The old links still in use by some systems. Deprecated -->
			<xsl:choose>
				<xsl:when test="matches($protocol,'^WWW:DOWNLOAD-.*-http--download.*') and not(contains($linkage,$download_check))">
					<link type="download"><xsl:value-of select="$linkage"/></link>
				</xsl:when>
				<xsl:when test="(starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-map') and string($linkage)!='' and string($name)!='') or ($protocol = 'OGC:WMS' and string($linkage)!='' and string($name)!='')">
					<link type="wms">
						<xsl:value-of select="concat('javascript:addWMSLayer([[&#34;' , $name , '&#34;,&#34;' ,  $linkage  ,  '&#34;, &#34;', $name  ,'&#34;,&#34;',$id,'&#34;]])')"/>
					</link>
					<link type="googleearth">
						<xsl:value-of select="concat(/root/gui/locService,'/google.kml?uuid=',$uuid,'&amp;layers=',$name)"/>
					</link>
				</xsl:when>
				<xsl:when test="starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-capabilities') and string($linkage)!=''">
            <link type="wms">
              <!--xsl:value-of select="concat('javascript:runIM_selectService(&#34;'  ,  $linkage  ,  '&#34;, 2,',$id,')' )"/-->
              <xsl:value-of select="concat('javascript:app.switchMode(&#34;','1','&#34;, true);app.getIMap().addWMSLayer([[&#34;' , $name , '&#34;,&#34;' ,  $linkage  ,  '&#34;, &#34;', $name  ,'&#34;,&#34;',$id,'&#34;]])')"/>
            </link>
        </xsl:when>
				<xsl:when test="string($linkage)!=''">
					<link type="url"><xsl:value-of select="$linkage"/></link>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>

		<xsl:for-each select="mdb:contact/*">
			<xsl:variable name="role" select="cit:role/*/@codeListValue"/>
			<xsl:if test="normalize-space($role)!=''">
				<responsibleParty role="{geonet:getCodeListValue(/root/gui/schemas, 'iso19139', 'gmd:CI_RoleCode', $role)}" appliesTo="metadata">
					<xsl:apply-templates mode="responsiblepartysimple" select="."/>
				</responsibleParty>
			</xsl:if>
		</xsl:for-each>

		<metadatacreationdate>
			<xsl:value-of select="mdb:dateInfo/cit:CI_Date
			            [cit:dateType/cit:CI_DateTypeCode/@codeListValue='creation']
									            /cit:date/*"/>
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
			<!--
				Internal category could be define using different informations
				in a metadata record (according to standard). This could be improved.
				This type of categories could be added to Lucene index also in order
				to be queriable.
				Services and datasets are at least the required internal categories
				to be distinguished for INSPIRE requirements (hierarchyLevel could be
				use also). TODO
			-->
			<category internal="true">
				<xsl:choose>
					<xsl:when test="mdb:identificationInfo/srv:SV_ServiceIdentification">service</xsl:when>
					<xsl:otherwise>dataset</xsl:otherwise>
				</xsl:choose>
			</category>
		</geonet:info>
	</xsl:template>

	<xsl:template mode="briefster" match="mri:MD_DataIdentification">
		<xsl:param name="id"/>
		<xsl:param name="langId"/>
		<xsl:param name="info"/>

		<xsl:if test="mri:citation/*/cit:title">
			<title>
				<xsl:apply-templates mode="localised19115-3" select="mri:citation/*/cit:title">
					<xsl:with-param name="langId" select="$langId"></xsl:with-param>
				</xsl:apply-templates>
			</title>
		</xsl:if>

		<xsl:if test="mri:citation/*/cit:date/*/cit:dateType/*[@codeListValue='creation']">
			<datasetcreationdate>
				<xsl:value-of select="mri:citation/*/cit:date/*/cit:date/gco:DateTime"/>
			</datasetcreationdate>
		</xsl:if>

		<xsl:if test="mri:abstract">
			<abstract>
				<xsl:apply-templates mode="localised19115-3" select="mri:abstract">
					<xsl:with-param name="langId" select="$langId"></xsl:with-param>
				</xsl:apply-templates>
			</abstract>
		</xsl:if>

		<xsl:for-each select=".//mri:keyword[not(@gco:nilReason)]">
			<keyword>
				<xsl:apply-templates mode="localised19115-3" select=".">
					<xsl:with-param name="langId" select="$langId"></xsl:with-param>
				</xsl:apply-templates>
			</keyword>
		</xsl:for-each>

		<xsl:for-each select="mri:extent/*/gex:geographicElement/gex:EX_GeographicBoundingBox">
			<geoBox>
				<westBL><xsl:value-of select="gex:westBoundLongitude"/></westBL>
				<eastBL><xsl:value-of select="gex:eastBoundLongitude"/></eastBL>
				<southBL><xsl:value-of select="gex:southBoundLatitude"/></southBL>
				<northBL><xsl:value-of select="gex:northBoundLatitude"/></northBL>
			</geoBox>
		</xsl:for-each>

		<xsl:for-each select="*/mco:MD_Constraints/*">
			<Constraints preformatted="true">
				<xsl:apply-templates mode="iso19115-3" select=".">
					<xsl:with-param name="schema" select="$info/schema"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:apply-templates>
			</Constraints>
			<Constraints preformatted="false">
				<xsl:copy-of select="."/>
			</Constraints>
		</xsl:for-each>

		<xsl:for-each select="*/mco:MD_SecurityConstraints/*">
			<SecurityConstraints preformatted="true">
				<xsl:apply-templates mode="iso19115-3" select=".">
					<xsl:with-param name="schema" select="$info/schema"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:apply-templates>
			</SecurityConstraints>
			<SecurityConstraints preformatted="false">
				<xsl:copy-of select="."/>
			</SecurityConstraints>
		</xsl:for-each>

		<xsl:for-each select="*/mco:MD_LegalConstraints/*">
			<LegalConstraints preformatted="true">
				<xsl:apply-templates mode="iso19115-3" select=".">
					<xsl:with-param name="schema" select="$info/schema"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:apply-templates>
			</LegalConstraints>
			<LegalConstraints preformatted="false">
				<xsl:copy-of select="."/>
			</LegalConstraints>
		</xsl:for-each>

		<xsl:for-each select="mri:extent/*/gex:temporalElement/*/gex:extent/gml:TimePeriod">
			<temporalExtent>
				<begin><xsl:apply-templates mode="brieftime" select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/></begin>
				<end><xsl:apply-templates mode="brieftime" select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/></end>
			</temporalExtent>
		</xsl:for-each>

		<xsl:if test="not($info/server)">
			<xsl:for-each select="mri:graphicOverview/mcc:MD_BrowseGraphic">
				<xsl:variable name="fileName"  select="mcc:fileName/gco:CharacterString"/>
				<xsl:if test="$fileName != ''">
					<xsl:variable name="fileDescr" select="mcc:fileDescription/gco:CharacterString"/>

					<xsl:choose>
						<!-- the thumbnail is an url -->
						<xsl:when test="contains($fileName ,'://')">
							<xsl:choose>
								<xsl:when test="string($fileDescr)='thumbnail'">
									<image type="thumbnail"><xsl:value-of select="$fileName"/></image>
								</xsl:when>
								<xsl:when test="string($fileDescr)='large_thumbnail'">
									<image type="overview"><xsl:value-of select="$fileName"/></image>
								</xsl:when>
								<xsl:otherwise>
									<image type="unknown"><xsl:value-of select="$fileName"/></image>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<!-- small thumbnail -->
						<xsl:when test="string($fileDescr)='thumbnail'">
							<xsl:choose>
								<xsl:when test="$info/smallThumbnail">
									<image type="thumbnail">
										<xsl:value-of select="concat($info/smallThumbnail, $fileName)"/>
									</image>
								</xsl:when>
								<xsl:otherwise>
									<image type="thumbnail">
										<xsl:value-of select="concat(/root/gui/locService,'/resources.get?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"/>
									</image>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<!-- large thumbnail -->

						<xsl:when test="string($fileDescr)='large_thumbnail'">
							<xsl:choose>
								<xsl:when test="$info/largeThumbnail">
									<image type="overview">
										<xsl:value-of select="concat($info/largeThumbnail, $fileName)"/>
									</image>
								</xsl:when>
								<xsl:otherwise>
									<image type="overview">
										<xsl:value-of select="concat(/root/gui/locService,'/graphover.show?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"/>
									</image>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<xsl:for-each-group select="mri:pointOfContact/*" group-by="cit:party/cit:CI_Organisation/cit:name/gco:CharacterString">
			<xsl:variable name="roles" select="string-join(current-group()/cit:role/*/geonet:getCodeListValue(/root/gui/schemas, 'iso19139', 'gmd:CI_RoleCode', @codeListValue), ', ')"/>
			<xsl:if test="normalize-space($roles)!=''">
				<responsibleParty role="{$roles}" appliesTo="resource">
					<xsl:if test="descendant::*/gcx:FileName">
						<xsl:attribute name="logo"><xsl:value-of select="descendant::*/gcx:FileName/@src"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates mode="responsiblepartysimple" select="."/>
				</responsibleParty>
			</xsl:if>
		</xsl:for-each-group>
	</xsl:template>

	<!-- helper to create a very simplified view of a CI_ResponsibleParty block -->

	<xsl:template mode="responsiblepartysimple" match="*">
		<xsl:for-each select=".//gco:CharacterString|.//cit:URL">
			<xsl:if test="normalize-space(.)!=''">
				<xsl:element name="{local-name(..)}">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="brieftime" match="*">
		<xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<xsl:value-of select="@indeterminatePosition"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
				<xsl:if test="@indeterminatePosition">
					<xsl:value-of select="concat(' (Qualified by indeterminatePosition',': ',@indeterminatePosition,')')"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- utilities -->
	<!-- ============================================================================= -->

	<xsl:template mode="iso19115-3IsEmpty" match="*|@*|text()">
		<xsl:choose>
			<!-- normal element -->
			<xsl:when test="*">
				<xsl:apply-templates mode="iso19115-3IsEmpty"/>
			</xsl:when>
			<!-- text element -->
			<xsl:when test="text()!=''">txt</xsl:when>
			<!-- empty element -->
			<xsl:otherwise>
				<!-- attributes? -->
				<xsl:for-each select="@*">
					<xsl:if test="string-length(.)!=0">att</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="iso19115-3-javascript"/>

</xsl:stylesheet>
