<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:dc="http://purl.org/dc/terms/" 
								xmlns:eml="eml://ecoinformatics.org/eml-2.1.1">	

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
		<Document>
			<xsl:apply-templates select="eml:eml" mode="metadata"/>
		</Document>
	</xsl:template>
	
	<!-- ========================================================================================= -->

	<xsl:template match="*" mode="metadata">

		<xsl:for-each select="dataset">
		
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="alternateIdentifier">
				<Field name="fileId" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:variable name="title" select="title[1]"/>
			<Field name="title" string="{string($title)}" store="true" index="true"/>
      <Field name="_title" string="{string($title)}" store="true" index="true"/>

			<xsl:for-each select="title[position() > 1]">
				<Field name="altTitle" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
	
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="pubDate">
				<Field name="publicationDate" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<!-- fields used to search for metadata in paper or digital format -->

			<Field name="digital" string="true" store="true" index="true"/>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="abstract">
				<Field name="abstract" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<!-- geographic extents -->

			<xsl:for-each select="coverage/geographicCoverage">
				<xsl:apply-templates select="boundingCoordinates" mode="latLon"/>

				<xsl:for-each select="geographicDescription">
					<Field name="geoDescCode" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
			</xsl:for-each>

			<!-- temporal extents -->

			<xsl:for-each select="coverage/temporalCoverage">
				<xsl:for-each select="rangeOfDates">
					<xsl:variable name="times">
						<xsl:call-template name="newGmlTime">
							<xsl:with-param name="begin" select="beginDate/calendarDate"/>
							<xsl:with-param name="end" select="endDate/calendarDate"/>
						</xsl:call-template>
					</xsl:variable>

					<Field name="tempExtentBegin" string="{lower-case(substring-before($times,'|'))}" store="true" index="true"/>
					<Field name="tempExtentEnd" string="{lower-case(substring-after($times,'|'))}" store="true" index="true"/>
				</xsl:for-each>

			</xsl:for-each>

			<!-- taxonomic extents -->
			<!-- FIXME: Not done yet - needs to use the same structure as the MCP
			     ALA -->

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

      <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
      <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
			<xsl:for-each select="keywordSet">
				<xsl:for-each select="keyword">
          <xsl:variable name="keywordLower" select="translate(string(.),$upper,$lower)"/>
          <Field name="keyword" string="{string(.)}" store="true" index="true"/>
					<Field name="subject" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>
			</xsl:for-each>
	
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<!-- Organization could be in associatedParty or in contact -->	

			<xsl:for-each select="associatedParty[role='pointOfContact' and organizationName]">
				<Field name="orgName" string="{string(organizationName)}" store="true" index="true"/>
			</xsl:for-each>

			<xsl:for-each select="contact[organizationName]">
				<Field name="orgName" string="{string(organizationName)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="language">
				<Field name="datasetLang" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="intellectualRights">
				<Field name="conditionApplyingToAccessAndUse" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
			<xsl:for-each select="metadataProvider/organisationName">
				<Field name="metadataPOC" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

		</xsl:for-each>
			
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<!-- === Other stuff from the additionalMetadata block === -->

		<xsl:for-each select="additionalMetadata/metadata/gbif">

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
			<xsl:choose>
				<xsl:when test="hierarchyLevel">
					<xsl:for-each select="hierarchyLevel">
						<Field name="type" string="{string(.)}" store="true" index="true"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<Field name="type" string="dataset" store="true" index="true"/>
				</xsl:otherwise>
			</xsl:choose>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="physical">
				<xsl:for-each select="dataFormat/externallyDefinedFormat/formatName">
					<Field name="format" string="{string(.)}" store="true" index="true"/>
				</xsl:for-each>

				<!-- index online protocol -->
				<xsl:if test="distribution/online/url/@function='download'">
					<Field name="protocol" string="WWW:DOWNLOAD-1.0-http--download" store="true" index="true"/>
				</xsl:if>  

				<!-- FIXME: add code to calculate mimetype and add to index -->
				<!--
        <Field name="mimetype" string="{$mimetype}" store="true" index="true"/>
				-->
			</xsl:for-each>  

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="dateStamp">
				<Field name="changeDate" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Free text search === -->		

		<Field name="any" store="false" index="true">
			<xsl:attribute name="string">
				<xsl:apply-templates select="." mode="allText"/>
			</xsl:attribute>
		</Field>

	</xsl:template>

	<!-- ========================================================================================= -->
	<!-- latlon coordinates indexed as numeric. -->
	
	<xsl:template match="*" mode="latLon">

		<xsl:variable name="format" select="'##.00'"></xsl:variable>

		<xsl:if test="number(westBoundingCoordinate)">
			<Field name="westBL" string="{format-number(westBoundingCoordinate, $format)}" store="true" index="true"/>
		</xsl:if>
	
		<xsl:if test="number(southBoundingCoordinate)">
			<Field name="southBL" string="{format-number(southBoundingCoordinate, $format)}" store="true" index="true"/>
		</xsl:if>
	
		<xsl:if test="number(eastBoundingCoordinate)">
			<Field name="eastBL" string="{format-number(eastBoundingCoordinate, $format)}" store="true" index="true"/>
		</xsl:if>
	
		<xsl:if test="number(northBoundingCoordinate)">
			<Field name="northBL" string="{format-number(northBoundingCoordinate, $format)}" store="true" index="true"/>
		</xsl:if>
	
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
