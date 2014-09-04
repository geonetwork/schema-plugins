<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp">

	<xsl:template match="mcp:MD_Metadata">
		 <dateStamp><xsl:value-of select="mcp:revisionDate/*"/></dateStamp>
	</xsl:template>

</xsl:stylesheet>
