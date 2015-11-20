<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:date="http://exslt.org/dates-and-times" xmlns:exslt="http://exslt.org/common"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">


    <xsl:template name="metadata-fop-iso19139.rndt">
        <xsl:param name="schema"/>

        <!-- IDENTIFICAZIONE DELLA RISORSA ================================= -->

        <xsl:variable name="tab_identificazione">

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:presentationForm">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code|
                                                         ./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:abstract">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:spatialRepresentationType">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:language">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:characterSet">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:supplementalInformation">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:topicCategory">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

            <!-- TODO: for-each on dates-->
            <xsl:apply-templates mode="fopTheDate" select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>

        </xsl:variable>

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Identificazione'"/>
            <xsl:with-param name="block" select="$tab_identificazione"/>
        </xsl:call-template>

        <!-- RESPONSABILE DEI DATI ========================================= -->

        <xsl:for-each select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="label" select="'Responsabile dei dati'"/>
                <xsl:with-param name="block">
                    <xsl:apply-templates mode="elementFop" select=".">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>                    
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <!-- POC =========================================================== -->

        <xsl:for-each select="./gmd:identificationInfo/*/gmd:pointOfContact">
            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="label">
                    <xsl:value-of select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='gmd:pointOfContact']/label"/>
                </xsl:with-param>
                <xsl:with-param name="block">
<!--                    <xsl:apply-templates mode="fopTheResponsibleParent" select=".">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>-->
                    <xsl:apply-templates mode="elementFop" select=".">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <!-- Keywords ====================================================== -->
        
        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="block">
                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword |
                                           ./gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
            <xsl:with-param name="label">
                <!--<xsl:value-of  select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='gmd:keyword']/label"/>-->
                <xsl:value-of  select="'Parole chiave'"/>
            </xsl:with-param>
        </xsl:call-template>

        <!-- Spatial resolution =============================================-->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="block">
                <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/gmd:spatialResolution">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
            <xsl:with-param name="label">
                <xsl:value-of select="/root/gui/schemas/iso19139/labels/element[@name='gmd:spatialResolution']/label"/>
                <!--<xsl:value-of select="'Scala equivalente'"/>-->
            </xsl:with-param>
        </xsl:call-template>


        <!-- SERVIZI ======================================================= -->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label">
                <xsl:value-of select="'Identificazione dei servizi'"/>
            </xsl:with-param>

            <xsl:with-param name="block">

                    <xsl:apply-templates mode="elementFop"
                                       select="./gmd:identificationInfo/*/srv:couplingType/srv:SV_CouplingType/@codeListValue">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>

                    <xsl:apply-templates mode="elementFop"
                                       select="./gmd:identificationInfo/*/srv:serviceType/gco:LocalName ">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>

                    <xsl:apply-templates mode="elementFop"
                                       select="./gmd:identificationInfo/*/srv:serviceTypeVersion">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>

                    <xsl:for-each select="./gmd:identificationInfo/*/srv:containsOperations">
                        <xsl:call-template name="blockElementFop">
                            <xsl:with-param name="label">
                                <xsl:value-of select="'Operazione'"/>
                            </xsl:with-param>
                            <xsl:with-param name="block">
                                <xsl:apply-templates mode="elementFop" select=".">
                                    <xsl:with-param name="schema" select="$schema"/>
                                </xsl:apply-templates>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>

                    <xsl:for-each select="./gmd:identificationInfo/*/srv:coupledResource/srv:SV_CoupledResource">
                        <xsl:call-template name="blockElementFop">
                            <xsl:with-param name="label">
                                <xsl:value-of select="'Risorsa accoppiata'"/>
                            </xsl:with-param>
                            <xsl:with-param name="block">

                                <xsl:apply-templates mode="simpleElementFop" select="srv:identifier/gco:CharacterString">
                                    <xsl:with-param name="title" select="'Titolo'"/>
                                    <xsl:with-param name="text">
                                        <xsl:call-template name="getMetadataTitle">
                                            <xsl:with-param name="uuid" select="srv:identifier/gco:CharacterString"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:apply-templates>

                                <xsl:apply-templates mode="elementFop" select="srv:operationName|srv:identifier">
                                    <xsl:with-param name="schema" select="$schema"/>
                                </xsl:apply-templates>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>

            </xsl:with-param>
        </xsl:call-template>

        <!-- Constraints =================================================== -->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Vincoli sui dati'"/>
            <xsl:with-param name="block">
                <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo//gmd:MD_Constraints">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Vincoli giuridici sui dati'"/>
            <xsl:with-param name="block">
                <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo//gmd:MD_LegalConstraints">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Vincoli di sicurezza sui dati'"/>
            <xsl:with-param name="block">
                <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo//gmd:MD_SecurityConstraints">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:call-template>

        <!-- Geographical extent =========================================== -->

        <xsl:variable name="geoDesc">
            <xsl:apply-templates mode="elementFop" select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:description">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="geoBbox">
            <xsl:apply-templates mode="elementFop"
                               select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="timeExtent">
            <xsl:choose>
                <xsl:when test="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
                    <xsl:apply-templates mode="elementFop"
                            select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
                    <xsl:variable name="timeBegin" select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
                    <xsl:variable name="timeEnd"   select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>

                    <xsl:apply-templates mode="simpleElementFop"
                                       select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="text" select="concat($timeBegin, ' / ', $timeEnd)"/>
                    </xsl:apply-templates>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="vertExtent">
            <xsl:choose>
                <xsl:when test="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:verticalElement">
                    <xsl:variable name="vertMin" select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent//gmd:minimumValue"/>
                    <xsl:variable name="vertMax" select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent//gmd:maximumValue"/>

                    <xsl:apply-templates mode="simpleElementFop"
                                       select="./gmd:identificationInfo/*/*:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="text" select="concat(normalize-space($vertMin), ' / ', normalize-space($vertMax))"/>
                    </xsl:apply-templates>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>


        <xsl:variable name="geoExtent">
            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="block" select="$geoDesc"/>
            </xsl:call-template>

            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="block" select="$geoBbox"/>
                <xsl:with-param name="label" select="'Estensione spaziale'"/>
            </xsl:call-template>

            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="block" select="$vertExtent"/>
                <xsl:with-param name="label" select="'Estensione verticale'"/>
            </xsl:call-template>
            
            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="block" select="$timeExtent"/>
                <xsl:with-param name="label" select="'Estensione temporale'"/>
