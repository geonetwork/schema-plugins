<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28" 
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
  exclude-result-prefixes="mds mcc">
	
	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		<xsl:apply-templates select="*[name() != 'env']"/>
	</xsl:template>
	
	<!-- ================================================================= -->
	
	<xsl:template match="mds:MD_Metadata|*[@gco:isoType='mds:MD_Metadata']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<mds:metadataIdentifier>
        <mcc:MD_Identifier>
          <!-- citation could be for this GeoNetwork node ?
          <mcc:citation><cit:CI_Citation>etc</cit:CI_Citation></mcc:citation>
          -->
          <mcc:codeSpace>
				    <gco:CharacterString>urn:uuid</gco:CharacterString>
          </mcc:codeSpace>
          <mcc:code>
				    <gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
          </mcc:code>
          <mcc:description>
				    <gco:CharacterString>uuid primary key used by GeoNetwork</gco:CharacterString>
          </mcc:description>
        </mcc:MD_Identifier>
			</mds:metadataIdentifier>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- ================================================================= -->
	
	<xsl:template match="mds:metadataIdentifier"/>
	
	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- ================================================================= -->
	
</xsl:stylesheet>
