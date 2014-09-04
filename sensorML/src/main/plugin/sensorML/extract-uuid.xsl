<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<xsl:template match="sml:SensorML">
		 <uuid><xsl:value-of select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID']/sml:Term/sml:value"/></uuid>
	</xsl:template>

</xsl:stylesheet>
