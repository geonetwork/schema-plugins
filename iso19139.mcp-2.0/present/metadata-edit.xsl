<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:exslt="http://exslt.org/common"
	xmlns:geonet="http://www.fao.org/geonetwork"
	exclude-result-prefixes="gmx gmd gco gml srv xlink exslt geonet">

	<xsl:import href="metadata-taxonconcepts.xsl"/>
	<xsl:import href="metadata-view.xsl"/>

	<xsl:variable name="mcpallgens-2.0" select="document('../schema/resources/Codelist/mcp-allgens.xml')"/>

	<!-- If this option exists in config-gui.xml then mcp:metadataContactInfo and
	     mcp:resourceContactInfo are preferred over gmd:contact and 
			 gmd:pointOfContact -->
	<xsl:variable name="useExperimentalContacts-2.0" select="/root/gui/config/iso19139.mcp-2.0/useExperimentalContacts"/>

	<!-- codelists are handled directly from the gmxCodelists.xml file as we
	     don't support localized codelists in the MCP and we don't want to
	     duplicate the codelists into another file -->
	<xsl:variable name="codelistsmcp-2.0" select="document('../schema/resources/Codelist/gmxCodelists.xml')"/>

	<xsl:variable name="dcurl-2.0" select="/root/gui/schemas/iso19139.mcp-2.0/strings/dataCommonsUrl"/>
	<xsl:variable name="ccurl-2.0" select="/root/gui/schemas/iso19139.mcp-2.0/strings/creativeCommonsUrl"/>

	<!-- main template - the way into processing iso19139.mcp -->
  <xsl:template match="metadata-iso19139.mcp-2.0" name="metadata-iso19139.mcp-2.0">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>


		<!-- process in profile mode first -->
		<xsl:variable name="mcpElements">
    	<xsl:apply-templates mode="iso19139.mcp-2.0" select="." >
     		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
     		<xsl:with-param name="embedded" select="$embedded" />
    	</xsl:apply-templates>
		</xsl:variable>

		<xsl:choose>

			<!-- if we got a match in profile mode then show it -->
			<xsl:when test="count($mcpElements/*)>0">
				<xsl:copy-of select="$mcpElements"/>
			</xsl:when>

			<!-- otherwise process in base iso19139 mode -->
			<xsl:otherwise>	
    		<xsl:apply-templates mode="iso19139" select="." >
     			<xsl:with-param name="schema" select="$schema"/>
     			<xsl:with-param name="edit"   select="$edit"/>
     			<xsl:with-param name="embedded" select="$embedded" />
    		</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

	<!-- CompleteTab template - iso19139.mcp-2.0 has its own set of tabs -->
	<xsl:template name="iso19139.mcp-2.0CompleteTab">
		<xsl:param name="tabLink"/>

		<xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byGroup"/>
        <xsl:with-param name="default">mcpCore</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="mcpMinimum">mcpMinimum</item>
          <item label="mcpCore">mcpCore</item>
          <item label="mcpAll">mcpAll</item>
        </xsl:with-param>
      </xsl:call-template>
     </xsl:if>



    <xsl:if test="/root/gui/config/metadata-tab/advanced">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byPackage"/>
        <xsl:with-param name="default">identification</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="metadata">metadata</item>
          <item label="identificationTab">identification</item>
          <item label="temporalExtentTab">temporalExtent</item>
          <item label="spatialExtentTab">spatialExtent</item>
          <item label="maintenanceTab">maintenance</item>
          <item label="constraintsTab">constraints</item>
          <item label="spatialTab">spatial</item>
          <item label="refSysTab">refSys</item>
          <item label="distributionTab">distribution</item>
          <item label="dataQualityTab">dataQuality</item>
          <item label="appSchInfoTab">appSchInfo</item>
          <item label="porCatInfoTab">porCatInfo</item>
          <item label="contentInfoTab">contentInfo</item>
          <item label="extensionInfoTab">extensionInfo</item>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
	</xsl:template>

	<!-- ==================================================================== -->
	<!-- mcp gco: elements -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19139" match="mcp:*[gco:CharacterString|gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="iso19139" match="mcp:*[geonet:child/@prefix='gco']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- mcp codelists -->
	<!-- ================================================================= -->

	<xsl:template mode="iso19139.mcp-2.0" match="*[*/@codeList and name(.)!='gmd:country' and name()!='gmd:language' and name()!='gmd:languageCode']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="iso19139Codelistmcp-2.0">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template name="iso19139Codelistmcp-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text">
				<xsl:apply-templates mode="iso19139GetAttributeTextmcp-2.0" select="*/@codeListValue">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ================================================================= -->

	<xsl:template mode="iso19139GetAttributeTextmcp-2.0" match="@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="name" select="local-name(..)"/>
		<xsl:variable name="value" select="../@codeListValue"/>
		<xsl:variable name="codelist" select="$codelistsmcp-2.0/gmx:CT_CodelistCatalogue/gmx:codelistItem/gmx:CodeListDictionary[gml:identifier=$name]"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<select class="md" name="_{../geonet:element/@ref}_{name(.)}" size="1">
					<option name=""/>
					<xsl:for-each select="$codelist/gmx:codeEntry">
						<option>
							<xsl:if test="gmx:CodeDefinition/gml:identifier=$value">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:variable name="choiceValue" select="string(gmx:CodeDefinition/gml:identifier)"/>
							<xsl:attribute name="value"><xsl:value-of select="$choiceValue"/></xsl:attribute>
							
							<xsl:variable name="label">
								<xsl:choose>
									<xsl:when test="/root/gui/codeListDescriptions='on'">
										<xsl:value-of select="gmx:CodeDefinition/gml:descriptions"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="gmx:CodeDefinition/gml:identifier"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="string-length($label)&gt;100"><xsl:value-of select="concat(substring($label, 0, 100),'...')"/></xsl:when>
								<xsl:when test="$label"><xsl:value-of select="$label"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$choiceValue"/></xsl:otherwise>
							</xsl:choose>
						</option>
					</xsl:for-each>
				</select>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="normalize-space($value)!=''">
					<b><xsl:value-of select="$value"/></b>
					<xsl:value-of select="concat(': ',$codelist/gmx:codeEntry[gmx:CodeDefinition/gml:identifier=$value]/gmx:CodeDefinition/gml:description)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		<!--
		<xsl:call-template name="getAttributeText">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
		-->
	</xsl:template>
	
	<!-- ==================================================================== -->
	<!-- taxonomic info 																											-->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:taxonomicElement">
  	<xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<xsl:variable name="html"  select="normalize-space(*/mcp:presentationLink/gmd:URL)"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="content">


			<xsl:call-template name="simpleElementGui">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="helpLink">
					<xsl:call-template name="getHelpLink">
						<xsl:with-param name="name"   select="'mcp:taxonConcepts'"/>
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="title">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name"   select="'mcp:taxonConcepts'"/>
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="text">
					<xsl:choose>
						<xsl:when test="$edit=false()">
							<xsl:choose>
								<xsl:when test="count(*/mcp:taxonConcepts/*)>0">
									<xsl:apply-templates mode="taxonconcepts" select="*/mcp:taxonConcepts"/>
								</xsl:when>
								<xsl:otherwise>
									<b>No link to taxonomic information provided</b>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:otherwise>
							<table width="100%">
								<xsl:for-each select="*/mcp:taxonConcepts/@xlink:href">
									<xsl:variable name="updatename">
										<xsl:call-template name="getAttributeName">
											<xsl:with-param name="name" select="name(.)"/>
										</xsl:call-template>
									</xsl:variable>
									<tr>
										<td class="padded" width="50%">
											<xsl:call-template name="getAttributeText">
												<xsl:with-param name="schema" select="$schema"/>
												<xsl:with-param name="edit"   select="$edit"/>
											</xsl:call-template>
										</td>
										<td class="padded" width="50%">
											<button class="content" onclick="startTaxonSearch('_{../geonet:element/@ref}_{$updatename}','{/root/gui/schemas/iso19139.mcp/strings/taxonSearch}');" type="button">
												<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/taxonSearch"/>
											</button>
										</td>
									</tr>
								</xsl:for-each> 
							</table>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="$edit=true()">
				<xsl:apply-templates mode="elementEP" select="*/mcp:presentationLink|*/geonet:child[@name='presentationLink']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:if>
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ==================================================================== -->
	<!-- keywords from GCMD Chooser Application                               -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19139.mcp-2.0" match="gmd:keyword">
  	<xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">

    	<xsl:apply-templates mode="simpleElement" select=".">
      	<xsl:with-param name="schema"  select="$schema"/>
      	<xsl:with-param name="edit"   select="$edit"/>
      	<xsl:with-param name="text">
      		<xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref"/>
        	<table width="100%"><tr>
          	<td>
<input class="md" type="text" name="_{$ref}" id="_{$ref}_cal1" value="{gco:CharacterString/text()}" size="60" onClick="window.open('/GCMDFinder/GCMDFinder/GCMDFinder.jsp',this.id,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=700,height=500,top=150,left=150');"/>
						</td>
        	</tr></table>
      	</xsl:with-param>
    	</xsl:apply-templates>
			</xsl:when>
      <xsl:otherwise>
      	<xsl:apply-templates mode="simpleElement" select=".">
          	<xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="text">
						  <xsl:value-of select="gco:CharacterString"/>
						</xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

	<!-- ================================================================ -->
	<!-- keyword; only called in edit mode (see descriptiveKeywords -->
	<!-- template) and code keyword in gmd:geographicIdentifier           -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="gmd:keyword[following-sibling::gmd:type/gmd:MD_KeywordTypeCode/@codeListValue='place']|gmd:code[name(../..)='gmd:geographicIdentifier']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
		<xsl:when test="$edit=true()">
		
		<xsl:variable name="text">
			<xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref"/>
			<xsl:variable name="keyword" select="gco:CharacterString/text()"/>
			
			<input class="md" type="text" name="_{$ref}" value="{gco:CharacterString/text()}" size="50" />

			<!-- mcp-allgens combobox -->

			<select name="place" size="1" onChange="document.mainForm._{$ref}.value=this.options[this.selectedIndex].text">
				<option value=""/>
				<xsl:for-each select="$mcpallgens-2.0/gmx:CT_CodelistCatalogue/gmx:codelistItem/gmx:CodeListDictionary">
					<optgroup label="{gml:identifier}">
					<xsl:for-each select="gmx:codeEntry">
						<xsl:variable name="entry" select="substring-before(gmx:CodeDefinition/gml:description,'|')"/>
						<option value="{$entry}">
							<xsl:if test="$entry=$keyword">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:value-of select="$entry"/>
						</option>
					</xsl:for-each>
					</optgroup>
				</xsl:for-each>
			</select>
		</xsl:variable>
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="true()"/>
			<xsl:with-param name="text"   select="$text"/>
		</xsl:apply-templates>
		</xsl:when>

		<xsl:otherwise>
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="text">
        <xsl:value-of select="gco:CharacterString"/>
      </xsl:with-param>
		</xsl:apply-templates>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================== -->
	<!-- EX_GeographicBoundingBox -->
	<!-- ================================================================== -->

	<xsl:template mode="iso19139.mcp-2.0" match="gmd:EX_GeographicBoundingBox">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="geoBox">
			<xsl:apply-templates mode="iso19139GeoBox" select=".">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:variable name="eltRef">
			<xsl:choose>
				<xsl:when test="$edit=true()">
					<xsl:value-of select="geonet:element/@ref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id(.)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:variable name="places">
					<xsl:variable name="ref" select="geonet:element/@ref"/>
					<xsl:variable name="keyword" select="string(.)"/>

					<script type="text/javascript">

				function setMcpRegion(westField, eastField, southField, northField, region, eltRef, descriptionRef)
				{
					var choice = region.value;
					var w = "";
					var e = "";
					var s = "";
					var n = "";
					
					if (choice != undefined &amp;&amp; choice != "") {
						coords = choice.split(",");
						n = coords[0];
						s = coords[1];
						e = coords[2];
						w = coords[3];
						$("_" + westField).value  = w;
						$("_" + eastField).value  = e;
						$("_" + southField).value = s;
						$("_" + northField).value = n;
						
						if ($("_" + descriptionRef) != null)
							$("_" + descriptionRef).value = region.text;
					} else {
						$("_" + westField).value  = "";
						$("_" + eastField).value  = "";
						$("_" + southField).value = "";
						$("_" + northField).value = "";
					}
					
					var viewers = Ext.DomQuery.select('.extentViewer');
					for (var idx = 0; idx &lt; viewers.length; ++idx) {
	     				var viewer = viewers[idx];
	     				if (eltRef == viewer.getAttribute("elt_ref")) {
	    	 				extentMap.updateBboxForRegion(extentMap.maps[eltRef], westField + "," + southField + "," + eastField + "," + northField, eltRef, true); // Region are in WGS84
	     				}
					}
				}
					</script>

					<xsl:variable name="selection" select="concat(gmd:northBoundLatitude/gco:Decimal,',',gmd:southBoundLatitude/gco:Decimal,',',gmd:eastBoundLongitude/gco:Decimal,',',gmd:westBoundLongitude/gco:Decimal)"/>

				
					<!-- anzlic-allgens combobox -->

					<select name="place" size="1" onChange="javascript:setMcpRegion('{gmd:westBoundLongitude/gco:Decimal/geonet:element/@ref}', '{gmd:eastBoundLongitude/gco:Decimal/geonet:element/@ref}', '{gmd:southBoundLatitude/gco:Decimal/geonet:element/@ref}', '{gmd:northBoundLatitude/gco:Decimal/geonet:element/@ref}', this.options[this.selectedIndex], {$eltRef}, '{../../gmd:description/gco:CharacterString/geonet:element/@ref}')">
						<option value=""/>
						<xsl:for-each select="$mcpallgens-2.0/gmx:CT_CodelistCatalogue/gmx:codelistItem/gmx:CodeListDictionary">
							<optgroup label="{gml:identifier}">
								<xsl:for-each select="gmx:codeEntry">
									<xsl:variable name="value" select="translate(normalize-space(substring-after(gmx:CodeDefinition/gml:description,'|')),'|',',')"/>
									<xsl:variable name="entry" select="substring-before(gmx:CodeDefinition/gml:description,'|')"/>
									<option value="{$value}">
										<xsl:if test="contains($value,$selection)">
											<xsl:attribute name="selected"/>
										</xsl:if>
										<xsl:value-of select="$entry"/>
									</option>
								</xsl:for-each>
							</optgroup>
						</xsl:for-each>
					</select>
				</xsl:variable>
				<xsl:apply-templates mode="complexElement" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="content">
						<tr>
							<td align="center">
								<xsl:copy-of select="$places"/>
							</td>
						</tr>
						<tr>
							<td align="center">
								<xsl:copy-of select="$geoBox"/>
							</td>
						</tr>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
			<!--	<xsl:if test="normalize-space($geoBox)!=''"> -->
					<xsl:apply-templates mode="complexElement" select=".">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="content">
							<tr>
								<td align="center">
									<xsl:copy-of select="$geoBox"/>
								</td>
							</tr>
						</xsl:with-param>
					</xsl:apply-templates>
			<!-- 	</xsl:if> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================ -->
	<!-- various fields that need 3 rows    -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:parameterDescription|mcp:attributionConstraints|mcp:otherConstraints|mcp:derivativeConstraints|mcp:commercialUseConstraints|mcp:collectiveWorksConstraints|gmd:useLimitation|gmd:otherConstraints|gmd:userNote|gmd:handlingDescription|gmd:classificationSystem">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="rows"   select="3"/>
    </xsl:call-template>
  </xsl:template>

	<!-- ================================================================ -->
	<!-- mcp:MD_Commons - offer creative or data commons editing          -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:MD_Commons[@mcp:commonsType='']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:for-each select="@mcp:commonsType">
			<xsl:apply-templates mode="simpleAttribute" select=".">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="text">
					<xsl:call-template name="getCommonsTypeAction-2.0">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:for-each>

		<table id="creative" style="display:none;">
			<tr>
				<td> 
					<xsl:call-template name="doCC-2.0">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit" select="$edit"/>
					</xsl:call-template>
				</td>
			</tr>
		</table>

		<table id="data" style="display:none;">
			<tr>
				<td>
					<xsl:call-template name="doDC-2.0">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit" select="$edit"/>
					</xsl:call-template>
				</td>
			</tr>
		</table>

	</xsl:template>

	<!--
	returns the text of the mcp:commonsType attribute
	-->
	<xsl:template name="getCommonsTypeAction-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="rows" select="1"/>
		<xsl:param name="cols" select="50"/>
		
		<xsl:variable name="name"  select="name(.)"/>
		<xsl:variable name="value" select="string(.)"/>
		<xsl:variable name="parent"  select="name(..)"/>

		<!-- the following variable is used in place of name as a work-around to
         deal with qualified attribute names like gml:id
		     which if not modified will cause JDOM errors on update because of the
				 way in which changes to ref'd elements are parsed as XML -->
		<xsl:variable name="updatename" select="concat(substring-before($name,':'),'COLON',substring-after($name,':'))"/>
		<select class="md" id="CommonsSelect" name="_{../geonet:element/@ref}_{$updatename}" size="1" onchange="javascript:showCommons(this.id)">
			<option name=""/>
			<xsl:for-each select="../geonet:attribute[@name=$name]/geonet:text">
				<option>
					<xsl:if test="@value=$value">
						<xsl:attribute name="selected"/>
					</xsl:if>
					<xsl:variable name="choiceValue" select="string(@value)"/>
					<xsl:attribute name="value"><xsl:value-of select="$choiceValue"/></xsl:attribute>

					<!-- codelist in edit mode -->
					<xsl:variable name="label" select="/root/gui/schemas/*[name(.)=$schema]/codelist[@name = $parent]/entry[code=$choiceValue]/label"/>
					<xsl:choose>
						<xsl:when test="$label"><xsl:value-of select="$label"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$choiceValue"/></xsl:otherwise>
					</xsl:choose>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<!-- ================================================================ -->
	<!-- mcp:MD_Commons - offer creative commons editing          -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:MD_Commons[@mcp:commonsType='Creative Commons']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="doCC-2.0">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================ -->

	<xsl:template name="doCC-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="content">

			<!-- get the id of this element to pass through to the datacommons action 
			     so that screen will scroll to here after data commons -->
			<xsl:variable name="id" select="generate-id(.)"/>
				

			<xsl:apply-templates mode="elementEP" select="gmd:useLimitation|geonet:child[string(@name)='useLimitation']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>
	
			<xsl:if test="mcp:jurisdictionLink/gmd:URL!=''">
				<xsl:call-template name="showCCLicense-2.0">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="title"  select="/root/gui/schemas/iso19139.mcp/strings/currentLicense"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$edit">
				<xsl:call-template name="complexElementGui">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/licenseSelector"/>
					<xsl:with-param name="content">

						<xsl:variable name="ref" select="mcp:jurisdictionLink/gmd:URL/geonet:element/@ref"/>
						<xsl:variable name="jvalue" select="mcp:jurisdictionLink/gmd:URL"/>
						<xsl:variable name="uvalue">
							<xsl:choose>
								<xsl:when test="normalize-space(mcp:licenseLink/gmd:URL)!=''">
									<xsl:value-of select="mcp:licenseLink/gmd:URL"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'none'"/>
								</xsl:otherwise>
				 		</xsl:choose>
						</xsl:variable>
						<xsl:variable name="type">
							<xsl:choose>
								<xsl:when test="name(..)='gmd:resourceConstraints'">
									<xsl:value-of select="'data'"/>
								</xsl:when>
								<xsl:when test="name(..)='gmd:metadataConstraints'">
									<xsl:value-of select="'metadata'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'none'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<tr>
							<td class="padded" width="50%">
								<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/licenseSelectorJurisdiction"/>
							</td>
							<td class="padded" width="50%">
								<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/licenseSelectorSelector"/>
							</td>
						</tr>
						<tr>
							<td class="padded" width="50%">
								<select class="md" id="ccjuris_{$ref}"> 
									<xsl:for-each select="/root/gui/ccjurisdictions/*">
										<option value="{@value}">
											<xsl:if test="@value=$jvalue">
												<xsl:attribute name="selected"/>
											</xsl:if>
											<xsl:value-of select="."/>
										</option>
									</xsl:for-each>
								</select>
							</td>
							<td class="padded">
							<xsl:choose>
								<xsl:when test="mcp:jurisdictionLink/gmd:URL!=''">
									<button class="content" onclick="doResetCommonsAction('{/root/gui/locService}/metadata.creativecommons.form','ccjuris_{$ref}','{$uvalue}','{$type}','{$id}','_{mcp:licenseLink/gmd:URL/geonet:element/@ref}')">
										<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/creativeCommonsLicenseSelector"/>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<button class="content" onclick="doCommonsAction('{/root/gui/locService}/metadata.creativecommons.form','ccjuris_{$ref}','{$uvalue}','{$type}','{$id}')">
										<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/creativeCommonsLicenseSelector"/>
									</button>
								</xsl:otherwise>
							</xsl:choose>
							</td>
						</tr>
						<xsl:if test="normalize-space(mcp:licenseLink/gmd:URL)!=''">
							<tr>
								<td colspan="2">
									<!-- Hidden value so that we can clear it on reset -->
									<input type="hidden" id="_{mcp:licenseLink/gmd:URL/geonet:element/@ref}" name="_{mcp:licenseLink/gmd:URL/geonet:element/@ref}" value="{mcp:licenseLink/gmd:URL}"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="schema"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:apply-templates mode="elementEP" select="mcp:attributionConstraints|geonet:child[string(@name)='attributionConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
	
			<xsl:apply-templates mode="elementEP" select="mcp:otherConstraints|geonet:child[string(@name)='otherConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
	

			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
  
	<!-- ================================================================ -->
	<!-- mcp:MD_Commons - offer data commons editing                  -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:MD_Commons[@mcp:commonsType='Data Commons']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="doDC-2.0">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================ -->

	<xsl:template name="doDC-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="content">

			<!-- get the id of this element to pass through to the datacommons action 
			     so that screen will scroll to here after data commons -->
			<xsl:variable name="id" select="generate-id(.)"/>
				

			<xsl:apply-templates mode="elementEP" select="gmd:useLimitation|geonet:child[string(@name)='useLimitation']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>
	
			<xsl:if test="mcp:jurisdictionLink/gmd:URL!=''">
				<xsl:call-template name="showDCLicense-2.0">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="title"  select="/root/gui/schemas/iso19139.mcp/strings/currentLicense"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$edit">
				<xsl:call-template name="complexElementGui">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/licenseSelector"/>
					<xsl:with-param name="content">

						<xsl:variable name="ref" select="mcp:jurisdictionLink/gmd:URL/geonet:element/@ref"/>
						<xsl:variable name="jvalue" select="mcp:jurisdictionLink/gmd:URL"/>
						<xsl:variable name="uvalue">
							<xsl:choose>
								<xsl:when test="normalize-space(mcp:licenseLink/gmd:URL)!=''">
									<xsl:value-of select="mcp:licenseLink/gmd:URL"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'none'"/>
								</xsl:otherwise>
				 		</xsl:choose>
						</xsl:variable>
						<xsl:variable name="type">
							<xsl:choose>
								<xsl:when test="name(..)='gmd:resourceConstraints'">
									<xsl:value-of select="'data'"/>
								</xsl:when>
								<xsl:when test="name(..)='gmd:metadataConstraints'">
									<xsl:value-of select="'metadata'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'none'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<tr>
							<td class="padded" width="50%">
								<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/licenseSelectorJurisdiction"/>
							</td>
							<td class="padded" width="50%">
								<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/licenseSelectorSelector"/>
							</td>
						</tr>
						<tr>
							<td class="padded" width="50%">
								<select class="md" id="dcjuris_{$ref}"> 
									<xsl:for-each select="/root/gui/dcjurisdictions/select/*">
										<option value="{@value}">
											<xsl:if test="@value=$jvalue">
												<xsl:attribute name="selected"/>
											</xsl:if>
											<xsl:value-of select="."/>
										</option>
									</xsl:for-each>
								</select>
							</td>
							<td class="padded">
							<xsl:choose>
								<xsl:when test="mcp:jurisdictionLink/gmd:URL!=''">
									<button class="content" onclick="doResetCommonsAction('{/root/gui/locService}/metadata.datacommons.form','dcjuris_{$ref}','{$uvalue}','{$type}','{$id}','_{mcp:licenseLink/gmd:URL/geonet:element/@ref}')">
										<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/dataCommonsLicenseSelector"/>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<button class="content" onclick="doCommonsAction('{/root/gui/locService}/metadata.datacommons.form','dcjuris_{$ref}','{$uvalue}','{$type}','{$id}')">
										<xsl:value-of select="/root/gui/schemas/iso19139.mcp/strings/dataCommonsLicenseSelector"/>
									</button>
								</xsl:otherwise>
							</xsl:choose>
							</td>
						</tr>
						<xsl:if test="normalize-space(mcp:licenseLink/gmd:URL)!=''">
							<tr>
								<td colspan="2">
									<!-- Hidden value so that we can clear it on reset -->
									<input type="hidden" id="_{mcp:licenseLink/gmd:URL/geonet:element/@ref}" name="_{mcp:licenseLink/gmd:URL/geonet:element/@ref}" value="{mcp:licenseLink/gmd:URL}"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="schema"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:apply-templates mode="elementEP" select="mcp:attributionConstraints|geonet:child[string(@name)='attributionConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="mcp:derivativeConstraints|geonet:child[string(@name)='derivativeConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
	
			<xsl:apply-templates mode="elementEP" select="mcp:commercialUseConstraints|geonet:child[string(@name)='commercialUseConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
	
			<xsl:apply-templates mode="elementEP" select="mcp:collectiveWorksConstraints|geonet:child[string(@name)='collectiveWorksConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
	
			<xsl:apply-templates mode="elementEP" select="mcp:otherConstraints|geonet:child[string(@name)='otherConstraints']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
	
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================ -->

	<xsl:template name="showCCLicense-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="title"/>
		<xsl:param name="edit" select="false()"/>

		<xsl:variable name="url" select="mcp:jurisdictionLink/gmd:URL"/>
		<xsl:variable name="licUrl" select="mcp:licenseLink/gmd:URL"/>
		<xsl:variable name="licName" select="mcp:licenseName/gco:CharacterString"/>
		<xsl:variable name="imUrl" select="mcp:imageLink/gmd:URL"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="false()"/>
			<xsl:with-param name="title"   select="$title"/>
			<xsl:with-param name="content">

				<tr>
				<td class="padded">
					<a onclick="setBunload(false);" href="javascript:popWindow('{$url}'); setBunload(true);"><xsl:value-of select="concat('Jurisdiction: ',substring-before(substring-after($url,concat($ccurl-2.0,'/international/')),'/'))"/></a>
				</td> 
				<td class="padded">
					<a onclick="setBunload(false);" href="javascript:popWindow('{$licUrl}'); setBunload(true);"><IMG align="middle" src="{$imUrl}" longdesc="{$licUrl}" alt="{$licName}"></IMG></a>
				</td>
				<td class="padded">
					<a onclick="setBunload(false);" href="javascript:popWindow('{$licUrl}'); setBunload(true);"><xsl:value-of select="$licName"/></a>
				</td>
				</tr>

			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ================================================================ -->

	<xsl:template name="showDCLicense-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="title"/>
		<xsl:param name="edit" select="false()"/>

		<xsl:variable name="url" select="mcp:jurisdictionLink/gmd:URL"/>
		<xsl:variable name="licUrl" select="mcp:licenseLink/gmd:URL"/>
		<xsl:variable name="licName" select="mcp:licenseName/gco:CharacterString"/>
		<xsl:variable name="imUrl" select="mcp:imageLink/gmd:URL"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="false()"/>
			<xsl:with-param name="title"   select="$title"/>
			<xsl:with-param name="content">

				<tr>
				<td class="padded">
					<a onclick="setBunload(false);" href="javascript:popWindow('{$url}'); setBunload(true);"><xsl:value-of select="concat('Jurisdiction: ',substring-before(substring-after($url,concat($dcurl-2.0,'/international/')),'/'))"/></a>
				</td> 
				<td class="padded">
					<a onclick="setBunload(false);" href="javascript:popWindow('{$licUrl}'); setBunload(true);"><IMG align="middle" src="{$imUrl}" longdesc="{$licUrl}" alt="{$licName}"></IMG></a>
				</td>
				<td class="padded">
					<a onclick="setBunload(false);" href="javascript:popWindow('{$licUrl}'); setBunload(true);"><xsl:value-of select="$licName"/></a>
				</td>
				</tr>

			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ================================================================ -->
	<!-- mcp:beginTime and mcp:endTime - deprecated - not editable        -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:beginTime|mcp:endTime" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"   select="false()"/>
			<xsl:with-param name="text">
				<xsl:variable name="time" select="gco:Date|gco:DateTime"/>
				<xsl:variable name="deprecated" select="/root/gui/schemas/iso19139.mcp/deprecatedTimeStrings"/>
				<xsl:choose>
					<xsl:when test="normalize-space($time)=''">
						<xsl:value-of select="$deprecated"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($time,' (',$deprecated,')')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================ -->
	<!-- These elements cannot be edited                                  -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:revisionDate|gmd:metadataStandardName|gmd:metadataStandardVersion">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<!-- Doesn't matter what mode this is - we don't allow editing -->
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="false()"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================== -->
	<!-- Callbacks from metadata-iso19139.xsl to add mcp specific content   -->
	<!-- ================================================================== -->

<!-- mcp extensions in gmd:MD_Metadata need to be added to brief template -->

	<xsl:template name="iso19139.mcp-2.0-brief">

		<revisiondate>
			<xsl:value-of select="mcp:revisionDate"/>
		</revisiondate>

		<xsl:for-each select="gmd:identificationInfo/mcp:MD_DataIdentification">
			<xsl:for-each select=".//mcp:MD_Commons[@mcp:commonsType='Creative Commons']">
				<creativecommons>
					<xsl:for-each select="*">
						<xsl:element name="{local-name(.)}">
							<xsl:value-of select="*/text()|*/@codeListValue"/>
						</xsl:element>
					</xsl:for-each>
				</creativecommons>
			</xsl:for-each>

			<xsl:for-each select=".//mcp:MD_Commons[@mcp:commonsType='Data Commons']">
				<datacommons>
					<xsl:for-each select="*">
						<xsl:element name="{local-name(.)}">
							<xsl:value-of select="*/text()|*/@codeListValue"/>
						</xsl:element>
					</xsl:for-each>
				</datacommons>
			</xsl:for-each>

			<xsl:choose>

				<!-- 1. role=moralRightsOwner -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='moralRightsOwner']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='moralRightsOwner']">
						<moralrightsowner>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</moralrightsowner>
					</xsl:for-each>
				</xsl:when>

				<!-- 2. role=ipOwner -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='ipOwner']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='ipOwner']">
						<ipOwner>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</ipOwner>
					</xsl:for-each>
				</xsl:when>

				<!-- 3. role=owner -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='owner']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='licensor']">
						<owner>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</owner>
					</xsl:for-each>
				</xsl:when>

				<!-- 4. role=principalInvestigator -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='principalInvestigator']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='principalInvestigator']">
						<principalInvestigator>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</principalInvestigator>
					</xsl:for-each>
				</xsl:when>

				<!-- 5. role=licensor -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='licensor']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='licensor']">
						<licensor>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</licensor>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>

			<xsl:for-each select="gmd:extent/mcp:EX_Extent/gmd:temporalElement/mcp:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
				<temporalExtent>
					<begin><xsl:apply-templates mode="brieftime" select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/></begin>
					<end><xsl:apply-templates mode="brieftime" select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/></end>
				</temporalExtent>
			</xsl:for-each>

			<xsl:for-each select="gmd:extent/mcp:EX_Extent/mcp:taxonomicElement/mcp:EX_TaxonomicCoverage/mcp:presentationLink">
				<taxonomicCoverage>	
					<link><xsl:value-of select="string(.)"/></link>
				</taxonomicCoverage>
			</xsl:for-each>
			
		</xsl:for-each>
	</xsl:template>
	
