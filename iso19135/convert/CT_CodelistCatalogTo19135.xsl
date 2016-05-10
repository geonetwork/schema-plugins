<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	 xmlns:gml="http://www.opengis.net/gml"
   xmlns:gco="http://www.isotc211.org/2005/gco"
   xmlns:gmx="http://www.isotc211.org/2005/gmx"
   xmlns:gmd="http://www.isotc211.org/2005/gmd"
   xmlns:grg="http://www.isotc211.org/2005/grg"
   xmlns:gnreg="http://geonetwork-opensource.org/register"
	 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 xmlns:xlink="http://www.w3.org/1999/xlink"
	 xmlns:util="java:java.util.UUID"
	 exclude-result-prefixes="#all">

	<xsl:output method="xml" version="1.0" indent="yes"/>

	<xsl:param name="uuid" select="util:toString(util:randomUUID())"/>
	<!-- some nasty CT_CodelistCatalog files actually have extra information
	     attached to gml:description in the form of a bounding box in longitudes
			 and latitudes 

			 eg. <gml:description>AUSTRALIA INCLUDING EXTERNAL TERRITORIES|-9|-90|168|45|Australia</gml:description>
			 
			 Nasty because the info has to be parsed out and its harder to validate 
			 (defeats the purpose of using XML really). Fortunately we can extract 
			 it into an extent element for the register items we create here -
			 setting extractbbox to true will do this -->
	<xsl:param name="extractbbox" select="false()"/>
	<!-- sometimes the gml:identifier is too short/not useful as thesaurus term
	     if so then setting usedescription to true() will use the gml:description
			 instead -->
	<xsl:param name="usedescription" select="false()"/>

	<xsl:variable name="versionDate">
		<xsl:choose>
			<xsl:when test="gmx:CT_CodelistCatalogue/gmx:versionDate">
				<xsl:value-of select="gmx:CT_CodelistCatalogue/gmx:versionDate/gco:Date"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>
        <xsl:value-of select="format-dateTime(current-dateTime(),$df)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="fieldOfApplication">
		<xsl:value-of select="gmx:CT_CodelistCatalogue/gmx:fieldOfApplication/gco:CharacterString"/>
	</xsl:variable>

	<!-- ================================================================= -->
	
	<xsl:template match="/gmx:CT_CodelistCatalogue">
		<xsl:element name="grg:RE_Register">
			<xsl:namespace name="grg" select="'http://www.isotc211.org/2005/grg'"/>
			<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
			<xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
   		<xsl:namespace name="gnreg" select="'http://geonetwork-opensource.org/register'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>

			<xsl:attribute name="uuid"><xsl:value-of select="$uuid"/></xsl:attribute>
			<xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/grg http://www.isotc211.org/2005/grg/grg.xsd http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/gco http://www.isotc211.org/2005/gco/gco.xsd</xsl:attribute>

			<grg:name>
				<gco:CharacterString><xsl:value-of select="string(gmx:name/*)"/></gco:CharacterString>
			</grg:name>

			<grg:contentSummary>
				<gco:CharacterString><xsl:value-of select="string(gmx:scope/*)"/></gco:CharacterString>
			</grg:contentSummary>

			<!-- Linkage to codelist catalog -->
  		<grg:uniformResourceIdentifier>
    		<gmd:CI_OnlineResource>
      		<gmd:linkage>
        		<gmd:URL><xsl:value-of select="gmx:codelistItem[1]/gmx:CodeListDictionary/gml:identifier/@codeSpace"/></gmd:URL>
      		</gmd:linkage>
    		</gmd:CI_OnlineResource>
  		</grg:uniformResourceIdentifier>
	
			<!-- Operating Language -->
  		<grg:operatingLanguage>
    		<grg:RE_Locale>
      		<grg:name>
        		<gco:CharacterString>English</gco:CharacterString>
      		</grg:name>
      		<grg:language>
						<gmd:LanguageCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_LanguageCode" codeListValue="eng"/>		
      		</grg:language>
      		<grg:country>
        		<gco:CharacterString>Australia</gco:CharacterString>
      		</grg:country>
      		<grg:characterEncoding>
        		<gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"/>
      		</grg:characterEncoding>
    		</grg:RE_Locale>
  		</grg:operatingLanguage>

			<!-- Alternative Languages (hard code just one here) -->
  		<grg:alternativeLanguages>
    		<grg:RE_Locale>
      		<grg:name>
        		<gco:CharacterString>English</gco:CharacterString>
      		</grg:name>
      		<grg:language>
						<gmd:LanguageCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_LanguageCode" codeListValue="eng"/>		
      		</grg:language>
      		<grg:country>
        		<gco:CharacterString>Australia</gco:CharacterString>
      		</grg:country>
      		<grg:characterEncoding>
        		<gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"/>
      		</grg:characterEncoding>
    		</grg:RE_Locale>
  		</grg:alternativeLanguages>

			<!-- Version - use this instead of dateOfLastChange -->
			<grg:version>
				<grg:RE_Version>
      		<grg:versionNumber>
						<gco:CharacterString><xsl:value-of select="string(gmx:versionNumber/*)"/></gco:CharacterString>
      		</grg:versionNumber>
      		<grg:versionDate>
						<gco:Date><xsl:value-of select="string(gmx:versionDate/*)"/></gco:Date>
      		</grg:versionDate>
				</grg:RE_Version>
			</grg:version>

			<!-- Owner -->
			<grg:owner>
				<grg:RE_RegisterOwner>
      		<grg:name>
        		<gco:CharacterString>ANZLIC</gco:CharacterString>
      		</grg:name>
					<grg:contact xlink:href="#ANZLIC_Contact"/>
				</grg:RE_RegisterOwner>
			</grg:owner>

			<!-- Submitter -->
			<grg:submitter>
				<grg:RE_SubmittingOrganization>
      		<grg:name>
        		<gco:CharacterString>ANZLIC</gco:CharacterString>
      		</grg:name>
					<grg:contact xlink:href="#ANZLIC_Contact"/>
				</grg:RE_SubmittingOrganization>
			</grg:submitter>

			<!-- containedItemClass - standard 19135 RE_RegisterItem -->
			<grg:containedItemClass>
				<grg:RE_ItemClass id="Item_Class">
					<grg:name>
        		<gco:CharacterString>gnreg:RE_RegisterItem</gco:CharacterString>
					</grg:name>
					<grg:technicalStandard>
        		<gmd:CI_Citation>	
							<gmd:title>
								<gco:CharacterString>GeoNetwork Extension to RE_RegisterItem in ISO19135</gco:CharacterString>
          		</gmd:title>
            	<gmd:date>
            		<gmd:CI_Date>
                	<gmd:date>
                		<gco:Date>2012-04-29</gco:Date>
                	</gmd:date>
                	<gmd:dateType>
                		<gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="creation"/>
                	</gmd:dateType>
              	</gmd:CI_Date>
            	</gmd:date>
							<gmd:edition>
              	<gco:CharacterString>First</gco:CharacterString>
            	</gmd:edition>
          	</gmd:CI_Citation>	
					</grg:technicalStandard>
				</grg:RE_ItemClass>
			</grg:containedItemClass>

			<!-- Manager -->
			<grg:manager>
				<grg:RE_RegisterManager>
      		<grg:name>
        		<gco:CharacterString>ANZLIC</gco:CharacterString>
      		</grg:name>
					<grg:contact>
						<gmd:CI_ResponsibleParty id="ANZLIC_Contact">
        			<gmd:organisationName>
            		<gco:CharacterString>ANZLIC</gco:CharacterString>
        			</gmd:organisationName>
        			<gmd:contactInfo>
            		<gmd:CI_Contact>
                	<gmd:address>
                    <gmd:CI_Address>
                        <gmd:deliveryPoint>
                            <gco:CharacterString>GPO Box 337</gco:CharacterString>
                        </gmd:deliveryPoint>
                        <gmd:city>
                            <gco:CharacterString>CANBERRA</gco:CharacterString>
                        </gmd:city>
                        <gmd:administrativeArea>
                            <gco:CharacterString>Australian Capital Territory</gco:CharacterString>
                        </gmd:administrativeArea>
                        <gmd:postalCode>
                            <gco:CharacterString>2601</gco:CharacterString>
                        </gmd:postalCode>
                        <gmd:country>
                            <gco:CharacterString>AUSTRALIA</gco:CharacterString>
                        </gmd:country>
                        <gmd:electronicMailAddress>
                            <gco:CharacterString>info@ANZLIC.org.au</gco:CharacterString>
                        </gmd:electronicMailAddress>
                    </gmd:CI_Address>
                	</gmd:address>
            		</gmd:CI_Contact>
        			</gmd:contactInfo>
        			<gmd:role>
            		<gmd:CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelist.xml#CI_RoleCode" codeListValue="custodian">custodian</gmd:CI_RoleCode>
        			</gmd:role>
    				</gmd:CI_ResponsibleParty>	
					</grg:contact>
				</grg:RE_RegisterManager>
			</grg:manager>

			<xsl:message>Converting <xsl:value-of select="count(gmx:codelistItem/gmx:CodeListDictionary/gmx:codeEntry)"/> codelist items</xsl:message>
			<xsl:message>Number of dictionaries <xsl:value-of select="count(gmx:codelistItem/gmx:CodeListDictionary)"/></xsl:message>

			<!-- codelist dictionaries -->
			<xsl:for-each select="gmx:codelistItem/gmx:CodeListDictionary">
				<xsl:message>Processing dictionary <xsl:value-of select="gml:description"/></xsl:message>
				<xsl:apply-templates select="."/>
			</xsl:for-each>
	
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmx:CodeListDictionary">

		<xsl:variable name="id" select="substring-after(generate-id(..),'e')"/>

		<!-- process the code dictionary element -->
		<xsl:call-template name="createItem"/>
		
		<!-- codelist items -->
		<xsl:for-each select="gmx:codeEntry/gmx:CodeDefinition">
			<xsl:call-template name="createItem">
				<xsl:with-param name="broader" select="$id"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<!-- ================================================================= -->

	<xsl:template name="createItem">
		<xsl:param name="broader"/>

		<xsl:variable name="uuid" select="concat(normalize-space(gml:identifier/@codeSpace),'/',normalize-space(gml:identifier))"/>

		<xsl:variable name="desc">
			<xsl:choose>
				<xsl:when test="$extractbbox">
					<xsl:variable name="descBefore" select="substring-before(gml:description,'|')"/>
					<xsl:choose>
						<xsl:when test="normalize-space($descBefore)=''">
							<xsl:value-of select="gml:description"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$descBefore"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="gml:description"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<grg:containedItem>
			<gnreg:RE_RegisterItem gco:isoType="grg:RE_RegisterItem" uuid="{$uuid}">
     	<grg:itemIdentifier>
				<gco:Integer><xsl:value-of select="substring-after(generate-id(),'e')"/></gco:Integer>
      </grg:itemIdentifier>

			<grg:name>
				<xsl:choose>
					<xsl:when test="$usedescription">
						<gco:CharacterString><xsl:value-of select="$desc"/></gco:CharacterString>
					</xsl:when>
					<xsl:otherwise>
						<gco:CharacterString><xsl:value-of select="gml:identifier"/></gco:CharacterString>
					</xsl:otherwise>
				</xsl:choose>
			</grg:name>

			<grg:status>
				<grg:RE_ItemStatus>valid</grg:RE_ItemStatus>
			</grg:status>

			<grg:dateAccepted>
				<gco:Date><xsl:value-of select="$versionDate"/></gco:Date>
			</grg:dateAccepted>

			<grg:definition>
				<gco:CharacterString><xsl:value-of select="gml:description"/></gco:CharacterString>
			</grg:definition>

			<grg:fieldOfApplication>
				<grg:RE_FieldOfApplication>
					<grg:name>
						<gco:CharacterString><xsl:value-of select="$fieldOfApplication"/></gco:CharacterString>
					</grg:name>
					<grg:description>
						<gco:CharacterString><xsl:value-of select="$fieldOfApplication"/></gco:CharacterString>
					</grg:description>
				</grg:RE_FieldOfApplication>
			</grg:fieldOfApplication>

			<grg:additionInformation>
				<grg:RE_AdditionInformation>
					<grg:dateProposed>
						<gco:Date><xsl:value-of select="$versionDate"/></gco:Date>
					</grg:dateProposed>
					<grg:justification>
						<gco:CharacterString>Needed for metadata themes</gco:CharacterString>
					</grg:justification>
					<grg:status>
						<grg:RE_DecisionStatus>final</grg:RE_DecisionStatus>
					</grg:status>
					<grg:sponsor>
						<grg:RE_SubmittingOrganization>
      				<grg:name>
        				<gco:CharacterString>ANZLIC</gco:CharacterString>
      				</grg:name>
							<grg:contact xlink:href="#ANZLIC_Contact"/>
						</grg:RE_SubmittingOrganization>
					</grg:sponsor>
				</grg:RE_AdditionInformation>
			</grg:additionInformation>

			<grg:itemClass xlink:href="#Item_Class"/>

			<!-- add broader similarity to source to point back to parent --> 
			<xsl:if test="normalize-space($broader)!=''">
				<grg:specificationLineage>
					<grg:RE_Reference>
						<grg:itemIdentifierAtSource>
							<gco:CharacterString><xsl:value-of select="$broader"/></gco:CharacterString>
						</grg:itemIdentifierAtSource>
						<grg:similarity>
							<grg:RE_SimilarityToSource codeListValue="generalization"
											codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#RE_SimilarityToSource"/>
						</grg:similarity>
					</grg:RE_Reference>
				</grg:specificationLineage>	
			</xsl:if>

			<!-- add narrower similarity to source to point to children -->
			<xsl:if test="local-name(.)='CodeListDictionary'">
				<xsl:for-each select="gmx:codeEntry">
					<grg:specificationLineage>
						<grg:RE_Reference>
							<grg:itemIdentifierAtSource>
								<gco:CharacterString><xsl:value-of select="substring-after(generate-id(),'e')"/></gco:CharacterString>
							</grg:itemIdentifierAtSource>
							<grg:similarity>
								<grg:RE_SimilarityToSource codeListValue="specialization"
												codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#RE_SimilarityToSource"/>
							</grg:similarity>
						</grg:RE_Reference>
					</grg:specificationLineage>	
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="$extractbbox">
				<xsl:variable name="extra" select="translate(normalize-space(substring-after(gml:description,'|')),'|',',')"/>
				<xsl:if test="normalize-space($extra)!=''">
					<xsl:variable name="bbox" select="tokenize($extra,',')"/>
					<gnreg:itemExtent>
						<gmd:EX_Extent>
							<gmd:geographicElement>
           			<gmd:EX_GeographicBoundingBox>
             			<gmd:westBoundLongitude>
               			<gco:Decimal><xsl:value-of select="$bbox[4]"/></gco:Decimal>
             			</gmd:westBoundLongitude>
             			<gmd:eastBoundLongitude>
               			<gco:Decimal><xsl:value-of select="$bbox[3]"/></gco:Decimal>
             			</gmd:eastBoundLongitude>
             			<gmd:southBoundLatitude>
               			<gco:Decimal><xsl:value-of select="$bbox[2]"/></gco:Decimal>
             			</gmd:southBoundLatitude>
             			<gmd:northBoundLatitude>
               			<gco:Decimal><xsl:value-of select="$bbox[1]"/></gco:Decimal>
             			</gmd:northBoundLatitude>
           			</gmd:EX_GeographicBoundingBox>
         			</gmd:geographicElement>
						</gmd:EX_Extent>
					</gnreg:itemExtent>
				</xsl:if>
			</xsl:if>

			<!-- add a useful identifier that has more meaning than the integer
		     	id provided by grg:itemIdentifier -->

			<gnreg:itemIdentifier>
				<gco:CharacterString><xsl:value-of select="$uuid"/></gco:CharacterString>
			</gnreg:itemIdentifier>

  	 	</gnreg:RE_RegisterItem>
		</grg:containedItem>

	</xsl:template>

	
</xsl:stylesheet>
