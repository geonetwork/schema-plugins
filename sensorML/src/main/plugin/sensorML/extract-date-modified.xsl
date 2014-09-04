<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<xsl:template match="sml:SensorML">
		 <dateStamp><xsl:value-of select="sml:validTime/gml:TimeInstant/gml:timePosition/*"/></dateStamp>
	</xsl:template>

</xsl:stylesheet>
