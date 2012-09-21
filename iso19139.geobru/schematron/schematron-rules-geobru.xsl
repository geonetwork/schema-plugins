<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:gml="http://www.opengis.net/gml" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:geonet="http://www.fao.org/geonetwork" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geobru="http://geobru.irisnet.be" version="2.0">
	<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
	<xsl:param name="archiveDirParameter"/>
	<xsl:param name="archiveNameParameter"/>
	<xsl:param name="fileNameParameter"/>
	<xsl:param name="fileDirParameter"/>
	<xsl:variable name="document-uri">
		<xsl:value-of select="document-uri(/)"/>
	</xsl:variable>
	<!--PHASES-->
	<!--PROLOG-->
	<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>
	<xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
	<xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
	<xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
	<xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
	<xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc" select="document(concat('loc/', $lang, '/', substring-before($rule, '.xsl'), '.xml'))"/>
	<!--XSD TYPES FOR XSLT2-->
	<!--KEYS AND FUNCTIONS-->
	<!--DEFAULT RULES-->
	<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
	<!--This mode can be used to generate an ugly though full XPath for locators-->
	<xsl:template match="*" mode="schematron-select-full-path">
		<xsl:apply-templates select="." mode="schematron-get-full-path"/>
	</xsl:template>
	<!--MODE: SCHEMATRON-FULL-PATH-->
	<!--This mode can be used to generate an ugly though full XPath for locators-->
	<xsl:template match="*" mode="schematron-get-full-path">
		<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
		<xsl:text>/</xsl:text>
		<xsl:choose>
			<xsl:when test="namespace-uri()=''">
				<xsl:value-of select="name()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*:</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>[namespace-uri()='</xsl:text>
				<xsl:value-of select="namespace-uri()"/>
				<xsl:text>']</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
		<xsl:text>[</xsl:text>
		<xsl:value-of select="1+ $preceding"/>
		<xsl:text>]</xsl:text>
	</xsl:template>
	<xsl:template match="@*" mode="schematron-get-full-path">
		<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
		<xsl:text>/</xsl:text>
		<xsl:choose>
			<xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>@*[local-name()='</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>' and namespace-uri()='</xsl:text>
				<xsl:value-of select="namespace-uri()"/>
				<xsl:text>']</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--MODE: SCHEMATRON-FULL-PATH-2-->
	<!--This mode can be used to generate prefixed XPath for humans-->
	<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
		<xsl:for-each select="ancestor-or-self::*">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="name(.)"/>
			<xsl:if test="preceding-sibling::*[name(.)=name(current())]">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="not(self::*)">
			<xsl:text/>/@<xsl:value-of select="name(.)"/>
		</xsl:if>
	</xsl:template>
	<!--MODE: SCHEMATRON-FULL-PATH-3-->
	<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
	<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
		<xsl:for-each select="ancestor-or-self::*">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="name(.)"/>
			<xsl:if test="parent::*">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="not(self::*)">
			<xsl:text/>/@<xsl:value-of select="name(.)"/>
		</xsl:if>
	</xsl:template>
	<!--MODE: GENERATE-ID-FROM-PATH -->
	<xsl:template match="/" mode="generate-id-from-path"/>
	<xsl:template match="text()" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
	</xsl:template>
	<xsl:template match="comment()" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
	</xsl:template>
	<xsl:template match="processing-instruction()" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
	</xsl:template>
	<xsl:template match="@*" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.@', name())"/>
	</xsl:template>
	<xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
	</xsl:template>
	<!--MODE: GENERATE-ID-2 -->
	<xsl:template match="/" mode="generate-id-2">U</xsl:template>
	<xsl:template match="*" mode="generate-id-2" priority="2">
		<xsl:text>U</xsl:text>
		<xsl:number level="multiple" count="*"/>
	</xsl:template>
	<xsl:template match="node()" mode="generate-id-2">
		<xsl:text>U.</xsl:text>
		<xsl:number level="multiple" count="*"/>
		<xsl:text>n</xsl:text>
		<xsl:number count="node()"/>
	</xsl:template>
	<xsl:template match="@*" mode="generate-id-2">
		<xsl:text>U.</xsl:text>
		<xsl:number level="multiple" count="*"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="string-length(local-name(.))"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="translate(name(),':','.')"/>
	</xsl:template>
	<!--Strip characters-->
	<xsl:template match="text()" priority="-1"/>
	<!--SCHEMA SETUP-->
	<xsl:template match="/">
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="GeoBRU metadata implementing rule validation" schemaVersion="">
			<xsl:comment>
				<xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
			</xsl:comment>
			<svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml" prefix="gml"/>
			<svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
			<svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
			<svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
			<svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
			<svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2004/02/skos/core#" prefix="skos"/>
			<svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex1"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex1_5"/>
			<xsl:apply-templates select="/" mode="annex1_7"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex2"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex2_1"/>
			<xsl:apply-templates select="/" mode="annex2_2"/>
			<xsl:apply-templates select="/" mode="annex2_3"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex5"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex5_3"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex6"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex6_1"/>
			<xsl:apply-templates select="/" mode="annex6_3"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex7"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex7_1"/>
			<xsl:apply-templates select="/" mode="annex7_2"/>
			<xsl:apply-templates select="/" mode="annex7_3"/>
			<xsl:apply-templates select="/" mode="annex7_4"/>
			<xsl:apply-templates select="/" mode="annex7_5"/>
			<xsl:apply-templates select="/" mode="annex7_6"/>
			<xsl:apply-templates select="/" mode="annex7_7"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex8"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex8_1"/>
			<xsl:apply-templates select="/" mode="annex8_2"/>
			<svrl:active-pattern>
				<xsl:attribute name="document"><xsl:value-of select="document-uri(/)"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$loc/strings/annex10"/></xsl:attribute>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="annex10_1"/>


		</svrl:schematron-output>
	</xsl:template>
	<!--SCHEMATRON PATTERNS-->
	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">GeoBRU metadata implementing rule validation</svrl:text>
	<!--PATTERN $loc/strings/identification-->
	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
		<xsl:copy-of select="$loc/strings/annex1"/>
	</svrl:text>
	<!--RULE -->
	<!-- CHECK 1.5 - Resource locator -->
    <!-- Check on resource locator exists in INSPIRE schematron, but is executed on //gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/gmd:CI_OnlineResource -->
    <!-- So, if no OnlineResource elements exist, no error will be thrown -->
    <!-- This is correct for INSPIRE -->
    <!--   SPEC: Conditional for spatial dataset and spatial dataset series: Mandatory if a URL is available to obtain more information on the resources and/or access related services. -->
    <!--         Conditional for services: Mandatory if linkage to the service is available) -->
    <!-- We'll just check if at least one OnlineResource element exists -->
	<xsl:template match="//gmd:MD_Metadata" mode="annex1_5">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
		<xsl:variable name="noOnlineResource" select="count(gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/gmd:CI_OnlineResource) = 0"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="not($noOnlineResource)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noOnlineResource)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG115/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="not($noOnlineResource)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noOnlineResource)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG115/div"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>	</xsl:template>
	<!-- CHECK 1.7 - Coupled Resource -->
    <!-- Check on coupled resource (on services) exists in INSPIRE schematron, but  it only contains reports, no asserts, so it will never report an error -->
    <!-- This is correct for INSPIRE -->
    <!--   SPEC: Not applicable to dataset and dataset series -->
    <!--         Conditional to services: Mandatory if linkage to datasets on which the service operates are available. -->
    <!-- We've copied this check created an assert instead of the reports in the INSPIRE XSL -->
	<xsl:template match="//srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']" mode="annex1_7">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
		<xsl:variable name="coupledResourceHref" select="string-join(srv:operatesOn/@xlink:href, ', ')"/>
		<xsl:variable name="coupledResourceUUID" select="string-join(srv:operatesOn/@uuidref, ', ')"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$coupledResourceHref!='' or $coupledResourceUUID!=''"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$coupledResourceHref!='' or $coupledResourceUUID!=''">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG117/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- CHECK 2.1 - GeoBRU version -->
    <!-- Specific GeoBRU check -->
	<xsl:template match="//gmd:MD_DataIdentification[    ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = '']    |    //*[@gco:isoType='gmd:MD_DataIdentification' and (    ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]" mode="annex2_1">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
		<xsl:variable name="geobruVersion" select="//gmd:distributionInfo/geobru:BXL_Distribution/geobru:version/*/text()"/>
		<xsl:variable name="noGeobruVersion" select="normalize-space(//gmd:distributionInfo/geobru:BXL_Distribution/geobru:version/*/text())='' or not(//gmd:distributionInfo/geobru:BXL_Distribution/geobru:version)"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="not($noGeobruVersion)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noResourceLocator)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG121/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="not($noGeobruVersion)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noResourceLocator)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG121/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$geobruVersion"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 2.2 - Coordinate reference system -->
    <!-- New check - not manadatory by INSPIRE -->
    <!-- Checks whether referenceSystemInfo occurs at least once and checks for each occurrence of referenceSystemInfo whether a code and code space are provided -->
	<xsl:template match="//gmd:MD_Metadata" mode="annex2_2">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
		<xsl:variable name="referenceSystemInfo" select="//gmd:referenceSystemInfo"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$referenceSystemInfo"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$referenceSystemInfo">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG122/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="//gmd:referenceSystemInfo" mode="annex2_2_report" />
	</xsl:template>
	<xsl:template match="//gmd:MD_Metadata/gmd:referenceSystemInfo" mode="annex2_2_report">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata/gmd:referenceSystemInfo"/>
		<xsl:variable name="referenceSystemIdentifier" select="gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier and not(gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier[gmd:code/@gco:nilReason='missing'])  and not(gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier[gmd:codeSpace/@gco:nilReason='missing'])"/>
		<xsl:variable name="referenceSystemIdentifier_code" select="gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/*/text()"/>
		<xsl:variable name="referenceSystemIdentifier_codeSpace" select="gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/*/text()"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$referenceSystemIdentifier"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$referenceSystemIdentifier">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG122.def/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="$referenceSystemIdentifier">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$referenceSystemIdentifier_code">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG122/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$referenceSystemIdentifier_code"/>
					<xsl:text/> (<xsl:text/>
					<xsl:copy-of select="$referenceSystemIdentifier_codeSpace"/>
					<xsl:text/>)
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 2.3 - Distribution format -->
    <!-- There is a check in ISO schematron, but on distribution level -->
    <!-- Copied check + modified the check to occur on MD_Metadata -->
    <!-- According to ISO SPEC (211n1359) The "distributionFormat" role of MD_Distribution or the "distributorFormat" role of MD_Distributor should be available -->
    <!-- So, I guess the check in the ISO schematron is not correct and the check should occur at MD_Metadata level  -->
	<xsl:template match="//gmd:MD_Metadata|//*[@gco:isoType='gmd:MD_Metadata']" mode="annex2_3">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//geobru:BXL_Distribution"/>
		<xsl:variable name="total" select="count(gmd:distributionInfo/geobru:BXL_Distribution/gmd:distributionFormat) +     count(gmd:distributionInfo/geobru:BXL_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat)"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$total &gt; 0"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$total &gt; 0">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:copy-of select="$loc/strings/alert.MG123"/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="$total &gt; 0">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$total &gt; 0">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$total"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG123"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 5.3 - Check if extent is correct -->
    <!-- This is a corrected version of the check in INSPIRE XSL -->
	<!-- INSPIRE XSL template matches EX_GeographicBoundingBox level, so only if this element exists, the check is performed -->
    <!-- This template matches the element MD_DataIdentification -->
    <!-- INSPIRE SPEC: Mandatory for spatial dataset and dataset series. -->
    <!--               Conditional for spatial services: Mandatory for services with an explicit geographic extent.  -->
    <!-- This seems to be an error in the INSPIRE schematron -->
	<xsl:template match="//gmd:MD_DataIdentification[    ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = '']    |    //*[@gco:isoType='gmd:MD_DataIdentification' and (    ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]" mode="annex5_3">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_DataIdentification[    ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = '']    |    //*[@gco:isoType='gmd:MD_DataIdentification' and (    ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]"/>
		<xsl:variable name="west" select="number(gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal/text())"/>
		<xsl:variable name="east" select="number(gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal/text())"/>
		<xsl:variable name="north" select="number(gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal/text())"/>
		<xsl:variable name="south" select="number(gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal/text())"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG153.W/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG153.W/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$west"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG153.E/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG153.E/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$east"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="(-90.00 &lt;= $south) and ($south &lt;= $north)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG153.S/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG153.S/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$south"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="($south &lt;= $north) and ($north &lt;= 90.00)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="($south &lt;= $north) and ($north &lt;= 90.00)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG153.N/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="($south &lt;= $north) and ($north &lt;= 90.00)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="($south &lt;= $north) and ($north &lt;= 90.00)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG153.N/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$north"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 6.1 & 6.2 - Check if begin date is filled in when end date is filled in and vice versa -->
    <!-- New check -->
	<xsl:template match="gml:TimePeriod" mode="annex6_1">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
		<xsl:variable name="temporalExtentBegin" select="gml:beginPosition/text()"/>
		<xsl:variable name="temporalExtentEnd" select="gml:endPosition/text()"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$temporalExtentBegin and normalize-space($temporalExtentBegin)!=''">
				<xsl:choose>
					<xsl:when test="$temporalExtentEnd and normalize-space($temporalExtentEnd)!=''"/>
					<xsl:otherwise>
						<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$no_creationDate &lt;= 1">
							<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
							<svrl:text>
								<xsl:text/>
								<xsl:copy-of select="$loc/strings/alert.MG161/div"/>
								<xsl:text/>
							</svrl:text>
						</svrl:failed-assert>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$temporalExtentEnd and normalize-space($temporalExtentEnd)!=''">
				<xsl:choose>
					<xsl:when test="$temporalExtentBegin and normalize-space($temporalExtentBegin)!=''"/>
					<xsl:otherwise>
						<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$no_creationDate &lt;= 1">
							<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
							<svrl:text>
								<xsl:text/>
								<xsl:copy-of select="$loc/strings/alert.MG162/div"/>
								<xsl:text/>
							</svrl:text>
						</svrl:failed-assert>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- CHECK 6.3 & 6.4 & 6.5 - ISO rules are more restrictive than INSPIRE/GeoBRU: publication date, creation date or revision date must be provided (even if an extent is already provided) -->
	<!-- Since this is not checked in ISO schematron, we'll add it here -->
	<xsl:template match="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']" mode="annex6_3">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
		<xsl:variable name="publicationDate" select="gmd:citation/*/gmd:date[./*/gmd:dateType/*/@codeListValue='publication']/*/gmd:date/*"/>
		<xsl:variable name="creationDate" select="gmd:citation/*/gmd:date[./*/gmd:dateType/*/@codeListValue='creation']/*/gmd:date/*"/>
		<xsl:variable name="revisionDate" select="gmd:citation/*/gmd:date[./*/gmd:dateType/*/@codeListValue='revision']/*/gmd:date/*"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$publicationDate or $creationDate or $revisionDate"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$publicationDate or $creationDate or $revisionDate">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG163/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="$publicationDate or $creationDate or $revisionDate">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$publicationDate or $creationDate or $revisionDate">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:copy-of select="$loc/strings/report.MG163/div"/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.1 - Check if lineage is provided -->
    <!-- This is a corrected version of the check in INSPIRE XSL -->
	<!-- INSPIRE XSL template matches DQ_DataQuality level, so only if this element exists, the check is performed -->
    <!-- This template matches the element MD_Metadata -->
    <!-- INSPIRE SPEC: Mandatory for spatial dataset and spatial dataset series. -->
    <!--               Not applicable to services.  -->
    <!-- This seems to be an error in the INSPIRE schematron -->
	<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']" mode="annex7_1">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']"/>
		<xsl:variable name="noLineage" select="not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/gmd:statement) or gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/gmd:statement/@gco:nilReason='missing'"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="not($noLineage)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noLineage)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:copy-of select="$loc/strings/alert.MG171/div"/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="not($noLineage)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noLineage)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:copy-of select="$loc/strings/report.MG171/div"/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.2 - Spatial resolution -->
    <!-- This is a corrected version of the check in INSPIRE XSL -->
	<!-- INSPIRE XSL template matches spatialResolution level, so only if this element exists, the check is performed -->
    <!-- This template matches the element MD_Metadata -->
    <!-- INSPIRE SPEC: Conditional: Mandatory if an equivalent scale or a resolution distance can be specified.  -->
    <!--               Conditional: Mandatory when there is a restriction on the spatial resolution for service.  -->
    <!-- This seems to be an error in the INSPIRE schematron -->
	<xsl:template match="//gmd:MD_DataIdentification|//*[@gco:isoType='gmd:MD_DataIdentification']" mode="annex7_2">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_DataIdentification|//*[@gco:isoType='gmd:MD_DataIdentification']"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="gmd:spatialResolution/*/gmd:equivalentScale or gmd:spatialResolution/*/gmd:distance"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="*/gmd:equivalentScale or */gmd:distance">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:copy-of select="$loc/strings/alert.MG172/div"/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="gmd:spatialResolution/*/gmd:equivalentScale or gmd:spatialResolution/*/gmd:distance">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="*/gmd:equivalentScale or */gmd:distance">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:copy-of select="$loc/strings/report.MG172/div"/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.3 - Completeness -->
    <!-- New check - GeoBRU extension -->
	<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']" mode="annex7_3">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']"/>
		<xsl:variable name="noCompleteness" select="not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:completeness) or not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:completeness/gco:Boolean)"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="not($noCompleteness)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noCompleteness)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:copy-of select="$loc/strings/alert.MG173/div"/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="not($noCompleteness)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noCompleteness)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:copy-of select="$loc/strings/report.MG173/div"/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.4 - Lineage - general quality -->
    <!-- GeoBRU extension -->
    <!-- No error - only report -->
	<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']" mode="annex7_4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']"/>
		<xsl:variable name="noQuality" select="not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:quality) or gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:quality/@gco:nilReason='missing'"/>
		<!--REPORT -->
		<xsl:if test="not($noQuality)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noQuality)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:copy-of select="$loc/strings/report.MG174/div"/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.5 - Lineage - validated -->
    <!-- GeoBRU extension -->
    <!-- No error - only report -->
	<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']" mode="annex7_5">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']"/>
		<xsl:variable name="noValidated" select="not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:validated) or not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:validated/gco:Boolean)"/>
		<xsl:variable name="validated" select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:validated/gco:Boolean/text()" />
		<!--REPORT -->
		<xsl:if test="not($noValidated)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noValidated)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG175/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$validated"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.6 - Lineage - official version -->
    <!-- GeoBRU extension -->
    <!-- No error - only report -->
	<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']" mode="annex7_6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']"/>
		<xsl:variable name="noOfficial" select="not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:official) or not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:official/gco:Boolean)"/>
		<xsl:variable name="official" select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:official/gco:Boolean/text()" />
		<!--REPORT -->
		<xsl:if test="not($noOfficial)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noOfficial)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG176/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$official"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 7.7 - Lineage - legal -->
    <!-- GeoBRU extension -->
    <!-- No error - only report -->
	<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']" mode="annex7_7">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification    or gmd:identificationInfo/*/@gco:isoType = 'gmd:MD_DataIdentification']"/>
		<xsl:variable name="noLegal" select="not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:legal) or not(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:legal/gco:Boolean)"/>
		<xsl:variable name="legal" select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/geobru:BXL_Lineage/geobru:legal/gco:Boolean/text()" />
		<!--REPORT -->
		<xsl:if test="not($noLegal)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noLegal)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG177/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$legal"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 8.1 - Conditions applying to access and use  -->
    <!-- There exists a check in INSPIRE XSL, but this check is never executed!! -->
    <!-- This seems to be an error in the INSPIRE schematron -->
    <!-- The check below is a slightly modified version of the INSPIRE check -->
    <!-- INSPIRE SPEC: [1..*] for the resource but there is zero or one condition applying to access and use per instance of  MD_Constraints  -->
	<xsl:template match="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']" mode="annex8_1">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
		<xsl:variable name="useLimitation" select="string-join(gmd:resourceConstraints/*/gmd:useLimitation/*/text(), ', ')"/>
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="$useLimitation != ''"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$useLimitation != ''">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG181/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="$useLimitation != ''">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$useLimitation_count">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG181/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$useLimitation"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 8.2 - Limitations on public access   -->
    <!-- INSPIRE SPEC: [1..*] for the resource but there are zero or many limitations on public access per instance of MD_Constraints.   -->
    <!-- This seems to be an error in the INSPIRE schematron -->
    <!-- The check below is a slightly modified version of the INSPIRE check -->
	<xsl:template match="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']" mode="annex8_2">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_DataIdentification|    //*[@gco:isoType='gmd:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
		<xsl:variable name="accessConstraints" select="string-join(gmd:resourceConstraints/*/gmd:accessConstraints/*/@codeListValue, ', ')"/>
		<xsl:choose>
			<xsl:when test="$accessConstraints != ''"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$useLimitation_count">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:text/>
						<xsl:copy-of select="$loc/strings/alert.MG182/div"/>
						<xsl:text/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="$accessConstraints != ''">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="$useLimitation_count">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG182/div"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
	<!-- CHECK 10.1 - fileIdentifier -->
    <!-- Not mandatory by INSPIRE -->
    <!-- Added check -->
	<xsl:template match="//gmd:MD_Metadata" mode="annex10_1">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
		<xsl:variable name="noFileIdentifier" select="not(gmd:fileIdentifier) or normalize-space(gmd:fileIdentifier/*/text())=''"/>
		<xsl:variable name="fileIdentifier" select="gmd:fileIdentifier/*/text()" />
		<!--ASSERT -->
		<xsl:choose>
			<xsl:when test="not($noFileIdentifier)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noFileIdentifier)">
					<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
					<svrl:text>
						<xsl:copy-of select="$loc/strings/alert.MG1101/div"/>
					</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<!--REPORT -->
		<xsl:if test="not($noFileIdentifier)">
			<svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}" test="not($noFileIdentifier)">
				<xsl:attribute name="location"><xsl:apply-templates select="." mode="schematron-select-full-path"/></xsl:attribute>
				<svrl:text>
					<xsl:text/>
					<xsl:copy-of select="$loc/strings/report.MG1101/div"/>
					<xsl:text/>
					<xsl:text/>
					<xsl:copy-of select="$fileIdentifier"/>
					<xsl:text/>
				</svrl:text>
			</svrl:successful-report>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
