<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:grg="http://www.isotc211.org/2005/grg"
						xmlns:gmd="http://www.isotc211.org/2005/gmd">

	<!-- ============================================================================================ -->

	<xsl:output indent="yes"/>
	
	<!-- ============================================================================================ -->
	
	<xsl:template match="grg:RE_Register">
		<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
						xmlns:dc   ="http://purl.org/dc/elements/1.1/"
						xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
						xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

			<dc:identifier><xsl:value-of select="@uuid"/></dc:identifier>

			<dc:date><xsl:value-of select="/root/env/changeDate"/></dc:date>
			
			<dc:title><xsl:value-of select="grg:name/gco:CharacterString"/></dc:title>

			<xsl:for-each select="grg:owner/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
				<dc:creator><xsl:value-of select="."/></dc:creator>
			</xsl:for-each>

			<xsl:for-each select="grg:manager/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
				<dc:publisher><xsl:value-of select="."/></dc:publisher>
			</xsl:for-each>

			<xsl:for-each select="grg:submitter/*/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
					<dc:contributor><xsl:value-of select="."/></dc:contributor>
			</xsl:for-each>

			<!-- subject -->

			<xsl:for-each select="grg:containedItem/*/grg:name/gco:CharacterString">
					<dc:subject><xsl:value-of select="."/></dc:subject>
			</xsl:for-each>

			<!-- description -->

			<xsl:for-each select="grg:contentSummary/gco:CharacterString">
				<dc:description><xsl:value-of select="."/></dc:description>
			</xsl:for-each>

			<!-- language -->

			<xsl:for-each select="grg:operatingLanguage/*/grg:language/gco:CharacterString">
				<dc:language><xsl:value-of select="."/></dc:language>
			</xsl:for-each>

			<xsl:for-each select="grg:alternativeLanguages/*/grg:language/gco:CharacterString">
				<dc:language><xsl:value-of select="."/></dc:language>
			</xsl:for-each>

			<dc:type>Register</dc:type>

		</oai_dc:dc>
	</xsl:template>

	<!-- ============================================================================================ -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<!-- ============================================================================================ -->

</xsl:stylesheet>
