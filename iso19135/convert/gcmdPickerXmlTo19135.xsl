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
		<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>
    <xsl:value-of select="format-dateTime(current-dateTime(),$df)"/>
	</xsl:variable>

	<!-- ================================================================= -->
	
	<xsl:template match="/GCMD_KEYWORDS">
		<xsl:element name="grg:RE_Register">
			<xsl:namespace name="grg" select="'http://www.isotc211.org/2005/grg'"/>
			<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
			<xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>

			<xsl:attribute name="uuid"><xsl:value-of select="$uuid"/></xsl:attribute>
			<xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/grg http://www.isotc211.org/2005/grg/grg.xsd http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/gco http://www.isotc211.org/2005/gco/gco.xsd</xsl:attribute>

			<grg:name>
				<gco:CharacterString>Global Change Master Directory Earth Science Keywords</gco:CharacterString>
			</grg:name>

			<grg:contentSummary>
				<gco:CharacterString>Keywords organised in a hierarchy of topic, term and variable. There are 7 sets of keywords: data set, data services, data centers, locations, instrument/sensors, platforms/sources, and projects. This does not include the Climate Diagnostic keywords.</gco:CharacterString>
			</grg:contentSummary>

			<!-- Linkage to codelist catalog -->
  		<grg:uniformResourceIdentifier>
    		<gmd:CI_OnlineResource>
      		<gmd:linkage>
        		<gmd:URL>http://gcmd.nasa.gov/Resources/valids/archives/keyword_list.html</gmd:URL>
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
        		<gco:CharacterString>USA</gco:CharacterString>
      		</grg:country>
      		<grg:characterEncoding>
        		<gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"/>
      		</grg:characterEncoding>
    		</grg:RE_Locale>
  		</grg:operatingLanguage>

			<!-- Version - use this instead of dateOfLastChange -->
			<grg:version>
				<grg:RE_Version>
      		<grg:versionNumber>
						<gco:CharacterString>GCMD Keywords, Version 5.3.8</gco:CharacterString>
      		</grg:versionNumber>
      		<grg:versionDate>
						<gco:Date>2006</gco:Date>
      		</grg:versionDate>
				</grg:RE_Version>
			</grg:version>

			<!-- Owner -->
			<grg:owner>
				<grg:RE_RegisterOwner>
      		<grg:name>
        		<gco:CharacterString>NASA</gco:CharacterString>
      		</grg:name>
					<grg:contact xlink:href="#NASA_Contact"/>
				</grg:RE_RegisterOwner>
			</grg:owner>

			<!-- Submitter -->
			<grg:submitter>
				<grg:RE_SubmittingOrganization>
      		<grg:name>
        		<gco:CharacterString>Various</gco:CharacterString>
      		</grg:name>
					<grg:contact xlink:href="#NASA_Contact"/>
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
        		<gco:CharacterString>NASA</gco:CharacterString>
      		</grg:name>
					<grg:contact>
						<gmd:CI_ResponsibleParty id="NASA_Contact">
        			<gmd:organisationName>
            		<gco:CharacterString>NASA</gco:CharacterString>
        			</gmd:organisationName>
        			<gmd:contactInfo>
            		<gmd:CI_Contact>
                	<gmd:onlineResource>
                    <gmd:CI_OnlineResource>
                      <gmd:linkage>
                        <gmd:URL>http://gcmd.gsfc.nasa.gov/Resources/valids/</gmd:URL>
                      </gmd:linkage>
                      <gmd:protocol>
                        <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                      </gmd:protocol>
                    </gmd:CI_OnlineResource>
                	</gmd:onlineResource>
            		</gmd:CI_Contact>
        			</gmd:contactInfo>
        			<gmd:role>
            		<gmd:CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="owner">owner</gmd:CI_RoleCode>
        			</gmd:role>
						</gmd:CI_ResponsibleParty>
					</grg:contact>
				</grg:RE_RegisterManager>
			</grg:manager>

			<!-- codelist items -->
			<xsl:apply-templates select="TOPIC"/>

		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="generalization" match="*">
		<xsl:call-template name="lineage">
			<xsl:with-param name="similarity" select="'generalization'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ............................................................ -->

	<xsl:template mode="specialization" match="*">
		<xsl:call-template name="lineage">
			<xsl:with-param name="similarity" select="'specialization'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ............................................................ -->

	<xsl:template name="lineage">
		<xsl:param name="similarity" select="'unknown'"/>

		<xsl:variable name="id" select="generate-id()"/>
		<grg:specificationLineage>
      <grg:RE_Reference>
      	<grg:itemIdentifierAtSource>
        	<gco:CharacterString><xsl:value-of select="substring-after($id,'e')"/></gco:CharacterString>
        </grg:itemIdentifierAtSource>
        <grg:similarity>
        	<grg:RE_SimilarityToSource codeListValue="{$similarity}" codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#RE_SimilarityToSource"/>
				</grg:similarity>
			</grg:RE_Reference>
		</grg:specificationLineage>
	</xsl:template>

	<!-- ............................................................ -->

	<xsl:template match="TOPIC">
		<xsl:variable name="id" select="generate-id()"/>
		<grg:containedItem>
    	<grg:RE_RegisterItem uuid="{$id}">
     		<grg:itemIdentifier>
					<gco:Integer><xsl:value-of select="substring-after($id,'e')"/></gco:Integer>
     		</grg:itemIdentifier>
				<grg:name>
					<gco:CharacterString><xsl:value-of select="@value"/></gco:CharacterString>
				</grg:name>
				<xsl:call-template name="addStatic"/>
				<xsl:apply-templates mode="specialization" select="TERM"/>
    	</grg:RE_RegisterItem>
		</grg:containedItem>
		<xsl:apply-templates select="TERM"/>
	</xsl:template>

	<!-- ............................................................ -->

	<xsl:template match="TERM">
		<xsl:variable name="id" select="generate-id()"/>
		<grg:containedItem>
    	<grg:RE_RegisterItem uuid="{$id}">
     		<grg:itemIdentifier>
					<gco:Integer><xsl:value-of select="substring-after($id,'e')"/></gco:Integer>
     		</grg:itemIdentifier>
				<grg:name>
					<gco:CharacterString><xsl:value-of select="@value"/></gco:CharacterString>
				</grg:name>
				<xsl:call-template name="addStatic"/>
				<xsl:apply-templates mode="specialization" select="VARIABLE"/>
				<xsl:apply-templates mode="generalization" select=".."/>
    	</grg:RE_RegisterItem>
		</grg:containedItem>
		<xsl:apply-templates select="VARIABLE"/>
	</xsl:template>

	<!-- ............................................................ -->

	<xsl:template match="VARIABLE">
		<xsl:variable name="id" select="generate-id()"/>
		<grg:containedItem>
    	<grg:RE_RegisterItem uuid="{$id}">
      	<grg:itemIdentifier>
					<gco:Integer><xsl:value-of select="substring-after($id,'e')"/></gco:Integer>
      	</grg:itemIdentifier>
				<grg:name>
					<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
				</grg:name>
				<xsl:call-template name="addStatic"/>
				<xsl:apply-templates mode="generalization" select=".."/>
    	</grg:RE_RegisterItem>
		</grg:containedItem>
	</xsl:template>

	<!-- ............................................................ -->

	<xsl:template name="addStatic">
		<grg:status>
			<grg:RE_ItemStatus>valid</grg:RE_ItemStatus>
		</grg:status>
		<grg:dateAccepted>
			<gco:Date>2006</gco:Date>
		</grg:dateAccepted>
		<grg:definition gco:nilReason="missing"/>
		<grg:itemClass xlink:href="#Item_Class"/>
	</xsl:template>

</xsl:stylesheet>
