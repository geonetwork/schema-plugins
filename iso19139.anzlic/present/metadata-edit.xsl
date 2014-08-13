<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="gmx xsi gmd gco gml gts srv xlink exslt geonet">

	<xsl:variable name="anzlicallgens" select="document('../schema/resources/Codelist/anzlic-allgens.xml')"/>
	<xsl:variable name="anzlicthemes" select="document('../schema/resources/Codelist/anzlic-theme.xml')"/>

	<xsl:template name="metadata-iso19139.anzlicview-simple">
	  <xsl:call-template name="metadata-iso19139view-simple"/>
	</xsl:template>

  <xsl:template name="view-with-header-iso19139.anzlic">
    <xsl:param name="tabs"/>
    
    <xsl:call-template name="view-with-header-iso19139">
      <xsl:with-param name="tabs" select="$tabs"/>
    </xsl:call-template>
  </xsl:template>
  
	<!-- main template - the way into processing iso19139.anzlic -->
  <xsl:template  name="metadata-iso19139.anzlic">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

		<!-- process in profile mode first -->
    <xsl:variable name="anzlicElements">
      <xsl:apply-templates mode="iso19139.anzlic" select="." >
        <xsl:with-param name="schema" select="$schema"/>
        <xsl:with-param name="edit"   select="$edit"/>
        <xsl:with-param name="embedded" select="$embedded" />
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:choose>

      <!-- if we got a match in profile mode then show it -->
      <xsl:when test="count($anzlicElements/*)>0">
        <xsl:copy-of select="$anzlicElements"/>
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


	<!-- ================================================================ -->
	<!-- keyword; only called in edit mode (see descriptiveKeywords -->
	<!-- template) and code keyword in gmd:geographicIdentifier           -->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.anzlic" match="gmd:keyword[following-sibling::gmd:type/gmd:MD_KeywordTypeCode/@codeListValue='place']|gmd:code[name(../..)='gmd:geographicIdentifier']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
		<xsl:when test="$edit=true()">
		
		<xsl:variable name="text">
			<xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref"/>
			<xsl:variable name="keyword" select="gco:CharacterString/text()"/>
			
			<input class="md" type="text" name="_{$ref}" value="{gco:CharacterString/text()}" size="50" />

			<!-- anzlic-allgens combobox -->

			<select name="place" size="1" onChange="document.mainForm._{$ref}.value=this.options[this.selectedIndex].text">
				<option value=""/>
				<xsl:for-each select="$anzlicallgens/gmx:CT_CodelistCatalogue/gmx:codelistItem/gmx:CodeListDictionary">
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
		
	<!-- ================================================================ -->
	<!-- anzlic theme keyword; only called in edit mode (see              -->
	<!-- descriptiveKeywords 																							-->
	<!-- ================================================================ -->

	<xsl:template mode="iso19139.anzlic" match="gmd:keyword[following-sibling::gmd:type/gmd:MD_KeywordTypeCode/@codeListValue!='place']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:choose>
		<xsl:when test="$edit=true()">
		
		<xsl:variable name="text">
			<xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref"/>
			<xsl:variable name="keyword" select="gco:CharacterString/text()"/>
			
			<input class="md" type="text" name="_{$ref}" value="{gco:CharacterString/text()}" size="50" />

			<!-- anzlic-allgens combobox -->

			<select name="place" size="1" onChange="document.mainForm._{$ref}.value=this.options[this.selectedIndex].text">
				<option value=""/>
				<xsl:for-each select="$anzlicthemes/gmx:CT_CodelistCatalogue/gmx:codelistItem/gmx:CodeListDictionary">
					<optgroup label="{gml:identifier}">
					<xsl:for-each select="gmx:codeEntry">
						<xsl:variable name="entry" select="gmx:CodeDefinition/gml:identifier"/>
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
	<!-- EX_GeographicBoundingBox - use for all schemas except iso19139     -->
	<!-- ================================================================== -->

	<xsl:template mode="iso19139.anzlic" match="gmd:EX_GeographicBoundingBox">
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

				function setAnzlicRegion(westField, eastField, southField, northField, region, eltRef, descriptionRef)
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

					<select name="place" size="1" onChange="javascript:setAnzlicRegion('{gmd:westBoundLongitude/gco:Decimal/geonet:element/@ref}', '{gmd:eastBoundLongitude/gco:Decimal/geonet:element/@ref}', '{gmd:southBoundLatitude/gco:Decimal/geonet:element/@ref}', '{gmd:northBoundLatitude/gco:Decimal/geonet:element/@ref}', this.options[this.selectedIndex], {$eltRef}, '{../../gmd:description/gco:CharacterString/geonet:element/@ref}')">
						<option value=""/>
						<xsl:for-each select="$anzlicallgens/gmx:CT_CodelistCatalogue/gmx:codelistItem/gmx:CodeListDictionary">
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

	<!-- ============================================================================= -->

	<xsl:template mode="iso19139GeoBox" match="*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		
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

    <!-- Loop on all projections defined in config-gui.xml -->
    <xsl:for-each select="/root/gui/config/map/proj/crs">
      <input id="{@code}_{$eltRef}" type="radio" class="proj" name="proj_{$eltRef}" value="{@code}">
      	<xsl:if test="@default='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
      </input>
      <!-- Set label from loc file -->
      <label for="{@code}_{$eltRef}">
        <xsl:variable name="code" select="@code"/>
        <xsl:choose>
          <xsl:when test="/root/gui/strings/*[@code=$code]"><xsl:value-of select="/root/gui/strings/*[@code=$code]"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="@code"/></xsl:otherwise>
        </xsl:choose>
      </label>
      <xsl:text> </xsl:text>
    </xsl:for-each>
        
		<table>
			<tr>
				<td class="padded" align="left" style="min-width:120px;">
				<table>
					<tr>
						<td>
					<xsl:apply-templates mode="coordinateElementGUI" select="gmd:northBoundLatitude/gco:Decimal">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name"   select="'gmd:northBoundLatitude'"/>
						<xsl:with-param name="eltRef" select="concat('n', $eltRef)"/>
					</xsl:apply-templates>
						</td>
					</tr>
					
					<tr>
						<td>
					<xsl:apply-templates mode="coordinateElementGUI" select="gmd:westBoundLongitude/gco:Decimal">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name"   select="'gmd:westBoundLongitude'"/>
						<xsl:with-param name="eltRef" select="concat('w', $eltRef)"/>
					</xsl:apply-templates>
						</td>
					</tr>
					
					<tr>
						<td>
					<xsl:apply-templates mode="coordinateElementGUI" select="gmd:eastBoundLongitude/gco:Decimal">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name"   select="'gmd:eastBoundLongitude'"/>
						<xsl:with-param name="eltRef" select="concat('e', $eltRef)"/>
					</xsl:apply-templates>
						</td>
					</tr>
					
					<tr>
						<td>
					<xsl:apply-templates mode="coordinateElementGUI" select="gmd:southBoundLatitude/gco:Decimal">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name"   select="'gmd:southBoundLatitude'"/>
						<xsl:with-param name="eltRef" select="concat('s', $eltRef)"/>
					</xsl:apply-templates>
						</td>
					</tr>
				</table>
				</td>
				<td align="center">
					<xsl:variable name="w" select="./gmd:westBoundLongitude/gco:Decimal"/>
          <xsl:variable name="e" select="./gmd:eastBoundLongitude/gco:Decimal"/>
          <xsl:variable name="n" select="./gmd:northBoundLatitude/gco:Decimal"/>
          <xsl:variable name="s" select="./gmd:southBoundLatitude/gco:Decimal"/>
                    
          <xsl:variable name="wID">
            <xsl:choose>
              <xsl:when test="$edit=true()"><xsl:value-of select="./gmd:westBoundLongitude/gco:Decimal/geonet:element/@ref"/></xsl:when>
              <xsl:otherwise>w<xsl:value-of select="$eltRef"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
                    
          <xsl:variable name="eID">
            <xsl:choose>
              <xsl:when test="$edit=true()"><xsl:value-of select="./gmd:eastBoundLongitude/gco:Decimal/geonet:element/@ref"/></xsl:when>
              <xsl:otherwise>e<xsl:value-of select="$eltRef"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
                    
          <xsl:variable name="nID">
            <xsl:choose>
              <xsl:when test="$edit=true()"><xsl:value-of select="./gmd:northBoundLatitude/gco:Decimal/geonet:element/@ref"/></xsl:when>
              <xsl:otherwise>n<xsl:value-of select="$eltRef"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
                    
          <xsl:variable name="sID">
            <xsl:choose>
              <xsl:when test="$edit=true()"><xsl:value-of select="./gmd:southBoundLatitude/gco:Decimal/geonet:element/@ref"/></xsl:when>
              <xsl:otherwise>s<xsl:value-of select="$eltRef"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
                    
                    
          <xsl:variable name="geom" >
            <xsl:value-of select="concat('Polygon((', $w, ' ', $s,',',$e,' ',$s,',',$e,' ',$n,',',$w,' ',$n,',',$w,' ',$s, '))')"/>
          </xsl:variable>
          <xsl:call-template name="showMap">
            <xsl:with-param name="edit" select="$edit" />
            <xsl:with-param name="mode" select="'bbox'" />
            <xsl:with-param name="coords" select="$geom"/>
            <xsl:with-param name="watchedBbox" select="concat($wID, ',', $sID, ',', $eID, ',', $nID)"/>
            <xsl:with-param name="eltRef" select="$eltRef"/>
          </xsl:call-template>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<!-- ============================================================================= -->
	<!-- supplementalInformation | purpose -->
	<!-- ============================================================================= -->

	<xsl:template mode="iso19139.anzlic" match="gmd:supplementalInformation|gmd:purpose|gmd:statement" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="rows"   select="5"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->
	<!-- Metadata -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19139.anzlic" match="gmd:MD_Metadata">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded" select="false()"/>

		<xsl:variable name="dataset" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset'  or gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataObject'	or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>
		
		<xsl:choose>
	
			<!-- simple tab -->
			<xsl:when test="$currTab='simple'">
        <xsl:call-template name="iso19139Simple">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:call-template>
			</xsl:when>

			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19139Metadata">
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

			<!-- anzlicMinimum tab -->
			<xsl:when test="$currTab='anzlicMinimum'">
				<xsl:call-template name="anzlic">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="false()"/>
				</xsl:call-template>
			</xsl:when>

			<!-- anzlicCore tab -->
			<xsl:when test="$currTab='anzlicCore'">
				<xsl:call-template name="anzlic">
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
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="anzlic">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>

		<!-- from mandatory and core elements table, pg 16 of AS/NZS 19115 -->

		<!-- dataset or resource info in its own box -->
	
		<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification|gmd:identificationInfo/srv:SV_ServiceIdentification">
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
	
				<xsl:apply-templates mode="elementEP" select="gmd:citation/gmd:CI_Citation/gmd:title|gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='title']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="gmd:citation/gmd:CI_Citation/gmd:date|gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='date']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<xsl:apply-templates mode="elementEP" select="gmd:abstract|geonet:child[string(@name)='abstract']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>

				<!-- dataset point of contact is optional in core elements -->

				<xsl:if test="$core">
					<xsl:apply-templates mode="elementEP" select="gmd:pointOfContact|geonet:child[string(@name)='pointOfContact']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				<!-- spatial representation and resolution are optional in core -->

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

				<!-- geographic extent is mandatory if record describes dataset -->

				<xsl:if test="$dataset">
					<xsl:apply-templates mode="elementEP" select="gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox|gmd:extent/*/gmd:geographicElement/geonet:child[string(@name)='EX_GeographicBoundingBox']">
					  <xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:if>

				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="realname"   select="name(.)"/>
			</xsl:call-template>
		
		</xsl:for-each>


		<xsl:if test="$core and $dataset">

		<!-- scope and lineage in their own box -->
		
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="'Lineage'"/>
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
      	<xsl:with-param name="group" select="/root/gui/schemas/iso19139.anzlic/strings/dataQualityTab"/>
      	<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="realname"   select="'gmd:DataQualityInfo'"/>
			</xsl:call-template>

		<!-- referenceSystemInfo in its own box -->
		
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19139.anzlic/strings/referenceSystemInfo"/>
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
      	<xsl:with-param name="title" select="/root/gui/schemas/iso19139.anzlic/strings/distributionOnlineInfo"/>
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
			<xsl:with-param name="title" select="/root/gui/schemas/iso19139.anzlic/strings/metadataInfo"/>
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

			<xsl:for-each select="gmd:contact">

				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title" select="/root/gui/schemas/iso19139.anzlic/strings/contact"/>
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

						<xsl:if test="$core and $dataset">
							<xsl:apply-templates mode="elementEP" select="*/gmd:contactInfo|*/geonet:child[string(@name)='contactInfo']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
						</xsl:if>

						<xsl:apply-templates mode="elementEP" select="*/gmd:role|*/geonet:child[string(@name)='role']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>

					</xsl:with-param>
					<xsl:with-param name="schema" select="$schema"/>
      		<xsl:with-param name="group" select="/root/gui/strings/metadata"/>
      		<xsl:with-param name="edit" select="$edit"/>
				</xsl:call-template>
		
			</xsl:for-each>

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

			</xsl:with-param>
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="group" select="/root/gui/strings/metadataTab"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:call-template>
		
	</xsl:template>

	<!-- =================================================================== -->
	<!-- display all tabs for iso19139 ANZLIC                                -->
	<!-- =================================================================== -->

	<xsl:template name="iso19139.anzlicCompleteTab">
		<xsl:param name="tabLink"/>

		<xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byGroup"/>
        <xsl:with-param name="default">anzlicCore</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="anzlicMinimum">anzlicMinimum</item>
          <item label="anzlicCore">anzlicCore</item>
          <item label="anzlicAll">anzlicAll</item>
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
	
	<!-- ===================================================================== -->
  <!-- === iso19139.anzlic brief formatting - same as iso19139           === -->
  <!-- ===================================================================== -->

	<xsl:template name="iso19139.anzlicBrief">
		<metadata>
			<!-- call iso19139 brief -->
	 		<xsl:call-template name="iso19139-brief"/>
		</metadata>
	</xsl:template>

	<!-- match everything else and do nothing - leave that to iso19139 mode -->
	<xsl:template mode="iso19139.anzlic" match="*|@*"/> 


</xsl:stylesheet>
