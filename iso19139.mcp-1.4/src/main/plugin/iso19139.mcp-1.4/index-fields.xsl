<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
			xmlns:gmx="http://www.isotc211.org/2005/gmx"
			xmlns:gco="http://www.isotc211.org/2005/gco"
			xmlns:gml="http://www.opengis.net/gml"
			xmlns:srv="http://www.isotc211.org/2005/srv"
			xmlns:geonet="http://www.fao.org/geonetwork"
			xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
			xmlns:app="http://biodiversity.org.au/xml/servicelayer/content"
			xmlns:xlink="http://www.w3.org/1999/xlink"
			xmlns:ibis="http://biodiversity.org.au/xml/ibis"
			xpath-default-namespace="http://biodiversity.org.au/xml/ibis"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			exclude-result-prefixes="gmd gmx gco gml srv geonet mcp app xlink ibis xsl">


	<xsl:import href="../iso19139/index-fields.xsl"/>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -     
	     If aggregation code comes from a thesaurus then index it and the      
	     the thesaurus it comes from in this template                          
	     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template mode="index" match="gmd:aggregationInfo/*">

		<xsl:variable name="code" select="string(gmd:aggregateDataSetIdentifier/*/gmd:code/*)"/>

		<xsl:variable name="thesaurusId" select="gmd:aggregateDataSetIdentifier/*/gmd:authority/*/gmd:identifier/*/gmd:code/gmx:Anchor"/>
		<xsl:if test="contains($thesaurusId,'geonetwork.thesaurus') and normalize-space($code)!=''">
			<Field name="thesaurusName" string="{$thesaurusId}" store="true" index="true"/>
			<!-- thesaurusId field not used for searching -->
			<Field name="{$thesaurusId}" string="{$code}" store="true" index="true"/>
			<xsl:variable name="initiative" select="gmd:initiativeType/gmd:DS_InitiativeTypeCode/@codeListValue"/>
			<!-- initiative field is used for searching -->
			<xsl:if test="normalize-space($initiative)!=''">
				<Field name="{concat('siblings_',$initiative)}" string="{$code}" store="true" index="true"/>
			</xsl:if>
		</xsl:if>

		<xsl:apply-templates mode="index" select="*"/>
	</xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

	<xsl:template mode="index" match="mcp:dataParameters/mcp:DP_DataParameters/mcp:dataParameter">

		<xsl:for-each select="mcp:DP_DataParameter/mcp:parameterName">
			<Field name="dataparam" string="{mcp:DP_ParameterName/mcp:name/gco:CharacterString}" store="true" index="true"/>
			
			<xsl:if test="mcp:DP_ParameterName/mcp:type/mcp:DP_TypeCode/@codeListValue='longName'">
				<Field name="longParamName" string="{mcp:DP_ParameterName/mcp:name/gco:CharacterString}" store="true" index="true"/>
			</xsl:if>
		</xsl:for-each>

		<xsl:apply-templates mode="index" select="*"/>
	</xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
	<xsl:template mode="index" match="mcp:EX_Extent">

		<xsl:apply-templates select="gmd:geographicElement/gmd:EX_GeographicBoundingBox" mode="latLon"/>

		<xsl:for-each select="gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
			<Field name="geoDescCode" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>
				
		<xsl:for-each select="gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:RS_Identifier">
			<xsl:if test="gmd:authority/*/gmd:title/gco:CharacterString='c-squares'">
				<xsl:for-each select="tokenize(gmd:code/gco:CharacterString,'\|')">
					<Field name="csquare" string="{string(.)}" store="false" index="true"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="gmd:temporalElement/mcp:EX_TemporalExtent/gmd:extent|gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent">
			<xsl:for-each select="gml:TimePeriod">
				<xsl:variable name="times">
					<xsl:call-template name="newGmlTime">
						<xsl:with-param name="begin" select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/>
						<xsl:with-param name="end" select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/>
					</xsl:call-template>
				</xsl:variable>

				<Field name="tempExtentBegin" string="{lower-case(substring-before($times,'|'))}" store="true" index="true"/>
				<Field name="tempExtentEnd" string="{lower-case(substring-after($times,'|'))}" store="true" index="true"/>
			</xsl:for-each>
		</xsl:for-each>


		<xsl:for-each select="mcp:taxonomicElement/*">
			<xsl:for-each select="mcp:taxonConcepts/*/ibis:TaxonName">
				<xsl:variable name="thesaurusId" select="normalize-space(@ibis:thesaurusUri)"/>

				<xsl:if test="$thesaurusId!=''">
					<Field name="thesaurusName" string="{string($thesaurusId)}" store="true" index="true"/>
				</xsl:if>

				<xsl:if test="PublicationRef">
					<Field name="taxonPub"			string="{string(PublicationRef/*[1])}" store="true" index="true"/>
				</xsl:if>

				<!-- index both complete name and lsid of this species -->
				<Field name="taxon"		string="{string(NameComplete)}" store="true" index="true"/>
				<Field name="taxonId"	string="{string(@ibis:lsid)}" store="true" index="true"/>
				<xsl:if test="$thesaurusId!=''">
					<Field name="{$thesaurusId}"	string="{string(@ibis:lsid)}" store="true" index="true"/>
				</xsl:if>
	
				<!-- Also index all synonyms and their lsids from this record so 
						that searches on synonyms will also pick up this record -->
				<xsl:for-each select="HasAcceptedConcept/HasNameRef">
					<Field name="taxon"		string="{string(NameComplete)}" store="true" index="true"/>
					<Field name="taxonId"	string="{string(@ibis:lsid)}" store="true" index="true"/>
					<xsl:if test="$thesaurusId!=''">
						<Field name="{$thesaurusId}"	string="{string(@ibis:lsid)}" store="true" index="true"/>
					</xsl:if>
				</xsl:for-each>
	
			</xsl:for-each>
		</xsl:for-each>

		<xsl:apply-templates mode="index" select="*"/>
	</xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

	<xsl:template mode="index" match="mcp:revisionDate/*">

		<Field name="changeDate" string="{string(.)}" store="true" index="true"/>

		<xsl:apply-templates mode="index" select="*"/>
	</xsl:template>
		
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
	<xsl:template mode="index" match="gmd:MD_Keywords">

		<xsl:variable name="thesaurusId" select="normalize-space(gmd:thesaurusName/*/gmd:identifier/*/gmd:code[starts-with(string(gmx:Anchor),'geonetwork.thesaurus')])"/>

		<xsl:if test="$thesaurusId!=''">
			<Field name="thesaurusName" string="{string($thesaurusId)}" store="true" index="true"/>
		</xsl:if>

		<!-- index keyword codes under lucene index field with name same
				 as thesaurus that contains the keyword codes -->

		<xsl:for-each select="gmd:keyword/*">
			<xsl:if test="name()='gmx:Anchor' and $thesaurusId!=''">
				<!-- expecting something like 
							    	<gmx:Anchor 
									  	xlink:href="http://localhost:8080/geonetwork/srv/en/xml.keyword.get?thesaurus=register.theme.urn:marine.csiro.au:marlin:keywords:standardDataType&id=urn:marine.csiro.au:marlin:keywords:standardDataTypes:concept:3510">CMAR Vessel Data: ADCP</gmx:Anchor>
				-->
	
				<xsl:variable name="keywordId">
					<xsl:for-each select="tokenize(@xlink:href,'&amp;')">
						<xsl:if test="starts-with(string(.),'id=')">
							<xsl:value-of select="substring-after(string(.),'id=')"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
	
				<xsl:if test="normalize-space($keywordId)!=''">
					<Field name="{$thesaurusId}" string="{replace($keywordId,'%23','#')}" store="true" index="true"/>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>

		<xsl:apply-templates mode="index" select="*"/>
	</xsl:template>
	
</xsl:stylesheet>
