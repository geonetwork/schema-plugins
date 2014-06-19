<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:gts="http://www.isotc211.org/2005/gts"
    xmlns:gco="http://www.isotc211.org/2005/gco" 
    xmlns:gmx="http://www.isotc211.org/2005/gmx" 
    xmlns:srv="http://www.isotc211.org/2005/srv"
    xmlns:gml="http://www.opengis.net/gml" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:geonet="http://www.fao.org/geonetwork" 
    xmlns:exslt="http://exslt.org/common"
    exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">
    
	<!-- Overrides the basic simpleElement template of GeoNetwork in 
		order to use the customized showSimpleElement.rndt -->
	
	<xsl:template mode="simpleElement" match="*" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"   select="false()"/>
		<xsl:param name="editAttributes" select="true()"/>
		<xsl:param name="showAttributes" select="true()"/>
		<xsl:param name="title">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="text">
			<xsl:call-template name="getElementText.rndt">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:call-template name="editSimpleElement.rndt">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="editAttributes" select="$editAttributes"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="showSimpleElement.rndt">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="showAttributes" select="$showAttributes"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	shows editable fields for a simple element
	-->
	<xsl:template name="editSimpleElement.rndt">
		<xsl:param name="schema"/>
		<xsl:param name="title"/>
		<xsl:param name="editAttributes"/>
		<xsl:param name="text"/>
		<xsl:param name="helpLink"/>
		
		<!-- if it's the last brother of it's type and there is a new brother make addLink -->
		
		<xsl:variable name="id" select="geonet:element/@uuid"/>
		<xsl:variable name="addLink">
			<xsl:call-template name="addLink">
				<xsl:with-param name="id" select="$id"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="addXMLFragment">
			<xsl:call-template name="addXMLFragment">
				<xsl:with-param name="id" select="$id"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="removeLink">
			<xsl:value-of select="concat('doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',geonet:element/@ref,',',geonet:element/@parent,',',$apos,$id,$apos,',',geonet:element/@min,');')"/>
			<xsl:if test="not(geonet:element/@del='true')">
				<xsl:text>!OPTIONAL</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="upLink">
			<xsl:value-of select="concat('doMoveElementAction(',$apos,'/metadata.elem.up',$apos,',',geonet:element/@ref,',',$apos,$id,$apos,');')"/>
			<xsl:if test="not(geonet:element/@up='true')">
				<xsl:text>!OPTIONAL</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="downLink">
			<xsl:value-of select="concat('doMoveElementAction(',$apos,'/metadata.elem.down',$apos,',',geonet:element/@ref,',',$apos,$id,$apos,');')"/>
			<xsl:if test="not(geonet:element/@down='true')">
				<xsl:text>!OPTIONAL</xsl:text>
			</xsl:if>
		</xsl:variable>
		<!-- xsd and schematron validation info -->
		<xsl:variable name="validationLink">
			<xsl:variable name="ref" select="concat('#_',geonet:element/@ref)"/>
			<xsl:call-template name="validationLink">
				<xsl:with-param name="ref" select="$ref"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:call-template name="simpleElementGui.rndt">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="text" select="$text"/>
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="addLink" select="$addLink"/>
			<xsl:with-param name="addXMLFragment" select="$addXMLFragment"/>
			<xsl:with-param name="removeLink" select="$removeLink"/>
			<xsl:with-param name="upLink"     select="$upLink"/>
			<xsl:with-param name="downLink"   select="$downLink"/>
			<xsl:with-param name="helpLink"   select="$helpLink"/>
			<xsl:with-param name="validationLink" select="$validationLink"/>
			<xsl:with-param name="editAttributes" select="$editAttributes"/>
			<xsl:with-param name="edit"       select="true()"/>
			<xsl:with-param name="id" select="$id"/>
		</xsl:call-template>
	</xsl:template>	
	
	<xsl:template name="simpleAttribute.rndt" mode="simpleAttribute.rndt" match="@*" priority="3">
		<xsl:param name="schema"/>
		<xsl:param name="edit"   select="false()"/>
		<xsl:param name="title">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="text">
			<xsl:call-template name="getAttributeText">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:variable name="name" select="name(.)"/>
				<xsl:variable name="id" select="concat('_', ../geonet:element/@ref, '_', $name)"/>

				<xsl:call-template name="editAttribute">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="id"     select="concat($id, '_block')"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
					<xsl:with-param name="name" select="$name"/>
					<xsl:with-param name="elemId" select="geonet:element/@uuid"/>
					<xsl:with-param name="removeLink">
						<xsl:if test="count(../geonet:attribute[@name=$name and @del])!=0">
							<xsl:value-of select="concat('doRemoveAttributeAction(',$apos,'/metadata.attr.delete',$apos,',',$apos,$id,$apos,',',$apos,../geonet:element/@ref,$apos,',',
								$apos,$id,$apos,',',$apos,$apos,');')"/>
						</xsl:if>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="showSimpleElement.rndt">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	shows a simple element
	-->
	<xsl:template name="showSimpleElement.rndt">
		<xsl:param name="schema"/>
		<xsl:param name="title"/>
		<xsl:param name="showAttributes" select="true()"/>
		<xsl:param name="text"/>
		<xsl:param name="helpLink"/>
		
		<!-- don't show it if there isn't anything in it! -->
		<xsl:if test="normalize-space($text)!=''">
			<xsl:call-template name="simpleElementGui.rndt">
				<xsl:with-param name="title" select="$title"/>
				<xsl:with-param name="showAttributes" select="$showAttributes"/>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="text" select="$text"/>
				<xsl:with-param name="helpLink" select="$helpLink"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!--
	gui to show a simple element
	-->
	<xsl:template name="simpleElementGui.rndt">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="helpLink"/>
		<xsl:param name="addLink"/>
		<xsl:param name="addXMLFragment"/>
		<xsl:param name="removeLink"/>
		<xsl:param name="upLink"/>
		<xsl:param name="downLink"/>
		<xsl:param name="validationLink"/>
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="id" select="generate-id(.)"/>
		<xsl:param name="visible" select="true()"/>
		<xsl:param name="editAttributes" select="true()"/>
		<xsl:param name="showAttributes" select="true()"/>
		
		<xsl:variable name="isXLinked" select="count(ancestor-or-self::node()[@xlink:href]) > 0" />
		<xsl:variable name="geonet" select="starts-with(name(.),'geonet:')"/>
		
		<xsl:if test="
			not(contains($helpLink, '|gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:unitsSystem|'))">
		
			<tr id="{$id}" type="metadata">
				<xsl:if test="not($visible)	or
					contains($helpLink, '|gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation|')">
					<xsl:attribute name="style">
						display:none;
					</xsl:attribute>
				</xsl:if>
				<th class="md" width="20%" valign="top">
					<xsl:choose>
						<xsl:when test="$isXLinked">
							<xsl:attribute name="class">md xlinked</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">md</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="$helpLink!=''">
							<span id="stip.{$helpLink}|{$id}" onclick="toolTip(this.id);" class="content" style="cursor:help;">
								<xsl:choose>
									<xsl:when test="contains($helpLink, '|gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS/@xlink:href|')">
										<xsl:value-of select="''"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$title"/>
									</xsl:otherwise>
								</xsl:choose>
							</span>
							<xsl:call-template name="asterisk">
								<xsl:with-param name="link" select="$removeLink"/>
								<xsl:with-param name="edit" select="$edit"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="showTitleWithTag">
								<xsl:with-param name="title" select="$title"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>&#160;</xsl:text>
					<xsl:if test="$edit and not($isXLinked)">
						<xsl:call-template name="getButtons">
							<xsl:with-param name="addLink" select="$addLink"/>
							<xsl:with-param name="addXMLFragment" select="$addXMLFragment"/>
							<xsl:with-param name="removeLink" select="$removeLink"/>
							<xsl:with-param name="upLink" select="$upLink"/>
							<xsl:with-param name="downLink" select="$downLink"/>
							<xsl:with-param name="validationLink" select="$validationLink"/>
							<xsl:with-param name="id" select="$id"/>
						</xsl:call-template>
					</xsl:if>
				</th>
				<td class="padded" valign="top">
					
					<xsl:variable name="textnode" select="exslt:node-set($text)"/>
					<xsl:choose>
						<xsl:when test="$edit">
							<xsl:copy-of select="$text"/>
						</xsl:when>
						<xsl:when test="count($textnode/*) &gt; 0">
							<!-- In some templates, text already contains HTML (eg. codelist, link for download).
						In that case copy text content and does not resolve
						hyperlinks. -->
							<xsl:copy-of select="$text"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="not(contains($helpLink, '|gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS|'))">
								<xsl:call-template name="addLineBreaksAndHyperlinks">
									<xsl:with-param name="txt" select="$text"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Display attributes for :
					* non codelist element
				 	* empty field with nilReason attributes 
				    -->
					<xsl:choose>
						<xsl:when test="$edit and $editAttributes
							and count(geonet:attribute)&gt;0 
							and count(*/geonet:attribute[@name='codeList'])=0 
							and count(*/geonet:attribute[@name='gco:nilReason'])=0
							and	count(geonet:attribute[@name!='gco:nilReason'])!=0
							and not(gco:CharacterString)
							">
							<!-- Display attributes if used -->
							<xsl:variable name="visibleAttributes" select="count(@*)!=0"/>
							
							<fieldset class="attributes metadata-block">
								<legend>
									<!-- RNDT: remove unnecessary collapsible fragment in order to clean up the GUI -->
									<!--<span>
										<div onclick="toggleFieldset(this, $('toggled{$id}'));">
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="$visibleAttributes">downBt Bt</xsl:when>
													<xsl:otherwise>rightBt Bt</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										</div>
									</span>
									...-->
								</legend>
								<table id="toggled{$id}" style="display:none;">
									<xsl:attribute name="style">
										<xsl:if test="not($visibleAttributes)">display:none;</xsl:if>
									</xsl:attribute>
									<xsl:apply-templates mode="simpleAttribute.rndt" select="@*|geonet:attribute">
										<xsl:with-param name="schema" select="$schema"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>
								</table>
							</fieldset>
						</xsl:when>
						<xsl:when test="$edit
							and /root/gui/config/metadata-editor-nilReason
							and	count(geonet:attribute[@name='gco:nilReason'])!=0
							and normalize-space(gco:CharacterString)=''">
							<xsl:for-each select="@gco:nilReason">
								<xsl:call-template name="getAttributeText">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="not($edit) and $showAttributes and @* 
							and not(contains($helpLink, '|gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:identifier|'))">
							<xsl:apply-templates mode="simpleAttribute.rndt" select="@*">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
					
					<!-- Adding custom SRS selection to the verticalCRS element -->
					<xsl:if test="$isXLinked=true() and $edit=true() and contains($helpLink, '|gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS')">	
						<xsl:apply-templates mode="verticalCRS.suggestions" select="@*|geonet:attribute">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:if>
				</td>
			</tr>		
		</xsl:if>	
	</xsl:template>
	
	<!-- Define suggestions for vertical CRS -->
	<xsl:template name="verticalCRS.suggestions" mode="verticalCRS.suggestions" match="@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"   select="false()"/>

		<xsl:variable name="name" select="name(.)"/>
		
		<xsl:variable name="updatename">
			<xsl:call-template name="getAttributeName">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:variable>		
		
		<xsl:variable name="hrefId" select="concat('_', ../geonet:element/@ref, '_', $updatename)"/>
		
		<br/>
		<span>
			( <xsl:value-of select="/root/gui/schemas/iso19139.rndt/strings/geoloc/suggestionsLabel"/> : 
			<select  id="vertCrs" class="md" onchange="setInputCRSel(this, '{$hrefId}');" oncontextmenu="setInputCRSel(this, '{$hrefId}');">	
				<option value="{/root/gui/schemas/iso19139.rndt/strings/geoloc/verticalCRSValues/default}" 
					selected="selected"><xsl:value-of select="/root/gui/schemas/iso19139.rndt/strings/geoloc/verticalCRSValues/default"/></option>
				
				<xsl:for-each select="/root/gui/schemas/iso19139.rndt/strings/geoloc/verticalCRSValues/crs">
					<option value="{./value/text()}"><xsl:value-of select="./label/text()"/></option>
				</xsl:for-each>
			</select>
			)
		</span>
	</xsl:template>
	
	<!-- Overrides the basic complex element template of GeoNetwork -->
	<xsl:template mode="complexElement" match="*" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"   select="false()"/>
		<xsl:param name="title">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="content">
			<xsl:call-template name="getContent">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:call-template name="editComplexElement.rndt">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="content"  select="$content"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="showComplexElement.rndt">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="content"  select="$content"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--
	shows editable fields for a complex element
	-->
	<xsl:template name="editComplexElement.rndt">
		<xsl:param name="schema"/>
		<xsl:param name="title"/>
		<xsl:param name="content"/>
		<xsl:param name="helpLink"/>
		
		<xsl:variable name="id" select="geonet:element/@uuid"/>
		<xsl:variable name="addLink">
			<xsl:call-template name="addLink">
				<xsl:with-param name="id" select="$id"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="addXMLFragment">
			<xsl:call-template name="addXMLFragment">
				<xsl:with-param name="id" select="$id"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="removeLink">
			<xsl:value-of select="concat('doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',geonet:element/@ref,',',geonet:element/@parent,',',$apos,$id,$apos,',',geonet:element/@min,');')"/>
			<xsl:if test="not(geonet:element/@del='true')">
				<xsl:text>!OPTIONAL</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="upLink">
			<xsl:value-of select="concat('doMoveElementAction(',$apos,'/metadata.elem.up',$apos,',',geonet:element/@ref,',',$apos,$id,$apos,');')"/>
			<xsl:if test="not(geonet:element/@up='true')">
				<xsl:text>!OPTIONAL</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="downLink">
			<xsl:value-of select="concat('doMoveElementAction(',$apos,'/metadata.elem.down',$apos,',',geonet:element/@ref,',',$apos,$id,$apos,');')"/>
			<xsl:if test="not(geonet:element/@down='true')">
				<xsl:text>!OPTIONAL</xsl:text>
			</xsl:if>
		</xsl:variable>
		<!-- xsd and schematron validation info -->
		<xsl:variable name="validationLink">
			<xsl:variable name="ref" select="concat('#_',geonet:element/@ref)"/>
			<xsl:call-template name="validationLink">
				<xsl:with-param name="ref" select="$ref"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:call-template name="complexElementGui.rndt">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="text" select="text()"/>
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="addLink" select="$addLink"/>
			<xsl:with-param name="addXMLFragment" select="$addXMLFragment"/>
			<xsl:with-param name="removeLink" select="$removeLink"/>
			<xsl:with-param name="upLink" select="$upLink"/>
			<xsl:with-param name="downLink" select="$downLink"/>
			<xsl:with-param name="helpLink" select="$helpLink"/>
			<xsl:with-param name="validationLink" select="$validationLink"/>
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="true()"/>			
			<xsl:with-param name="id" select="$id"/>
		</xsl:call-template>
	</xsl:template>
	
	<!--
	shows a complex element
	-->
	<xsl:template name="showComplexElement.rndt">
		<xsl:param name="schema"/>
		<xsl:param name="title"/>
		<xsl:param name="content"/>
		<xsl:param name="helpLink"/>
		
		<!-- don't show it if there isn't anything in it! -->
		<xsl:if test="normalize-space($content)!=''">
			<xsl:call-template name="complexElementGui.rndt">
				<xsl:with-param name="title" select="$title"/>
				<xsl:with-param name="text" select="text()"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="helpLink" select="$helpLink"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>
	
	<!--
	gui to show a complex element
	-->
	<xsl:template name="complexElementGui.rndt">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="content"/>
		<xsl:param name="helpLink"/>
		<xsl:param name="addLink"/>
		<xsl:param name="addXMLFragment"/>
		<xsl:param name="removeLink"/>
		<xsl:param name="upLink"/>
		<xsl:param name="downLink"/>
		<xsl:param name="validationLink"/>
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="id" select="generate-id(.)"/>
		
		<xsl:variable name="isXLinked" select="count(ancestor::node()[@xlink:href]) > 0" />
		
		<tr id="{$id}" type="metadata">
			<td class="padded-content" width="100%" colspan="2">
				<xsl:choose>
					<xsl:when test="contains($helpLink, '|gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:identifier|')">
						<table width="100%" id="toggled{$id}">
							<xsl:copy-of select="$content"/>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<fieldset class="metadata-block">
							<legend class="block-legend">
								<span>
									<xsl:if test="/root/gui/config/metadata-view-toggleTab">
										<div class="downBt Bt" onclick="toggleFieldset(this, $('toggled{$id}'));"></div>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="$helpLink!=''">
											<span id="stip.{$helpLink}|{$id}" onclick="toolTip(this.id);" class="content" style="cursor:help;"><xsl:value-of select="$title"/>
											</span>
											<!-- Only show asterisks on simpleElements - user has to know
									which ones to fill out 
									<xsl:call-template name="asterisk">
									<xsl:with-param name="link" select="$helpLink"/>
									<xsl:with-param name="edit" select="$edit"/>
									</xsl:call-template>
								-->
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="showTitleWithTag">
												<xsl:with-param name="title" select="$title"/>
												<xsl:with-param name="class" select="'no-help'"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
									
									<xsl:if test="$edit and not($isXLinked)">
										<xsl:call-template name="getButtons">
											<xsl:with-param name="addLink" select="$addLink"/>
											<xsl:with-param name="addXMLFragment" select="$addXMLFragment"/>
											<xsl:with-param name="removeLink" select="$removeLink"/>
											<xsl:with-param name="upLink" select="$upLink"/>
											<xsl:with-param name="downLink" select="$downLink"/>
											<xsl:with-param name="validationLink" select="$validationLink"/>
											<xsl:with-param name="id" select="$id"/>
										</xsl:call-template>
									</xsl:if>
								</span>
							</legend>
							<table width="100%" id="toggled{$id}">
								<xsl:copy-of select="$content"/>
							</table>
						</fieldset>
					</xsl:otherwise>
				</xsl:choose>					
			</td>
		</tr>
	</xsl:template>
	
	<!--
	returns the text of an element
	-->
	<xsl:template name="getElementText.rndt">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="rows" select="1"/>
		<xsl:param name="cols" select="40"/>
		<xsl:param name="langId"/>
		<xsl:param name="visible" select="true"/>
		<!-- Add javascript validator function. By default, if element 
		is mandatory a non empty validator is defined. -->
		<xsl:param name="validator"/>
		<!-- Use input_type parameter to create an hidden field. 
		Default is a text input. -->
		<xsl:param name="input_type">text</xsl:param>
		<!-- Set to true no_name parameter in order to create an element 
		which will not be submitted to the form. -->
		<xsl:param name="no_name" select="false()" />
		
		
		<xsl:variable name="name"  select="name(.)"/>
		<xsl:variable name="value" select="string(.)"/>
		<xsl:variable name="isXLinked" select="count(ancestor-or-self::node()[@xlink:href]) > 0" />		
		
		<xsl:variable name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!--<h2><xsl:value-of select="$helpLink"/></h2>-->
		<xsl:choose>
			<!-- list of values -->
			<xsl:when test="geonet:element/geonet:text">
				
				<xsl:variable name="mandatory" select="geonet:element/@min='1' and
					geonet:element/@max='1'"/>
				
				<!-- This code is mainly run under FGDC 
				but also for enumeration like topic category and 
				service parameter direction in ISO. 
				
				Create a temporary list and retrive label in 
				current gui language which is sorted after. -->				
				<xsl:variable name="list">
					<items>
						<xsl:for-each select="geonet:element/geonet:text">
							<xsl:variable name="choiceValue" select="string(@value)"/>							
							<xsl:variable name="label" select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $name]/entry[code = $choiceValue]/label"/>
							
							<item>
								<value>
									<xsl:value-of select="@value"/>
								</value>
								<label>
									<xsl:choose>
										<xsl:when test="$label"><xsl:value-of select="$label"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="$choiceValue"/></xsl:otherwise>
									</xsl:choose>									
								</label>
							</item>
						</xsl:for-each>
					</items>
				</xsl:variable>
				<select class="md" name="_{geonet:element/@ref}" size="1">
					<xsl:if test="$visible = 'false'">
						<xsl:attribute name="style">display:none;</xsl:attribute>
					</xsl:if>
					<xsl:if test="$isXLinked">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					
					<option name=""/>
					<xsl:for-each select="exslt:node-set($list)//item">
						<xsl:sort select="label"/>
						<option>
							<xsl:if test="value=$value">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:attribute name="value"><xsl:value-of select="value"/></xsl:attribute>
							<xsl:value-of select="label"/>
						</option>
					</xsl:for-each>
				</select>
			</xsl:when>
			<xsl:when test="$edit=true() and $rows=1">
				<xsl:choose>					
					<!-- heikki doeleman: for gco:Boolean, use checkbox.
					Default value set to false. -->
					<xsl:when test="name(.)='gco:Boolean'">
						<input type="hidden" name="_{geonet:element/@ref}" id="_{geonet:element/@ref}" value="{.}">
							<xsl:if test="$isXLinked">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test=". = ''">
									<xsl:attribute name="value">false</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</input>
						
						<xsl:choose>
							<xsl:when test="text()='true' or text()='1'">
								<input class="md" type="checkbox" id="_{geonet:element/@ref}_checkbox" onclick="handleCheckboxAsBoolean(this, '_{geonet:element/@ref}');" checked="checked">
									<xsl:if test="$isXLinked">
										<xsl:attribute name="disabled">disabled</xsl:attribute>
									</xsl:if>
								</input>
							</xsl:when>
							<xsl:otherwise>
								<input class="md" type="checkbox" id="_{geonet:element/@ref}_checkbox" onclick="handleCheckboxAsBoolean(this, '_{geonet:element/@ref}');">
									<xsl:if test="$isXLinked">
										<xsl:attribute name="disabled">disabled</xsl:attribute>
									</xsl:if>								
								</input>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					
					<xsl:otherwise>
						<input class="md" type="{$input_type}" value="{text()}" size="{$cols}">
							<xsl:if test="$isXLinked">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>						
							<xsl:choose>
								<xsl:when test="$no_name=false()">
									<xsl:attribute name="name">_<xsl:value-of select="geonet:element/@ref"/></xsl:attribute>
									<xsl:attribute name="id">_<xsl:value-of select="geonet:element/@ref"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="id"><xsl:value-of select="geonet:element/@ref"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:if test="$visible = 'false'">
								<xsl:attribute name="style">display:none;</xsl:attribute>
							</xsl:if>
							
							<xsl:variable name="mandatory" select="(name(.)='gmd:LocalisedCharacterString' 
								and ../../geonet:element/@min='1')
								or ../geonet:element/@min='1'"/>
						
							<xsl:choose>
								<!-- Numeric field -->
								<xsl:when test="name(.)='gco:Integer' or 
									name(.)='gco:Decimal' or name(.)='gco:Real'">
									<xsl:choose>
										<xsl:when test="name(.)='gco:Integer'">
											<xsl:attribute name="onkeyup">validateNumber(this, <xsl:value-of select="not($mandatory)"/>, false);</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="onkeyup">validateNumber(this, <xsl:value-of select="not($mandatory)"/>, true);</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<!-- Mandatory field (with extra validator) -->
								<xsl:when test="$mandatory
									and $edit">
									<xsl:choose>
										<!-- RNDT: specific telephon/linkage check -->
										<xsl:when test="contains($helpLink, 'gmd:CI_OnlineResource/gmd:linkage/gmd:URL')">
											<xsl:variable name="phoneElem"><xsl:value-of select="../../../../gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString/geonet:element/@ref"/></xsl:variable>
											<xsl:attribute name="onkeyup">
												validateNonEmpty_rndt(this, '_<xsl:value-of select="$phoneElem"/>');
											</xsl:attribute>
											<xsl:variable name="linkageElem"><xsl:value-of select="./geonet:element/@ref"/></xsl:variable>
											<script type="text/javascript">
												setValidationCheck_rndt('_<xsl:value-of select="$linkageElem"/>', '_<xsl:value-of select="$phoneElem"/>');
											</script>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="onkeyup">
												validateNonEmpty(this);
											</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<!-- Custom validator -->
								<xsl:when test="$validator">
									<xsl:attribute name="onkeyup"><xsl:value-of select="$validator"/></xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</input>
						<xsl:call-template name="helper">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="attribute" select="false()"/>
						</xsl:call-template>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$edit=true()">
				<textarea class="md" name="_{geonet:element/@ref}" id="_{geonet:element/@ref}" rows="{$rows}" cols="{$cols}">
					<xsl:if test="$isXLinked">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:if test="$visible = 'false'">
						<xsl:attribute name="style">display:none;</xsl:attribute>
					</xsl:if>
					<xsl:if test="(
						(name(.)='gmd:LocalisedCharacterString' and ../../geonet:element/@min='1')
						or ../geonet:element/@min='1'
						) and $edit">
						<xsl:attribute name="onkeyup">validateNonEmpty(this);</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="text()"/>
				</textarea>
			</xsl:when>
			<xsl:when test="$edit=false() and $rows!=1">
				<xsl:choose>
					<xsl:when test="starts-with($schema,'iso19139')">
						<xsl:apply-templates mode="localised" select="..">
							<xsl:with-param name="langId" select="$langId"></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- not editable text/codelists -->
				<xsl:variable name="label" select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $name]/entry[code=$value]/label"/>
				<xsl:choose>
					<xsl:when test="$label"><xsl:value-of select="$label"/></xsl:when>
					<xsl:when test="starts-with($schema,'iso19139')"> 
						<xsl:apply-templates mode="localised" select="..">
							<xsl:with-param name="langId" select="$langId"></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>