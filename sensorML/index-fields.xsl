<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:swe="http://www.opengis.net/swe/1.0.1"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
	xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ========================================================================================= -->
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	
	<!-- ========================================================================================= -->

	<xsl:template match="/">
		<Document>
      <Field name="_locale" string="eng" store="true" index="true"/>
      <Field name="_docLocale" string="eng" store="true" index="true"/>

			<xsl:apply-templates select="sml:SensorML" mode="metadata"/>
		</Document>
	</xsl:template>
	
	<!-- ========================================================================================= -->

	<xsl:template match="*" mode="metadata">

		<!-- === Sensor Identification === -->		

		<xsl:for-each select="sml:member">

			<xsl:for-each select="sml:System/sml:identification">
				<xsl:for-each select="sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID']">
					<Field name="identifier" string="{normalize-space(string(.))}" store="true" index="true" token="false"/>
				</xsl:for-each>
	
				<xsl:for-each select="sml:IdentifierList/sml:identifier[@name='siteFullName']">
					<Field name="title" string="{normalize-space(string(.))}" store="true" index="true" token="true"/>
					<!-- not tokenized title for sorting -->
					<Field name="_title" string="{normalize-space(string(.))}" store="true" index="true" token="false"/>
				</xsl:for-each>

				<xsl:for-each select="sml:IdentifierList/sml:identifier[@name='siteShortName']">
					<Field name="altTitle" string="{normalize-space(string(.))}" store="true" index="true" token="true"/>
				</xsl:for-each>

			</xsl:for-each>

      <xsl:for-each select="sml:System/sml:validTime/gml:TimeInstant/gml:timePosition">
          <Field name="createDate" string="{string(.)}" store="true" index="true" token="false"/>
          <Field name="changeDate" string="{string(.)}" store="true" index="true" token="false"/>
          <Field name="tempExtentBegin" string="{string(.)}" store="false" index="true"/>
      </xsl:for-each>

			<!-- observed phenomenom -->
			<xsl:for-each select="sml:System/sml:inputs/sml:InputList/sml:input/swe:ObservableProperty">
				<Field name="observedPhenomenon" string="{string(../@name)}" store="true" index="true"/>
			</xsl:for-each>

			<!-- status -->
			<xsl:for-each select="sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']/swe:Text/swe:value">
				<Field name="siteStatus" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

      <!-- observed bbox -->
      <xsl:for-each select="sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope">
         <xsl:apply-templates select="." mode="latLonBbox"/>
      </xsl:for-each>

      <!-- site position -->
      <xsl:for-each select="sml:System/sml:position[@name='sitePosition']/swe:Position">
        <xsl:apply-templates select="." mode="latLonPosition"/>
      </xsl:for-each>


            <!-- organization name -->
			<xsl:for-each select="sml:System/sml:contact/sml:ResponsibleParty/sml:organizationName">
				<Field name="orgName" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>

      <!-- related dataset-uuid (parentUuid field in index) -->
      <xsl:for-each select="sml:System/sml:documentation/sml:DocumentList/sml:member[@name='relatedDataset-GeoNetworkUUID']">
        <Field name="parentUuid" string="{string(@xlink:href)}" store="true" index="true" token="false"/>
      </xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteType']/sml:Term/sml:value">
				<Field name="type" string="{string(.)}" store="true" index="true" token="false"/>
			</xsl:for-each>

      <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

      <xsl:for-each select="sml:System/sml:history/sml:EventList/sml:member/sml:Event/sml:classification/sml:ClassifierList/sml:classifier[@name='siteEventType']/sml:Term/sml:value">
        <Field name="siteEvent" string="{string(.)}" store="true" index="true" token="false"/>
      </xsl:for-each>

      <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
			<xsl:for-each select="sml:System/gml:description">
				<Field name="abstract" string="{string(.)}" store="true" index="true" token="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

			<xsl:for-each select="sml:System">
				<!-- ?? -->
				<xsl:apply-templates select="gml:location/gml:Point" mode="latLon"/>

				<xsl:for-each select="sml:validTime">
					<xsl:for-each select="gml:TimePeriod/gml:beginPosition">
						<Field name="tempExtentBegin" string="{string(.)}" store="true" index="true" token="false"/>
					</xsl:for-each>

					<xsl:for-each select="gml:TimePeriod/gml:endPosition">
						<Field name="tempExtentEnd" string="{string(.)}" store="true" index="true" token="false"/>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

			<xsl:for-each select="sml:System/sml:keywords/sml:KeywordList">
				<xsl:for-each select="sml:keyword">
					<Field name="keyword" string="{string(.)}" store="true" index="true" token="false"/>
				</xsl:for-each>

				<Field name="keywordType" string="'descriptive'" store="true" index="true" token="true"/>
			</xsl:for-each>
	
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
	
			<xsl:for-each select="sml:System/sml:contact/sml:ResponsibleParty/sml:organizationName">
				<Field name="orgName" string="{string(.)}" store="true" index="true" token="true"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
			<xsl:for-each select="sml:System/sml:classification/sml:ClassifierList/sml:classifier/sml:Term/sml:value">
				<Field name="topicCat" string="{string(.)}" store="true" index="true" token="false"/>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<!-- === Free text search === -->		

		<Field name="any" store="false" index="true" token="true">
			<xsl:attribute name="string">
				<xsl:apply-templates select="." mode="allText"/>
			</xsl:attribute>
		</Field>

	</xsl:template>

	<!-- ========================================================================================= -->
	<!-- latlon coordinates + 360, zero-padded, indexed, not stored, not tokenized -->
	
	<xsl:template match="*" mode="latLon">

		<xsl:variable name="long" select="substring-before(gml:coordinates,' ')"/>
		<xsl:variable name="rest" select="substring-after(gml:coordinates,' ')"/>
		<xsl:variable name="lat">
			<xsl:choose>
				<xsl:when test="contains($rest,' ')">
					<xsl:value-of select="substring-before($rest,' ')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rest"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<Field name="westBL" string="{$long + 360}" store="true" index="true" token="false"/>
		<Field name="southBL" string="{$lat + 360}" store="true" index="true" token="false"/>
		<Field name="eastBL" string="{$long + 360}" store="true" index="true" token="false"/>
		<Field name="northBL" string="{$lat + 360}" store="true" index="true" token="false"/>
	
	</xsl:template>


    <xsl:template match="*" mode="latLonPosition">
        <xsl:variable name="format" select="'##.00'"></xsl:variable>

        <xsl:variable name="long" select="swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value"/>
        <xsl:variable name="lat" select="swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value" />

        <Field name="westBL" string="{format-number($long, $format)}" store="true" index="true" token="false"/>
        <Field name="southBL" string="{format-number($lat, $format)}" store="true" index="true" token="false"/>
        <Field name="eastBL" string="{format-number($long, $format)}" store="true" index="true" token="false"/>
        <Field name="northBL" string="{format-number($lat, $format)}" store="true" index="true" token="false"/>

        <Field name="geoBox" string="{concat(swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value, '|',
                swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value, '|',
                swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value, '|',
                swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value
                )}" store="true" index="false"/>
    </xsl:template>


    <xsl:template match="*" mode="latLonBbox">
        <xsl:variable name="format" select="'##.00'"></xsl:variable>

        <xsl:variable name="xmin" select="swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value"/>
        <xsl:variable name="ymin" select="swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value"/>
        <xsl:variable name="xmax" select="swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value"/>
        <xsl:variable name="ymax" select="swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value"/>


        <Field name="westBL" string="{format-number($xmin, $format)}" store="true" index="true" token="false"/>
        <Field name="southBL" string="{format-number($ymin, $format)}" store="true" index="true" token="false"/>
        <Field name="eastBL" string="{format-number($xmax, $format)}" store="true" index="true" token="false"/>
        <Field name="northBL" string="{format-number($ymax, $format)}" store="true" index="true" token="false"/>

        <Field name="geoBox" string="{concat(swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value, '|',
                swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value, '|',
                swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value, '|',
                swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value
                )}" store="true" index="false"/>

    </xsl:template>

	<!-- ========================================================================================= -->
	<!--allText -->
	
	<xsl:template match="*" mode="allText">
		<xsl:for-each select="@*">
			<xsl:value-of select="concat(string(.),' ')"/>
		</xsl:for-each>

		<xsl:choose>
			<xsl:when test="*"><xsl:apply-templates select="*" mode="allText"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat(string(.),' ')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ========================================================================================= -->

</xsl:stylesheet>