<!-- helper to create a simplified view of a CI_ResponsibleParty block -->

	<xsl:template mode="responsiblepartyprocessor" match="*">
		<xsl:choose>
			<xsl:when test="*">
				<xsl:apply-templates mode="responsiblepartyprocessor"/>
			</xsl:when>
			<xsl:when test="text()!=''">
				<xsl:element name="{local-name(..)}">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- ==================================================================== -->
	<!-- mcp:MD_Metadata -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:MD_Metadata">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded" select="false()"/>

		<xsl:variable name="dataset" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset'  or gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataObject'	or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>

		<xsl:choose>
			<!-- simple tab -->
			<xsl:when test="$currTab='simple'">
        <xsl:call-template name="iso19139mcpSimple-2.0">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:call-template>
			</xsl:when>

			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19139McpMetadata-2.0">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>

			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
			</xsl:when>

			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- embedded distribution tab -->
			<xsl:when test="$currTab='distribution2'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- temporalExtent tab -->
			<xsl:when test="$currTab='temporalExtent'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:extent/*/gmd:temporalElement|gmd:identificationInfo/*/gmd:extent/*/geonet:child[string(@name)='temporalElement']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- spatialExtent tab -->
			<xsl:when test="$currTab='spatialExtent'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement|gmd:identificationInfo/*/gmd:extent/*/geonet:child[string(@name)='geographicElement']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- appSchInfo tab -->
			<xsl:when test="$currTab='appSchInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- porCatInfo tab -->
			<xsl:when test="$currTab='porCatInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- contentInfo tab -->
      <xsl:when test="$currTab='contentInfo'">
        <xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- extensionInfo tab -->
      <xsl:when test="$currTab='extensionInfo'">
        <xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

			<!-- mcpMinimum -->
			<xsl:when test="$currTab='mcpMinimum'">
				<xsl:call-template name="mcp-2.0">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="false()"/>
				</xsl:call-template>
			</xsl:when>

			<!-- mcpCore -->
			<xsl:when test="$currTab='mcpCore'">
				<xsl:call-template name="mcp-2.0">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="true()"/>
				</xsl:call-template>
			</xsl:when>

			<!-- default - display everything - usually just tab="complete" -->
			<xsl:otherwise>
			
				<xsl:call-template name="iso19139Complete">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>

				<!-- mcp:revisionDate is the only element added mcp:MD_Metadata -->

				<xsl:apply-templates mode="elementEP" select="mcp:revisionDate|geonet:child[string(@name)='revisionDate']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================= -->

  <xsl:template name="iso19139McpMetadata-2.0">
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
  		<xsl:with-param name="edit" select="true()"/>
  		<xsl:with-param name="content">
  	
			<!-- if the parent is root then display fields not in tabs -->
				<xsl:choose>
	    		<xsl:when test="name(..)='root'">
			    <xsl:apply-templates mode="elementEP" select="gmd:fileIdentifier|geonet:child[string(@name)='fileIdentifier']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:language|geonet:child[string(@name)='language']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:characterSet|geonet:child[string(@name)='characterSet']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:parentIdentifier|geonet:child[string(@name)='parentIdentifier']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:hierarchyLevel|geonet:child[string(@name)='hierarchyLevel']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:hierarchyLevelName|geonet:child[string(@name)='hierarchyLevelName']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:dateStamp|geonet:child[string(@name)='dateStamp']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
					<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardName|geonet:child[string(@name)='metadataStandardName']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardVersion|geonet:child[string(@name)='metadataStandardVersion']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
	
					<xsl:choose>
						<xsl:when test="$useExperimentalContacts-2.0">
		    			<xsl:apply-templates mode="elementEP" select="gmd:contact">
		      			<xsl:with-param name="schema" select="$schema"/>
		      			<xsl:with-param name="edit"   select="$edit"/>
		    			</xsl:apply-templates>

				    	<xsl:apply-templates mode="elementEP" select="mcp:metadataContactInfo|geonet:child[string(@name)='metadataContactInfo']">
		      			<xsl:with-param name="schema" select="$schema"/>
		      			<xsl:with-param name="edit"   select="$edit"/>
		    			</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
		    			<xsl:apply-templates mode="elementEP" select="gmd:contact|geonet:child[string(@name)='contact']">
		      			<xsl:with-param name="schema" select="$schema"/>
		      			<xsl:with-param name="edit"   select="$edit"/>
		    			</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:dataSetURI|geonet:child[string(@name)='dataSetURI']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:locale|geonet:child[string(@name)='locale']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:series|geonet:child[string(@name)='series']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:describes|geonet:child[string(@name)='describes']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:propertyType|geonet:child[string(@name)='propertyType']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
				<xsl:apply-templates mode="elementEP" select="gmd:featureType|geonet:child[string(@name)='featureType']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:featureAttribute|geonet:child[string(@name)='featureAttribute']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>

		    	<xsl:apply-templates mode="elementEP" select="mcp:revisionDate|geonet:child[string(@name)='revisionDate']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="false()"/>
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
<!-- mcp tabs -->
	
	<xsl:template name="mcp-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>

		<!-- from mandatory and core elements table of MCP 1.4 -->

		<!-- dataset or resource info in its/their own box -->
	
		<xsl:for-each select="gmd:identificationInfo/mcp:MD_DataIdentification|gmd:identificationInfo/srv:SV_ServiceIdentification">
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="$dataset">
						<xsl:value-of select="'Data Identification'"/>
					</xsl:when>
					<xsl:when test="local-name(.)='SV_ServiceIdentification'">
						<xsl:value-of select="'Service Identification'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'Resource Identification'"/>
					</xsl:otherwise>
				</xsl:choose> 
				</xsl:with-param>
				<xsl:with-param name="content">
	
				<xsl:apply-templates mode="elementEP" select="gmd:citation/*/gmd:title|gmd:citation/*/geonet:child[string(@name)='title']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="gmd:citation/*/gmd:date|gmd:citation/*/geonet:child[string(@name)='date']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="gmd:abstract|geonet:child[string(@name)='abstract']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<!-- if core elements tab then add pointOfContact and descriptive 
				     keywords -->

				<xsl:if test="$core">
					<xsl:choose>
						<xsl:when test="$useExperimentalContacts-2.0">
							<xsl:apply-templates mode="elementEP" select="gmd:pointOfContact">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>

							<xsl:apply-templates mode="elementEP" select="mcp:resourceContactInfo|geonet:child[string(@name)='resourceContactInfo']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates mode="elementEP" select="gmd:pointOfContact|geonet:child[string(@name)='pointOfContact']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>

					<!-- keywords is not part of MCP core elements but it should be -->

					<xsl:apply-templates mode="elementEP" select="gmd:descriptiveKeywords|geonet:child[string(@name)='descriptiveKeywords']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				<xsl:if test="$core and $dataset">
					<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationType|geonet:child[string(@name)='spatialRepresentationType']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP" select="gmd:spatialResolution|geonet:child[string(@name)='spatialResolution']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				<xsl:if test="$core">
					<xsl:apply-templates mode="elementEP" select="gmd:language|geonet:child[string(@name)='language']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				<!-- topic category is mandatory if dataset -->

				<xsl:if test="$dataset">
					<xsl:apply-templates mode="elementEP" select="gmd:topicCategory|geonet:child[string(@name)='topicCategory']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				<!-- geographic extent is mandatory -->

				<xsl:if test="$dataset">
					<xsl:apply-templates mode="elementEP" select="gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox|gmd:extent/*/gmd:geographicElement/geonet:child[string(@name)='EX_GeographicBoundingBox']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				<!-- temporal extent and taxonomic extent in their own boxes if 
				     core -->

				<xsl:if test="$dataset and $core">
					<xsl:apply-templates mode="elementEP" select="gmd:extent/*/gmd:EX_TemporalExtent|gmd:extent/*/geonet:child[string(@name)='EX_TemporalExtent']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP" select="gmd:extent/*/gmd:EX_TaxonomicExtent|gmd:extent/*/geonet:child[string(@name)='EX_TaxonomicExtent']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="realname"   select="'mcp:MD_DataIdentification'"/>
			</xsl:call-template>
		
		</xsl:for-each>
		
		<xsl:if test="$core and $dataset">

		<!-- scope and lineage in their own box -->
		
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/lineage"/>
				<xsl:with-param name="content">

				<xsl:for-each select="gmd:dataQualityInfo/gmd:DQ_DataQuality">
					<xsl:apply-templates mode="elementEP" select="gmd:scope|geonet:child[string(@name)='scope']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP" select="gmd:lineage|geonet:child[string(@name)='lineage']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:for-each>

				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="group" select="/root/gui/strings/dataQualityTab"/>
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="realname"   select="'gmd:dataQualityInfo'"/>
			</xsl:call-template>

		<!-- referenceSystemInfo in its own box -->

			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/referenceSystemInfo"/>
				<xsl:with-param name="content">

				<xsl:for-each select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem">
					<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code|gmd:referenceSystemIdentifier/gmd:RS_Identifier/geonet:child[string(@name)='code']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace|gmd:referenceSystemIdentifier/gmd:RS_Identifier/geonet:child[string(@name)='codeSpace']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:for-each>

				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="group" select="/root/gui/strings/refSysTab"/>
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="realname"   select="'gmd:referenceSystemInfo'"/>
			</xsl:call-template>

		<!-- distribution Format and onlineResource(s) in their own box -->
			
    	<xsl:call-template name="complexElementGuiWrapper">
      	<xsl:with-param name="title" select="'Distribution and On-line Resource(s)'"/>
      	<xsl:with-param name="content">

				<xsl:for-each select="gmd:distributionInfo">
        	<xsl:apply-templates mode="elementEP" select="*/gmd:distributionFormat|*/geonet:child[string(@name)='distributionFormat']">
          	<xsl:with-param name="schema" select="$schema"/>
          	<xsl:with-param name="edit"   select="$edit"/>
        	</xsl:apply-templates>

        	<xsl:apply-templates mode="elementEP" select="*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine|*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/geonet:child[string(@name)='onLine']">
          	<xsl:with-param name="schema" select="$schema"/>
          	<xsl:with-param name="edit"   select="$edit"/>
        	</xsl:apply-templates>
				</xsl:for-each>

      	</xsl:with-param>
      	<xsl:with-param name="schema" select="$schema"/>
      	<xsl:with-param name="group" select="/root/gui/strings/distributionTab"/>
      	<xsl:with-param name="edit" select="$edit"/>
      	<xsl:with-param name="realname" select="gmd:distributionInfo"/>
    	</xsl:call-template>

		</xsl:if>

		<!-- metadata info in its own box -->
		
		<xsl:call-template name="complexElementGuiWrapper">
			<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/metadataInfo"/>
			<xsl:with-param name="content">

			<xsl:apply-templates mode="elementEP" select="gmd:fileIdentifier|geonet:child[string(@name)='fileIdentifier']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
		
			<xsl:apply-templates mode="elementEP" select="gmd:language|geonet:child[string(@name)='language']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
		
			<xsl:apply-templates mode="elementEP" select="gmd:characterSet|geonet:child[string(@name)='characterSet']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
		
		<!-- metadata contact info in its own box -->

			<xsl:for-each select="gmd:contact[gmd:CI_ResponsibleParty]">

			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/contact"/>
				<xsl:with-param name="content">

				<xsl:apply-templates mode="elementEP" select="*/gmd:individualName|*/geonet:child[string(@name)='individualName']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="*/gmd:organisationName|*/geonet:child[string(@name)='organisationName']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="*/gmd:positionName|*/geonet:child[string(@name)='positionName']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="*/gmd:role|*/geonet:child[string(@name)='role']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="*/gmd:contactInfo|*/geonet:child[string(@name)='contactInfo']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:call-template>

			</xsl:for-each>

		<xsl:if test="$useExperimentalContacts-2.0">
			<xsl:for-each select="mcp:metadataContactInfo/mcp:CI_Responsibility">

			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/contact"/>
				<xsl:with-param name="content">

				<xsl:apply-templates mode="elementEP" select="mcp:role|geonet:child[string(@name)='role']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="mcp:extent|geonet:child[string(@name)='extent']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:for-each select="mcp:party/mcp:CI_Organisation">

				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/organisation"/>
					<xsl:with-param name="content">

					<xsl:apply-templates mode="elementEP" select="mcp:name|geonet:child[string(@name)='name']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP" select="mcp:contactInfo|geonet:child[string(@name)='contactInfo']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<xsl:for-each select="mcp:individual/mcp:CI_Individual">
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/individual"/>
						<xsl:with-param name="content">
	
						<xsl:apply-templates mode="elementEP" select="mcp:name|geonet:child[string(@name)='name']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mcp:contactInfo|geonet:child[string(@name)='contactInfo']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						<xsl:apply-templates mode="elementEP" select="mcp:positionName|geonet:child[string(@name)='positionName']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

						</xsl:with-param>
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
						<xsl:with-param name="edit" select="$edit"/>
					</xsl:call-template>

					</xsl:for-each>

					</xsl:with-param>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:call-template>

				</xsl:for-each>

				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:call-template>

			</xsl:for-each>
		</xsl:if>

		<!-- more metadata elements -->

			<xsl:apply-templates mode="elementEP" select="gmd:dateStamp|geonet:child[string(@name)='dateStamp']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>

			<xsl:if test="$core">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardName|geonet:child[string(@name)='metadataStandardName']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
	
				<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardVersion|geonet:child[string(@name)='metadataStandardVersion']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:if>

		<!-- mcp:revisionDate is mandatory (despite what the MCP doc says!)  -->
		
			<xsl:apply-templates mode="elementEP" select="mcp:revisionDate|geonet:child[string(@name)='revisionDate']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>

			</xsl:with-param>
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="group" select="/root/gui/strings/metadataTab"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:metadataContactInfo|mcp:resourceContactInfo|mcp:responsibleParty">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content">
				<xsl:apply-templates mode="elementEP" select="mcp:CI_Responsibility|geonet:child[string(@name)='CI_Responsibility']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:CI_Responsibility">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="mcp:role|geonet:child[string(@name)='role']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<!-- extent is not necessary for simple/default mode -->
		<xsl:if test="not($flat)">
			<xsl:apply-templates mode="elementEP" select="mcp:extent|geonet:child[string(@name)='extent']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:apply-templates mode="elementEP" select="mcp:party|geonet:child[string(@name)='party']">
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="schema" select="$schema"/>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:party|geonet:child[string(@name)='party']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="partyTemplate-2.0">
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="partyTemplate-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="content">
			<xsl:apply-templates mode="elementEP" select="@xlink:href">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:apply-templates>
			
			<xsl:apply-templates mode="elementEP" select="mcp:CI_Organisation|geonet:child[string(@name)='CI_Organisation']">
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="mcp:CI_Individual|geonet:child[string(@name)='CI_Individual']">
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content" select="$content"/>
		</xsl:apply-templates>
		
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:CI_Individual|geonet:child[string(@name)='CI_Individual']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

			
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="content">
									
				<xsl:apply-templates mode="elementEP" select="../@xlink:href">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
									
				<xsl:apply-templates mode="elementEP" select="mcp:name|geonet:child[string(@name)='name']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
									
				<xsl:apply-templates mode="elementEP" select="mcp:positionName|geonet:child[string(@name)='positionName']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<!-- Show contact info when not in simple/default view and 
				     individuals not part of an organisation -->
				<xsl:if test="not($flat and name(..)='mcp:individual')">
					<xsl:apply-templates mode="elementEP" select="mcp:contactInfo|geonet:child[string(@name)='contactInfo']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>
									
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================== -->
	<!-- mcp Online Resource space reduced when only one resource available -->
	<!-- ================================================================== -->

	<xsl:template mode="iso19139.mcp-2.0" match="gmd:distributionInfo">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="tab"/>
		<xsl:param name="core"/>

		<xsl:for-each select=".">
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19139.mcp/strings/distributionOnlineInfo"/>
				<xsl:with-param name="tab" select="$tab"/>
				<xsl:with-param name="content">

				<xsl:choose>
					<xsl:when test="$edit=true() or count(*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine)>1"> <!-- TODO: include 'more than one resource' test in if statement ticket:159 -->
						<xsl:for-each select=".">
							<xsl:apply-templates mode="elementEP" select="*/gmd:distributionFormat|*/geonet:child[string(@name)='distributionFormat']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
 
							<xsl:apply-templates mode="elementEP" select="*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine|*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/geonet:child[string(@name)='onLine']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select=".">
							<xsl:apply-templates mode="elementEP" select="*/gmd:distributionFormat|*/geonet:child[string(@name)='distributionFormat']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>

							<xsl:apply-templates mode="element" select="*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine|*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/geonet:child[string(@name)='onLine']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
								<xsl:with-param name="flat"   select="true()"/>
							</xsl:apply-templates>							
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="group" select="/root/gui/strings/distributionTab"/>
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="realname"   select="'gmd:distributionInfo'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="iso19139mcpSimple-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:call-template name="complexElementGui">
			<xsl:with-param name="title" select="/root/gui/strings/metadata"/>
			<xsl:with-param name="content">
				<xsl:call-template name="iso19139mcpSimpleMDMetadata-2.0">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>

		<xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="iso19139mcpSimpleMDMetadata-2.0">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="gmd:fileIdentifier|geonet:child[string(@name)='fileIdentifier']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:language|geonet:child[string(@name)='language']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:characterSet|geonet:child[string(@name)='characterSet']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:parentIdentifier|geonet:child[string(@name)='parentIdentifier']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:hierarchyLevel|geonet:child[string(@name)='hierarchyLevel']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:hierarchyLevelName|geonet:child[string(@name)='hierarchyLevelName']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:dateStamp|geonet:child[string(@name)='dateStamp']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardName|geonet:child[string(@name)='metadataStandardName']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardVersion|geonet:child[string(@name)='metadataStandardVersion']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:choose>
			<xsl:when test="$useExperimentalContacts-2.0">
				<xsl:apply-templates mode="elementEP" select="gmd:contact">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="elementEP" select="mcp:metadataContactInfo|geonet:child[string(@name)='metadataContactInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="elementEP" select="gmd:contact|geonet:child[string(@name)='contact']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:apply-templates mode="elementEP" select="gmd:dataSetURI|geonet:child[string(@name)='dataSetURI']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:locale|geonet:child[string(@name)='locale']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:series|geonet:child[string(@name)='series']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:describes|geonet:child[string(@name)='describes']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:propertyType|geonet:child[string(@name)='propertyType']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:featureType|geonet:child[string(@name)='featureType']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:featureAttribute|geonet:child[string(@name)='featureAttribute']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template mode="iso19139.mcp-2.0" match="mcp:MD_DataIdentification">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="elementEP" select="gmd:citation|geonet:child[string(@name)='citation']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:abstract|geonet:child[string(@name)='abstract']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:purpose|geonet:child[string(@name)='purpose']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:credit|geonet:child[string(@name)='credit']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:status|geonet:child[string(@name)='status']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:choose>
			<xsl:when test="$useExperimentalContacts-2.0">
				<xsl:apply-templates mode="elementEP" select="gmd:pointOfContact">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="mcp:resourceContactInfo|geonet:child[string(@name)='resourceContactInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="elementEP" select="gmd:pointOfContact|geonet:child[string(@name)='pointOfContact']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
			</xsl:otherwise>
		</xsl:choose>
			
		<xsl:apply-templates mode="elementEP" select="gmd:resourceMaintenance|geonet:child[string(@name)='resourceMaintenance']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:graphicOverview|geonet:child[string(@name)='graphicOverview']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:resourceFormat|geonet:child[string(@name)='resourceFormat']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:descriptiveKeywords|geonet:child[string(@name)='descriptiveKeywords']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:resourceSpecificUsage|geonet:child[string(@name)='resourceSpecificUsage']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:resourceConstraints|geonet:child[string(@name)='resourceConstraints']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:aggregationInfo|geonet:child[string(@name)='aggregationInfo']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationType|geonet:child[string(@name)='spatialRepresentationType']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:spatialResolution|geonet:child[string(@name)='spatialResolution']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:language|geonet:child[string(@name)='language']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:characterSet|geonet:child[string(@name)='characterSet']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:topicCategory|geonet:child[string(@name)='topicCategory']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:environmentDescription|geonet:child[string(@name)='environmentDescription']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:extent|geonet:child[string(@name)='extent']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:supplementalInformation|geonet:child[string(@name)='supplementalInformation']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="gmd:samplingFrequency|geonet:child[string(@name)='samplingFrequency']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mcp:sensor|geonet:child[string(@name)='sensor']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mcp:sensorCalibrationProcess|geonet:child[string(@name)='sensorCalibrationProcess']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="mcp:dataParameters|geonet:child[string(@name)='dataParameters']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

	</xsl:template>

	<!-- ==================================================================== -->
  <!-- === iso19139.mcp-2.0 brief formatting === -->
  <!-- ==================================================================== -->

	<xsl:template name="iso19139.mcp-2.0Brief">
		<metadata>
				<!-- call iso19139 brief -->
	 			<xsl:call-template name="iso19139-brief"/>
				<!-- now brief elements for mcp specific elements -->
				<xsl:call-template name="iso19139.mcp-2.0-brief"/>
		</metadata>
	</xsl:template>

	<!-- match everything else and do nothing - leave that to iso19139 mode -->
	<xsl:template mode="iso19139.mcp-2.0" match="*|@*"/> 

	<!-- ==================================================================== -->
  <!-- === Javascript used by functions in this presentation XSLT -->
  <!-- ==================================================================== -->

	<!-- Javascript used by functions in this XSLT -->
	<xsl:template name="iso19139.mcp-2.0-javascript">
		<script type="text/javascript">
		<![CDATA[
/**
 * JavaScript Functions to support Marine Community Profile
 */

function submitTaxonSearch(refToUpdate) {
				// submit search to APC/AFD search URL with params
				// using Ajax.Updater

				$('taxonSearchButton').hide();
				$('taxonSearchWaitMessage').show();


				var forwardUrl = 'http://biodiversity.org.au/name/?';
				
				var forwardTempBeg =
					'<request>'+
					'   <site>'+
					'      <url>{URL}</url>'+
					'      <type>other</type>'+
					'   </site>'+
					'   <params>';
				var forwardTempEnd = '</params>'+
					'</request>';

				// build params from form
				var hmParams = $('taxonSearchForm').serialize(true);
				var params = '';

				for (var name in hmParams) {
					params = params + '<'+name+'>'+hmParams[name]+'</'+name+'>\n';
				}
		
				var request = str.substitute(forwardTempBeg, { URL : forwardUrl })+params+forwardTempEnd;

				ker.send('xml.forward.taxonsearch', request, ker.wrap(this, retrieve_OK));
				
				function retrieve_OK(xmlRes) {
					var selectedId = 'assignedTaxonName';
					if (xmlRes.nodeName == 'error')
						ker.showError('taxonSearchError', xmlRes);
					else {
						var list = xml.children(xmlRes);
						var taxonSearchResults = $('taxonSearchResults');
						taxonSearchResults.update(); // clear it out
						for (var i=0; i < list.length; i++) {
							var data = xml.toObject(list[i]);

							var divSel = new Element('div', { 'id': 'row_'+i, 'style': 'position:relative;left:-20px;top:-20px' });
							var divName = new Element('div', { 'class': 'table-left' }).update(data.name);
							divName.insert(divSel, divName);
							var divScore = new Element('div', { 'class': 'table-middle' }).update(data.score);
							var anchor = new Element('a', { 'class': 'content', 'onclick': "clickSetRef('"+selectedId+"','"+refToUpdate+"','"+data.uri+"','"+data.name+"','"+i+"');" }).update('Use this name');
							var divAnchor = new Element('div', { 'class': 'table-right' }).update(anchor);
							var divTableRow = new Element('div', { 'class': 'table-row' });
							divTableRow.insert(divName, divTableRow);
							divTableRow.insert(divScore, divTableRow);
							divTableRow.insert(divAnchor, divTableRow);
							taxonSearchResults.insert(divTableRow, taxonSearchResults);
						}
					}

					$('taxonSearchWaitMessage').hide();
					$('taxonSearchResultsHeader').show();
					$('taxonSearchResults').show();
					$('taxonSearchButton').show();
				}

}

function clickSetRef(selectedId, refToUpdate, uri, name, index) {
					$(refToUpdate).value = uri + '.xml';

					var selected = $(selectedId);
					if (selected != null) {
						selected.remove();
					}
					var spanSel = new Element('span', { 'id': selectedId, 'class': 'searchHelpFrame', 'style': 'z-index:1000;color:#ff0000;opacity:0.75' }).update('Selected');
					$('row_'+index).insert(spanSel);
}
							
function startTaxonSearch(inputFieldToUpdate, taxonSearchTitle) {
	pars = "&ref="+inputFieldToUpdate;
	new Ajax.Request(
		getGNServiceURL('prepare.taxon.search'),
			{
				method: 'get',
				parameters: pars,
				onSuccess: function(req) {
					Modalbox.show(req.responseText ,{title: taxonSearchTitle, height: 600, width: 800} );
				},
				onFailure: function(req) {
					alert("ERROR: "+getGNServiceURL('prepare.taxon.search')+" failed: status "+req.status+" text: "+req.statusText+" - Try again later?");
				}
			}
	);
}

function showCommons(select) {
	var commons = $(select).value;

	if (commons == 'Creative Commons') $("creative").show();
	else $("creative").hide();

	if (commons == 'Data Commons') 		 $("data").show();
	else $("data").hide();
}

function doCommonsAction(action, name, licenseurl, type, id)
{
	var top = findPos($(id));
	setBunload(false);
  document.mainForm.name.value = $(name).value;
  document.mainForm.licenseurl.value = licenseurl;
  document.mainForm.type.value = type;
	document.mainForm.position.value = top;
  doAction(action);
}

function doResetCommonsAction(action, name, licenseurl, type, id, ref)
{
	$(ref).value = '';
	document.mainForm.ref.value = '';
	doCommonsAction(action, name, licenseurl, type, id);
}

		]]>
		</script>
	</xsl:template>
</xsl:stylesheet>
