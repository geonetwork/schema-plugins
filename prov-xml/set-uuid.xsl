<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
								  xmlns:prov="http://www.w3.org/ns/prov#"
									xmlns:dc="http://purl.org/dc/elements/1.1/"
									xmlns:dct="http://purl.org/dc/terms/">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		<xsl:apply-templates select="prov:document"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="dc:identifier[name(..)='prov:other']">
		 <xsl:copy>
				<xsl:value-of select="/root/env/uuid"/>
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
