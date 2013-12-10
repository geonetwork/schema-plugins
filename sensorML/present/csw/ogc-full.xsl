<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:swe="http://www.opengis.net/swe/1.0.1"
										xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:ows="http://www.opengis.net/ows">

	<xsl:param name="displayInfo"/>
	
	<!-- ============================================================================= -->

	<xsl:template match="sml:SensorML">
		<xsl:variable name="info" select="geonet:info"/>
		<csw:Record>

			<!-- Identifier -->
			<xsl:for-each select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name='siteID']/sml:Term">
				<dc:identifier><xsl:value-of select="sml:value"/></dc:identifier>
			</xsl:for-each>

			<!-- Titles -->
			<xsl:for-each select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteFullName' or @name='siteShortName']/sml:Term">
		    <dc:title><xsl:value-of select="sml:value"/></dc:title>
      </xsl:for-each>

			<!-- Keywords -->
			<xsl:for-each select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword">
		    <dc:subject><xsl:value-of select="."/></dc:subject>
      </xsl:for-each>

			<xsl:for-each select="sml:member/sml:System/sml:validTime/gml:TimePeriod">
				<dct:valid>
					<xsl:choose>
						<xsl:when test="gml:beginPosition/@indeterminatePosition">
							<xsl:value-of select="gml:beginPosition/@indeterminatePosition"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gml:beginPosition"/>
						</xsl:otherwise>
					</xsl:choose>
				</dct:valid>
				<dct:valid>
					<xsl:choose>
						<xsl:when test="gml:endPosition/@indeterminatePosition">
							<xsl:value-of select="gml:endPosition/@indeterminatePosition"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gml:endPosition"/>
						</xsl:otherwise>
					</xsl:choose>
				</dct:valid>
			</xsl:for-each>

			<!--<xsl:for-each select="sml:member/sml:System/sml:contact[@xlink:role='urn:x-ogc:def:classifiers:OGC:contactType:operator']">
				<dc:creator><xsl:value-of select="."/></dc:creator>
			</xsl:for-each>

			<xsl:for-each select="sml:member/sml:System/sml:contact[@xlink:role='urn:x-ogc:def:classifiers:OGC:contactType:owner']">
				<dc:publisher><xsl:value-of select="."/></dc:publisher>
			</xsl:for-each>-->

			<!-- Keywords -->
			<xsl:for-each select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword">
		    <dc:subject><xsl:value-of select="."/></dc:subject>
      </xsl:for-each>

			<!-- Abstract -->
			<xsl:for-each select="sml:member/sml:System/gml:description">
      	<dct:abstract><xsl:value-of select="."/></dct:abstract>
      </xsl:for-each>

			<!-- bounding box -->
			<!--<xsl:for-each select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope">
				<ows:BoundingBox crs="gml:Point/@srsName">
					<ows:LowerCorner>
						<xsl:value-of select="swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value"/> <xsl:value-of select="swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value"/>
					</ows:LowerCorner>
	
					<ows:UpperCorner>
						<xsl:value-of select="swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value"/> <xsl:value-of select="swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value"/>
					</ows:UpperCorner>
				</ows:BoundingBox>
			</xsl:for-each>-->

			<!-- Type - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteType']/sml:Term">
      	<dc:type><xsl:value-of select="sml:value"/></dc:type>
      </xsl:for-each>

			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</csw:Record>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
