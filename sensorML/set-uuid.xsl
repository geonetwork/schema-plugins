<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"   
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
        <xsl:apply-templates select="sml:SensorML"/>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="sml:System">
		 <xsl:copy>
			<xsl:variable name="att" select="sml:identification"/>
			<xsl:if test="not($att)">
				<sml:identification>
					<sml:IdentifierList>
						<sml:identifier name="GeoNetwork-UUID">
							<sml:Term>
								<sml:value><xsl:value-of select="/root/env/uuid"/></sml:value>
							</sml:Term>
						</sml:identifier>
					</sml:IdentifierList>
				</sml:identification>
			</xsl:if>
			<xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>
	
	<!-- ================================================================= -->

	<xsl:template match="sml:IdentifierList">
		<xsl:copy>
			<xsl:variable name="att" select="sml:identifier[@name='GeoNetwork-UUID']"/>
			<xsl:if test="not($att)">
				<sml:identifier name="GeoNetwork-UUID">
					<sml:Term>
				  	<sml:value><xsl:value-of select="/root/env/uuid"/></sml:value>
					</sml:Term>
				</sml:identifier>
			</xsl:if>
			<xsl:apply-templates select="@*|node()"/>
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
