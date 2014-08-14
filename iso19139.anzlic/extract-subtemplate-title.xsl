<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<xsl:template match="gmd:CI_ResponsibleParty">
		 <title><xsl:value-of select="concat(gmd:positionName/gco:CharacterString,', ',gmd:individualName/gco:CharacterString,', ',gmd:organisationName/gco:CharacterString)"/></title>
	</xsl:template>

	<xsl:template match="*">
		<title></title>
	</xsl:template>

</xsl:stylesheet>
