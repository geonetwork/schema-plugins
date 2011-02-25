<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="anzmeta">
		 <uuid><xsl:value-of select="citeinfo/uniqueid"/></uuid>
	</xsl:template>

</xsl:stylesheet>
