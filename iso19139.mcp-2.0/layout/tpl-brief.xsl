<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"
	xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:include href="utility-tpl.xsl"/>

  <!-- ===================================================================== -->
  <!-- === iso19139.mcp-2.0 brief formatting === -->
  <!-- ===================================================================== -->
  <xsl:template name="iso19139.mcp-2.0Brief">
    <metadata>
      <xsl:call-template name="iso19139-brief"/>
			<xsl:call-template name="iso19139.mcp-2.0-brief"/>
    </metadata>
  </xsl:template>

<!-- mcp extensions in MD_Metadata need to be added to brief template -->

	<xsl:template name="iso19139.mcp-2.0-brief">

		<revisiondate>
			<xsl:value-of select="mcp:revisionDate"/>
		</revisiondate>

		<xsl:for-each select="gmd:identificationInfo/mcp:MD_DataIdentification">
			<xsl:for-each select=".//mcp:MD_Commons[@mcp:commonsType='Creative Commons']">
				<creativecommons>
					<xsl:for-each select="*">
						<xsl:element name="{local-name(.)}">
							<xsl:value-of select="*/text()|*/@codeListValue"/>
						</xsl:element>
					</xsl:for-each>
				</creativecommons>
			</xsl:for-each>

			<xsl:for-each select=".//mcp:MD_Commons[@mcp:commonsType='Data Commons']">
				<datacommons>
					<xsl:for-each select="*">
						<xsl:element name="{local-name(.)}">
							<xsl:value-of select="*/text()|*/@codeListValue"/>
						</xsl:element>
					</xsl:for-each>
				</datacommons>
			</xsl:for-each>

			<xsl:choose>

				<!-- 1. role=moralRightsOwner -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='moralRightsOwner']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='moralRightsOwner']">
						<moralrightsowner>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</moralrightsowner>
					</xsl:for-each>
				</xsl:when>

				<!-- 2. role=ipOwner -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='ipOwner']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='ipOwner']">
						<ipOwner>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</ipOwner>
					</xsl:for-each>
				</xsl:when>

				<!-- 3. role=owner -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='owner']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='licensor']">
						<owner>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</owner>
					</xsl:for-each>
				</xsl:when>

				<!-- 4. role=principalInvestigator -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='principalInvestigator']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='principalInvestigator']">
						<principalInvestigator>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</principalInvestigator>
					</xsl:for-each>
				</xsl:when>

				<!-- 5. role=licensor -->
				<xsl:when test="gmd:pointOfContact/*[gmd:role/*/@codeListValue='licensor']">
					<xsl:for-each select="gmd:pointOfContact/*[gmd:role/*/@codeListValue='licensor']">
						<licensor>
							<xsl:apply-templates mode="responsiblepartyprocessor" select="."/>
						</licensor>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>

			<xsl:for-each select="gmd:extent/*/gmd:temporalElement/mcp:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
				<temporalExtent>
					<begin><xsl:apply-templates mode="brieftime" select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/></begin>
					<end><xsl:apply-templates mode="brieftime" select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/></end>
				</temporalExtent>
			</xsl:for-each>

			<xsl:for-each select="gmd:extent/mcp:EX_Extent/mcp:taxonomicElement/mcp:EX_TaxonomicCoverage/mcp:presentationLink">
				<taxonomicCoverage>	
					<link><xsl:value-of select="string(.)"/></link>
				</taxonomicCoverage>
			</xsl:for-each>
		</xsl:for-each>

  </xsl:template>

	<!-- helper to create a simplified view of a CI_ResponsibleParty|
       CI_Responsibility block -->

  <xsl:template mode="responsiblepartyprocessor" match="*">
    <xsl:choose>
      <xsl:when test="*">
        <xsl:apply-templates mode="responsiblepartyprocessor"/>
      </xsl:when>
      <xsl:when test="text()!=''">
        <xsl:element name="{local-name(..)}">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
