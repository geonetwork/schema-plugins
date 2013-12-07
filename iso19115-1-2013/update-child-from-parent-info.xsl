<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:gml="http://www.opengis.net/gml/3.2" 
    xmlns:gco="http://www.isotc211.org/2005/gco" 
    xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
    xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
    xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
    xmlns:geonet="http://www.fao.org/geonetwork" exclude-result-prefixes="gmd srv gco mds mri gml">


    <!-- Parameters -->
    <xsl:param name="updateMode" select="'replace'"/>
    
    <xsl:param name="gmd-contact"/>
    <xsl:param name="gmd-spatialRepresentationInfo"/>
    <xsl:param name="gmd-referenceSystemInfo"/>
    <xsl:param name="gmd-metadataExtensionInfo"/>
    <xsl:param name="gmd-pointOfContact"/>
    <xsl:param name="gmd-descriptiveKeywords"/>
    <xsl:param name="gmd-extent"/>
    <xsl:param name="gmd-contentInfo"/>
    <xsl:param name="gmd-distributionInfo"/>
    <xsl:param name="gmd-dataQualityInfo"/>
    <xsl:param name="gmd-portrayalCatalogueInfo"/>
    <xsl:param name="gmd-metadataConstraints"/>
    <xsl:param name="gmd-applicationSchemaInfo"/>
    <xsl:param name="gmd-metadataMaintenance"/>
    
    <!-- ================================================================= -->

    <xsl:template match="/">
        <xsl:apply-templates select="/root/update/parent/mds:MD_Metadata"/>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="/root/update/parent/mds:MD_Metadata">
        <xsl:copy>
            <xsl:copy-of select="/root/child/mds:MD_Metadata/mds:metadataIdentifier"/>
            <xsl:copy-of select="/root/child/mds:MD_Metadata/mds:defaultLocale"/>
            <xsl:copy-of select="/root/child/mds:MD_Metadata/mds:parentMetadata"/>
            <xsl:copy-of select="/root/child/mds:MD_Metadata/mds:metadataScope"/>

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-contact"/>
                <xsl:with-param name="name" select="mds:contact"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <xsl:copy-of select="mds:dateStamp"/>
            <xsl:copy-of select="mds:dateInfo"/>
            <xsl:copy-of select="mds:metadataStandard"/>
            <xsl:copy-of select="mds:metadataProfile"/>
            <xsl:copy-of select="mds:alternativeMetadataReference"/>
            <xsl:copy-of select="mds:otherLocale"/>
            <xsl:copy-of select="mds:metadataLinkage"/>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-spatialRepresentationInfo"/>
                <xsl:with-param name="name" select="mds:spatialRepresentationInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-referenceSystemInfo"/>
                <xsl:with-param name="name" select="mds:referenceSystemInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-metadataExtensionInfo"/>
                <xsl:with-param name="name" select="mds:metadataExtensionInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
            <!-- Identification -->
            <mds:identificationInfo>
                <xsl:for-each select="/root/child/mds:MD_Metadata/mds:identificationInfo/*">
	            	<xsl:copy>
	            		<xsl:copy-of select="@*"/>
		                <xsl:copy-of select="mri:citation"/>
	                  <xsl:copy-of select="mri:abstract"/>
	
	                  <!-- FIXME / TO BE DISCUSS following sections are preserved -->
	                  <xsl:copy-of select="mri:purpose"/>
	                  <xsl:copy-of select="mri:credit"/>
	                  <xsl:copy-of select="mri:status"/>
	
	                  <xsl:call-template name="process">
	                     <xsl:with-param name="update" select="$gmd-pointOfContact"/>
	                     <xsl:with-param name="name" select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:pointOfContact"/>
	                     <xsl:with-param name="mode" select="$updateMode"/>
	                     <xsl:with-param name="subLevel" select="true()"/>
	                  </xsl:call-template>
	                    
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:spatialRepresentationType"/>
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:spatialResolution"/>
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:temporalResolution"/>
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:topicCategory"/>

	                  <xsl:call-template name="process">
	                      <xsl:with-param name="update" select="$gmd-extent"/>
	                      <xsl:with-param name="name" select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:extent"/>
	                      <xsl:with-param name="mode" select="$updateMode"/>
	                      <xsl:with-param name="subLevel" select="true()"/>
	                  </xsl:call-template>

	                  <!-- FIXME / TO BE DISCUSS following sections are preserved -->
	                  <xsl:copy-of select="mri:additionalDocumentation"/>
	                  <xsl:copy-of select="mri:processingLevel"/>
	                    
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:resourceMaintenance"/>

	                  <!-- FIXME / TO BE DISCUSS following sections are preserved -->
	                  <xsl:copy-of select="mri:graphicOverview"/>

	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:resourceFormat"/>
	                    
	                  <xsl:call-template name="process">
	                     <xsl:with-param name="update" select="$gmd-descriptiveKeywords"/>
	                     <xsl:with-param name="name" select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:descriptiveKeywords"/>
	                     <xsl:with-param name="mode" select="$updateMode"/>
	                     <xsl:with-param name="subLevel" select="true()"/>
	                  </xsl:call-template>
	                    
	                  <!-- FIXME / TO BE DISCUSS following sections are replaced (except associatedResource which is preserved). -->
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:resourceSpecificUsage"/>
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:resourceConstraints"/>

	                  <xsl:copy-of "mri:associatedResource"/>

	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:defaultLocale"/>
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:otherLocale"/>
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:environmentDescription"/>
	                    
	                  <!-- FIXME / TO BE DISCUSS following sections are replaced/preserved  -->
	                  <xsl:copy-of select="/root/update/parent/mds:MD_Metadata/mds:identificationInfo/*/mri:supplementalInformation"/>
		            	<xsl:copy-of select="srv:*"/>
		            	
		            	<!-- Note: When applying this stylesheet
			                to an ISO profile having a new substitute for
			                MD_Identification, profile specific element copy.
			            -->
			            <xsl:for-each select="*[namespace-uri()!='http://www.isotc211.org/2005/mds/1.0/2013-03-28' and namespace-uri()!='http://www.isotc211.org/2005/srv/2.0/2013-03-28']">
			                <xsl:copy-of select="."/>
			            </xsl:for-each>
	            	</xsl:copy>
	            </xsl:for-each>
	        </mds:identificationInfo>
               
            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-contentInfo"/>
                <xsl:with-param name="name" select="mds:contentInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
            <!-- Distribution -->
            
            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-distributionInfo"/>
                <xsl:with-param name="name" select="mds:distributionInfo"/>
                <!-- Force mode to replace element due to schema cardinality -->
                <xsl:with-param name="mode" select="'replace'"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
            <!-- Quality -->
            
            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-dataQualityInfo"/>
                <xsl:with-param name="name" select="mds:dataQualityInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-portrayalCatalogueInfo"/>
                <xsl:with-param name="name" select="mds:portrayalCatalogueInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-metadataConstraints"/>
                <xsl:with-param name="name" select="mds:metadataConstraints"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>
            
            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-applicationSchemaInfo"/>
                <xsl:with-param name="name" select="mds:applicationSchemaInfo"/>
                <xsl:with-param name="mode" select="$updateMode"/>
            </xsl:call-template>

            <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

            <xsl:call-template name="process">
                <xsl:with-param name="update" select="$gmd-metadataMaintenance"/>
                <xsl:with-param name="name" select="mds:metadataMaintenance"/>
                <!-- Force mode to replace element due to schema cardinality -->
                <xsl:with-param name="mode" select="'replace'"/>
            </xsl:call-template>
            
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Generic template for children update -->
    <!-- Depending on the choosen strategy to be applied on each main sections (mode) -->
    <xsl:template name="process">
        <xsl:param name="update" select="false()"/>
        <xsl:param name="name"/>
        <xsl:param name="mode"/>
        <xsl:param name="subLevel" select="false()"></xsl:param>
        
        <xsl:variable name="childElement">
            <xsl:choose>
                <xsl:when test="$subLevel=true()">
                    <xsl:copy-of select="/root/child/mds:MD_Metadata/mds:identificationInfo/*/*[name(.)=name($name)]"/>        
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="/root/child/mds:MD_Metadata/*[name(.)=name($name)]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		
		<xsl:choose>
            <!-- Replacing elements from parent -->
            <xsl:when test="$mode='replace' and $update='true'">
                <xsl:copy-of select="$name"/>
            </xsl:when>
            <!-- Adding elements -->
            <xsl:when test="$mode='add' and $update='true'">
                <xsl:copy-of select="$childElement"/>
                <xsl:copy-of select="$name"/>
            </xsl:when>
            <!-- Elements preserved from child-->
            <xsl:otherwise>
                <xsl:copy-of select="$childElement"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>


</xsl:stylesheet>
