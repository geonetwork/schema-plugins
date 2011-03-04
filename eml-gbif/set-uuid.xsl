<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
								xmlns:dc="http://purl.org/dc/terms/" 
								xmlns:eml="eml://ecoinformatics.org/eml-2.1.1">	

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="eml:eml"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="dataset">
		 <xsl:copy>
		 		<xsl:copy-of select="@*"/>
	 			<alternateIdentifier>
					<xsl:value-of select="/root/env/uuid"/>
				</alternateIdentifier>
			  <xsl:apply-templates select="node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="alternateIdentifier"/>
	
	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

</xsl:stylesheet>
