<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	 xmlns:gml="http://www.opengis.net/gml"
   xmlns:gco="http://www.isotc211.org/2005/gco"
   xmlns:gmx="http://www.isotc211.org/2005/gmx"
   xmlns:gmd="http://www.isotc211.org/2005/gmd"
   xmlns:grg="http://www.isotc211.org/2005/grg"
	 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 xmlns:xlink="http://www.w3.org/1999/xlink"
	 exclude-result-prefixes="#all">

	<xsl:output method="xml" version="1.0" indent="yes"/>

	<xsl:param name="uuid" select="generate-id()"/>

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
        		<gmd:URL><xsl:value-of select="gmx:codelistItem/gmx:CodeListDictionary/gml:identifier/@codeSpace"/></gmd:URL>
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
        		<gco:CharacterString>eng</gco:CharacterString>
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
        		<gco:CharacterString>eng</gco:CharacterString>
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
        		<gco:CharacterString>grg:RE_RegisterItem</gco:CharacterString>
					</grg:name>
					<grg:technicalStandard>
        		<gmd:CI_Citation>	
							<gmd:title>
								<gco:CharacterString>ISO19135</gco:CharacterString>
          		</gmd:title>
            	<gmd:date>
            		<gmd:CI_Date>
                	<gmd:date>
                		<gco:Date>2005-10-15</gco:Date>
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

			<!-- codelist items -->
			<xsl:for-each select="gmx:codelistItem/gmx:CodeListDictionary/gmx:codeEntry">
				<grg:containedItem>
    			<grg:RE_RegisterItem uuid="{gmx:CodeDefinition/gml:identifier}">
      			<grg:itemIdentifier>
							<gco:Integer><xsl:value-of select="position()"/></gco:Integer>
      			</grg:itemIdentifier>

						<xsl:apply-templates select="gmx:CodeDefinition"/>

    			</grg:RE_RegisterItem>
				</grg:containedItem>
					
			</xsl:for-each>
	
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmx:CodeDefinition">
		<grg:name>
			<gco:CharacterString><xsl:value-of select="gml:identifier"/></gco:CharacterString>
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

	</xsl:template>

	
</xsl:stylesheet>
