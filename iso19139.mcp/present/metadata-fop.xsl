<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- Redirect to iso19139 default layout first then MCP specific stuff -->
  <xsl:template name="metadata-fop-iso19139.mcp">
    <xsl:param name="schema"/>

    <xsl:call-template name="metadata-fop-iso19139">
      <xsl:with-param name="schema" select="'iso19139'"/>
    </xsl:call-template>

		<!-- geo BBox for MCP -->
		
    <xsl:variable name="geoBbox">
      <xsl:apply-templates mode="elementFop"
        select="./gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox |
              ./gmd:identificationInfo/*/srv:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="timeExtent">
      <xsl:apply-templates mode="elementFop"
        select="./gmd:identificationInfo/*/gmd:extent/*/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="taxonExtent">
      <xsl:apply-templates mode="elementFop"
        select="./gmd:identificationInfo/*/gmd:extent/*/mcp:taxonomicElement/mcp:EX_TaxonomicCoverage/mcp:presentationLink">
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="extent">
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$geoBbox"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/iso19139/labels/element[@name='gmd:EX_GeographicBoundingBox']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$timeExtent"/>
        <xsl:with-param name="label">
          <xsl:value-of
            select="/root/gui/schemas/iso19139/labels/element[@name='gmd:temporalElement']/label"
          />
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="blockElementFop">
        <xsl:with-param name="block" select="$taxonExtent"/>
        <xsl:with-param name="label">
          <xsl:value-of select="'Species Extent'"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

		<xsl:variable name="extent">
    	<xsl:call-template name="blockElementFop">
      	<xsl:with-param name="block" select="$extent"/>
      	<xsl:with-param name="label">
        	<xsl:value-of
          	select="/root/gui/schemas/iso19139/labels/element[@name='gmd:EX_Extent']/label"/>
      	</xsl:with-param>
    	</xsl:call-template>
    </xsl:variable>

    <xsl:variable name="cc">
			<xsl:for-each select="./gmd:identificationInfo/*/gmd:resourceConstraints/mcp:MD_Commons[@mcp:commonsType='Creative Commons']">
      	<xsl:apply-templates mode="elementFop"
        	select="mcp:jurisdictionLink/gmd:URL">
        	<xsl:with-param name="schema" select="$schema"/>
      	</xsl:apply-templates>
      	<xsl:apply-templates mode="elementFop"
        	select="mcp:licenseLink/gmd:URL">
        	<xsl:with-param name="schema" select="$schema"/>
      	</xsl:apply-templates>
      	<xsl:apply-templates mode="elementFop"
        	select="mcp:imageLink/gmd:URL">
        	<xsl:with-param name="schema" select="$schema"/>
      	</xsl:apply-templates>
      	<xsl:apply-templates mode="elementFop"
        	select="mcp:licenseName/gco:CharacterString">
        	<xsl:with-param name="schema" select="$schema"/>
      	</xsl:apply-templates>
			</xsl:for-each>
    </xsl:variable>

		<xsl:variable name="creativecommons">
    	<xsl:call-template name="blockElementFop">
      	<xsl:with-param name="block" select="$cc"/>
      	<xsl:with-param name="label">
        	<xsl:value-of
          	select="'Creative Commons'"/>
      	</xsl:with-param>
    	</xsl:call-template>
    </xsl:variable>

		<!-- MCP data -->

    <xsl:call-template name="blockElementFop">
     	<xsl:with-param name="block">	

				<!-- MCP revision data -->

				<xsl:apply-templates mode="elementFop" select="./mcp:revisionDate">
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>

				<!-- MCP creative commons -->

				<xsl:copy-of select="$creativecommons"/>

				<!-- MCP extent -->

				<xsl:copy-of select="$extent"/>
				
			</xsl:with-param>
     	<xsl:with-param name="label">
       	<xsl:value-of select="'MCP Specific Information'"/>
     	</xsl:with-param>
    </xsl:call-template>

  </xsl:template>
  
</xsl:stylesheet>
