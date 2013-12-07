<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:gml="http://www.opengis.net/gml/3.2" 
  xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
	xmlns:gcx="http://www.isotc211.org/2005/gcx/1.0/2013-03-28" 
  xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28" 
	xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28" 
	xmlns:mrc="http://www.isotc211.org/2005/mrc/1.0/2013-03-28" 
  xmlns:lan="http://www.isotc211.org/2005/lan/1.0/2013-03-28"
  xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
  xmlns:dqm="http://www.isotc211.org/2005/dqm/1.0/2013-03-28"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  exclude-result-prefixes="#all">

	<xsl:include href="../iso19139/convert/functions.xsl"/>
	<xsl:include href="convert/functions.xsl"/>

	<!-- ================================================================= -->

	<xsl:template match="/root">
		<xsl:apply-templates select="mds:MD_Metadata"/>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="mds:MD_Metadata">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
		
      <!-- Add metadataIdentifier if it doesn't exist -->
			<mds:metadataIdentifier>
        <mcc:MD_Identifier>
          <!-- authority could be for this GeoNetwork node ?
          <mcc:authority><cit:CI_Citation>etc</cit:CI_Citation></mcc:authority>
          -->
          <mcc:code>
            <gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
          </mcc:code>
          <mcc:codeSpace>
            <gco:CharacterString>urn:uuid</gco:CharacterString>
          </mcc:codeSpace>
          <mcc:description>
            <gco:CharacterString>uuid primary key used by GeoNetwork</gco:CharacterString>
          </mcc:description>
        </mcc:MD_Identifier>
			</mds:metadataIdentifier>
			
			<xsl:apply-templates select="mds:defaultLocale"/>
			
      <!-- Add parentMetadata if it doesn't exist -->
			<xsl:choose>
				<xsl:when test="/root/env/parentUuid!=''">
					<mds:parentMetadata>
            <mcc:MD_Identifier>
              <mcc:code>
						    <gco:CharacterString><xsl:value-of select="/root/env/parentUuid"/></gco:CharacterString>
              </mcc:code>
              <mcc:codeSpace>
                <gco:CharacterString>urn:uuid</gco:CharacterString>
              </mcc:codeSpace>
            </mcc:MD_Identifier>
					</mds:parentMetadata>
				</xsl:when>
				<xsl:when test="mds:parentMetadata">
					<xsl:copy-of select="mds:parentMetadata"/>
				</xsl:when>
			</xsl:choose>

      <xsl:apply-templates select="mds:metadataScope"/>
      <xsl:apply-templates select="mds:contact"/>

      <!-- Add dateInfo creation and revision if they don't exist -->
      <xsl:if test="not(mds:dateInfo/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='creation']) and /root/env/changeDate">
          <mds:dateInfo>
            <cit:CI_Date>
              <cit:date>
                <gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
              </cit:date>
              <cit:dateType>
                <cit:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="creation"/>
              </cit:dateType>
            </cit:CI_Date>
          </mds:dateInfo>
      </xsl:if>
      <xsl:if test="not(mds:dateInfo/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']) and /root/env/changeDate">
          <mds:dateInfo>
            <cit:CI_Date>
              <cit:date>
                <gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
              </cit:date>
              <cit:dateType>
                <cit:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="revision"/>
              </cit:dateType>
            </cit:CI_Date>
          </mds:dateInfo>
      </xsl:if>
      <xsl:apply-templates select="mds:dateInfo"/>

      <!-- Add metadataStandard if it doesn't exist -->
      <xsl:choose>
        <xsl:when test="not(mds:metadataStandard)">
          <mds:metadataStandard>
            <cit:CI_Citation>
              <cit:title>
			          <gco:CharacterString>ISO/FDIS 19115-1:2013</gco:CharacterString>
              </cit:title>
            </cit:CI_Citation>
          </mds:metadataStandard>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mds:metadataStandard"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mds:metadataProfile"/>
      <xsl:apply-templates select="mds:alternativeMetadataReference"/>
      <xsl:apply-templates select="mds:otherLocale"/>
      <xsl:apply-templates select="mds:metadataLinkage"/>
      <xsl:apply-templates select="mds:spatialRepresentationInfo"/>
      <xsl:apply-templates select="mds:referenceSystemInfo"/>
      <xsl:apply-templates select="mds:metadataExtensionInfo"/>
      <xsl:apply-templates select="mds:identificationInfo"/>
      <xsl:apply-templates select="mds:contentInfo"/>
      <xsl:apply-templates select="mds:distributionInfo"/>
      <xsl:apply-templates select="mds:dataQualityInfo"/>
      <xsl:apply-templates select="mds:resourceLineage"/>
      <xsl:apply-templates select="mds:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="mds:metadataConstraints"/>
      <xsl:apply-templates select="mds:applicationSchemaInfo"/>
      <xsl:apply-templates select="mds:metadataMaintenance"/>
		</xsl:copy>
	</xsl:template>
  
	<!-- ================================================================= -->
  <!-- Update revision date -->

  <xsl:template match="mds:dateInfo[cit:CI_Date/cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="/root/env/changeDate">
          <cit:CI_Date>
            <cit:date>
              <gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
            </cit:date>
            <cit:dateType>
              <cit:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="revision"/>
            </cit:dateType>
          </cit:CI_Date>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

	<!-- ================================================================= -->
	<!-- Only set metadataStandard if not set. -->

	<xsl:template match="mds:metadataStandard/cit:CI_Citation/cit:title[@gco:nilReason='missing' or gco:CharacterString='']" priority="10">
		<xsl:copy>
			<gco:CharacterString>ISO/FDIS 19115-1:2013</gco:CharacterString>
		</xsl:copy>
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
	<!-- Fix srsName attribute generate CRS:84 (EPSG:4326 with long/lat 
	     ordering) by default -->

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
  
  <!-- Add required gml attributes if missing -->
  <xsl:template match="gml:Polygon[not(@gml:id) and not(@srsName)]">
    <xsl:copy>
      <xsl:attribute name="gml:id">
        <xsl:value-of select="generate-id(.)"/>
      </xsl:attribute>
      <xsl:attribute name="srsName">
        <xsl:text>urn:x-ogc:def:crs:EPSG:6.6:4326</xsl:text>
      </xsl:attribute>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="*"/>
    </xsl:copy>
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

	<xsl:template match="lan:LanguageCode[@codeListValue]" priority="10">
		<lan:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
			<xsl:apply-templates select="@*[name(.)!='codeList']"/>
		</lan:LanguageCode>
	</xsl:template>
	
	<xsl:template match="dqm:*[@codeListValue]" priority="10">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="codeList">
			  <xsl:value-of select="concat('http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19157_Schemas/resources/codelist/ML_gmxCodelists.xml#',local-name(.))"/>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[@codeListValue]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="codeList">
			  <xsl:value-of select="concat('http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#',local-name(.))"/>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- online resources: download -->
	<!-- ================================================================= -->

	<xsl:template match="cit:CI_OnlineResource[matches(cit:protocol/gco:CharacterString,'^WWW:DOWNLOAD-.*-http--download.*') and cit:name]">
		<xsl:variable name="fname" select="cit:name/gco:CharacterString|cit:name/gcx:MimeFileType"/>
		<xsl:variable name="mimeType">
			<xsl:call-template name="getMimeTypeFile">
				<xsl:with-param name="datadir" select="/root/env/datadir"/>
				<xsl:with-param name="fname" select="$fname"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<cit:linkage>
				<cit:URL>
					<xsl:choose>
						<xsl:when test="/root/env/config/downloadservice/simple='true'">
							<xsl:value-of select="concat(/root/env/siteURL,'/resources.get?uuid=',/root/env/uuid,'&amp;fname=',$fname,'&amp;access=private')"/>
						</xsl:when>
						<xsl:when test="/root/env/config/downloadservice/withdisclaimer='true'">
							<xsl:value-of select="concat(/root/env/siteURL,'/file.disclaimer?uuid=',/root/env/uuid,'&amp;fname=',$fname,'&amp;access=private')"/>
						</xsl:when>
						<xsl:otherwise> <!-- /root/env/config/downloadservice/leave='true' -->
							<xsl:value-of select="cit:linkage/cit:URL"/>
						</xsl:otherwise>
					</xsl:choose>
				</cit:URL>
			</cit:linkage>
			<xsl:copy-of select="cit:protocol"/>
			<xsl:copy-of select="cit:applicationProfile"/>
			<cit:name>
				<gcx:MimeFileType type="{$mimeType}">
					<xsl:value-of select="$fname"/>
				</gcx:MimeFileType>
			</cit:name>
			<xsl:copy-of select="cit:description"/>
			<xsl:copy-of select="cit:function"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- online resources: link-to-downloadable data etc -->
	<!-- ================================================================= -->

	<xsl:template match="cit:CI_OnlineResource[starts-with(cit:protocol/gco:CharacterString,'WWW:LINK-') and contains(cit:protocol/gco:CharacterString,'http--download')]">
		<xsl:variable name="mimeType">
			<xsl:call-template name="getMimeTypeUrl">
				<xsl:with-param name="linkage" select="cit:linkage/cit:URL"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="cit:linkage"/>
			<xsl:copy-of select="cit:protocol"/>
			<xsl:copy-of select="cit:applicationProfile"/>
			<cit:name>
				<gcx:MimeFileType type="{$mimeType}"/>
			</cit:name>
			<xsl:copy-of select="cit:description"/>
			<xsl:copy-of select="cit:function"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

  <xsl:template match="gcx:FileName[name(..)!='cit:contactInstructions']">
    <xsl:copy>
			<xsl:attribute name="src">
				<xsl:choose>
					<xsl:when test="/root/env/config/downloadservice/simple='true'">
						<xsl:value-of select="concat(/root/env/siteURL,'/resources.get?uuid=',/root/env/uuid,'&amp;fname=',.,'&amp;access=private')"/>
					</xsl:when>
					<xsl:when test="/root/env/config/downloadservice/withdisclaimer='true'">
						<xsl:value-of select="concat(/root/env/siteURL,'/file.disclaimer?uuid=',/root/env/uuid,'&amp;fname=',.,'&amp;access=private')"/>
					</xsl:when>
					<xsl:otherwise> <!-- /root/env/config/downloadservice/leave='true' -->
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<!-- Do not allow to expand operatesOn sub-elements 
		and constrain users to use uuidref attribute to link
		service metadata to datasets. This will avoid to have
		error on XSD validation. -->

	<xsl:template match="srv:operatesOn|mrc:featureCatalogueCitation">
        <xsl:copy>
        <xsl:copy-of select="@uuidref"/>
        <xsl:if test="@uuidref">
            <xsl:choose>
                <xsl:when test="not(string(@xlink:href)) or starts-with(@xlink:href, /root/env/siteURL)">
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="concat(/root/env/siteURL,'/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id=',@uuidref)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="@xlink:href"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:if>
        </xsl:copy>

	</xsl:template>

	<!-- ================================================================= -->
	<!-- Set local identifier to the first 3 letters of iso code. Locale ids
		are used for multilingual charcterString using #iso2code for referencing.
	-->
	<xsl:template match="lan:PT_Locale">
		<xsl:element name="lan:{local-name()}">
			<xsl:variable name="id" select="upper-case(
				substring(lan:languageCode/lan:LanguageCode/@codeListValue, 1, 3))"/>

			<xsl:apply-templates select="@*"/>
			<xsl:if test="normalize-space(@id)='' or normalize-space(@id)!=$id">
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- Apply same changes as above to the lan:LocalisedCharacterString -->
	<xsl:variable name="language" select="//lan:PT_Locale" /> <!-- Need list of all locale -->

	<xsl:template match="lan:LocalisedCharacterString">
		<xsl:element name="lan:{local-name()}">
			<xsl:variable name="currentLocale" select="upper-case(replace(normalize-space(@locale), '^#', ''))"/>
			<xsl:variable name="ptLocale" select="$language[upper-case(replace(normalize-space(@id), '^#', ''))=string($currentLocale)]"/>
			<xsl:variable name="id" select="upper-case(substring($ptLocale/lan:language/lan:LanguageCode/@codeListValue, 1, 3))"/>
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
	<!-- Note: Only included prefix gml, mds and gco for now. -->
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

	<xsl:template match="mds:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'mds'"/>
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
	<!-- copy everything else as is -->
	
	<xsl:template match="@*|node()">
	    <xsl:copy>
	        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
	</xsl:template>

</xsl:stylesheet>
