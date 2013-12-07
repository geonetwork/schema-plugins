<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28">

	<xsl:template match="mds:MD_Metadata">
		 <dateStamp><xsl:value-of select="mds:dateInfo/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/cit:date/*"/></dateStamp>
	</xsl:template>

</xsl:stylesheet>
