<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
						xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
						xmlns:ows="http://www.opengis.net/ows"
						xmlns:geonet="http://www.fao.org/geonetwork"
						xmlns:dc ="http://purl.org/dc/elements/1.1/">

	<xsl:param name="displayInfo"/>
	<xsl:param name="lang"/>

	<!-- ================================================================== -->

	<xsl:template match="anzmeta">

		<xsl:variable name="info" select="geonet:info"/>

		<!-- TODO: This xslt needs to have additional fields mapped into it -->

		<csw:Record>
			<dc:identifier><xsl:value-of select="citeinfo/uniqueid"/></dc:identifier>
			<dc:title><xsl:value-of select="citeinfo/title"/></dc:title>
			<dc:date><xsl:value-of select="metainfo/metd/date"/></dc:date>
			<ows:BoundingBox crs="epsg::4326">
				<ows:LowerCorner>
					<xsl:value-of select="concat(descript/spdom/bounding/eastbc, ' ', descript/spdom/bounding/southbc)"/>
				</ows:LowerCorner>
				<ows:UpperCorner>
					<xsl:value-of select="concat(descript/spdom/bounding/westbc, ' ', descript/spdom/bounding/northbc)"/>
				</ows:UpperCorner>
			</ows:BoundingBox>

			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</csw:Record>
	</xsl:template>
</xsl:stylesheet>
