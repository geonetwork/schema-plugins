<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmi="http://sdi.eurac.edu/metadata/iso19139-2/schema/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">

	<xsl:import href="metadata-iso19139-2-fop.xsl" />

	<!-- Brief template -->
	<xsl:template name="iso19139-2Brief">
		<metadata>
			<xsl:choose>
				<xsl:when test="geonet:info/isTemplate='s'">
					<xsl:apply-templates mode="iso19139-subtemplate" select="." />
					<xsl:copy-of select="geonet:info" copy-namespaces="no" />
				</xsl:when>
				<xsl:otherwise>

					<!-- call iso19139-brief located in iso19139 -->
					<xsl:call-template name="iso19139-brief" />
				</xsl:otherwise>
			</xsl:choose>
		</metadata>
	</xsl:template>

	<!-- RT#53364 InM begin -->
	<!-- Enables in the left tab to show acquisition information -->
	<xsl:template name="iso19139-2CompleteTab">
		<xsl:param name="tabLink" />
		<xsl:param name="schema" />

		<!-- INSPIRE tab -->
		<xsl:if test="/root/gui/env/inspire/enable = 'true' and /root/gui/env/metadata/enableInspireView = 'true'">
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'inspire'" />
				<xsl:with-param name="text" select="/root/gui/strings/inspireTab" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>
		</xsl:if>

		<!-- To define profil specific tabs for schema iso19139-2 -->
		<xsl:apply-templates mode="extraTab" select="/">
			<xsl:with-param name="tabLink" select="$tabLink" />
			<xsl:with-param name="schema" select="$schema" />
		</xsl:apply-templates>

		<xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'groups'" /> <!-- just a non-existing tab -->
				<xsl:with-param name="text" select="/root/gui/strings/byGroup" />
				<xsl:with-param name="tabLink" select="''" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'ISOMinimum'" />
				<xsl:with-param name="text" select="/root/gui/strings/isoMinimum" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'ISOCore'" />
				<xsl:with-param name="text" select="/root/gui/strings/isoCore" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'ISOAll'" />
				<xsl:with-param name="text" select="/root/gui/strings/isoAll" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="/root/gui/config/metadata-tab/advanced">
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'packages'" /> <!-- just a non-existing tab -->
				<xsl:with-param name="text" select="/root/gui/strings/byPackage" />
				<xsl:with-param name="tabLink" select="''" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'metadata'" />
				<xsl:with-param name="text" select="/root/gui/strings/metadata" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'identification'" />
				<xsl:with-param name="text" select="/root/gui/strings/identificationTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'maintenance'" />
				<xsl:with-param name="text" select="/root/gui/strings/maintenanceTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'constraints'" />
				<xsl:with-param name="text" select="/root/gui/strings/constraintsTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'spatial'" />
				<xsl:with-param name="text" select="/root/gui/strings/spatialTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'refSys'" />
				<xsl:with-param name="text" select="/root/gui/strings/refSysTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'distribution'" />
				<xsl:with-param name="text" select="/root/gui/strings/distributionTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'dataQuality'" />
				<xsl:with-param name="text" select="/root/gui/strings/dataQualityTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'appSchInfo'" />
				<xsl:with-param name="text" select="/root/gui/strings/appSchInfoTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'porCatInfo'" />
				<xsl:with-param name="text" select="/root/gui/strings/porCatInfoTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'contentInfo'" />
				<xsl:with-param name="text" select="/root/gui/strings/contentInfoTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<!-- RT#53364: new tab for acquisition information -->
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'acquisitionInfo'" />
				<xsl:with-param name="text" select="/root/gui/strings/acquisitionInfoTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab" select="'extensionInfo'" />
				<xsl:with-param name="text" select="/root/gui/strings/extensionInfoTab" />
				<xsl:with-param name="indent" select="'&#xA0;&#xA0;&#xA0;'" />
				<xsl:with-param name="tabLink" select="$tabLink" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- RT#53364 InM end -->

	<!-- main template - the way into processing iso19139-2 -->
	<xsl:template name="metadata-iso19139-2">
		<xsl:param name="schema" />
		<xsl:param name="edit" select="false()" />
		<xsl:param name="embedded" />

		<!-- Debug start <xsl:message> Template metadata-iso19139-2 (.xsl)</xsl:message> Debug end <xsl:message><xsl:value-of select="."/></xsl:message> -->
		<!-- apply iso19139 located in iso19139 -->
		<xsl:apply-templates mode="iso19139" select=".">
			<xsl:with-param name="schema" select="$schema" />
			<xsl:with-param name="edit" select="$edit" />
			<xsl:with-param name="embedded" select="$embedded" />
		</xsl:apply-templates>
	</xsl:template>


	<!-- ===================================================================== -->
	<!-- these elements should be boxed -->

	<!-- ===================================================================== -->
	<xsl:template mode="iso19139-2" match="gmd:MD_LegalConstraints|gmd:SecurityConstraints">
		<xsl:param name="schema" />
		<xsl:param name="edit" />

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema" />
			<xsl:with-param name="edit" select="$edit" />
		</xsl:apply-templates>
	</xsl:template>

	<!-- Redirection template for profil gmi in order to process extraTabs. -->
	<xsl:template mode="iso19139" match="gmi:MI_Metadata|*[@gco:isoType='gmi:MI_Metadata']" priority="2">
		<xsl:param name="schema" />
		<xsl:param name="edit" />
		<xsl:param name="embedded" />

		<xsl:variable name="dataset"
			select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''" />

		<!-- thumbnail -->
		<tr>
			<td valign="middle" colspan="2">
				<xsl:if test="$currTab='metadata' or $currTab='identification' or /root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat">
					<div style="float:left;width:70%;text-align:center;">
						<xsl:variable name="md">
							<xsl:apply-templates mode="brief" select="." />
						</xsl:variable>
						<xsl:variable name="metadata" select="exslt:node-set($md)/*[1]" />
						<xsl:call-template name="thumbnail">
							<xsl:with-param name="metadata" select="$metadata" />
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:if test="/root/gui/config/editor-metadata-relation">
					<div style="float:right;">
						<xsl:call-template name="relatedResources">
							<xsl:with-param name="edit" select="$edit" />
						</xsl:call-template>
					</div>
				</xsl:if>
			</td>
		</tr>

		<xsl:choose>

			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19139Metadata">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:call-template>
			</xsl:when>

			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- embedded distribution tab -->
			<xsl:when test="$currTab='distribution2'">
				<xsl:apply-templates mode="elementEP"
					select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- appSchInfo tab -->
			<xsl:when test="$currTab='appSchInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- porCatInfo tab -->
			<xsl:when test="$currTab='porCatInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- contentInfo tab -->
			<xsl:when test="$currTab='contentInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- acquisitionInfo tab -->
			<xsl:when test="$currTab='acquisitionInfo'">
				<xsl:apply-templates mode="elementEP" select="gmi:acquisitionInfo|geonet:child[string(@name)='acquisitionInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- extensionInfo tab -->
			<xsl:when test="$currTab='extensionInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:apply-templates>
			</xsl:when>

			<!-- ISOMinimum tab -->			
			<xsl:when test="$currTab='ISOMinimum'">
				<xsl:call-template name="inspiretabs">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="dataset" select="$dataset" />
				</xsl:call-template>
			</xsl:when>

			<!-- ISOCore tab -->
			<xsl:when test="$currTab='ISOCore'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="dataset" select="$dataset" />
					<xsl:with-param name="core" select="true()" />
				</xsl:call-template>
			</xsl:when>

			<!-- ISOAll tab -->
			<xsl:when test="$currTab='ISOAll'">
				<xsl:call-template name="iso19139Complete">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
				</xsl:call-template>
			</xsl:when>

			<!-- INSPIRE tab -->
			<xsl:when test="$currTab='inspire'">
				<xsl:call-template name="inspiretabs">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="dataset" select="$dataset" />
				</xsl:call-template>
			</xsl:when>

			<!-- Represents the default view -->
			<xsl:otherwise>
				<xsl:call-template name="iso19139-2Simple">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="flat" select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- main template - the way into processing iso19139-2 -->
  <xsl:template name="iso19139-2Simple">
    <xsl:call-template name="iso19139Simple"/>
  </xsl:template>


<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT -->
	<!-- =================================================================== -->
	<xsl:template name="iso19139-2-javascript" />	



	<!-- =================================================================== -->
	<!-- === Displays EURAC extra elements -->
	<!-- =================================================================== <xsl:template name="displayGmieExtraElement"> <xsl:param name="schema"/> 
		<xsl:param name="edit"/> <xsl:apply-templates mode="elementEP" select="gmi:acquisitionInfo|geonet:child[string(@name)='acquisitionInfo']"> <xsl:with-param 
		name="schema" select="$schema"/> <xsl:with-param name="edit" select="$edit"/> </xsl:apply-templates> </xsl:template> -->

</xsl:stylesheet>