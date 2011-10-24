<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:grg="http://www.isotc211.org/2005/grg"
						xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<xsl:template match="grg:RE_Register">
		 <uuid><xsl:value-of select="@uuid"/></uuid>
	</xsl:template>

</xsl:stylesheet>
