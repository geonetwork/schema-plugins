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
			<xsl:call-template name="getElementText">
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
				<xsl:call-template name="editSimpleElement">
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
		
        <!--<xsl:if test="contains($helpLink, '|gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS/@xlink:href|')">
			<h1>TEST</h1>
		</xsl:if>-->
		
		<xsl:if test="
			not(contains($helpLink, '|gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:unitsSystem|'))">
		
			<tr id="{$id}" type="metadata">
				<xsl:if test="not($visible)">
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
									<span>
										<div onclick="toggleFieldset(this, $('toggled{$id}'));">
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="$visibleAttributes">downBt Bt</xsl:when>
													<xsl:otherwise>rightBt Bt</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										</div>
									</span>
									...
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
				</td>
			</tr>		
		</xsl:if>	
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

</xsl:stylesheet>