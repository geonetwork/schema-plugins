<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:grg="http://www.isotc211.org/2005/grg"
						xmlns:gnreg="http://geonetwork-opensource.org/register"
						xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<xsl:template match="gnreg:RE_RegisterItem|grg:RE_RegisterItem">
		<title><xsl:value-of select="grg:name/gco:CharacterString"/></title>
	</xsl:template>

</xsl:stylesheet>
