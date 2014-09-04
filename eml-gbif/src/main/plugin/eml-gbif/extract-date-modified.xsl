<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
								xmlns:dc="http://purl.org/dc/terms/" 
								xmlns:eml="eml://ecoinformatics.org/eml-2.1.1">	

	<xsl:template match="eml:eml">
		 <dateStamp><xsl:value-of select="additionalMetadata/metadata/gbif/dateStamp"/></dateStamp>
	</xsl:template>

</xsl:stylesheet>
