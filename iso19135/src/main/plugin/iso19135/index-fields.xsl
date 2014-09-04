<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:grg="http://www.isotc211.org/2005/grg"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:gmx="http://www.isotc211.org/2005/gmx">

	<xsl:include href="convert/functions.xsl"/>

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<xsl:template match="/">
		<xsl:variable name="isoLangId" select="'eng'"/>
			
		<Document locale="{$isoLangId}">
			<Field name="_locale" string="{$isoLangId}" store="true" index="true"/>
			<Field name="_docLocale" string="{$isoLangId}" store="true" index="true"/>
			<xsl:apply-templates select="grg:RE_Register" mode="metadata"/>
		</Document>
	</xsl:template>
	
	<!-- ========================================================================================= -->

	<xsl:template match="*" mode="metadata">
    <Field name="type" string="register" store="true" index="true"/>

		<Field name="title" string="{string(grg:name/gco:CharacterString)}" store="true" index="true"/>
    <!-- not tokenized title for sorting -->
    <Field name="_title" string="{string(grg:name/gco:CharacterString)}" store="true" index="true"/>

		<Field name="revisionDate" string="{string(grg:version/*/grg:versionDate/*|grg:dateOfLastUpdate/*)}" store="true" index="true"/>
		<Field name="tempExtentBegin" string="{string(grg:version/*/grg:versionDate/*|grg:dateOfLastUpdate/*)}" store="true" index="true"/>

		<Field name="createDate" string="{string(grg:version/*/grg:versionDate/*|grg:dateOfLastUpdate/*)}" store="true" index="true"/>

		<Field name="abstract" string="{string(grg:contentSummary/gco:CharacterString)}" store="true" index="true"/>

		<xsl:for-each select="grg:containedItem/*">
			<Field name="registerItem" string="{string(grg:name/*)}" store="true" index="true"/>
			<Field name="registerItemDesc" string="{string(grg:definition/*|grg:description)}" store="true" index="true"/>

			<Field name="registerItemAcceptedDate" string="{string(grg:dateAccepted/*)}" store="true" index="true"/>
			<Field name="registerItemAmendedDate" string="{string(grg:dateAmended/*)}" store="true" index="true"/>

			<Field name="registerItemFieldOfApplication" string="{string(grg:fieldOfApplication/*/grg:name/*)}" store="true" index="true"/>
		</xsl:for-each>
	
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<xsl:for-each select="//grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
			<Field name="orgName" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- index online protocol -->
			
		<xsl:for-each select="grg:uniformResourceIdentifier/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString">
			<xsl:variable name="download_check"><xsl:text>&amp;fname=&amp;access</xsl:text></xsl:variable>
			<xsl:variable name="linkage" select="../../gmd:linkage/gmd:URL" /> 

			<!-- ignore empty downloads -->
			<xsl:if test="string($linkage)!='' and not(contains($linkage,$download_check))">  
				<Field name="protocol" string="{string(.)}" store="true" index="true"/>
			</xsl:if>  

			<xsl:variable name="mimetype" select="../../gmd:name/gmx:MimeFileType/@type"/>
			<xsl:if test="normalize-space($mimetype)!=''">
         <Field name="mimetype" string="{$mimetype}" store="true" index="true"/>
			</xsl:if>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<xsl:for-each select="grg:operatingLanguage/*/grg:language/gco:CharacterString">
			<Field name="language" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:for-each select="@uuid">
			<Field name="fileId" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<Field name="changeDate" string="{string(grg:version/*/grg:versionDate/*|grg:dateOfLastUpdate/*)}" store="true" index="true"/>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="grg:submitter/*/gmd:contact/*/gmd:organisationName/gco:CharacterString">
			<Field name="metadataPOC" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Free text search === -->		

		<Field name="any" store="false" index="true">
			<xsl:attribute name="string">
				<xsl:apply-templates select="." mode="allText"/>
			</xsl:attribute>
		</Field>

		<xsl:apply-templates select="." mode="codeList"/>
		
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
	<!--allText -->
	
	<xsl:template match="*" mode="allText">
		<xsl:for-each select="@*">
			<xsl:if test="name(.) != 'codeList' ">
				<xsl:value-of select="concat(string(.),' ')"/>
			</xsl:if>	
		</xsl:for-each>

		<xsl:choose>
			<xsl:when test="*"><xsl:apply-templates select="*" mode="allText"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat(string(.),' ')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ========================================================================================= -->

</xsl:stylesheet>
