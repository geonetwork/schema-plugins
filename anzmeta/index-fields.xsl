<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

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
		<Document>
	
			<xsl:apply-templates select="/anzmeta/citeinfo/title">
				<xsl:with-param name="token" select="'true'"/>
				<xsl:with-param name="store" select="'true'"/>
			</xsl:apply-templates>
			
			<xsl:apply-templates select="/anzmeta/descript/abstract">
				<xsl:with-param name="token" select="'true'"/>
				<xsl:with-param name="store" select="'true'"/>
			</xsl:apply-templates>
		
			<xsl:apply-templates select="/anzmeta/descript/spdom/bounding" mode="latLon"/>
			
			<xsl:apply-templates select="/anzmeta/citeinfo/origin/jurisdic/keyword">
				<xsl:with-param name="name" select="'keyword'"/>
				<xsl:with-param name="store" select="'true'"/>
				<xsl:with-param name="token" select="'false'"/>
			</xsl:apply-templates>
	
			<xsl:apply-templates select="/anzmeta/descript/theme/keyword">
				<xsl:with-param name="name" select="'keyword'"/>
				<xsl:with-param name="store" select="'true'"/>
				<xsl:with-param name="token" select="'false'"/>
			</xsl:apply-templates>

			<Field name="any" store="false" index="true">
				<xsl:attribute name="string">
					<xsl:apply-templates select="/anzmeta" mode="allText"/>
				</xsl:attribute>
			</Field>
	
			<!-- digital data format -->
			<xsl:if test="/anzmeta/distinfo/native/digform">
				<Field name="digital" string="true" store="false" index="true"/>
			</xsl:if>

     	<!-- not tokenized title for sorting -->
     	<Field name="_title" string="{string(/anzmeta/citeinfo/title)}" store="true" index="true"/>
		</Document>
	</xsl:template>
	
	<!-- ========================================================================================= -->
	
	<!-- text element, by default indexed, not stored, tokenized -->
	<xsl:template match="*">
		<xsl:param name="name"  select="name(.)"/>
		<xsl:param name="store" select="'false'"/>
		<xsl:param name="index" select="'true'"/>
		<xsl:param name="token" select="'false'"/>
		
	   <Field name="{$name}" string="{string(.)}" store="{$store}" index="{$index}" token="{$token}"/>
	</xsl:template>
	
	<!-- ========================================================================================= -->
	
	<!-- latlon coordinates + 360, zero-padded, indexed, not stored, not tokenized -->
	<xsl:template match="*" mode="latLon">
		<xsl:variable name="format" select="'##.00'"></xsl:variable>
		<xsl:if test="number(westbc)">
			<Field name="westBL" string="{format-number(westbc, $format)}" store="true" index="true"/>
		</xsl:if>
	
		<xsl:if test="number(southbc)">
			<Field name="southBL" string="{format-number(southbc, $format)}" store="true" index="true"/>
		</xsl:if>
	
		<xsl:if test="number(eastbc)">
			<Field name="eastBL" string="{format-number(eastbc, $format)}" store="true" index="true"/>
		</xsl:if>
	
		<xsl:if test="number(northbc)">
			<Field name="northBL" string="{format-number(northbc, $format)}" store="true" index="true"/>
		</xsl:if>
	</xsl:template>
	
	<!-- ========================================================================================= -->
	
	<!--allText -->
	<xsl:template match="*" mode="allText">
		<xsl:for-each select="@*"><xsl:value-of select="concat(string(.),' ')"/></xsl:for-each>
		<xsl:choose>
			<xsl:when test="*"><xsl:apply-templates select="*" mode="allText"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat(string(.),' ')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
