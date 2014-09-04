<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:grg="http://www.isotc211.org/2005/grg"
	xmlns:gnreg="http://geonetwork-opensource.org/register"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="grg gnreg gmx xsi gmd gco gml gts xlink exslt geonet">

	<xsl:import href="metadata-fop.xsl"/>

	<!-- main template - the way into processing iso19135 -->
  <xsl:template name="metadata-iso19135">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

		<xsl:choose>
			<!-- process in iso19135 mode if grg namespace -->
			<xsl:when test="namespace-uri(.)='http://www.isotc211.org/2005/grg' or
									namespace-uri()='http://geonetwork-opensource.org/register'">
      	<xsl:apply-templates mode="iso19135" select="." >
        	<xsl:with-param name="schema" select="$schema"/>
        	<xsl:with-param name="edit"   select="$edit"/>
        	<xsl:with-param name="embedded" select="$embedded" />
      	</xsl:apply-templates>
			</xsl:when>
      <!-- otherwise process in iso19139 mode -->
      <xsl:otherwise>
        <xsl:apply-templates mode="iso19139" select="." >
          <xsl:with-param name="schema" select="'iso19139'"/>
          <xsl:with-param name="edit"   select="$edit"/>
          <xsl:with-param name="embedded" select="$embedded" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>	
  </xsl:template>

	<!-- =================================================================== -->
	<!-- Register -->
	<!-- =================================================================== -->

	<xsl:template mode="iso19135" match="grg:RE_Register">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded" select="false()"/>

		<xsl:choose>
       			
			<!-- simple tab -->
			<xsl:when test="$currTab='simple'">
				<xsl:apply-templates mode="elementEP" select="*">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- register tab -->
			<xsl:when test="$currTab='register'">
				<xsl:call-template name="iso19135Register">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>

			<!-- language tab -->
			<xsl:when test="$currTab='language'">
				<xsl:apply-templates mode="elementEP" select="grg:operatingLanguage|geonet:child[string(@name)='operatingLanguage']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="grg:alternativeLanguages|geonet:child[string(@name)='alternativeLanguages']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- owner tab -->
			<xsl:when test="$currTab='owner'">
				<xsl:apply-templates mode="elementEP" select="grg:owner|geonet:child[string(@name)='owner']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- submitter tab -->
			<xsl:when test="$currTab='submitter'">
				<xsl:apply-templates mode="elementEP" select="grg:submitter|geonet:child[string(@name)='submitter']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- manager tab -->
			<xsl:when test="$currTab='manager'">
				<xsl:apply-templates mode="elementEP" select="grg:manager|geonet:child[string(@name)='manager']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- default - display everything except contained items - usually just tab="complete" -->
			<xsl:otherwise>
				<xsl:apply-templates mode="elementEP" select="*[name()!='grg:containedItem']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- Process grg:contact like gmd:contactInfo -->
	<!-- =================================================================== -->

	<xsl:template mode="iso19135" match="grg:contact">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="content">
			<xsl:for-each select="gmd:CI_ResponsibleParty">
			<tr>
				<td class="padded-content" width="100%" colspan="2">
					<table width="100%">
						<tr>
							<td width="50%" valign="top">
								<table width="100%">
									<xsl:apply-templates mode="elementEP" select="../@xlink:href">
										<xsl:with-param name="schema" select="'iso19139'"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates mode="elementEP" select="gmd:individualName|geonet:child[string(@name)='individualName']">
										<xsl:with-param name="schema" select="'iso19139'"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates mode="elementEP" select="gmd:organisationName|geonet:child[string(@name)='organisationName']">
										<xsl:with-param name="schema" select="'iso19139'"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates mode="elementEP" select="gmd:positionName|geonet:child[string(@name)='positionName']">
										<xsl:with-param name="schema" select="'iso19139'"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates mode="elementEP" select="gmd:role|geonet:child[string(@name)='role']">
										<xsl:with-param name="schema" select="'iso19139'"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
									
								</table>
							</td>
							<td valign="top">
								<table width="100%">
									<xsl:apply-templates mode="elementEP" select="gmd:contactInfo|geonet:child[string(@name)='contactInfo']">
										<xsl:with-param name="schema" select="'iso19139'"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</xsl:for-each>
		</xsl:variable>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content" select="$content"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- These items should be boxed as they have children -->
	<!-- =================================================================== -->

	<xsl:template mode="iso19135" match="grg:submitter|grg:manager|grg:owner|grg:containedItemClass|grg:version|grg:operatingLanguage|grg:alternativeLanguages|grg:successor|grg:predecessor|grg:fieldOfApplication|grg:technicalStandard|grg:additionInformation|grg:sponsor|grg:specificationLineage">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:apply-templates mode="complexElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="content">

    		<xsl:apply-templates mode="elementEP" select="*">
      		<xsl:with-param name="schema" select="$schema"/>
      		<xsl:with-param name="edit"   select="$edit"/>
    		</xsl:apply-templates>
				
			</xsl:with-param>
    </xsl:apply-templates>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- some gco: elements and gmx:MimeFileType are swallowed -->
	<!-- =================================================================== -->

	<xsl:template mode="iso19135" match="grg:*[gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType|gmx:MimeFileType]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- =================================================================== -->
	<!-- Display Register tab - elements not included in other tabs          -->
	<!-- =================================================================== -->

	<xsl:template name="iso19135Register">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<!-- Register name -->
		<xsl:apply-templates mode="elementEP" select="grg:name|geonet:child[string(@name)='name']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<!-- Register content summary -->
		<xsl:apply-templates mode="elementEP" select="grg:contentSummary|geonet:child[string(@name)='contentSummary']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<!-- Register version -->
		<xsl:apply-templates mode="elementEP" select="grg:version|geonet:child[string(@name)='version']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<!-- Register dateOfLastChange -->
		<xsl:apply-templates mode="elementEP" select="grg:dateOfLastChange|geonet:child[string(@name)='dateOfLastChange']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- display all tabs for iso19135                                       -->
	<!-- =================================================================== -->

	<xsl:template name="iso19135CompleteTab">
		<xsl:param name="tabLink"/>

		<xsl:if test="/root/gui/config/metadata-tab/advanced">
			<xsl:call-template name="displayTab"> <!-- non existent tab - by packages -->
				<xsl:with-param name="tab"     select="'packages'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/byPackage"/>
				<xsl:with-param name="tabLink" select="''"/>
			</xsl:call-template>
			
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'register'"/>
				<xsl:with-param name="text"    select="/root/gui/schemas/iso19135/strings/registerTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>
		
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'language'"/>
				<xsl:with-param name="text"    select="/root/gui/schemas/iso19135/strings/languageTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'owner'"/>
				<xsl:with-param name="text"    select="/root/gui/schemas/iso19135/strings/ownerTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
				<xsl:with-param name="highlighted" select="true()"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'submitter'"/>
				<xsl:with-param name="text"    select="/root/gui/schemas/iso19135/strings/submitterTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
				<xsl:with-param name="highlighted" select="true()"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'manager'"/>
				<xsl:with-param name="text"    select="/root/gui/schemas/iso19135/strings/managerTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>
	
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'All'"/>
				<xsl:with-param name="text"    select="/root/gui/schemas/iso19135/strings/allTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
	
	<!-- =================================================================== -->
  <!-- === iso19135 brief formatting                                   === -->
  <!-- =================================================================== -->

	<xsl:template name="iso19135Brief">
			<metadata>
			
				<xsl:variable name="langId">
        	<xsl:call-template name="getLangId">
          	<xsl:with-param name="langGui" select="/root/gui/language"/>
          	<xsl:with-param name="md" select="."/>
        	</xsl:call-template>
      	</xsl:variable>
	
				<title>
					<xsl:apply-templates mode="localised" select="grg:name">
						<xsl:with-param name="langId" select="$langId"></xsl:with-param>
					</xsl:apply-templates>	
				</title>
	
				<abstract>
					<xsl:apply-templates mode="localised" select="grg:contentSummary">
						<xsl:with-param name="langId" select="$langId"></xsl:with-param>
					</xsl:apply-templates>
				</abstract>
	
				<!-- Put valid register items out as keywords -->
      	<xsl:for-each select="grg:containedItem[*/grg:status/grg:RE_ItemStatus='valid']">
        	<keyword>
          	<xsl:apply-templates mode="localised" select="*/grg:name">
            	<xsl:with-param name="langId" select="$langId"/>
          	</xsl:apply-templates>
        	</keyword>
      	</xsl:for-each>
	
				<xsl:for-each-group select="//grg:contact/*" group-by="gmd:organisationName/gco:CharacterString">
        	<xsl:variable name="roles" select="string-join(current-group()/gmd:role/*/geonet:getCodeListValue(/root/gui/schemas, 'iso19139', 'gmd:CI_RoleCode', @codeListValue), ', ')"/>
        	<xsl:if test="normalize-space($roles)!=''">
          	<responsibleParty role="{$roles}" appliesTo="resource">
            	<xsl:if test="descendant::*/gmx:FileName">
              	<xsl:attribute name="logo"><xsl:value-of select="descendant::*/gmx:FileName/@src"/></xsl:attribute>
            	</xsl:if>
            	<xsl:apply-templates mode="responsiblepartysimple" select="."/>
          	</responsibleParty>
        	</xsl:if>
      	</xsl:for-each-group>
	
				<xsl:for-each select="grg:uniformResourceIdentifier/gmd:CI_OnlineResource">
        	<xsl:variable name="protocol" select="gmd:protocol[1]/gco:CharacterString"/>
        	<xsl:variable name="linkage"  select="normalize-space(gmd:linkage/gmd:URL)"/>
        	<xsl:variable name="name">
          	<xsl:for-each select="gmd:name">
            	<xsl:call-template name="localised">
              	<xsl:with-param name="langId" select="$langId"/>
            	</xsl:call-template>
          	</xsl:for-each>
        	</xsl:variable>
	
        	<xsl:variable name="mimeType" select="normalize-space(gmd:name/gmx:MimeFileType/@type)"/>
	
        	<xsl:variable name="desc">
          	<xsl:for-each select="gmd:description">
            	<xsl:call-template name="localised">
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
				</xsl:for-each>
	
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
				</geonet:info>
			</metadata>
	</xsl:template>

	<!-- =================================================================== -->
  <!-- default: in simple mode just a flat list -->
  <!-- =================================================================== -->

  <xsl:template mode="iso19135" match="*|@*">
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
          <xsl:apply-templates mode="iso19135IsEmpty" select="."/>
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

	<!--
		=====================================================================				
		* All elements having gco:CharacterString or gmd:PT_FreeText elements
		have to display multilingual editor widget. Even if default language
		is set, an element could have gmd:PT_FreeText and no gco:CharacterString
		(ie. no value for default metadata language) .
	-->
	<xsl:template mode="iso19135" match="grg:*[gco:CharacterString or gmd:PT_FreeText]">
		<xsl:param name="schema" />
		<xsl:param name="edit" />
		
		<!-- Define a rows variable if form element as
			to be a textarea instead of a simple text input.
			This parameter define the number of rows of the textarea. -->
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="name(.)='grg:contentSummary'
					or name(.)='grg:controlBodyDecisionEvent'
					or name(.)='grg:controlBodyNotes'
				  or name(.)='grg:registerManagerNotes'">10</xsl:when>
				<xsl:when test="name(.)='grg:description'
					or name(.)='grg:definition'">5</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="localizedCharStringField">
			<xsl:with-param name="schema" select="$schema" />
			<xsl:with-param name="edit" select="$edit" />
			<xsl:with-param name="rows" select="$rows" />
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================= -->
  <!-- codelists -->
  <!-- ================================================================= -->

  <xsl:template mode="iso19135" match="grg:*[*/@codeList]">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:call-template name="iso19135Codelist">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>

	<xsl:template name="iso19135Codelist">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text">
				<xsl:apply-templates mode="iso19135GetAttributeText" select="*/@codeListValue">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="iso19135GetAttributeText" match="@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="name"     select="local-name(..)"/>
		<xsl:variable name="qname"    select="name(..)"/>
		<xsl:variable name="value"    select="../@codeListValue"/>
		
		<xsl:choose>
			<xsl:when test="$qname='gmd:LanguageCode'">
				<xsl:apply-templates mode="iso19139" select="..">
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!--
					Get codelist from profil first and use use default one if not
					available.
				-->
				<xsl:variable name="codelistProfil">
					<xsl:choose>
						<xsl:when test="starts-with($schema,'iso19135.')">
							<xsl:copy-of
								select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $qname]/*" />
						</xsl:when>
						<xsl:otherwise />
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="codelistCore">
					<xsl:choose>
						<xsl:when test="normalize-space($codelistProfil)!=''">
							<xsl:copy-of select="$codelistProfil" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of
								select="/root/gui/schemas/*[name(.)='iso19135']/codelists/codelist[@name = $qname]/*" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="codelist" select="exslt:node-set($codelistCore)" />
				<xsl:variable name="isXLinked" select="count(ancestor-or-self::node()[@xlink:href]) > 0" />

				<xsl:choose>
					<xsl:when test="$edit=true()">
						<!-- codelist in edit mode -->
						<select class="md" name="_{../geonet:element/@ref}_{name(.)}" id="_{../geonet:element/@ref}_{name(.)}" size="1">
							<!-- Check element is mandatory or not -->
							<xsl:if test="../../geonet:element/@min='1' and $edit">
								<xsl:attribute name="onchange">validateNonEmpty(this);</xsl:attribute>
							</xsl:if>
							<xsl:if test="$isXLinked">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
							<option name=""/>
							<xsl:for-each select="$codelist/entry[not(@hideInEditMode)]">
								<xsl:sort select="label"/>
								<option>
									<xsl:if test="code=$value">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:attribute name="value"><xsl:value-of select="code"/></xsl:attribute>
									<xsl:value-of select="label"/>
								</option>
							</xsl:for-each>
						</select>
					</xsl:when>
					<xsl:otherwise>
						<!-- codelist in view mode -->
						<xsl:if test="normalize-space($value)!=''">
							<b><xsl:value-of select="$codelist/entry[code = $value]/label"/></b>
							<xsl:value-of select="concat(': ',$codelist/entry[code = $value]/description)"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<!--
		<xsl:call-template name="getAttributeText">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
		-->
	</xsl:template>

	<!-- =================================================================== -->
  <!-- Capture grg:containedItem - not processed here as too many  -->
  <!-- =================================================================== -->

	<xsl:template mode="iso19135" match="grg:containedItem">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
	</xsl:template>

	<!-- =================================================================== -->
  <!-- Utilities -->
  <!-- =================================================================== -->

	<xsl:template mode="iso19135IsEmpty" match="*|@*|text()">
    <xsl:choose>
      <!-- normal element -->
      <xsl:when test="*">
        <xsl:apply-templates mode="iso19135IsEmpty"/>
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

	<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT          -->
	<!-- =================================================================== -->
	<xsl:template name="iso19135-javascript"/>

</xsl:stylesheet>
