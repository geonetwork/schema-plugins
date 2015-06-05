<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:prov="http://www.w3.org/ns/prov#"
								xmlns:dct="http://purl.org/dc/terms/" 
								xmlns:dc="http://purl.org/dc/elements/1.1/">	

	<xsl:include href="convert/functions.xsl"/>

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
		<Document locale="eng">
			<Field name="_locale" string="eng" store="true" index="true" token="false"/>
			<Field name="_docLocale" string="eng" store="true" index="true" token="false"/>
			<xsl:apply-templates select="prov:document" mode="metadata"/>
		</Document>
	</xsl:template>
	
	<!-- ========================================================================================= -->

	<xsl:template match="*" mode="metadata">

		<!-- TODO: Need to get metadata record pointed to by entity gnprov:documentMetadata -->

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<xsl:for-each select="prov:other/dc:identifier">
			<Field name="fileId" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<Field name="_defaultTitle" string="{string(prov:other/dc:title)}" store="true" index="true"/>
		<!-- not tokenized title for sorting, needed for multilingual sorting -->
		<Field name="_title" string="{string(prov:other/dc:title)}" store="true" index="true" />

		<xsl:for-each select="prov:other/dc:description">
				<Field name="abstract" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- fields used to search for metadata in paper or digital format -->

		<Field name="digital" string="true" store="true" index="true"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
		<Field name="type" string="provenanceDocument" store="true" index="true"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<Field name="changeDate" string="{prov:other/dct:modified}" store="true" index="true"/>
			
		<!-- Assume that we DCMI box encoding present in dc:coverage --> 
		<xsl:for-each select="tokenize(/prov:other/dc:coverage,';')">
			<xsl:choose>
				<xsl:when test="contains(.,'northlimit')">
					<Field name="northBL" string="{substring-after(.,'=')}" store="false" index="true"/>
				</xsl:when>
				<xsl:when test="contains(.,'southlimit')">
					<Field name="southBL" string="{substring-after(.,'=')}" store="false" index="true"/>
				</xsl:when>
				<xsl:when test="contains(.,'eastlimit')">
    			<Field name="eastBL"  string="{substring-after(.,'=')}" store="false" index="true"/>
				</xsl:when>
				<xsl:when test="contains(.,'westlimit')">
    			<Field name="westBL"  string="{substring-after(.,'=')}" store="false" index="true"/>
				</xsl:when>
				<xsl:when test="contains(.,'place')">
    			<Field name="keyword"  string="{substring-after(.,'=')}" store="false" index="true"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<xsl:for-each select="tokenize(/prov:other/dc:subject,',')">
			<Field name="keyword" string="{string(.)}" store="true" index="true"/>
		</xsl:for-each>
	
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Free text search === -->		

		<Field name="any" store="false" index="true">
			<xsl:attribute name="string">
				<xsl:value-of select="normalize-space(string(.))"/>
			</xsl:attribute>
		</Field>

	</xsl:template>

	<!-- ========================================================================================= -->

</xsl:stylesheet>
