<?xml version="1.0" encoding="UTF-8"?>
<!-- FIXME: Which MD_Identifier do we select under mds:metadataIdentifier
            probably should use some form of match on a particular codeSpace?
            -->
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
            xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
						xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28">

	<xsl:template match="mds:MD_Metadata">
		 <uuid><xsl:value-of select="mds:metadataIdentifier/mcc:MD_Identifier[mcc:codeSpace/gco:CharacterString='urn:uuid']/mcc:code/gco:CharacterString"/></uuid>
	</xsl:template>

</xsl:stylesheet>
