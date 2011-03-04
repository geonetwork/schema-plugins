<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
								xmlns:dc="http://purl.org/dc/terms/" 
								xmlns:eml="eml://ecoinformatics.org/eml-2.1.1">	

	<!-- ================================================================= -->

	<xsl:template match="/root">
		<xsl:apply-templates select="eml:eml"/>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="eml:eml">
		<xsl:copy>
			<xsl:copy-of select="@*[name(.)!='xsi:schemaLocation']"/>
			<xsl:attribute name="xsi:schemaLocation">eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/dev/eml.xsd</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
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
	<!-- copy everything else as is -->
	
	<xsl:template match="@*|node()">
	    <xsl:copy>
	        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
	</xsl:template>

</xsl:stylesheet>
