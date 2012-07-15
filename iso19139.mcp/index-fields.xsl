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
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="datadir"/>

	<xsl:include href="../iso19139/convert/functions.xsl"/>
	<xsl:include href="../../../xsl/utils-fn.xsl"/>

	<!-- This file defines what parts of the metadata are indexed by Lucene
	     Searches can be conducted on indexes defined here. 
	     The Field@name attribute defines the name of the search variable.
		 If a variable has to be maintained in the user session, it needs to be 
		 added to the GeoNetwork constants in the Java source code.
		 Please keep indexes consistent among metadata standards if they should
		 work accross different metadata resources -->
	<!-- ========================================================================================= -->
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	
	<!-- ========================================================================================= -->

	<xsl:template match="/">
		<xsl:variable name="isoLangId">
			<xsl:call-template name="langId19139"/>
		</xsl:variable>

		<Document locale="{$isoLangId}">
			<Field name="_locale" string="{$isoLangId}" store="true" index="true"/>
			<Field name="_docLocale" string="{$isoLangId}" store="true" index="true"/>
			<xsl:variable name="_defaultTitle">
				<xsl:call-template name="defaultTitle">
					<xsl:with-param name="isoDocLangId" select="$isoLangId"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- not tokenized title for sorting, needed for multilingual sorting -->
			<Field name="_defaultTitle" string="{string($_defaultTitle)}" store="true" index="true"/>

			<xsl:apply-templates select="mcp:MD_Metadata" mode="metadata"/>
		</Document>
	</xsl:template>
	
	<!-- ========================================================================================= -->

	<xsl:template match="*" mode="metadata">

		<!-- === Data or Service Identification === -->		

		<xsl:for-each select="gmd:identificationInfo/mcp:MD_DataIdentification|gmd:identificationInfo/srv:SV_ServiceIdentification">

			<xsl:for-each select="gmd:citation/*">
				<xsl:for-each select="gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
					<Field name="identifier" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
	
				<xsl:for-each select="gmd:title/gco:CharacterString">
					<Field name="title" string="{string(.)}" store="true" index="true"/>
					<!-- not tokenized title for sorting -->
					<Field name="_title" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
	
				<xsl:for-each select="gmd:alternateTitle/gco:CharacterString">
					<Field name="altTitle" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='revision']/gmd:date/gco:Date|gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='revision']/gmd:date/gco:DateTime">
					<Field name="revisionDate" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='creation']/gmd:date/gco:Date|gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='creation']/gmd:date/gco:DateTime">
					<Field name="createDate" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='publication']/gmd:date/gco:Date">
					<Field name="publicationDate" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="mcp:responsibleParty/mcp:CI_Responsibility/mcp:party/mcp:CI_Organisation/mcp:name/gco:CharacterString">
					<xsl:variable name="org" select="string(.)"/>

					<Field name="orgName" string="{$org}" store="true" index="true"/>

					<xsl:variable name="logo" select="../..//gmx:FileName/@src"/>
					<xsl:for-each select="../../../../mcp:role/*/@codeListValue">
						<Field name="responsibleParty" string="{concat(., '|resource|', $org, '|', $logo)}" store="true" index="false"/>
					</xsl:for-each>
				</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
				<!-- fields used to search for metadata in paper or digital format -->

				<xsl:for-each select="gmd:presentationForm">
					<Field name="presentationForm" string="{gmd:CI_PresentationFormCode/@codeListValue}" store="true" index="true"/>

					<xsl:if test="contains(gmd:CI_PresentationFormCode/@codeListValue, 'Digital')">
						<Field name="digital" string="true" store="true" index="true"/>
					</xsl:if>
				
					<xsl:if test="contains(gmd:CI_PresentationFormCode/@codeListValue, 'Hardcopy')">
						<Field name="paper" string="true" store="true" index="true"/>
					</xsl:if>
				</xsl:for-each>

			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			<!-- if aggregation code comes from a thesaurus then index it and the  -->
			<!-- the thesaurus it comes from                                       -->
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:aggregateInformation/*">
				<xsl:variable name="code" select="string(gmd:aggregateDataSetIdentifier/*/gmd:code/*)"/>

				<xsl:variable name="thesaurusId" select="gmd:aggregateDataSetIdentifier/*/gmd:authority/*/gmd:identifier/*/gmd:code/gmx:Anchor"/>
				<xsl:if test="contains($thesaurusId,'geonetwork.thesaurus') and normalize-space($code)!=''">
					<Field name="thesaurusName" string="{$thesaurusId}" store="true" index="true"/>
					<!-- thesaurusId field not used for searching -->
					<Field name="{$thesaurusId}" string="{$code}" store="true" index="true"/>
					<xsl:variable name="initiative" select="gmd:initiativeType/gmd:DS_InitiativeTypeCode/@codeListValue"/>
					<!-- initiative field is used for searching -->
					<xsl:if test="normalize-space($initiative)!=''">
						<Field name="{$initiative}" string="{$code}" store="true" index="true"/>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:pointOfContact[1]/*/gmd:role/*/@codeListValue|mcp:resourceContactInfo[1]/mcp:CI_Responsibility/mcp:role/*/@codeListValue">
				<Field name="responsiblePartyRole" string="{string(.)}" store="false" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

			<xsl:for-each select="mcp:dataParameters/mcp:DP_DataParameters/mcp:dataParameter">
				<xsl:for-each select="mcp:DP_DataParameter/mcp:parameterName">
					<Field name="dataparam" string="{mcp:DP_ParameterName/mcp:name/gco:CharacterString}" store="true" index="true"/>
					
					<xsl:if test="mcp:DP_ParameterName/mcp:type/mcp:DP_TypeCode/@codeListValue='longName'">
						<Field name="longParamName" string="{mcp:DP_ParameterName/mcp:name/gco:CharacterString}" store="true" index="true"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="gmd:abstract/gco:CharacterString">
				<Field name="abstract" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="gmd:credit/gco:CharacterString">
				<Field name="credit" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

			<xsl:for-each select="*/mcp:EX_Extent|*/gmd:EX_Extent">
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


				<xsl:for-each select="mcp:taxonomicElement/*/mcp:taxonConcepts/app:documents/TaxonConcept|mcp:taxonomicElement/*/mcp:taxonConcepts/app:documents/TaxonName">
					<Field name="taxonPub"			string="{string(PublicationRef/*[1])}" store="true" index="true"/>

					<!-- index both complete name and lsid of this species -->
					<Field name="taxon"		string="{string(HasNameRef/NameComplete)}" store="true" index="true"/>
					<Field name="taxon"		string="{string(HasNameRef/@ibis:lsidRef)}" store="true" index="true"/>

					<!-- Also index all synonyms and their lsids from this record so 
							 that searches on synonyms will also pick up this record -->
					<xsl:for-each select="AcceptedFor/AcceptedForNameRef">
						<Field name="taxon"		string="{string(NameComplete)}" store="true" index="true"/>
						<Field name="taxon"		string="{string(@ibis:lsidRef)}" store="true" index="true"/>
					</xsl:for-each>

				</xsl:for-each>

			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

			<xsl:for-each select="*/gmd:MD_Keywords">
				<xsl:variable name="thesaurusId" select="normalize-space(gmd:thesaurusName/*/gmd:identifier/*/gmd:code[starts-with(string(gmx:Anchor),'geonetwork.thesaurus')])"/>

				<xsl:if test="$thesaurusId!=''">
					<Field name="thesaurusName" string="{string($thesaurusId)}" store="true" index="true"/>
				</xsl:if>

				<xsl:for-each select="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue">
					<Field name="keywordType" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="gmd:keyword/*">
					<Field name="keyword" string="{string(.)}" store="true" index="true"/>
					<Field name="subject" string="{string(.)}" store="true" index="true"/>

					<!-- index keyword codes under lucene index field with name same
					     as thesaurus that contains the keyword codes -->

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
			</xsl:for-each>
	
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="mcp:resourceContactInfo/mcp:CI_Responsibility//mcp:party/mcp:CI_Organisation/mcp:name/gco:CharacterString">
				<xsl:variable name="org" select="string(.)"/>

				<Field name="orgName" string="{$org}" store="true" index="true"/>

				<xsl:variable name="logo" select="../..//gmx:FileName/@src"/>
				<xsl:for-each select="../../../../mcp:role/*/@codeListValue">
					<Field name="responsibleParty" string="{concat(., '|resource|', $org, '|', $logo)}" store="true" index="false"/>
				</xsl:for-each>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
				<Field name="orgName" string="{string(.)}" store="true" index="true"/>

				<xsl:variable name="role" select="../../gmd:role/*/@codeListValue"/>
				<xsl:variable name="logo" select="../..//gmx:FileName/@src"/>

				<Field name="responsibleParty" string="{concat($role, '|resource|', ., '|', $logo)}" store="true" index="false"/>

			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:choose>
				<xsl:when test="gmd:resourceConstraints/gmd:MD_SecurityConstraints">
					<Field name="secConstr" string="true" store="true" index="true"/>
				</xsl:when>
				<xsl:otherwise>
					<Field name="secConstr" string="false" store="true" index="true"/>
				</xsl:otherwise>
			</xsl:choose>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="gmd:topicCategory/gmd:MD_TopicCategoryCode">
				<Field name="topicCat" string="{string(.)}" store="true" index="true"/>
				<Field name="keyword" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="gmd:language/gco:CharacterString|gmd:language/gmd:LanguageCode/@codeListValue">
				<Field name="datasetLang" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

			<xsl:for-each select="gmd:spatialResolution/gmd:MD_Resolution">
				<xsl:for-each select="gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer">
					<Field name="denominator" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="gmd:distance/gco:Distance">
					<Field name="distanceVal" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<xsl:for-each select="gmd:distance/gco:Distance/@uom">
					<Field name="distanceUom" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			<xsl:for-each select="gmd:spatialRepresentationType">
				<Field name="spatialRepresentationType" string="{gmd:MD_SpatialRepresentationTypeCode/@codeListValue}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			<xsl:for-each select="gmd:resourceConstraints">
				<xsl:for-each select="//gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue">
					<Field name="accessConstr" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
				<xsl:for-each select="//gmd:otherConstraints/gco:CharacterString">
					<Field name="otherConstr" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
				<xsl:for-each select="//gmd:classification/gmd:MD_ClassificationCode/@codeListValue">
					<Field name="classif" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
				<xsl:for-each select="//gmd:useLimitation/gco:CharacterString">
					<Field name="conditionApplyingToAccessAndUse" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			<!--  Fields use to search on Service -->
			
			<xsl:for-each select="srv:serviceType/gco:LocalName">
				<Field  name="serviceType" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
			
			<xsl:for-each select="srv:serviceTypeVersion/gco:CharacterString">
				<Field  name="serviceTypeVersion" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
			
			<xsl:for-each select="//srv:SV_OperationMetadata/srv:operationName/gco:CharacterString">
				<Field  name="operation" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
			
			<xsl:for-each select="srv:operatesOn/@uuidref">
				<Field  name="operatesOn" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
			
			<xsl:for-each select="srv:coupledResource">
				<xsl:for-each select="srv:SV_CoupledResource/srv:identifier/gco:CharacterString">
					<Field  name="operatesOnIdentifier" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
				
				<xsl:for-each select="srv:SV_CoupledResource/srv:operationName/gco:CharacterString">
					<Field  name="operatesOnName" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
			</xsl:for-each>
			
			<xsl:for-each select="//srv:SV_CouplingType/srv:code/@codeListValue">
				<Field  name="couplingType" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>		


			<xsl:for-each select="gmd:graphicOverview/gmd:MD_BrowseGraphic">
				<xsl:variable name="fileName"  select="gmd:fileName/gco:CharacterString"/>
				<xsl:if test="$fileName != ''">
					<xsl:variable name="fileDescr" select="gmd:fileDescription/gco:CharacterString"/>
					<xsl:choose>
						<xsl:when test="contains($fileName ,'://')">
							<Field  name="image" string="{concat('unknown|', $fileName)}" store="true" index="false"/>
						</xsl:when>
						<xsl:when test="string($fileDescr)='thumbnail'">
							<!-- FIXME : relative path -->
							<Field  name="image" string="{concat($fileDescr, '|', '../../srv/en/resources.get?uuid=', //gmd:fileIdentifier/gco:CharacterString, '&amp;fname=', $fileName, '&amp;access=public')}" store="true" index="false"/>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>

		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Distribution === -->		

		<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
			<xsl:for-each select="gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString">
				<Field name="format" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- index online protocol -->
			
			<xsl:for-each select="gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:linkage/gmd:URL!='']">
				<xsl:variable name="download_check"><xsl:text>&amp;fname=&amp;access</xsl:text></xsl:variable>
				<xsl:variable name="linkage" select="gmd:linkage/gmd:URL" /> 
				<xsl:variable name="title" select="normalize-space(gmd:name/gco:CharacterString|gmd:name/gmx:MimeFileType)"/>
				<xsl:variable name="desc" select="normalize-space(gmd:description/gco:CharacterString)"/>
				<xsl:variable name="protocol" select="normalize-space(gmd:protocol/gco:CharacterString)"/>
				<xsl:variable name="mimetype" select="geonet:protocolMimeType($linkage, $protocol, gmd:name/gmx:MimeFileType/@type)"/>
				
				<!-- ignore empty downloads -->
				<xsl:if test="string($linkage)!='' and not(contains($linkage,$download_check))">  
					<Field name="protocol" string="{string($protocol)}" store="false" index="true"/>
				</xsl:if>  

				<xsl:if test="normalize-space($mimetype)!=''">
					<Field name="mimetype" string="{$mimetype}" store="false" index="true"/>
				</xsl:if>
			  
				<xsl:if test="contains($protocol, 'WWW:DOWNLOAD')">
			    	<Field name="download" string="true" store="false" index="true"/>
			  	</xsl:if>
			  
				<xsl:if test="contains($protocol, 'OGC:WMS')">
			   	 	<Field name="dynamic" string="true" store="false" index="true"/>
			  	</xsl:if>
				<Field name="link" string="{concat($title, '|', $desc, '|', $linkage, '|', $protocol, '|', $mimetype)}" store="true" index="false"/>
				
				<!-- Add KML link if WMS -->
				<xsl:if test="starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-map') and string($linkage)!='' and string($title)!=''">
					<!-- FIXME : relative path -->
					<Field name="link" string="{concat($title, '|', $desc, '|', 
						'../../srv/en/google.kml?uuid=', /gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString, '&amp;layers=', $title, 
						'|application/vnd.google-earth.kml+xml|application/vnd.google-earth.kml+xml')}" store="true" index="false"/>					
				</xsl:if>					
				
			</xsl:for-each>  
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<!-- === Content info === -->
		<xsl:for-each select="gmd:contentInfo/*/gmd:featureCatalogueCitation[@uuidref]">
			<Field  name="hasfeaturecat" string="{string(@uuidref)}" store="false" index="true"/>
		</xsl:for-each>
		
		<!-- === Data Quality  === -->
		<xsl:for-each select="gmd:dataQualityInfo/*/gmd:lineage//gmd:source[@uuidref]">
			<Field  name="hassource" string="{string(@uuidref)}" store="false" index="true"/>
		</xsl:for-each>
		
		<xsl:for-each select="gmd:dataQualityInfo/*/gmd:report/*/gmd:result">
			
			<xsl:for-each select="//gmd:pass/gco:Boolean">
				<Field name="degree" string="{string(.)}" store="false" index="true"/>
			</xsl:for-each>
			
			<xsl:for-each select="//gmd:specification/*/gmd:title/gco:CharacterString">
				<Field name="specificationTitle" string="{string(.)}" store="false" index="true"/>
			</xsl:for-each>
				
			<xsl:for-each select="//gmd:specification/*/gmd:date/*/gmd:date">
				<Field name="specificationDate" string="{string(gco:Date|gco:DateTime)}" store="false" index="true"/>
			</xsl:for-each>
				
			<xsl:for-each select="//gmd:specification/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue">
				<Field name="specificationDateType" string="{string(.)}" store="false" index="true"/>
			</xsl:for-each>
		</xsl:for-each>

		<xsl:for-each select="gmd:dataQualityInfo/*/gmd:lineage/*/gmd:statement/gco:CharacterString">
			<Field name="lineage" string="{string(.)}" store="false" index="true"/>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === General stuff === -->		

		<xsl:choose>
			<xsl:when test="gmd:hierarchyLevel">
				<xsl:for-each select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue">
					<Field name="type" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<Field name="type" string="dataset" store="true" index="true"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="gmd:identificationInfo/srv:SV_ServiceIdentification">
			<Field name="type" string="service" store="false" index="true"/>
		</xsl:if>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:for-each select="gmd:hierarchyLevelName/gco:CharacterString">
			<Field name="levelName" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:for-each select="gmd:language/gco:CharacterString">
			<Field name="language" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:for-each select="gmd:fileIdentifier/gco:CharacterString">
			<Field name="fileId" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:for-each select="gmd:parentIdentifier/gco:CharacterString">
			<Field name="parentUuid" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="mcp:revisionDate/*">
			<Field name="changeDate" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="mcp:metadataContactInfo/mcp:CI_Responsibility/mcp:party/mcp:CI_Organisation/mcp:name/gco:CharacterString">
			<xsl:variable name="org" select="."/>

			<Field name="metadataPOC" string="{$org}" store="true" index="true"/>

			<xsl:variable name="logo" select="../..//gmx:FileName/@src"/>
			<xsl:for-each select="../../../../mcp:role/*/@codeListValue">
				<Field name="responsibleParty" string="{concat(., '|metadata|', $org, '|', $logo)}" store="true" index="false"/>
			</xsl:for-each>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
			<Field name="metadataPOC" string="{string(.)}" store="true" index="true"/>
			<xsl:variable name="role" select="../../gmd:role/*/@codeListValue"/>
			<xsl:variable name="logo" select="../..//gmx:FileName/@src"/>

			<Field name="responsibleParty" string="{concat($role, '|metadata|', ., '|', $logo)}" store="true" index="false"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Reference system info === -->		

		<xsl:for-each select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem">
			<xsl:for-each select="gmd:referenceSystemIdentifier/gmd:RS_Identifier">
				<xsl:variable name="crs" select="concat(string(gmd:codeSpace/gco:CharacterString),'::',string(gmd:code/gco:CharacterString))"/>

				<xsl:if test="$crs != '::'">
					<Field name="crs" string="{$crs}" store="true" index="true"/>
					<Field name="authority" string="{string(gmd:codeSpace/gco:CharacterString)}" store="false" index="true"/>
					<Field name="crsCode" string="{string(gmd:code/gco:CharacterString)}" store="false" index="true"/>
					<Field name="crsVersion" string="{string(gmd:version/gco:CharacterString)}" store="false" index="true"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Free text search === -->		

		<Field name="any" store="false" index="true">
			<xsl:attribute name="string">
				<xsl:value-of select="normalize-space(string(.))"/>
				<xsl:text> </xsl:text>
				<xsl:for-each select="//@codeListValue">
					<xsl:value-of select="concat(., ' ')"/>
				</xsl:for-each>
			</xsl:attribute>
		</Field>

		<!-- <xsl:apply-templates select="." mode="codeList"/> -->
		
	</xsl:template>

	<!-- ========================================================================================= -->
	<!-- codelist element, indexed, not stored nor tokenized -->
	
	<xsl:template match="*[./*/@codeListValue]" mode="codeList">
		<xsl:param name="name" select="name(.)"/>
		
		<Field name="{$name}" string="{*/@codeListValue}" store="false" index="true"/>		
	</xsl:template>

	<!-- ========================================================================================= -->
	
	<xsl:template match="*" mode="codeList">
		<xsl:apply-templates select="*" mode="codeList"/>
	</xsl:template>
	
	<!-- ========================================================================================= -->

</xsl:stylesheet>
