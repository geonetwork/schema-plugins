<?xml version="1.0" encoding="UTF-8"?>
<!-- heikki: added geobru namespace declaration and exclude-result-prefix declaration -->
<xsl:stylesheet version="2.0" 
	xmlns:geobru="http://geobru.irisnet.be" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:gco="http://www.isotc211.org/2005/gco" 
	xmlns:gfc="http://www.isotc211.org/2005/gfc"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" 
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:gmi="http://www.isotc211.org/2005/gmi" 
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	exclude-result-prefixes="#all">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<!-- identity template -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
		<!-- <xsl:copy> -->
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	

	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:BXL_Address">
		<gmd:CI_Address>
				<xsl:apply-templates select="@*|node()"/>
		</gmd:CI_Address>
	</xsl:template>

	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:BXL_Lineage">
		<gmd:LI_Lineage>
				<xsl:apply-templates select="@*|node()"/>
		</gmd:LI_Lineage>
	</xsl:template>	
	
	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:BXL_Distribution">
		<gmd:MD_Distribution>
				<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_Distribution>
	</xsl:template>		
	
	<!-- heikki: added conversion for geobru extension elements -->
	<xsl:template match="geobru:*">
	</xsl:template>	

</xsl:stylesheet>
