<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
						xmlns:gml="http://www.opengis.net/gml"
						xmlns:srv="http://www.isotc211.org/2005/srv"
						xmlns:gmx="http://www.isotc211.org/2005/gmx"
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
						xmlns:xlink="http://www.w3.org/1999/xlink"
						xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
						xmlns:dwc="http://rs.tdwg.org/dwc/terms/"
						xmlns:gmd="http://www.isotc211.org/2005/gmd"
						exclude-result-prefixes="#all">

	<xsl:include href="../iso19139/convert/functions.xsl"/>

	<xsl:variable name="metadataStandardName" select="'Australian Marine Community Profile of ISO 19115:2005/19139'"/>
	<xsl:variable name="metadataStandardVersion" select="'2.0'"/>

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="mcp:MD_Metadata"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="mcp:MD_Metadata">
		 <xsl:copy>
		 	<xsl:copy-of select="@*[name()!='xsi:schemaLocation']"/>
			<xsl:copy-of select="/root/env/schemaLocation/@xsi:schemaLocation"/>
			<xsl:if test="not(@gco:isoType)">
				<xsl:attribute name="gco:isoType">gmd:MD_Metadata</xsl:attribute>
			</xsl:if>
		 	<xsl:choose>
				<xsl:when test="not(gmd:fileIdentifier)">
		 			<gmd:fileIdentifier>
						<gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
					</gmd:fileIdentifier>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gmd:fileIdentifier"/>
				</xsl:otherwise>
			</xsl:choose>
      <xsl:apply-templates select="gmd:language"/>
      <xsl:apply-templates select="gmd:characterSet"/>
			<xsl:choose>
        <xsl:when test="/root/env/parentUuid!=''">
          <gmd:parentIdentifier>
            <gco:CharacterString>
              <xsl:value-of select="/root/env/parentUuid"/>
            </gco:CharacterString>
          </gmd:parentIdentifier>
        </xsl:when>
        <xsl:when test="gmd:parentIdentifier">
          <xsl:apply-templates select="gmd:parentIdentifier"/>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="gmd:hierarchyLevel"/>
      <xsl:apply-templates select="gmd:hierarchyLevelName"/>
      <xsl:apply-templates select="gmd:contact"/>
			<xsl:choose>
				<xsl:when test="not(gmd:dateStamp) or normalize-space(gmd:dateStamp/*)=''">
					<gmd:dateStamp>
						<gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
					</gmd:dateStamp>
				</xsl:when>
				<xsl:otherwise>
      		<xsl:apply-templates select="gmd:dateStamp"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:metadataStandardName)">
					<gmd:metadataStandardName>
						<gco:CharacterString><xsl:value-of select="$metadataStandardName"/></gco:CharacterString>
					</gmd:metadataStandardName>
				</xsl:when>
				<xsl:otherwise>
      		<xsl:apply-templates select="gmd:metadataStandardName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="not(gmd:metadataStandardVersion)">
					<gmd:metadataStandardVersion>
						<gco:CharacterString><xsl:value-of select="$metadataStandardVersion"/></gco:CharacterString>
					</gmd:metadataStandardVersion>
				</xsl:when>
				<xsl:otherwise>
      		<xsl:apply-templates select="gmd:metadataStandardVersion"/>
				</xsl:otherwise>
			</xsl:choose>
      <xsl:apply-templates select="gmd:dataSetURI"/>
      <xsl:apply-templates select="gmd:locale"/>
      <xsl:apply-templates select="gmd:spatialRepresentationInfo"/>
      <xsl:apply-templates select="gmd:referenceSystemInfo"/>
      <xsl:apply-templates select="gmd:metadataExtensionInfo"/>
      <xsl:apply-templates select="gmd:identificationInfo"/>
			<xsl:apply-templates select="gmd:contentInfo"/>
			<xsl:choose>
				<xsl:when test="not(gmd:distributionInfo)">
					<gmd:distributionInfo>
						<gmd:MD_Distribution>
							<gmd:transferOptions>
								<gmd:MD_DigitalTransferOptions>
									<xsl:call-template name="addMetadataURL"/>
								</gmd:MD_DigitalTransferOptions>
							</gmd:transferOptions>
						</gmd:MD_Distribution>
					</gmd:distributionInfo>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gmd:distributionInfo"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="gmd:dataQualityInfo"/>
      <xsl:apply-templates select="gmd:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="gmd:metadataConstraints"/>
      <xsl:apply-templates select="gmd:applicationSchemaInfo"/>
      <xsl:apply-templates select="gmd:metadataMaintenance"/>
      <xsl:apply-templates select="gmd:series"/>
      <xsl:apply-templates select="gmd:describes"/>
      <xsl:apply-templates select="gmd:propertyType"/>
      <xsl:apply-templates select="gmd:featureType"/>
      <xsl:apply-templates select="gmd:featureAttribute"/>
			<xsl:choose>
        <xsl:when test="not(mcp:revisionDate)">
          <mcp:revisionDate>
            <gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
          </mcp:revisionDate>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mcp:revisionDate"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="mcp:metadataContactInfo"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmd:MD_Distribution">
		 <xsl:copy>
		 		<xsl:copy-of select="@*"/>
      	<xsl:apply-templates select="gmd:distributionFormat"/>
      	<xsl:apply-templates select="gmd:distributor"/>
				<xsl:choose>
					<xsl:when test="not(gmd:transferOptions)">
						<gmd:transferOptions>
							<gmd:MD_DigitalTransferOptions>
								<xsl:call-template name="addMetadataURL"/>
							</gmd:MD_DigitalTransferOptions>
						</gmd:transferOptions>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="gmd:transferOptions"/>
					</xsl:otherwise>
				</xsl:choose>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="gmd:fileIdentifier" priority="10">
		<xsl:copy>
			<gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
		</xsl:copy>
	</xsl:template>
	
	<!-- ================================================================= -->
	
	<xsl:template match="mcp:revisionDate" priority="10">
		<xsl:choose>
			<xsl:when test="/root/env/changeDate">
				<xsl:copy>
					<gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================================================================= -->
	
	<xsl:template match="gmd:metadataStandardName" priority="10">
		<xsl:copy>
			<gco:CharacterString><xsl:value-of select="$metadataStandardName"/></gco:CharacterString>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="gmd:metadataStandardVersion" priority="10">
		<xsl:copy>
			<gco:CharacterString><xsl:value-of select="$metadataStandardVersion"/></gco:CharacterString>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="mcp:MD_CreativeCommons" priority="10">
		<mcp:MD_Commons mcp:commonsType="Creative Commons" gco:isoType="gmd:MD_Constraints">
			<xsl:copy-of select="*"/>
		</mcp:MD_Commons>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="mcp:MD_DataCommons" priority="10">
		<mcp:MD_Commons mcp:commonsType="Data Commons" gco:isoType="gmd:MD_Constraints">
			<xsl:copy-of select="*"/>
		</mcp:MD_Commons>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmd:dateStamp">
		<xsl:choose>
			<xsl:when test="/root/env/changeDate">
				<gmd:dateStamp>
					<gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
				</gmd:dateStamp>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmd:LanguageCode[@codeListValue]" priority="10">
	 	<gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
			<xsl:apply-templates select="@*[name(.)!='codeList']"/>
		</gmd:LanguageCode>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="@gml:id">
		<xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<xsl:attribute name="gml:id">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==================================================================== -->
	<!-- Fix srsName attribute generate CRS:84 (long/lat ordering) by default -->

	<xsl:template match="@srsName">
		<xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<xsl:attribute name="srsName">
					<xsl:text>CRS:84</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================================================================= -->
	
	<xsl:template match="*[gco:CharacterString]">
		<xsl:copy>
			<xsl:apply-templates select="@*[not(name()='gco:nilReason')]"/>
			<xsl:choose>
				<xsl:when test="normalize-space(gco:CharacterString)=''">
					<xsl:attribute name="gco:nilReason">
						<xsl:choose>
							<xsl:when test="@gco:nilReason"><xsl:value-of select="@gco:nilReason"/></xsl:when>
							<xsl:otherwise>missing</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@gco:nilReason!='missing' and normalize-space(gco:CharacterString)!=''">
					<xsl:copy-of select="@gco:nilReason"/>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- codelists: set @codeList path -->
	<!-- ================================================================= -->
	
	<xsl:template match="*[@codeListValue]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="codeList">
				<xsl:value-of select="concat('http://schemas.aodn.org.au/mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#',local-name(.))"/>
			</xsl:attribute>
			<xsl:value-of select="@codeListValue"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- online resources: metadata URL -->
	<!-- ================================================================= -->

	<!-- test and see whether we need to add a metadata URL to the
			 distributionInfo -->
	     
	<xsl:template match="gmd:transferOptions[ancestor::gmd:distributionInfo and position()=1]/gmd:MD_DigitalTransferOptions">
		<xsl:copy>
		 	<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="gmd:unitsOfDistribution"/>
			<xsl:apply-templates select="gmd:transferSize"/>
			<xsl:choose>
				<xsl:when test="not(gmd:onLine)">
						<xsl:call-template name="addMetadataURL"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- find out whether we need to add the METADATA URL -->
					<xsl:if test="not(../..//gmd:protocol[starts-with(gco:CharacterString,'WWW:LINK-') and contains(gco:CharacterString,'metadata-URL')])">
						<xsl:call-template name="addMetadataURL"/>
					</xsl:if>
					<!-- process the onLine blocks anyway -->
					<xsl:apply-templates select="gmd:onLine"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="gmd:offLine"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="gmd:CI_OnlineResource[starts-with(gmd:protocol/gco:CharacterString,'WWW:LINK-') and contains(gmd:protocol/gco:CharacterString,'metadata-URL') and ancestor::gmd:distributionInfo]" priority="20">
		<xsl:copy>
			<xsl:call-template name="addMetadataURLInternals"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- online resources: download -->
	<!-- ================================================================= -->

	<xsl:template match="gmd:CI_OnlineResource[starts-with(gmd:protocol/gco:CharacterString,'WWW:DOWNLOAD-') and contains(gmd:protocol/gco:CharacterString,'http--download') and gmd:name]">
		<xsl:variable name="fname" select="gmd:name/gco:CharacterString|gmd:name/gmx:MimeFileType"/>
		<xsl:variable name="mimeType">
			<xsl:call-template name="getMimeTypeFile">
				<xsl:with-param name="datadir" select="/root/env/datadir"/>
				<xsl:with-param name="fname" select="$fname"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<gmd:linkage>
				<gmd:URL>
					<xsl:choose>
						<xsl:when test="/root/env/config/downloadservice/simple='true' or contains(gmd:protocol/gco:CharacterString,'direct')">
							<xsl:value-of select="concat(/root/env/siteURL,'/resources.get?uuid=',/root/env/uuid,'&amp;fname=',$fname,'&amp;access=private')"/>
						</xsl:when>
						<xsl:when test="/root/env/config/downloadservice/withdisclaimer='true'">
							<xsl:value-of select="concat(/root/env/siteURL,'/file.disclaimer?uuid=',/root/env/uuid,'&amp;fname=',$fname,'&amp;access=private')"/>
						</xsl:when>
						<xsl:otherwise> <!-- /root/env/config/downloadservice/leave='true' -->
							<xsl:value-of select="gmd:linkage/gmd:URL"/>
						</xsl:otherwise>
					</xsl:choose>
				</gmd:URL>
			</gmd:linkage>
			<xsl:copy-of select="gmd:protocol"/>
			<xsl:copy-of select="gmd:applicationProfile"/>
			<gmd:name>
				<gmx:MimeFileType type="{$mimeType}">
					<xsl:value-of select="$fname"/>
				</gmx:MimeFileType>
			</gmd:name>
			<xsl:copy-of select="gmd:description"/>
			<xsl:copy-of select="gmd:function"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- online resources: link-to-downloadable data etc -->
	<!-- ================================================================= -->

	<xsl:template match="gmd:CI_OnlineResource[starts-with(gmd:protocol/gco:CharacterString,'WWW:LINK-') and contains(gmd:protocol/gco:CharacterString,'http--download')]">
		<xsl:variable name="mimeType">
			<xsl:call-template name="getMimeTypeUrl">
				<xsl:with-param name="linkage" select="gmd:linkage/gmd:URL"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="gmd:linkage"/>
			<xsl:copy-of select="gmd:protocol"/>
			<xsl:copy-of select="gmd:applicationProfile"/>
			<gmd:name>
				<gmx:MimeFileType type="{$mimeType}"/>
			</gmd:name>
			<xsl:copy-of select="gmd:description"/>
			<xsl:copy-of select="gmd:function"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================-->
	
	<xsl:template match="gmx:FileName">
		<xsl:copy>
			<xsl:attribute name="src">
				<xsl:value-of select="concat(/root/env/siteURL,'/resources.get?uuid=',/root/env/uuid,'&amp;fname=',.,'&amp;access=private')"/>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- Set local identifier to the first 3 letters of iso code. Locale ids
		are used for multilingual charcterString using #iso2code for referencing.
	-->
	<xsl:template match="gmd:PT_Locale">
		<xsl:element name="gmd:{local-name()}">
			<xsl:variable name="id" select="upper-case(
				substring(gmd:languageCode/gmd:LanguageCode/@codeListValue, 1, 3))"/>

			<xsl:apply-templates select="@*"/>
			<xsl:if test="@id and (normalize-space(@id)='' or normalize-space(@id)!=$id)">
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- Apply same changes as above to the gmd:LocalisedCharacterString -->
	<xsl:variable name="language" select="//gmd:PT_Locale" /> <!-- Need list of all locale -->
	<xsl:template  match="gmd:LocalisedCharacterString">
		<xsl:element name="gmd:{local-name()}">
			<xsl:variable name="currentLocale" select="upper-case(replace(normalize-space(@locale), '^#', ''))"/>
			<xsl:variable name="ptLocale" select="$language[upper-case(replace(normalize-space(@id), '^#', ''))=string($currentLocale)]"/>
			<xsl:variable name="id" select="upper-case(substring($ptLocale/gmd:languageCode/gmd:LanguageCode/@codeListValue, 1, 3))"/>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="$id != '' and ($currentLocale='' or @locale!=concat('#', $id)) ">
				<xsl:attribute name="locale">
					<xsl:value-of select="concat('#',$id)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- Adjust the namespace declaration - In some cases name() is used to get the 
		element. The assumption is that the name is in the format of  <ns:element> 
		however in some cases it is in the format of <element xmlns=""> so the 
		following will convert them back to the expected value. This also corrects the issue 
		where the <element xmlns=""> loose the xmlns="" due to the exclude-result-prefixes="#all" -->
	<!-- Note: Only included prefix gml, gmd and gco for now. -->
	<!-- TODO: Figure out how to get the namespace prefix via a function so that we don't need to hard code them -->
	<!-- ================================================================= -->

	<xsl:template name="correct_ns_prefix">
		<xsl:param name="element" />
		<xsl:param name="prefix" />
		<xsl:choose>
			<xsl:when test="local-name($element)=name($element) and $prefix != '' ">
				<xsl:element name="{$prefix}:{local-name($element)}">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="gmd:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'gmd'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="gco:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'gco'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="gml:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'gml'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template name="addMetadataURL">
		<gmd:onLine>
			<gmd:CI_OnlineResource>
				<xsl:call-template name="addMetadataURLInternals"/>
			</gmd:CI_OnlineResource>
		</gmd:onLine>
	</xsl:template>

	<!-- ================================================================= -->
		
	<xsl:template name="addMetadataURLInternals">
		<gmd:linkage>
			<gmd:URL>
				<xsl:value-of select="concat(/root/env/siteURL,'/metadata.show?uuid=',/root/env/uuid)"/>
			</gmd:URL>
		</gmd:linkage>
		<gmd:protocol>
			<gco:CharacterString>WWW:LINK-1.0-http--metadata-URL</gco:CharacterString>
		</gmd:protocol>
		<gmd:description>
			<gco:CharacterString>Point of truth URL of this metadata record</gco:CharacterString>
		</gmd:description>
	</xsl:template>

</xsl:stylesheet>
