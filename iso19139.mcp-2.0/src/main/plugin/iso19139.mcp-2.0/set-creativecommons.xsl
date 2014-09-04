<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
						xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="mcp:MD_Metadata"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="mcp:MD_Commons[@mcp:commonsType='Creative Commons' and normalize-space(mcp:licenseLink)='']">
		<xsl:variable name="type" select="/root/env/type"/>
		<xsl:variable name="up" select="name(..)"/>
		<xsl:choose>
			<xsl:when test="$type='data' and $up='gmd:resourceConstraints'">
				<xsl:call-template name="fill"/>
			</xsl:when>
			<xsl:when test="$type='metadata' and $up='gmd:metadataConstraints'">
				<xsl:call-template name="fill"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template name="fill">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="gmd:useLimitation"/>
			<mcp:jurisdictionLink>
				<gmd:URL><xsl:value-of select="/root/env/jurisdiction"/></gmd:URL>
			</mcp:jurisdictionLink>
			<mcp:licenseLink>
				<gmd:URL><xsl:value-of select="/root/env/licenseurl"/></gmd:URL>
			</mcp:licenseLink>
			<mcp:imageLink>
				<gmd:URL><xsl:value-of select="/root/env/imageurl"/></gmd:URL>
			</mcp:imageLink>
			<mcp:licenseName>
				<gco:CharacterString><xsl:value-of select="/root/env/licensename"/></gco:CharacterString>
			</mcp:licenseName>
			<xsl:apply-templates select="mcp:attributionConstraints"/>
			<xsl:apply-templates select="mcp:otherConstraints"/>
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
