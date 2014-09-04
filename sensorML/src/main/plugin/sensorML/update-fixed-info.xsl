<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
	xmlns:swe="http://www.opengis.net/swe/1.0.1"
	>

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="sml:SensorML"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="sml:date">
		<xsl:choose>
			<xsl:when test="string(.)" >
				<xsl:copy-of select="." />
			</xsl:when>

			<xsl:otherwise>
				<!--<sml:date>unknown</sml:date>-->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="sml:member/sml:System">
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

	<xsl:template match="sml:member/sml:System/sml:identification/sml:IdentifierList">
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
	
	<xsl:template match="sml:identifier[@name='GeoNetwork-UUID']">
		<sml:identifier name="GeoNetwork-UUID">
			<sml:Term>
			<sml:value><xsl:value-of select="/root/env/uuid"/></sml:value>
			</sml:Term>
		</sml:identifier>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="swe:Vector">
   	<xsl:variable name="coordsWithValue" select="count(swe:coordinate/swe:Quantity/swe:value[text()])" />

   	<xsl:if test="$coordsWithValue > 0">
			<xsl:copy>
     		<xsl:apply-templates select="@*|node()"/>
     	</xsl:copy>
   	</xsl:if>
  </xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="swe:coordinate">
		<xsl:variable name="coordinateEmpty" select="not(string(swe:Quantity/swe:value))" />

		<xsl:if test="not($coordinateEmpty)">
	        <xsl:copy>
	        	<xsl:apply-templates select="@*|node()"/>
	        </xsl:copy>
	    </xsl:if>
	</xsl:template>

	<!-- ================================================================= -->

</xsl:stylesheet>
