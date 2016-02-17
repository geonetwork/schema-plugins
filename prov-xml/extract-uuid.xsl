<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
								xmlns:prov="http://www.w3.org/ns/prov#"	
								xmlns:dc="http://purl.org/dc/elements/1.1/"
								xmlns:dct="http://purl.org/dc/terms/">

	<xsl:template match="/">
		 <uuid><xsl:value-of select="prov:other/dc:identifier"/></uuid>
	</xsl:template>

</xsl:stylesheet>
