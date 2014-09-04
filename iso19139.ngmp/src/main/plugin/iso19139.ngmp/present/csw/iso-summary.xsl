<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:ows="http://www.opengis.net/ows"

                xmlns:dc ="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"

                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                
                xmlns:gml="http://www.opengis.net/gml"

                xmlns:ngmp="urn:int:nato:geometoc:geo:metadata:ngmp:1.0"
                xmlns:geonet="http://www.fao.org/geonetwork"

                exclude-result-prefixes="ngmp geonet dc dct gml ows">

    <xsl:output indent="yes" method="xml"/>

	<xsl:param name="displayInfo"/>
	
	<!-- =================================================================== -->

	<!--<xsl:template match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']">-->
	<xsl:template match="gmd:MD_Metadata">

		<xsl:variable name="info" select="geonet:info"/>

        <xsl:copy copy-namespaces="no">

            <!--<xsl:element name="gmd:MD_Metadata">-->
                <xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
                <xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
                <xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
                <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
                <xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
                <!--<xsl:namespace name="abc" select="'http://www.opengis.net/abc'"/>-->
                <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
                <xsl:copy-of select="@*[name()!='xsi:schemaLocation' and name()!='gco:isoType']"/>

                <xsl:attribute name="xsi:schemaLocation"> http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd  http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:attribute>
    <!--			<xsl:apply-templates select="child::*"/>-->

                <xsl:apply-templates select="gmd:fileIdentifier"/>
                <xsl:apply-templates select="gmd:language"/>
                <xsl:apply-templates select="gmd:characterSet"/>
                <xsl:apply-templates select="gmd:parentIdentifier"/>
                <xsl:apply-templates select="gmd:hierarchyLevel"/>
                <xsl:apply-templates select="gmd:hierarchyLevelName"/>
                <xsl:apply-templates select="gmd:dateStamp"/>
                <xsl:apply-templates select="gmd:metadataStandardName"/>
                <xsl:apply-templates select="gmd:metadataStandardVersion"/>
                <xsl:apply-templates select="gmd:referenceSystemInfo"/>
                <xsl:apply-templates select="gmd:identificationInfo"/>
                <xsl:apply-templates select="gmd:distributionInfo"/>
                <xsl:apply-templates select="gmd:dataQualityInfo"/>
            <!--</xsl:element>-->
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
			
		</xsl:copy>
	</xsl:template>

    <xsl:template match="ngmp:*" priority="100">
        <xsl:comment>
            <xsl:value-of select="name(.)"/>
        </xsl:comment>
    </xsl:template>
<!--

    <xsl:template match="ngmp:NGMP_Constraints" priority="100">
        <xsl:copy>
        <xsl:comment> NGMP Constraints
            <xsl:copy-of select="."/>
            <xsl:value-of select="name(.)"/>
            <xsl:copy />
        </xsl:comment>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ngmp:NGMP_NatoBodyCode" priority="100">
        <xsl:copy>
        <xsl:comment> ngmp NGMP_NatoBodyCode
            <xsl:copy-of select="."/>
            <xsl:value-of select="name(.)"/>
            <xsl:copy />
        </xsl:comment>
        </xsl:copy>
    </xsl:template>-->

<!--    <xsl:template match="gml32:*" priority="100">
        <xsl:element namespace="gml" name="name(.)">
            <xsl:apply-templates select="@*|*"/>
        </xsl:element>
    </xsl:template>

-->


    <!-- ================================================================= -->
    <!-- Convert gml URI -->

    <xsl:template match="gml:*">
       <xsl:element name="{concat('gml:', local-name(.))}" namespace="http://www.opengis.net/gml/3.2">
          <xsl:apply-templates select="node()|@*"/>
       </xsl:element>
    </xsl:template>

    <xsl:template match="@gml:*">
       <xsl:attribute name="{concat('gml:', local-name(.))}" namespace="http://www.opengis.net/gml/3.2">
          <xsl:value-of select="."/>
       </xsl:attribute>
    </xsl:template>

<!--
    <xsl:template match="*[namespace-uri()='http://www.opengis.net/gml/3.2']" priority="100">
        <xsl:element name="{local-name(.)}" namespace="http://www.opengis.net/gml">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*[namespace-uri()='http://www.opengis.net/gml/3.2']" priority="100">
        <xsl:attribute name="{local-name(.)}"><xsl:copy/></xsl:attribute>
    </xsl:template>
