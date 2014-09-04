<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
        <xsl:apply-templates select="sml:SensorML"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>
	
	<!-- ================================================================= -->

    <xsl:template match="sml:member[@name='thumbnail' and sml:Document/gml:description = /root/env/type]"/>

    <xsl:template match="geonet:info" priority="2"/>
</xsl:stylesheet>
