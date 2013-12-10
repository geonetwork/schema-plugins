<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
	xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="#all">

	<xsl:import href="../../iso19139/present/metadata-iso19139-fop.xsl"/>
	
	<xsl:include href="metadata-edit-sdn.xsl"/>

	<xsl:template name="iso19139.sdn-csrBrief">
		<metadata>
			<xsl:choose>
				<xsl:when test="geonet:info/isTemplate='s'">
					<xsl:call-template name="iso19139-subtemplate"/>
					<xsl:copy-of select="geonet:info" copy-namespaces="no"/>
				</xsl:when>
				<xsl:otherwise>

					<!-- call iso19139 brief -->
					<xsl:call-template name="iso19139-brief"/>
				</xsl:otherwise>
			</xsl:choose>
		</metadata>
	</xsl:template>



	<!-- Tab configuration -->
	<xsl:template name="iso19139.sdn-csrCompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

		<xsl:message>##sdn csr</xsl:message>
		<!-- INSPIRE tab -->
		<xsl:if
			test="/root/gui/env/inspire/enable = 'true' and /root/gui/env/metadata/enableInspireView = 'true'">
			<xsl:call-template name="mainTab">
				<xsl:with-param name="title" select="/root/gui/strings/inspireTab"/>
				<xsl:with-param name="default">inspire</xsl:with-param>
				<xsl:with-param name="menu">
					<item label="inspireTab">inspire</item>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
			<xsl:call-template name="mainTab">
				<xsl:with-param name="title" select="/root/gui/strings/byGroup"/>
				<xsl:with-param name="default">ISOCore</xsl:with-param>
				<xsl:with-param name="menu">
					<item label="isoMinimum">ISOMinimum</item>
					<item label="isoCore">ISOCore</item>
					<item label="isoAll">ISOAll</item>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>



		<xsl:if test="/root/gui/config/metadata-tab/advanced">
			<xsl:call-template name="mainTab">
				<xsl:with-param name="title" select="/root/gui/strings/byPackage"/>
				<xsl:with-param name="default">identification</xsl:with-param>
				<xsl:with-param name="menu">
					<item label="metadata">metadata</item>
					<item label="identificationTab">identification</item>
					<item label="maintenanceTab">maintenance</item>
					<item label="constraintsTab">constraints</item>
					<item label="spatialTab">spatial</item>
					<item label="refSysTab">refSys</item>
					<item label="distributionTab">distribution</item>
					<item label="dataQualityTab">dataQuality</item>
					<item label="acquisitionInformation">acquisitionInformation</item>
					<item label="appSchInfoTab">appSchInfo</item>
					<item label="porCatInfoTab">porCatInfo</item>
					<item label="contentInfoTab">contentInfo</item>
					<item label="extensionInfoTab">extensionInfo</item>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="metadata-iso19139.sdn-csr">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>

		<xsl:apply-templates mode="iso19139" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded"/>
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template name="iso19139.sdn-csr-javascript"/>
</xsl:stylesheet>