<!--                <xsl:with-param name="label">
                    <xsl:value-of
                        select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='gmd:temporalElement']/label"/>
                </xsl:with-param>-->
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="block" select="$geoExtent"/>
            <xsl:with-param name="label" select="'Estensione'"/>
                <!--<xsl:value-of select="/root/gui/schemas/*[name()=$schema]/labels/element[@name='gmd:EX_Extent']/label"/>-->
            <!--</xsl:with-param>-->
        </xsl:call-template>


        <!-- Genealogia ==================================================== -->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label">
                <xsl:value-of select="/root/gui/schemas/iso19139.rndt/strings/quality/title"/>
            </xsl:with-param>
            <xsl:with-param name="block">

                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:levelDescription">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <xsl:if test="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy">
                    <xsl:variable name ="posacc" select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy"/>
                    <xsl:apply-templates mode="simpleElementFop" select="$posacc/gmd:result">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="text" select="concat(normalize-space($posacc//gmd:value),' (', normalize-space($posacc//gmd:valueUnit), ')')"/>
                    </xsl:apply-templates>
                </xsl:if>


                <xsl:variable name="explanation" select="normalize-space(./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation)"/>

                <xsl:apply-templates mode="simpleElementFop"
                                     select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="title">
                            <xsl:call-template name="getTitle">
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="name" select="'gmd:pass'"/>
                            </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="$explanation"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

            </xsl:with-param>
        </xsl:call-template>

        <!-- RISORSE ONLINE ================================================ -->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Distribuzione'"/>
            <xsl:with-param name="block">

                <xsl:call-template name="blockElementFop">
                    <xsl:with-param name="label" select="'Formato'"/>
                    <xsl:with-param name="block">
                        <xsl:apply-templates mode="elementFop"
                                           select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:apply-templates>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="blockElementFop">
                    <xsl:with-param name="label">
                        <xsl:value-of select="'Distributore'"/>
                    </xsl:with-param>
                    <xsl:with-param name="block">
                        <xsl:apply-templates mode="elementFop" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact">
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:apply-templates>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:for-each select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
                    <xsl:call-template name="blockElementFop">
                        <xsl:with-param name="label" select="'Risorsa online'"/>
                        <xsl:with-param name="block">
                            <xsl:apply-templates mode="elementFop" select="gmd:linkage | gmd:protocol">
                                <xsl:with-param name="schema" select="$schema"/>
                            </xsl:apply-templates>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>

            </xsl:with-param>
        </xsl:call-template>

        <!-- CRS =========================================================== -->

        <!-- Spatial Reference System -->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label">
                <xsl:value-of select="'CRS'"/>
            </xsl:with-param>
            <xsl:with-param name="block">
                <xsl:apply-templates mode="elementFop" select="//gmd:referenceSystemInfo">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:call-template>
        
        <!-- Conformance =================================================== -->
        
        <xsl:if
            test="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult[contains(gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString, 'INSPIRE')]">
            <xsl:variable name="conf">
                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="elementFop"
                                   select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="block" select="$conf"/>
                <xsl:with-param name="label">INSPIRE</xsl:with-param>
            </xsl:call-template>
        </xsl:if>


        <!-- UPDATE FREQ =================================================== -->

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Gestione dei dati'"/>
            <xsl:with-param name="block">

                <xsl:apply-templates mode="elementFop" select="gmd:identificationInfo/*/gmd:resourceMaintenance">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:call-template>

        <!-- METADATI ====================================================== -->

        <xsl:variable name="parentId">
            <xsl:choose>
                <xsl:when test="./gmd:parentIdentifier/gco:CharacterString!=''">
                    <xsl:value-of select="./gmd:parentIdentifier/gco:CharacterString"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./gmd:fileIdentifier"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="blockElementFop">
            <xsl:with-param name="label" select="'Metadati'"/>
            <xsl:with-param name="block">
                
                <xsl:apply-templates mode="elementFop" select="./gmd:fileIdentifier">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="simpleElementFop" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="title">
                        <xsl:call-template name="getTitle">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="name" select="name(gmd:parentIdentifier)"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="normalize-space($parentId)"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementFop" select="./gmd:language">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <!-- Encoding -->
                <xsl:apply-templates mode="elementFop" select="./gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementFop"
                                     select="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementFop" select="./gmd:dateStamp">
                    <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>

            <xsl:call-template name="blockElementFop">
                <xsl:with-param name="label">
                    <xsl:value-of select="'Responsabile dei metadati'"/>
                </xsl:with-param>
                <xsl:with-param name="block">
                    <xsl:apply-templates mode="elementFop" select="./gmd:contact/gmd:CI_ResponsibleParty">
                        <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>
                </xsl:with-param>
            </xsl:call-template>


            </xsl:with-param>
        </xsl:call-template>


    </xsl:template>

    <!-- =================================================================== -->

    <xsl:template mode="fopTheDate" match="gmd:CI_Date">
        <xsl:param name="schema"/>

        <xsl:variable name="date">
                    <xsl:apply-templates mode="getTextForFOP" select="gmd:date">
                      <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="datetype">
                    <xsl:apply-templates mode="getTextForFOP" select="gmd:dateType/gmd:CI_DateTypeCode">
                      <xsl:with-param name="schema" select="$schema"/>
                    </xsl:apply-templates>
        </xsl:variable>

        <xsl:apply-templates mode="simpleElementFop" select="gmd:date">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="text" select="concat(normalize-space($datetype),': ', normalize-space($date))"/>
        </xsl:apply-templates>

    </xsl:template>

    <!-- =================================================================== -->

    <xsl:template mode="getTextForFOP" match="*|@*">
        <xsl:param name="schema"/>

        <xsl:call-template name="getElementText">
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>

    </xsl:template>

</xsl:stylesheet>
