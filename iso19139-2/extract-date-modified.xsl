<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmi="http://sdi.eurac.edu/metadata/iso19139-2/schema/gmi">
	<xsl:template match="gmi:MI_Metadata">
		<dateStamp>
			<xsl:value-of select="gmi:revisionDate/*" />
		</dateStamp>
	</xsl:template>
</xsl:stylesheet>
