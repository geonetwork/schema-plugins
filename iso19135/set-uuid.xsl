<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:grg="http://www.isotc211.org/2005/grg"
						xmlns:gmd="http://www.isotc211.org/2005/gmd" 
						exclude-result-prefixes="grg">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="grg:RE_Register"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="gmd:MD_Metadata">
		 <xsl:copy>
		 		<xsl:copy-of select="@*[name()!='uuid']"/>
				<xsl:attribute name="uuid">
					<xsl:value-of select="/root/env/uuid"/>
				</xsl:attribute>
			  <xsl:apply-templates select="node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

</xsl:stylesheet>
