<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0">

	<xsl:template match="mcp:MD_Metadata">
		 <dateStamp><xsl:value-of select="mcp:revisionDate/*"/></dateStamp>
	</xsl:template>

</xsl:stylesheet>
