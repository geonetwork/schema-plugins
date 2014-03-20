<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmi="http://sdi.eurac.edu/metadata/iso19139-2/schema/gmi"
	xmlns:gmd="http://www.isotc211.org/2005/gmd">
	<xsl:template match="gmi:MI_Metadata">
		<uuid>
			<xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
		</uuid>
	</xsl:template>
</xsl:stylesheet>
