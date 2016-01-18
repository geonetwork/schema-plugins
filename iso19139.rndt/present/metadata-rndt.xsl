<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:gco="http://www.isotc211.org/2005/gco"
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:srv="http://www.isotc211.org/2005/srv" 
        xmlns:geonet="http://www.fao.org/geonetwork"
        xmlns:exslt="http://exslt.org/common"
        xmlns:java="java:org.fao.geonet.util.XslUtil"
        version="2.0">

    <!--
        Template for INSPIRE RNDT tab
    -->
    <xsl:template name="rndttabs">
            <xsl:param name="schema" />
            <xsl:param name="edit" />
            <xsl:param name="dataset" />

        <xsl:call-template name="complexElementGuiWrapper">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="title"
                select="/root/gui/schemas/iso19139.rndt/strings/rndt/org/title" />
            <!--<xsl:with-param name="helpLink" select="concat('iso19139.rndt|','rndt_org_box')"/>-->

            <xsl:with-param name="id"
                select="generate-id(/root/gui/schemas/iso19139.rndt/strings/rndt/org/title)" />

            <xsl:with-param name="content">
                <xsl:call-template name="select_pa">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="edit" select="$edit" />
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>


        <xsl:for-each
                select="gmd:identificationInfo/gmd:MD_DataIdentification|
                gmd:identificationInfo/srv:SV_ServiceIdentification|
                gmd:identificationInfo/*[@gco:isoType='gmd:MD_DataIdentification']|
                gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification']">

            <xsl:call-template name="complexElementGuiWrapper">
                <xsl:with-param name="schema" select="$schema"/>
                <xsl:with-param name="title"
                                        select="/root/gui/schemas/iso19139.rndt/strings/identification/title" />
                <xsl:with-param name="id"
                                        select="generate-id(/root/gui/schemas/iso19139.rndt/strings/identification/title)" />
                <xsl:with-param name="content">

                    <xsl:apply-templates mode="elementEP"
                            select="gmd:citation/gmd:CI_Citation/gmd:title">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:title)">
                            <xsl:apply-templates mode="elementEP"
                                    select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='title']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                            </xsl:apply-templates>
                    </xsl:if>

                    <xsl:apply-templates mode="elementEP" select="
                            gmd:citation/gmd:CI_Citation/gmd:presentationForm">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                    </xsl:apply-templates>

                    <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:presentationForm)">
                            <xsl:apply-templates mode="elementEP"
                                    select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='presentationForm']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                            </xsl:apply-templates>
                    </xsl:if>

                    <!-- Identifier -->
                    <xsl:apply-templates mode="elementEP"
                            select="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code)">
                            <xsl:apply-templates mode="elementEP"
                                    select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='code']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            </xsl:apply-templates>
                    </xsl:if>

                    <!-- Id Livello superiore -->
                    <xsl:apply-templates mode="elementEP"
                            select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification)">
                        <xsl:apply-templates mode="elementEP"
                                select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/geonet:child[string(@name)='issueIdentification']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- Optional for RNDT -->
                    <xsl:apply-templates mode="elementEP"
                            select="gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails)">
                        <xsl:apply-templates mode="elementEP"
                                select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='otherCitationDetails']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <xsl:apply-templates mode="elementEP"
                            select="gmd:abstract">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:abstract)">
                        <xsl:apply-templates mode="elementEP"
                                select="geonet:child[string(@name)='abstract']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- Spatial Representation -->
                    <xsl:apply-templates mode="elementEP"
                            select="gmd:spatialRepresentationType">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:spatialRepresentationType)">
                        <xsl:apply-templates mode="elementEP"
                                select="geonet:child[string(@name)='spatialRepresentationType']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- Language -->
                    <xsl:apply-templates mode="elementEP" select="gmd:language">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                    </xsl:apply-templates>
                    <xsl:if test="not(gmd:language)">
                            <xsl:apply-templates mode="elementEP"
                                    select="geonet:child[string(@name)='language']">
                                    <xsl:with-param name="schema" select="$schema" />
                                    <xsl:with-param name="edit" select="$edit" />
                            </xsl:apply-templates>
                    </xsl:if>

                                        <!-- Character Set -->
                                        <xsl:apply-templates mode="elementEP" select="gmd:characterSet">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit"   select="$edit"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:characterSet)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="geonet:child[string(@name)='characterSet']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- SupplementalInformation (Optional for RNDT) -->
                                        <xsl:apply-templates mode="elementEP" select="gmd:supplementalInformation">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit"   select="$edit"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:supplementalInformation)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="geonet:child[string(@name)='supplementalInformation']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Topic Category -->
                                        <xsl:apply-templates mode="complexElement" select="gmd:topicCategory">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit"   select="$edit"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:topicCategory)">
                                                <xsl:apply-templates mode="complexElement"
                                                        select="geonet:child[string(@name)='topicCategory']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Date -->
                                        <xsl:apply-templates mode="complexElement"
                                                select="gmd:citation/gmd:CI_Citation/gmd:date">
                                                <xsl:with-param name="schema" select="$schema" />
                                                <xsl:with-param name="edit" select="$edit" />
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:date)">
                                                <xsl:apply-templates mode="complexElement"
                                                        select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='date']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!--  Responsible -->
                                        <xsl:apply-templates mode="elementEP"
                                                select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
                                                <xsl:with-param name="schema" select="$schema" />
                                                <xsl:with-param name="edit" select="$edit" />
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='citedResponsibleParty']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!--  Keywords -->
                                        <xsl:call-template name="complexElementGuiWrapper">
                                                <xsl:with-param name="title"
                                                        select="/root/gui/schemas/iso19139.rndt/strings/keywords/title" />
                                                <xsl:with-param name="id"
                                                        select="generate-id(/root/gui/schemas/iso19139.rndt/strings/keywords/title)" />
                                                <xsl:with-param name="content">

                                                        <xsl:apply-templates mode="elementEP"
                                                                select="gmd:descriptiveKeywords">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if test="not(gmd:descriptiveKeywords)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="geonet:child[string(@name)='descriptiveKeywords']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>

                                                </xsl:with-param>
                                        </xsl:call-template>

                                        <!-- Point of Contact -->
                                        <xsl:apply-templates mode="elementEP"
                                                select="gmd:pointOfContact">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit" select="$edit"/>
                                                <xsl:with-param name="force" select="true()"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:pointOfContact)">
                                                <xsl:apply-templates mode="elementEP" select="
                                                        geonet:child[string(@name)='pointOfContact']">
                                                        <xsl:with-param name="schema" select="$schema"/>
                                                        <xsl:with-param name="edit" select="$edit"/>
                                                        <xsl:with-param name="force" select="true()"/>
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Spatial Resolution -->
                                        <xsl:apply-templates mode="elementEP" select="gmd:spatialResolution">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit"   select="$edit"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:spatialResolution)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="geonet:child[string(@name)='spatialResolution']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                </xsl:with-param>
                        </xsl:call-template>

                        <!-- Service info-->
                        <xsl:if test="not($dataset)">
                                <xsl:call-template name="complexElementGuiWrapper">
                                        <xsl:with-param name="title"
                                                select="/root/gui/schemas/iso19139.rndt/strings/service/title" />
                                        <xsl:with-param name="id"
                                                select="generate-id(/root/gui/schemas/iso19139.rndt/strings/service/title)" />
                                        <xsl:with-param name="content">

                                                <!-- Coupling Type -->
                                                <xsl:apply-templates mode="elementEP"
                                                        select="srv:couplingType">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                                <xsl:if test="not(srv:couplingType)">
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="geonet:child[string(@name)='couplingType']">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                </xsl:if>

                                                <!-- Resource Coupled -->
                                                <xsl:apply-templates mode="elementEP"
                                                        select="srv:operatesOn">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                                <xsl:if test="not(srv:operatesOn)">
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="geonet:child[string(@name)='operatesOn']">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                </xsl:if>

                                                <!-- Service Type -->
                                                <xsl:apply-templates mode="elementEP"
                                                        select="srv:serviceType">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                                <xsl:if test="not(gmd:serviceType)">
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="geonet:child[string(@name)='serviceType']">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                </xsl:if>

                                                <!-- Contains Operations -->
                                                <xsl:apply-templates mode="elementEP"
                                                        select="srv:containsOperations">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                                <xsl:if test="not(srv:containsOperations)">
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="geonet:child[string(@name)='containsOperations']">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                </xsl:if>

                                        </xsl:with-param>
                                </xsl:call-template>
                        </xsl:if>

                        <!-- Constraints  -->
                        <xsl:call-template name="complexElementGuiWrapper">
                                <xsl:with-param name="title"
                                        select="/root/gui/schemas/iso19139.rndt/strings/constraint/title" />
                                <xsl:with-param name="id"
                                        select="generate-id(/root/gui/schemas/iso19139.rndt/strings/constraint/title)" />
                                <xsl:with-param name="content">
                                        <xsl:apply-templates mode="complexElement"
                                                select="gmd:resourceConstraints">
                                                <xsl:with-param name="schema" select="$schema" />
                                                <xsl:with-param name="edit" select="$edit" />
                                        </xsl:apply-templates>

                                        <xsl:apply-templates mode="elementEP"
                                                select="geonet:child[string(@name)='resourceConstraints']">
                                                <xsl:with-param name="schema" select="$schema" />
                                                <xsl:with-param name="edit" select="$edit" />
                                        </xsl:apply-templates>
                                </xsl:with-param>
                        </xsl:call-template>

                        <!-- Extent information -->
                        <xsl:call-template name="complexElementGuiWrapper">
                                <xsl:with-param name="title"
                                        select="/root/gui/schemas/iso19139.rndt/strings/geoloc/title" />
                                <xsl:with-param name="id"
                                        select="generate-id(/root/gui/schemas/iso19139.rndt/strings/geoloc/title)" />
                                <xsl:with-param name="content">

                                        <!-- Geographic Extent -->
                                        <xsl:choose>
                                                <xsl:when test="exists(gmd:extent)">
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="gmd:extent/gmd:EX_Extent/gmd:geographicElement">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:geographicElement)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="gmd:extent/gmd:EX_Extent/geonet:child[string(@name)='geographicElement']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>
                                                </xsl:when>

                                                <xsl:when test="exists(srv:extent)">
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="srv:extent/gmd:EX_Extent/gmd:geographicElement">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if test="not(srv:extent/gmd:EX_Extent/gmd:geographicElement)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="srv:extent/gmd:EX_Extent/geonet:child[string(@name)='geographicElement']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>
                                                </xsl:when>
                                        </xsl:choose>

                                    <!-- Vertical Extent -->
                                        <xsl:apply-templates mode="complexElement"
                                                select="gmd:extent/gmd:EX_Extent/gmd:verticalElement">
                                                <xsl:with-param name="schema" select="$schema" />
                                                <xsl:with-param name="edit" select="$edit" />
                                                <xsl:with-param name="force" select="true()" />
                                        </xsl:apply-templates>
                                        <xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement)">
                                                <xsl:apply-templates mode="complexElement"
                                                        select="gmd:extent/gmd:EX_Extent/geonet:child[string(@name)='verticalElement']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Temporal extent -->
                                        <xsl:choose>
                                                <xsl:when test="exists(gmd:extent)">
                                                        <xsl:apply-templates mode="complexElement"
                                                                select="gmd:extent/gmd:EX_Extent/gmd:temporalElement">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                                <xsl:with-param name="force" select="true()" />
                                                        </xsl:apply-templates>
                                                        <xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:temporalElement)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="gmd:extent/gmd:EX_Extent/geonet:child[string(@name)='temporalElement']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>
                                                </xsl:when>

                                                <xsl:when test="exists(srv:extent)">
                                                        <xsl:apply-templates mode="complexElement"
                                                                select="srv:extent/gmd:EX_Extent/gmd:temporalElement">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if test="not(srv:extent/gmd:EX_Extent/gmd:temporalElement)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="srv:extent/gmd:EX_Extent/geonet:child[string(@name)='temporalElement']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>
                                                </xsl:when>
                                        </xsl:choose>

                                </xsl:with-param>
                        </xsl:call-template>

                        <!-- Quality and validity  -->
                        <xsl:call-template name="complexElementGuiWrapper">
                                <xsl:with-param name="title"
                                        select="/root/gui/schemas/iso19139.rndt/strings/quality/title" />
                                <xsl:with-param name="id"
                                        select="generate-id(/root/gui/schemas/iso19139.rndt/strings/quality/title)" />
                                <xsl:with-param name="content">

                                        <!-- Quality level -->
                                        <xsl:apply-templates mode="elementEP"
                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit"   select="$edit"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/geonet:child[string(@name)='level']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Quality level description -->
                                        <xsl:apply-templates mode="elementEP"
                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:levelDescription">
                                                <xsl:with-param name="schema" select="$schema"/>
                                                <xsl:with-param name="edit"   select="$edit"/>
                                        </xsl:apply-templates>
                                        <xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:levelDescription)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/geonet:child[string(@name)='levelDescription']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Lineage -->
                                        <xsl:apply-templates mode="elementEP"
                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement">
                                                <xsl:with-param name="schema" select="$schema" />
                                                <xsl:with-param name="edit" select="$edit" />
                                        </xsl:apply-templates>
                                        <xsl:if	test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement)">
                                                <xsl:apply-templates mode="elementEP"
                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/geonet:child[string(@name)='statement']">
                                                        <xsl:with-param name="schema" select="$schema" />
                                                        <xsl:with-param name="edit" select="$edit" />
                                                        <xsl:with-param name="force" select="true()" />
                                                </xsl:apply-templates>
                                        </xsl:if>

                                        <!-- Positional Accuracy -->
                                        <xsl:if test="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy">
                                                <xsl:call-template name="complexElementGuiWrapper">
                                                        <xsl:with-param name="title"
                                                                select="/root/gui/schemas/iso19139.rndt/strings/positionalAccuracy/title" />
                                                        <xsl:with-param name="id"
                                                                select="generate-id(/root/gui/schemas/iso19139.rndt/strings/positionalAccuracy/title)" />
                                                        <xsl:with-param name="content">

                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                                <xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit)">
                                                                        <xsl:apply-templates mode="elementEP"
                                                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/geonet:child[string(@name)='valueUnit']">
                                                                                <xsl:with-param name="schema" select="$schema" />
                                                                                <xsl:with-param name="edit" select="$edit" />
                                                                        </xsl:apply-templates>
                                                                </xsl:if>

                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                                <xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value)">
                                                                        <xsl:apply-templates mode="elementEP"
                                                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/geonet:child[string(@name)='value']">
                                                                                <xsl:with-param name="schema" select="$schema" />
                                                                                <xsl:with-param name="edit" select="$edit" />
                                                                        </xsl:apply-templates>
                                                                </xsl:if>

                                                        </xsl:with-param>
                                                </xsl:call-template>
                                        </xsl:if>

                                        <!-- Specific Conformity  -->
                                        <xsl:call-template name="complexElementGuiWrapper">
                                                <xsl:with-param name="title"
                                                        select="/root/gui/schemas/iso19139.rndt/strings/conformity/title" />
                                                <xsl:with-param name="id"
                                                        select="generate-id(/root/gui/schemas/iso19139.rndt/strings/conformity/title)" />
                                                <xsl:with-param name="content">

                                                        <!--<xsl:apply-templates mode="elementEP"
                                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if
                                                                test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/geonet:child[string(@name)='DQ_ConformanceResult']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                        <xsl:with-param name="force" select="true()" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>-->

                                                        <!-- Title -->
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if
                                                                test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/geonet:child[string(@name)='title']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                        <xsl:with-param name="force" select="true()" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>

                                                        <!-- Date -->
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if
                                                                test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/geonet:child[string(@name)='date']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                        <xsl:with-param name="force" select="true()" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>

                                                        <!-- Date Type -->
                                                        <xsl:apply-templates mode="elementEP"
                                                                select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType">
                                                                <xsl:with-param name="schema" select="$schema" />
                                                                <xsl:with-param name="edit" select="$edit" />
                                                        </xsl:apply-templates>
                                                        <xsl:if
                                                                test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType)">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/geonet:child[string(@name)='dateType']">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                        <xsl:with-param name="force" select="true()" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>

                                                        <!-- Conformity Level -->
                                                        <!--<xsl:variable name="conformity">
                                                                <xsl:value-of select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass"/>
                                                        </xsl:variable>

                                                        <xsl:if test="$conformity != ''">
                                                                <xsl:apply-templates mode="elementEP"
                                                                        select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass">
                                                                        <xsl:with-param name="schema" select="$schema" />
                                                                        <xsl:with-param name="edit" select="$edit" />
                                                                </xsl:apply-templates>
                                                        </xsl:if>

                            <xsl:if
                                    test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass)">
                                    <xsl:apply-templates mode="elementEP"
                                            select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/geonet:child[string(@name)='pass']">
                                            <xsl:with-param name="schema" select="$schema" />
                                            <xsl:with-param name="edit" select="$edit" />
                                            <xsl:with-param name="force" select="true()" />
                                    </xsl:apply-templates>
                            </xsl:if>-->

                            <!-- Only to support gmd:pass -->
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                            </xsl:apply-templates>

                            <xsl:apply-templates mode="iso19139-rndt.pass"
                                                 select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                            </xsl:apply-templates>
                            <xsl:if
                                test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass)">
                                <xsl:apply-templates mode="iso19139-rndt.pass"
                                                     select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/geonet:child[string(@name)='pass']">
                                    <xsl:with-param name="schema" select="$schema" />
                                    <xsl:with-param name="edit" select="$edit" />
                                    <xsl:with-param name="force" select="true()" />
                                </xsl:apply-templates>
                            </xsl:if>

                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>

            <!-- Spatial Reference System -->
            <xsl:apply-templates mode="elementEP"
                                 select="../../gmd:referenceSystemInfo">
                <xsl:with-param name="schema" select="$schema" />
                <xsl:with-param name="edit" select="$edit" />
            </xsl:apply-templates>
            <xsl:if	test="not(../../gmd:referenceSystemInfo)">
                <xsl:apply-templates mode="elementEP"
                                     select="../../geonet:child[string(@name)='referenceSystemInfo']">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="edit" select="$edit" />
                    <xsl:with-param name="force" select="true()" />
                </xsl:apply-templates>
            </xsl:if>

            <!-- Distribution -->
            <xsl:call-template name="complexElementGuiWrapper">
                <xsl:with-param name="title"
                                select="/root/gui/schemas/iso19139.rndt/strings/distribution/title" />
                <xsl:with-param name="id"
                                select="generate-id(/root/gui/schemas/iso19139.rndt/strings/distribution/title)" />
                <xsl:with-param name="content">

                    <xsl:apply-templates mode="elementEP"
                                         select="
                                                ../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='distributionFormat']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <xsl:apply-templates mode="elementEP"
                                         select="
                                                ../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='distributor']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='transferOptions']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                </xsl:with-param>
            </xsl:call-template>

            <!-- Data management -->
            <xsl:apply-templates mode="complexElement"
                                 select="gmd:resourceMaintenance">
                <xsl:with-param name="schema" select="$schema" />
                <xsl:with-param name="edit" select="$edit" />
            </xsl:apply-templates>
            <xsl:if	test="not(gmd:resourceMaintenance)">
                <xsl:apply-templates mode="elementEP"
                                     select="geonet:child[string(@name)='resourceMaintenance']">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="edit" select="$edit" />
                    <xsl:with-param name="force" select="true()" />
                </xsl:apply-templates>
            </xsl:if>

            <!-- Raster data content -->
            <xsl:if test="exists(../../gmd:contentInfo/gmd:MD_ImageDescription)">
                <xsl:call-template name="complexElementGuiWrapper">
                    <xsl:with-param name="title"
                                    select="/root/gui/schemas/iso19139.rndt/strings/rasterContent/title" />
                    <xsl:with-param name="id"
                                    select="generate-id(/root/gui/schemas/iso19139.rndt/strings/rasterContent/title)" />
                    <xsl:with-param name="content">

                        <!-- Attribute Description -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:contentInfo/gmd:MD_ImageDescription/geonet:child[string(@name)='attributeDescription']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Content Type -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:contentInfo/gmd:MD_ImageDescription/geonet:child[string(@name)='contentType']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Radiometric Resolution -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/gmd:bitsPerValue">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/gmd:bitsPerValue)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/geonet:child[string(@name)='bitsPerValue']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Triangulation Area -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:triangulationIndicator">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:triangulationIndicator)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:contentInfo/gmd:MD_ImageDescription/geonet:child[string(@name)='triangulationIndicator']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

            <!-- Spatial Representation information for Raster data -->
            <xsl:if test="exists(../../gmd:spatialRepresentationInfo)">
                <xsl:call-template name="complexElementGuiWrapper">
                    <xsl:with-param name="title"
                                    select="/root/gui/schemas/iso19139.rndt/strings/rasterSpatialRepresentation/title" />
                    <xsl:with-param name="id"
                                    select="generate-id(/root/gui/schemas/iso19139.rndt/strings/rasterSpatialRepresentation/title)" />
                    <xsl:with-param name="content">

                        <!-- Number of Dimension -->

                        <!-- MD_Georectified -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='numberOfDimensions']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- MD_Georeferenceable -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='numberOfDimensions']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Dimension Properties -->

                        <!-- MD_Georectified -->
                        <xsl:apply-templates mode="complexElement"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties)">
                            <xsl:apply-templates mode="complexElement"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='axisDimensionProperties']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- MD_Georeferenceable -->
                        <xsl:apply-templates mode="complexElement"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties)">
                            <xsl:apply-templates mode="complexElement"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='axisDimensionProperties']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Cell Geometry -->

                        <!-- MD_Georectified -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='cellGeometry']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- MD_Georeferenceable -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='cellGeometry']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Transformation Parameter Availability -->

                        <!-- MD_Georectified -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='transformationParameterAvailability']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- MD_Georeferenceable -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:transformationParameterAvailability">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:transformationParameterAvailability)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='transformationParameterAvailability']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Chak Point Availability -->

                        <!-- Only for MD_Georectified -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='checkPointAvailability']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Chak Point Description -->

                        <!-- Only for MD_Georectified -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointDescription">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointDescription)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='checkPointDescription']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Coorner Points Coordinates -->

                        <!-- Only for MD_Georectified -->
                        <xsl:apply-templates mode="complexElement"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cornerPoints">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cornerPoints)">
                            <xsl:apply-templates mode="complexElement"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='cornerPoints']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Pixel Point -->

                        <!-- Only for MD_Georectified -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:pointInPixel">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:pointInPixel)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='pointInPixel']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Control Point Availability -->

                        <!-- Only for MD_Georeferenceable -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:controlPointAvailability">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:controlPointAvailability)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='controlPointAvailability']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Orentation Parameter Availability -->

                        <!-- Only for MD_Georeferenceable -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:orientationParameterAvailability">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:orientationParameterAvailability)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='orientationParameterAvailability']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                        <!-- Georeferenced Parameters -->

                        <!-- Only for MD_Georeferenceable -->
                        <xsl:apply-templates mode="elementEP"
                                             select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:georeferencedParameters">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                        </xsl:apply-templates>
                        <xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:georeferencedParameters)">
                            <xsl:apply-templates mode="elementEP"
                                                 select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='georeferencedParameters']">
                                <xsl:with-param name="schema" select="$schema" />
                                <xsl:with-param name="edit" select="$edit" />
                                <xsl:with-param name="force" select="true()" />
                            </xsl:apply-templates>
                        </xsl:if>

                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

            <!-- Metadata  -->
            <xsl:call-template name="complexElementGuiWrapper">
                <xsl:with-param name="title"
                                select="/root/gui/schemas/iso19139.rndt/strings/metadata/title" />
                <xsl:with-param name="id"
                                select="generate-id(/root/gui/schemas/iso19139.rndt/strings/metadata/title)" />
                <xsl:with-param name="content">

                    <!-- fileIdentifier -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:fileIdentifier">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:fileIdentifier)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='fileIdentifier']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- language -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:language">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:language)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='language']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- metadataStandardName -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:metadataStandardName">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:metadataStandardName)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='metadataStandardName']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- metadataStandardVersion -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:metadataStandardVersion">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:metadataStandardVersion)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='metadataStandardVersion']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- characterSet -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:characterSet">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:characterSet)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='characterSet']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- parentIdentifier -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:parentIdentifier">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:parentIdentifier)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='parentIdentifier']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- hierarchyLevel -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:hierarchyLevel">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:hierarchyLevel)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='hierarchyLevel']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- hierarchyLevel Name -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:hierarchyLevelName">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:hierarchyLevelName)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='hierarchyLevel']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- dateStamp -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:dateStamp">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:dateStamp)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='dateStamp']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                    <!-- contact -->
                    <xsl:apply-templates mode="elementEP"
                                         select="../../gmd:contact">
                        <xsl:with-param name="schema" select="$schema" />
                        <xsl:with-param name="edit" select="$edit" />
                    </xsl:apply-templates>
                    <xsl:if	test="not(../../gmd:contact)">
                        <xsl:apply-templates mode="elementEP"
                                             select="../../geonet:child[string(@name)='contact']">
                            <xsl:with-param name="schema" select="$schema" />
                            <xsl:with-param name="edit" select="$edit" />
                            <xsl:with-param name="force" select="true()" />
                        </xsl:apply-templates>
                    </xsl:if>

                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- Customize the gmd:pass element as dropdown in order to support the RNDT spec (for 'not evaluated' we use the explanation field as support) -->
    <xsl:template mode="iso19139-rndt.pass" match="gmd:pass">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>
        <xsl:param name="id" select="generate-id(.)"/>

        <!-- Used for the gmd:pass warkaround see below -->
        <xsl:variable name="explanationValue" select="string(../gmd:explanation)"/>

        <xsl:variable name="helpLink">
            <xsl:call-template name="getHelpLink">
                <xsl:with-param name="name"   select="name(.)"/>
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
        </xsl:variable>

        <th class="md" width="20%" valign="top">
            <span id="stip.{$helpLink}|{$id}" onclick="toolTip(this.id);" class="content" style="cursor:help;">
                <xsl:value-of select=" concat(/root/gui/schemas/iso19139.rndt/labels/element[@name = 'gmd:pass']/label, ':')"/>
            </span>
        </th>
        <td class="padded" valign="top">
            <xsl:choose>
                <xsl:when test="$edit=true()">
                    <input type="hidden" name="_{./gco:Boolean/geonet:element/@ref}" id="_{./gco:Boolean/geonet:element/@ref}" value="{./gco:Boolean}">
                        <xsl:choose>
                            <xsl:when test="./gco:Boolean = ''">
                                <xsl:attribute name="value">false</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./gco:Boolean"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>

                    <xsl:variable name="explanationRef">
                        <xsl:value-of select="../gmd:explanation/gco:CharacterString/geonet:element/@ref"/>
                    </xsl:variable>

                    <!-- This choose element contains a warkaround to manage the 'gmd:pass' as a select due to the RNDT specifications -->
                    <xsl:choose>
                        <xsl:when test="./gco:Boolean/text()='true'">
                            <select class="md" style="width: 110px;" name="conformity-pass" id="_{./gco:Boolean/geonet:element/@ref}_checkbox" onChange="javascript:setConformityPass(this, '_{./gco:Boolean/geonet:element/@ref}', '_{$explanationRef}');">
                                <option value="non valutato">non valutato</option>
                                <option value="conforme" selected="selected">conforme</option>
                                <option value="non conforme">non conforme</option>
                            </select>
                        </xsl:when>
                        <xsl:when test="./gco:Boolean/text()='false' and $explanationValue!='non valutato'">
                            <select class="md" style="width: 110px;" name="conformity-pass" id="_{./gco:Boolean/geonet:element/@ref}_checkbox" onChange="javascript:setConformityPass(this, '_{./gco:Boolean/geonet:element/@ref}', '_{$explanationRef}');">
                                <option value="non valutato">non valutato</option>
                                <option value="conforme">conforme</option>
                                <option value="non conforme" selected="selected">non conforme</option>
                            </select>
                        </xsl:when>
                        <xsl:when test="./gco:Boolean/text()='false' and $explanationValue='non valutato'">
                            <select class="md" style="width: 110px;" name="conformity-pass" id="_{./gco:Boolean/geonet:element/@ref}_checkbox" onChange="javascript:setConformityPass(this, '_{./gco:Boolean/geonet:element/@ref}', '_{$explanationRef}');">
                                <option value="non valutato" selected="selected">non valutato</option>
                                <option value="conforme">conforme</option>
                                <option value="non conforme">non conforme</option>
                            </select>
                        </xsl:when>
                        <xsl:otherwise>
                            <select class="md" style="width: 110px;" name="conformity-pass" id="_{./gco:Boolean/geonet:element/@ref}_checkbox" onChange="javascript:setConformityPass(this, '_{./gco:Boolean/geonet:element/@ref}', '_{$explanationRef}');">
                                <option value="non valutato" selected="selected">non valutato</option>
                                <option value="conforme">conforme</option>
                                <option value="non conforme">non conforme</option>
                            </select>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$explanationValue"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
    </xsl:template>

    <!-- Allows the possibility to add new element in gmd:CI_Citation/gmd:date
    in box as the first element -->
    <xsl:template mode="elementEP" match="gmd:CI_Citation/gmd:date">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- Allows the possibility to add multiple connection points -->
    <xsl:template mode="elementEP" match="srv:connectPoint">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- Allows the possibility to see the unit of measure for gmd:resolution -->
    <xsl:template mode="elementEP" match="gmd:resolution">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template mode="elementEP" match="gmd:axisDimensionProperties">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- Allows the possibility to add multiple gmd:topicCategory in box -->
    <xsl:template mode="elementEP" match="gmd:topicCategory">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- Sometime occurs that new elements cannot be removed this template fix thie behavior-->
    <xsl:template mode="elementEP" match="gmd:resourceMaintenance">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- Allows the possibility to add multiple gmd:resourceConstraints in box -->
    <xsl:template mode="elementEP" match="gmd:resourceConstraints">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="elementEP" match="gmd:cornerPoints">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="complexElement"
                             select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="$edit" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- ============================================================================= -->
    <!-- CRS custom visualization                                -->
    <!-- ============================================================================= -->

    <xsl:template mode="elementEP" match="gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code" priority="99">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:choose>
            <xsl:when test="$edit=true()">
                <xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="title">
                        <xsl:call-template name="getTitle">
                            <xsl:with-param name="name"   select="'RNDTcrs'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name" select="'RNDTcrs'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="text">
                        <xsl:variable name="value" select="string(gco:CharacterString)"/>
                        <xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref"/>
                        <!--<xsl:variable name="fref" select="../gmd:name/gco:CharacterString/geonet:element/@ref|../gmd:name/gmx:MimeFileType/geonet:element/@ref"/>-->
                        <!--                        <xsl:variable name="relatedJsAction">
                            <xsl:value-of select="concat('checkForFileUpload(&quot;',$fref,'&quot;, &quot;',$ref,'&quot;, this.options[this.selectedIndex].value);')" />
                        </xsl:variable>-->

                        <input type="text" id="_{$ref}" name="_{$ref}" value="{$value}" size="50" />
                        <input type="hidden" id="previous_{$ref}" name="previous_{$ref}" value="{$value}"/>

                        <xsl:for-each select="gco:CharacterString">
                            <xsl:call-template name="helperCRS">
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="attribute" select="false()"/>
                                <xsl:with-param name="labels" select="/root/gui/schemas/*[name(.)=$schema]/labels/element[@name='RNDTcrs']"/>
                                <xsl:with-param name="selectedValue" select="$value"/>
                                <!--                                <xsl:with-param name="jsAction" select="$relatedJsAction"/>-->
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="element" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="false()"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- the codespace is forced upon save if the CRS is an EPSG code -->
    <xsl:template mode="elementEP" match="gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace">
        <xsl:param name="schema"/>
        <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="simpleElement" select=".">
            <xsl:with-param name="schema" select="$schema" />
            <xsl:with-param name="edit" select="false()" />
            <xsl:with-param name="text">
                <xsl:value-of select="gco:CharacterString"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template name="helperCRS">
        <xsl:param name="schema"/>
        <xsl:param name="attribute"/>
        <xsl:param name="jsAction"/>
        <xsl:param name="selectedValue"/>
        <xsl:param name="labels"/>

        <!-- Define the element to look for. -->
        <xsl:variable name="parentName">
            <xsl:choose>
                <!-- In dublin core element contains value.
                In ISO, attribute also but element contains characterString which contains the value -->
                <xsl:when test="$attribute=true() or $schema = 'dublin-core'">
                    <xsl:value-of select="name(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name(parent::node())"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Look for the helper -->
        <xsl:variable name="helper">
            <xsl:copy-of select="$labels/helper"/>
        </xsl:variable>

        <!-- Display the helper list -->
        <xsl:if test="normalize-space($helper)!=''">
            <xsl:variable name="list" select="exslt:node-set($helper)"/>
            <xsl:variable name="refId" select="if ($attribute=true()) then concat(../geonet:element/@ref, '_', name(.)) else geonet:element/@ref"/>
            <xsl:variable name="relatedElementName" select="$list/*/@rel"/>
            <xsl:variable name="relatedElementAction">
                <xsl:if test="$relatedElementName!=''">
                    <xsl:variable name="relatedElement" select="../following-sibling::node()[name()=$relatedElementName]/gco:CharacterString"/>
                    <xsl:variable name="relatedElementRef" select="../following-sibling::node()[name()=$relatedElementName]/gco:CharacterString/geonet:element/@ref"/>
                    <xsl:variable name="relatedElementIsEmpty" select="normalize-space($relatedElement)=''"/>

                    <xsl:value-of select="concat('if ($(&quot;_', $relatedElementRef, '&quot;)) $(&quot;_', $relatedElementRef, '&quot;).value=this.options[this.selectedIndex].title;')"/>

                </xsl:if>
            </xsl:variable>
            <xsl:text> </xsl:text>
            <xsl:variable name="descr" select="$list/*/option[@value=$selectedValue]"/>

            <!--<input type="label" for="s_{$refId}" size="50" id="label-s_{$refId}" name="label-s_{$refId}" value="{$descr}"/>-->

            <select id="s_{$refId}" name="s_{$refId}"
                        size="1" class="md"
                        onchange="$('_{$refId}').value=this.options[this.selectedIndex].value; if ($('_{$refId}').onkeyup) $('_{$refId}').onkeyup(); {$relatedElementAction} {$jsAction}">
                <option/>
                <!-- This assume that helper list is already sort in alphabetical order in loc file. -->
                <xsl:copy-of select="$list/*"/>
            </select>
        </xsl:if>
    </xsl:template>


    <!-- ============================================================================= -->

    <!-- Don't add some gmd:thesaurusName|gmd:MD_Keywords sub elements because not required by RNDT -->
    <xsl:template mode="elementEP" match="gmd:thesaurusName/gmd:CI_Citation/gmd:citedResponsibleParty |
                gmd:thesaurusName/gmd:CI_Citation/gmd:presentationForm | gmd:thesaurusName/gmd:CI_Citation/gmd:identifier"/>

    <xsl:template mode="elementEP" match="gmd:MD_Keywords/gmd:type"/>



    <xsl:template name="select_pa">
        <xsl:param name="edit"/>
        <xsl:param name="schema"/>

        <xsl:variable name="fileid" select="/root/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString/text()"/>
        <xsl:variable name="hasIpa" select="contains($fileid, ':')"/>
        <xsl:variable name="ipa" select="substring-before($fileid, ':')"/>

        <xsl:choose>
            <xsl:when test="not($hasIpa) and not($edit)">
                <strong>ATTENZIONE</strong>: Codice iPA non impostato in questo metadato
            </xsl:when>
            <xsl:when test="not($hasIpa) and $edit and not (/root/gui/config/rndt)">
                <strong>Errore di configurazione</strong>: iPA non trovati in <tt>config-gui.xml</tt>
            </xsl:when>
            <xsl:when test="$hasIpa">
                <xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="id"      select="'select_pa_simple'"/>
                    <xsl:with-param name="schema"  select="$schema"/>
                    <xsl:with-param name="edit"    select="false()"/>
                    <xsl:with-param name="showAttributes"   select="false()"/>
                    <xsl:with-param name="title"    select="/root/gui/schemas/iso19139.rndt/strings/rndt/org/field"/>
                    <xsl:with-param name="helpLink" select="concat('iso19139.rndt|','rndt_org_select')"/>
                    <xsl:with-param name="text"><xsl:value-of select="concat(/root/gui/config/rndt/ente[ipa/text()=$ipa]/name/text(), ' (', $ipa, ')')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($hasIpa) and $edit and /root/gui/config/rndt and count(/root/gui/config/rndt/ente)=1">
                <xsl:variable name="forcedname" select="/root/gui/config/rndt/ente/name/text()"/>
                <xsl:variable name="forcedipa" select="/root/gui/config/rndt/ente/ipa/text()"/>

                <xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="id"      select="'select_pa_simple'"/>
                    <xsl:with-param name="schema"  select="$schema"/>
                    <xsl:with-param name="edit"    select="false()"/>
                    <xsl:with-param name="showAttributes"   select="false()"/>
                    <xsl:with-param name="title"    select="/root/gui/schemas/iso19139.rndt/strings/rndt/org/field"/>
                    <xsl:with-param name="helpLink" select="concat('iso19139.rndt|','rndt_org_select')"/>
                    <xsl:with-param name="text"><xsl:value-of select="concat($forcedname, ' (', $forcedipa, ')   ')"/><i>Valore impostato automaticamente</i></xsl:with-param>
                </xsl:call-template>

            </xsl:when>
            <xsl:when test="not($hasIpa) and $edit and /root/gui/config/rndt">

                <xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="id" select="'select_pa_simple'"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.rndt/strings/rndt/org/field"/>
                    <xsl:with-param name="helpLink" select="concat('iso19139.rndt|','rndt_org_select')"/>
                    <!--     <xsl:with-param name="removeLink"   select="false()"/>
                                <xsl:with-param name="addLink"   select="false()"/>
                    -->
                    <xsl:with-param name="text">

                        <select class="md" name="rdnt_org_select" size="1"
                                onChange="javascript: $(_{/root/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString/geonet:element/@ref}).value=this.options[this.selectedIndex].value">
                            <option value="{$fileid}">
                                <xsl:value-of select="/root/gui/schemas/iso19139.rndt/strings/rndt/org/askselect"/>
                            </option>
                            <!-- tutti gli enti definiti -->
                            <xsl:for-each select="/root/gui/config/rndt/ente">
                                <option value="{concat(./ipa/text(),':', $fileid)}">
                                    <xsl:value-of select="./name/text()"/>
                                </option>
                            </xsl:for-each>
                        </select>

                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <strong>ATTENZIONE</strong>: Casistica non contemplata
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template mode="iso19139" match="gmd:fileIdentifier" priority="99">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>

        <xsl:choose>
            <xsl:when test="$edit=true()">

                <xsl:variable name="initialfileid" select="gco:CharacterString/text()"/>
                <xsl:variable name="hasIpa" select="contains($initialfileid, ':')"/>

                <xsl:variable name="fileid">
                    <xsl:choose>
                        <xsl:when test="not($hasIpa) and count(/root/gui/config/rndt/ente)=1">
                             <xsl:value-of select="concat(/root/gui/config/rndt/ente/ipa/text(),':',$initialfileid)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$initialfileid"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="text">
                    <xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref" />
                    <input
                        class="md" type="text" name="_{$ref}" id="_{$ref}" value="{normalize-space($fileid)}" size="40" readonly="readonly"/>
                </xsl:variable>

                <xsl:apply-templates mode="simpleElement" select=".">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="edit" select="true()" />
                    <xsl:with-param name="text" select="$text" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="simpleElement" select=".">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="text">
                        <xsl:value-of select="gco:CharacterString"/>

                        <!--                        <xsl:variable name="metadataTitle">
                            <xsl:call-template name="getMetadataTitle">
                                <xsl:with-param name="uuid" select="gco:CharacterString"></xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <a href="metadata.show?uuid={gco:CharacterString}">
                            <xsl:value-of select="$metadataTitle"/>
                        </a>-->
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