-->
    <xsl:template match="comment()" priority="100"/>
    
	<xsl:template match="@*|node()">
	<!--<xsl:template match="node()">-->
<!--        <xsl:comment>
            <xsl:value-of select="namespace-uri()"/>
        </xsl:comment>-->
		<!--<xsl:copy>-->
		 <xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
    </xsl:template>

<!--	<xsl:template match="@*">
		<xsl:copy/>
    </xsl:template>-->
    

	<!-- =================================================================== -->

	<xsl:template match="gmd:CI_Citation">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:title"/>
			<xsl:apply-templates select="gmd:date[gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='revision']"/>
			<xsl:apply-templates select="gmd:identifier"/>
			<xsl:apply-templates select="gmd:citedResponsibleParty"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="gmd:MD_Distribution">
		 <xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:distributionFormat"/>
			<xsl:apply-templates select="gmd:transferOptions"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="gmd:MD_DigitalTransferOptions">
		 <xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:onLine"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gmd:CI_OnlineResource">
        <xsl:copy copy-namespaces="no">
        	<xsl:apply-templates select="gmd:linkage"/>
        </xsl:copy>
    </xsl:template>
	
	<!-- =================================================================== -->

	<xsl:template match="gmd:MD_Format">
		 <xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:name"/>
			<xsl:apply-templates select="gmd:version"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="gmd:DQ_DataQuality">
        <xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:lineage"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="gmd:EX_Extent">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:geographicElement[child::gmd:EX_GeographicBoundingBox]"/>
			<xsl:apply-templates select="gmd:temporalElement"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="gmd:EX_GeographicBoundingBox">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:westBoundLongitude"/>
			<xsl:apply-templates select="gmd:southBoundLatitude"/>
			<xsl:apply-templates select="gmd:eastBoundLongitude"/>
			<xsl:apply-templates select="gmd:northBoundLatitude"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='originator'
		or gmd:role/gmd:CI_RoleCode/@codeListValue='author'
		or gmd:role/gmd:CI_RoleCode/@codeListValue='publisher']">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:organisationName"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gmd:MD_LegalConstraints">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:accessConstraints"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- =================================================================== -->
	
	<xsl:template match="gmd:MD_BrowseGraphic">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:fileName"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === Data === -->
	<!-- =================================================================== -->

	<xsl:template match="gmd:MD_DataIdentification
		|*[contains(@gco:isoType, 'MD_DataIdentification')]">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:citation"/>
			<xsl:apply-templates select="gmd:abstract"/>
			<xsl:apply-templates select="gmd:graphicOverview"/>
			<xsl:apply-templates select="gmd:pointOfContact"/>
			<xsl:apply-templates select="gmd:resourceConstraints"/>
			<xsl:apply-templates select="gmd:spatialRepresentationType"/>
			<xsl:apply-templates select="gmd:spatialResolution"/>
			<xsl:apply-templates select="gmd:language"/>
			<xsl:apply-templates select="gmd:characterSet"/>
			<xsl:apply-templates select="gmd:topicCategory"/>
			<xsl:apply-templates select="gmd:extent[child::gmd:EX_Extent
				[child::gmd:geographicElement]]"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === Services === -->
	<!-- =================================================================== -->

	<xsl:template match="srv:SV_ServiceIdentification|
		*[contains(@gco:isoType, 'SV_ServiceIdentification')]">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="gmd:citation"/>
			<xsl:apply-templates select="gmd:abstract"/>
			<xsl:apply-templates select="gmd:graphicOverview"/>
			<xsl:apply-templates select="gmd:pointOfContact"/>
			<xsl:apply-templates select="gmd:resourceConstraints"/>
			<xsl:apply-templates select="srv:serviceType"/>
			<xsl:apply-templates select="srv:serviceTypeVersion"/>
			<xsl:apply-templates select="srv:extent[child::gmd:EX_Extent
				[child::gmd:geographicElement]]"/>
			<xsl:apply-templates select="srv:couplingType"/>
			<xsl:apply-templates select="srv:containsOperations"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template match="srv:SV_OperationMetadata">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="srv:operationName"/>
			<xsl:apply-templates select="srv:DCP"/>
			<xsl:apply-templates select="srv:connectPoint"/>
		</xsl:copy>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === copy template === -->
	<!-- =================================================================== -->



	<!-- =================================================================== -->

    <!-- Replace STANAG metadata name -->

	<xsl:template match="gmd:metadataStandardName">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="gmd:metadataStandardVersion">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>1.0</gco:CharacterString>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>



