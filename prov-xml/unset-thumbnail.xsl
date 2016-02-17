<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
								xmlns:prov="http://www.w3.org/ns/prov#">

	<!-- No thumbnail to unset -->

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="prov:document"/>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>
	
	<!-- ================================================================= -->
	
</xsl:stylesheet>
