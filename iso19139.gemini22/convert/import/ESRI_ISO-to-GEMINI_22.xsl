<?xml version="1.0" encoding="utf-8"?>
<!-- 
  James Rapaport 
  SeaZone Solutions Limited
  2010-11-15
  
  This stylesheet is designed to tranform ESRI ISO metadata produced
  by ESRI ArcCatalog to the GEMINI 2.1 discovery metadata standard. 
  
  2011-02-07 - Support for service metadata
  2014-12-01 - Port to gemini22 schema plugin (Emanuele Tajariol AT GeoSolutions)

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="gml" version="1.0" >
    <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes" />
    <!-- ========================================================================== -->
    <!-- Parameters                                                                 -->
    <!-- ========================================================================== -->
    <xsl:param name="CodeListUri">
        <xsl:text>http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#</xsl:text>
    </xsl:param>
    <xsl:param name="LanguageCodeUri">
        <xsl:text>http://www.loc.gov/standards/iso639-2/php/code_list.php</xsl:text>
    </xsl:param>
    <!-- ========================================================================== -->
    <!-- Variables                                                                  -->
    <!-- ========================================================================== -->
    <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="resourceType">
        <xsl:choose>
            <xsl:when test="count(/metadata/mdHrLv/ScopeCd)!=0">
                <xsl:call-template name="GetScopeCode">
                    <xsl:with-param name="esriScopeCode" select="/metadata/mdHrLv/ScopeCd/@value" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="count(/metadata/mdHrLvName[@Sync='TRUE'])!=0">
                <xsl:value-of select="/metadata/mdHrLvName" />
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <!-- ========================================================================== -->
    <!-- Core Template                                                              -->
    <!-- ========================================================================== -->
    <xsl:template match="/*">
        <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd"
                     xmlns:gco="http://www.isotc211.org/2005/gco"
                     xmlns:gmx="http://www.isotc211.org/2005/gmx"
                     xmlns:gsr="http://www.isotc211.org/2005/gsr"
                     xmlns:gss="http://www.isotc211.org/2005/gss"
                     xmlns:gts="http://www.isotc211.org/2005/gts"
                     xmlns:srv="http://www.isotc211.org/2005/srv"
                     xmlns:gml="http://www.opengis.net/gml"
                     xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="MD_Metadata" />
        </gmd:MD_Metadata>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- MD_Metadata                                                                -->
    <!-- ========================================================================== -->
    <xsl:template name="MD_Metadata">
        <!-- Metadata file identifier -->
        <xsl:call-template name="fileIdentifier" />
        <!-- Metadata language -->
        <xsl:call-template name="language">
            <xsl:with-param name="IsoLangCode" select="./mdLang/languageCode" />
            <xsl:with-param name="FgdcLangCode" select="./metainfo/langmeta" />
            <xsl:with-param name="GeminiItemName">
                <xsl:text>Metadata language</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <!-- Character set -->
        <xsl:call-template name="characterSet" />
        <!-- Resource type -->
        <xsl:call-template name="hierarchyLevel" />
        <!-- Metadata contact -->
        <xsl:call-template name="metadataContact">
            <xsl:with-param name="IsoElement" select="./mdContact" />
            <xsl:with-param name="FgdcElement" select="./metaInfo/metc/cntinfo" />
        </xsl:call-template>
        <!-- Metadata date -->
        <xsl:call-template name="dateStamp" />
        <!-- Metadata standard information -->
        <xsl:call-template name="metadataNameVersion" />
        <!-- Reference system information -->
        <xsl:call-template name="referenceSystemInfo" />
        <!-- Identification information -->
        <xsl:call-template name="identificationInfo" />
        <!-- Distribution information -->
        <xsl:call-template name="distributionInfo" />
        <!-- Data quality information -->
        <xsl:call-template name="dataQualityInfo"/>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Metadata standard information                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="metadataNameVersion">
        <gmd:metadataStandardName>
            <gco:CharacterString>UK GEMINI</gco:CharacterString>
        </gmd:metadataStandardName>
        <gmd:metadataStandardVersion>
            <gco:CharacterString>2.2</gco:CharacterString>
        </gmd:metadataStandardVersion>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Metadata file identifier                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="fileIdentifier">
        <xsl:comment>Metadata file identifier</xsl:comment>
        <xsl:element name="gmd:fileIdentifier" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
                <xsl:when test="count(./Esri/MetaID)!=0">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="translate(./Esri/MetaID,'{}','')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value">
                            <xsl:text/> <!-- Output empty text if there is no identifier -->
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Character set                                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="characterSet">
        <xsl:if test="mdChar/CharSetCd">
            <xsl:comment>
                <xsl:text>Character set</xsl:text>
            </xsl:comment>
            <xsl:element name="gmd:characterSet" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:MD_CharacterSetCode" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="CodeListAttributes">
                        <xsl:with-param name="CodeList">
                            <xsl:text>MD_CharacterSetCode</xsl:text>
                        </xsl:with-param>
                        <xsl:with-param name="CodeListValue">
                            <xsl:call-template name="GetCharacterSetCode">
                                <xsl:with-param name="esriCode" select="mdChar/CharSetCd/@value"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Resource type                                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="hierarchyLevel">
        <xsl:comment>Resource type</xsl:comment>
        <xsl:element name="gmd:hierarchyLevel" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_ScopeCode" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="CodeListAttributes">
                    <xsl:with-param name="CodeList">
                        <xsl:text>MD_ScopeCode</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="CodeListValue" select="$resourceType"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Metadata contact                                                           -->
    <!-- ========================================================================== -->
    <xsl:template name="metadataContact">
        <xsl:param name="IsoElement" />
        <xsl:param name="FgdcElement" />
        <xsl:comment>Metadata point of contact</xsl:comment>
        <xsl:choose>
            <xsl:when test="count($IsoElement)!=0">
                <xsl:for-each select="$IsoElement">
                    <xsl:element name="gmd:contact" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CI_ResponsibleParty">
                            <xsl:with-param name="value" select="." />
                            <xsl:with-param name="metadataContact">
                                <xsl:text>true</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="count($FgdcElement)!=0 and contains($FgdcElement/cntinfo/cntperp/cntorg,'REQUIRED:')=false">
                <xsl:for-each select="$FgdcElement">
                    <xsl:element name="gmd:contact" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CI_ResponsibleParty">
                            <xsl:with-param name="value" select="." />
                            <xsl:with-param name="metadataContact">
                                <xsl:text>true</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Metadata date                                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="dateStamp">
        <xsl:comment>Metadata date</xsl:comment>
        <xsl:element name="gmd:dateStamp" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gco:Date" namespace="http://www.isotc211.org/2005/gco">
                <xsl:choose>
                    <xsl:when test="count(./mdDateSt[/@Sync='TRUE'])!=0">
                        <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="./mdDateSt" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="count(./metainfo/metd[/@Sync='TRUE'])!=0">
                        <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="./metainfo/metd" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="count(./mdDateSt)!=0">
                        <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="./mdDateSt" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="count(./metainfo/metd)!=0">
                        <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="./metainfo/metd" />
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Reference System Information                                               -->
    <!-- ========================================================================== -->
    <xsl:template name="referenceSystemInfo">
        <xsl:comment>Spatial reference system</xsl:comment>
        <xsl:element name="gmd:referenceSystemInfo" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_ReferenceSystem" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:referenceSystemIdentifier" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:RS_Identifier" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:code" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value">
                                    <xsl:choose>
                                        <xsl:when test="count(./refSysInfo/RefSystem/refSysID/identCode[@Sync='TRUE'])!=0">
                                            <xsl:call-template name="GetEpsgCode">
                                                <xsl:with-param name="esriCode" select="./refSysInfo/RefSystem/refSysID/identCode" />
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:when test="count(./spref/horizsys/cordsysn/*[@Sync='TRUE'])!=0">
                                            <xsl:call-template name="GetEpsgCode">
                                                <xsl:with-param name="esriCode" select="./spref/horizsys/cordsysn/*" />
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:when test="count(./refSysInfo/RefSystem/refSysID/identCode)!=0">
                                            <xsl:call-template name="GetEpsgCode">
                                                <xsl:with-param name="esriCode" select="./refSysInfo/RefSystem/refSysID/identCode" />
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:when test="count(./spref/horizsys/cordsysn/*)!=0">
                                            <xsl:call-template name="GetEpsgCode">
                                                <xsl:with-param name="esriCode" select="./spref/horizsys/cordsysn/*" />
                                            </xsl:call-template>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Identification information                                                 -->
    <!-- ========================================================================== -->
    <xsl:template name="identificationInfo">
        <xsl:element name="gmd:identificationInfo" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
                <xsl:when test="$resourceType='service'">
                    <xsl:call-template name="SV_ServiceIdentification"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="MD_DataIdentification"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- SV_ServiceIdentification                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="SV_ServiceIdentification">
        <xsl:element name="srv:SV_ServiceIdentification" namespace="http://www.isotc211.org/2005/srv">
            <!-- Citation -->
            <xsl:call-template name="citation"/>
            <!-- Abstract -->
            <xsl:call-template name="abstract"/>
            <!-- Responsible organisation -->
            <xsl:call-template name="responsibleOrganisation">
                <xsl:with-param name="IsoElement" select="./dataIdInfo/idCitation/citRespParty" />
                <xsl:with-param name="FgdcElement" select="./idinfo/ptcontac/cntinfo" />
            </xsl:call-template>
            <!-- Distributor Contact -->
            <xsl:call-template name="responsibleOrganisation">
                <xsl:with-param name="IsoElement" select="./distInfo/distributor/distorCont" />
                <xsl:with-param name="FgdcElement" select="./distinfo/distrib/cntinfo" />
            </xsl:call-template>
            <!-- Maintenance and Update Frequency -->
            <xsl:call-template name="frequencyOfUpdate"/>
            <!-- Resource Format -->
            <xsl:call-template name="dataFormat"/>
            <!-- Keyword -->
            <xsl:call-template name="keyword"/>
            <!-- Limitations on public access and Use constraints -->
            <xsl:call-template name="limitationsOnPublicAccess"/>
            <!-- Use constraints -->
            <xsl:call-template name="useConstraints"/>
            <!-- Service Type -->
            <xsl:call-template name="serviceType"/>
            <!-- Extent -->
            <xsl:call-template name="extent"/>
            <!-- Coupling type -->
            <xsl:call-template name="couplingType"/>
            <!-- Contains operations -->
            <xsl:call-template name="containsOperations"/>
            <!-- Coupled resource -->
            <xsl:call-template name="coupledResource"/>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- MD_DataIdentification                                                      -->
    <!-- ========================================================================== -->
    <xsl:template name="MD_DataIdentification">
        <xsl:element name="gmd:MD_DataIdentification" namespace="http://www.isotc211.org/2005/gmd">
            <!-- Citation -->
            <xsl:call-template name="citation"/>
            <!-- Abstract -->
            <xsl:call-template name="abstract"/>
            <!-- Responsible organisation -->
            <xsl:call-template name="responsibleOrganisation">
                <xsl:with-param name="IsoElement" select="./dataIdInfo/idCitation/citRespParty" />
                <xsl:with-param name="FgdcElement" select="./idinfo/ptcontac/cntinfo" />
            </xsl:call-template>
            <!-- Distributor Contact -->
            <xsl:call-template name="responsibleOrganisation">
                <xsl:with-param name="IsoElement" select="./distInfo/distributor/distorCont" />
                <xsl:with-param name="FgdcElement" select="./distinfo/distrib/cntinfo" />
            </xsl:call-template>
            <!-- Maintenance and Update Frequency -->
            <xsl:call-template name="frequencyOfUpdate"/>
            <!-- Resource Format -->
            <xsl:call-template name="dataFormat"/>
            <!-- Keyword -->
            <xsl:call-template name="keyword"/>
            <!-- Limitations on public access and Use constraints -->
            <xsl:call-template name="limitationsOnPublicAccess"/>
            <!-- Use constraints -->
            <xsl:call-template name="useConstraints"/>
            <!-- Spatial representation type -->
            <xsl:call-template name="spatialRepresentationType"/>
            <!-- 	Spatial Resolution	-->
            <xsl:call-template name="spatialResolution" />
            <!-- Equivalent scale -->
            <xsl:call-template name="equivalentScale"/>
            <!-- Dataset language -->
            <xsl:call-template name="language">
                <xsl:with-param name="IsoLangCode" select="./dataIdInfo/dataLang/languageCode" />
                <xsl:with-param name="FgdcLangCode" select="./idinfo/descript/langdata" />
                <xsl:with-param name="GeminiItemName">
                    <xsl:text>Dataset language</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
            <!-- Topic category -->
            <xsl:call-template name="topicCategory"/>
            <!-- Extent -->
            <xsl:call-template name="extent"/>
            <!-- Additional information source -->
            <xsl:call-template name="additionalInformationSource" />
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Citation                                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="citation">
        <xsl:variable name="isoCitation" select="/metadata/dataIdInfo/idCitation"/>
        <xsl:variable name="fgdcCitation" select="/metadata/idinfo/citation/citeinfo"/>
        <xsl:element name="gmd:citation" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:CI_Citation" namespace="http://www.isotc211.org/2005/gmd">
                <!-- Resource title -->
                <xsl:comment>Resource title</xsl:comment>
                <xsl:element name="gmd:title" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value">
                            <xsl:choose>
                                <xsl:when test="count($isoCitation/resTitle)!=0">
                                    <xsl:value-of select="$isoCitation/resTitle"/>
                                </xsl:when>
                                <xsl:when test="count($fgdcCitation/title)!=0">
                                    <xsl:value-of select="$fgdcCitation/resTitle"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
                <!-- Alternative title -->
                <xsl:for-each select="$isoCitation/resAltTitle">
                    <xsl:comment>Alternative title</xsl:comment>
                    <xsl:element name="gmd:alternateTitle" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value" select="." />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
                <!-- Dataset reference date -->
                <xsl:comment>Dataset reference date</xsl:comment>
                <xsl:choose>
                    <xsl:when test="count($isoCitation/resRefDate) > 0">
                        <xsl:for-each select="$isoCitation/resRefDate">
                            <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CI_Date">
                                    <xsl:with-param name="date" select="./refDate" />
                                    <xsl:with-param name="type" select="./refDateType/DateTypCd/@value" />
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CI_Date">
                                <xsl:with-param name="date">
                                    <xsl:text/>
                                </xsl:with-param>
                                <xsl:with-param name="type">
                                    <xsl:text/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Unique resource identifier -->
                <xsl:if test="$resourceType='dataset'">
                    <xsl:comment>Unique resource identifier</xsl:comment>
                    <xsl:element name="gmd:identifier" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:MD_Identifier" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:element name="gmd:code" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CharacterString">
                                    <xsl:with-param name="value">
                                        <xsl:text/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="$isoCitation/presForm/PresFormCd">
                    <xsl:element name="gmd:presentationForm" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:CI_PresentationFormCode" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CodeListAttributes">
                                <xsl:with-param name="CodeList">
                                    <xsl:text>CI_PresentationFormCode</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="CodeListValue">
                                    <xsl:call-template name="GetPresentationFormCode">
                                        <xsl:with-param name="esriCode" select="@value"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Abstract                                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="abstract">
        <xsl:comment>Abstract: A brief description of the contents of the dataset</xsl:comment>
        <xsl:element name="gmd:abstract" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
                <xsl:when test="count(./dataIdInfo/idAbs)!=0">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="./dataIdInfo/idAbs" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="count(./idinfo/descript/abstract)!=0 and contains(./idinfo/descript/abstract,'REQUIRED:')=false">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="./idinfo/descript/abstract" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value">
                            <xsl:text/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Responsible organisation                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="responsibleOrganisation">
        <xsl:param name="IsoElement" />
        <xsl:param name="FgdcElement" />
        <xsl:comment>Responsible organisation</xsl:comment>
        <xsl:choose>
            <xsl:when test="count($IsoElement)!=0">
                <xsl:for-each select="$IsoElement">
                    <xsl:element name="gmd:pointOfContact" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CI_ResponsibleParty">
                            <xsl:with-param name="value" select="." />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="count($FgdcElement)!=0 and contains($FgdcElement/cntinfo/cntperp/cntorg,'REQUIRED:')=false">
                <xsl:for-each select="$FgdcElement">
                    <xsl:element name="gmd:pointOfContact" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CI_ResponsibleParty">
                            <xsl:with-param name="value" select="." />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Spatial representation type                                                -->
    <!-- ========================================================================== -->
    <xsl:template name="spatialRepresentationType">
        <xsl:for-each select="./dataIdInfo/spatRpType/SpatRepTypCd">
            <xsl:comment>
                <xsl:text>Spatial representation type</xsl:text>
            </xsl:comment>
            <xsl:element name="gmd:spatialRepresentationType" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:MD_SpatialRepresentationTypeCode" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="CodeListAttributes">
                        <xsl:with-param name="CodeList">
                            <xsl:text>MD_SpatialRepresentationTypeCode</xsl:text>
                        </xsl:with-param>
                        <xsl:with-param name="CodeListValue">
                            <xsl:call-template name="GetSpatialRepresentationTypeCode">
                                <xsl:with-param name="esriCode" select="@value"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Frequency of update                                                        -->
    <!-- ========================================================================== -->
    <xsl:template name="frequencyOfUpdate">
        <xsl:comment>Frequency of update</xsl:comment>
        <xsl:element name="gmd:resourceMaintenance" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_MaintenanceInformation" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:maintenanceAndUpdateFrequency" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:choose>
                        <xsl:when test="count(./dataIdInfo/resMaint/maintFreq/MaintFreqCd)!=0">
                            <xsl:element name="gmd:MD_MaintenanceFrequencyCode" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CodeListAttributes">
                                    <xsl:with-param name="CodeList">
                                        <xsl:text>MD_MaintenanceFrequencyCode</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="CodeListValue">
                                        <xsl:call-template name="GetMaintenanceCode">
                                            <xsl:with-param name="esriCode" select="./dataIdInfo/resMaint/maintFreq/MaintFreqCd/@value" />
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:when>
                        <!-- FGDC uses same update list as ISO but encodes with capitalised start. Translates to all lower case to be iso compatible -->
                        <xsl:when test="count(./idinfo/status/update)!=0 and contains(./idinfo/status/update,'REQUIRED:')=false">
                            <xsl:element name="gmd:MD_MaintenanceFrequencyCode" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CodeListAttributes">
                                    <xsl:with-param name="CodeList">
                                        <xsl:text>MD_MaintenanceFrequencyCode</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="CodeListValue">
                                        <xsl:value-of select="translate(./idinfo/status/update,$upper,$lower)"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="gmd:MD_MaintenanceFrequencyCode" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CodeListAttributes">
                                    <xsl:with-param name="CodeList">
                                        <xsl:text>MD_MaintenanceFrequencyCode</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="CodeListValue">
                                        <xsl:text/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Data format                                                                -->
    <!-- ========================================================================== -->
    <xsl:template name="dataFormat">
        <xsl:choose>
            <xsl:when test="count(./distInfo/distributor/distorFormat/formatName)!=0">
                <xsl:comment>Data Format</xsl:comment>
                <xsl:element name="gmd:resourceFormat" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:MD_Format" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:name" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value" select="./distInfo/distributor/distorFormat/formatName" />
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:element name="gmd:version" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value" select="./distInfo/distributor/distorFormat/formatVer" />
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="count(./idinfo/nativeform)!=0">
                    <xsl:comment>Resource Format</xsl:comment>
                    <xsl:element name="gmd:resourceFormat" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:MD_Format" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:element name="gmd:name" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CharacterString">
                                    <xsl:with-param name="value" select="./idinfo/nativeform" />
                                </xsl:call-template>
                            </xsl:element>
                            <xsl:element name="gmd:version" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CharacterString">
                                    <xsl:with-param name="value">
                                        <xsl:text/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Keyword                                                                    -->
    <!-- ========================================================================== -->
    <xsl:template name="keyword">
        <xsl:comment>Keyword</xsl:comment>
        <xsl:choose>
            <!-- KeyTypCode = 002: Place keywords output as Extent -->
            <xsl:when test="count(./dataIdInfo/descKeys[@KeyTypCd != '002']) != 0">
                <xsl:for-each select="./dataIdInfo/descKeys[@KeyTypCd != '002']">
                    <xsl:element name="gmd:descriptiveKeywords" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:MD_Keywords" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:choose>
                                <xsl:when test="count(./keyword)!=0">
                                    <xsl:for-each select="./keyword">
                                        <xsl:element name="gmd:keyword" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:call-template name="CharacterString">
                                                <xsl:with-param name="value" select="." />
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="gmd:keyword" namespace="http://www.isotc211.org/2005/gmd">
                                        <xsl:call-template name="CharacterString">
                                            <xsl:with-param name="value">
                                                <xsl:text/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="count(./thesaName) = 1">
                                    <xsl:element name="gmd:thesaurusName" namespace="http://www.isotc211.org/2005/gmd">
                                        <xsl:choose>
                                            <xsl:when test="count(./thesaName/resTitle)!=0">
                                                <xsl:element name="gmd:CI_Citation" namespace="http://www.isotc211.org/2005/gmd">
                                                    <xsl:element name="gmd:title" namespace="http://www.isotc211.org/2005/gmd">
                                                        <xsl:choose>
                                                            <xsl:when test="count(./thesaName/resTitle)!=0">
                                                                <xsl:call-template name="CharacterString">
                                                                    <xsl:with-param name="value" select="./thesaName/resTitle" />
                                                                </xsl:call-template>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:call-template name="CharacterString">
                                                                    <xsl:with-param name="value">
                                                                        <xsl:text/>
                                                                    </xsl:with-param>
                                                                </xsl:call-template>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:element>
                                                    <xsl:choose>
                                                        <xsl:when test="count(./thesaName/resRefDate)!=0">
                                                            <xsl:for-each select="./thesaName/resRefDate">
                                                                <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                                                                    <xsl:call-template name="CI_Date">
                                                                        <xsl:with-param name="date" select="./refDate" />
                                                                        <xsl:with-param name="type" select="./refDateType/DateTypCd/@value" />
                                                                    </xsl:call-template>
                                                                </xsl:element>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                                                                <xsl:call-template name="CI_Date">
                                                                    <xsl:with-param name="date">
                                                                        <xsl:text/>
                                                                    </xsl:with-param>
                                                                    <xsl:with-param name="type">
                                                                        <xsl:text/>
                                                                    </xsl:with-param>
                                                                </xsl:call-template>
                                                            </xsl:element>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="gmd:descriptiveKeywords" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:MD_Keywords" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:keyword" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value">
                                    <xsl:text/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Limitations on public access                                               -->
    <!-- ========================================================================== -->
    <xsl:template name="limitationsOnPublicAccess">
        <xsl:comment>Limitations on public access</xsl:comment>
        <xsl:element name="gmd:resourceConstraints" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_LegalConstraints" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:choose>
                    <xsl:when test="count(./dataIdInfo/resConst/LegConsts/accessConsts)!=0">
                        <xsl:for-each select="./dataIdInfo/resConst/LegConsts/accessConsts">
                            <xsl:element name="gmd:accessConstraints">
                                <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CodeListAttributes">
                                        <xsl:with-param name="CodeList">
                                            <xsl:text>MD_RestrictionCode</xsl:text>
                                        </xsl:with-param>
                                        <xsl:with-param name="CodeListValue">
                                            <xsl:call-template name="GetConstraintCode">
                                                <xsl:with-param name="esriCode" select="./RestrictCd/@value"/>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="count(./idinfo/accconst)!=0 and contains(./idinfo/accconst,'REQUIRED:')=false">
                        <xsl:for-each select="./idinfo/accconst">
                            <xsl:element name="gmd:accessConstraints">
                                <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CodeListAttributes">
                                        <xsl:with-param name="CodeList">
                                            <xsl:text>MD_RestrictionCode</xsl:text>
                                        </xsl:with-param>
                                        <xsl:with-param name="CodeListValue" select="."/>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="count(./dataIdInfo/resConst/LegConsts/accessConsts/RestrictCd[@value='008']) = 0">
                    <xsl:element name="gmd:accessConstraints">
                        <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CodeListAttributes">
                                <xsl:with-param name="CodeList">
                                    <xsl:text>MD_RestrictionCode</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="CodeListValue">
                                    <xsl:call-template name="GetConstraintCode">
                                        <xsl:with-param name="esriCode">
                                            <xsl:text>008</xsl:text>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="./dataIdInfo/resConst/LegConsts/useConsts">
                    <xsl:element name="gmd:useConstraints">
                        <xsl:element name="gmd:MD_RestrictionCode" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CodeListAttributes">
                                <xsl:with-param name="CodeList">
                                    <xsl:text>MD_RestrictionCode</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="CodeListValue">
                                    <xsl:call-template name="GetConstraintCode">
                                        <xsl:with-param name="esriCode" select="./RestrictCd/@value"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="count(./dataIdInfo/resConst/LegConsts/othConsts) = 0">
                        <xsl:element name="gmd:otherConstraints" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value">
                                    <xsl:text/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="./dataIdInfo/resConst/LegConsts/othConsts">
                            <xsl:element name="gmd:otherConstraints" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CharacterString">
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Use constraints                                                            -->
    <!-- ========================================================================== -->
    <xsl:template name="useConstraints">
        <xsl:comment>Use constraints</xsl:comment>
        <xsl:element name="gmd:resourceConstraints" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:MD_Constraints" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:useLimitation" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:choose>
                        <xsl:when test="count(./dataIdInfo/resConst/Consts/useLimit)!=0">
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value" select="./dataIdInfo/resConst/Consts/useLimit" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="CharacterString">
                                <xsl:with-param name="value">
                                    <xsl:text/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Spatial resolution                                                         -->
    <!-- ========================================================================== -->
    <xsl:template name="spatialResolution">
        <xsl:comment>Spatial resolution</xsl:comment>
        <xsl:for-each select="./dataIdInfo/dataScale/scaleDist">
            <xsl:element name="gmd:spatialResolution" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:MD_Resolution" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:distance" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="Distance">
                            <xsl:with-param name="uom">
                                <xsl:value-of select="./uom/UomScale/uomName"/>
                            </xsl:with-param>
                            <xsl:with-param name="value">
                                <xsl:value-of select="./value"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Equivalent scale                                                           -->
    <!-- ========================================================================== -->
    <xsl:template name="equivalentScale">
        <xsl:comment>Equivalent scale</xsl:comment>
        <!-- ESRI ISO can contain scale range -->
        <xsl:for-each select="./dataIdInfo/dataScale/equScale">
            <xsl:choose>
                <xsl:when test="contains(./rfDenom,'/')">
                    <xsl:element name="gmd:spatialResolution" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="MD_Resolution_EquivalentScale">
                            <xsl:with-param name="value" select="substring-before(./rfDenom,'/')"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="gmd:spatialResolution" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="MD_Resolution_EquivalentScale">
                            <xsl:with-param name="value" select="substring-after(./rfDenom,'/')"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="gmd:spatialResolution" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="MD_Resolution_EquivalentScale">
                            <xsl:with-param name="value" select="./rfDenom"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Language                                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="language">
        <xsl:param name="IsoLangCode" />
        <xsl:param name="FgdcLangCode" />
        <xsl:param name="GeminiItemName"/>
        <xsl:choose>
            <xsl:when test="count($IsoLangCode)!=0">
                <xsl:comment>
                    <xsl:value-of select="$GeminiItemName"/>
                </xsl:comment>
                <xsl:element name="gmd:language" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="LanguageCode">
                        <xsl:with-param name="value">
                            <xsl:call-template name="GetLanguageCode">
                                <xsl:with-param name="esriCode" select="$IsoLangCode/@value" />
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count($FgdcLangCode[@Sync='TRUE'])!=0 and contains($FgdcLangCode,'REQUIRED:')=false">
                <xsl:comment>
                    <xsl:value-of select="$GeminiItemName"/>
                </xsl:comment>
                <xsl:element name="gmd:language" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="LanguageCode">
                        <xsl:with-param name="value">
                            <xsl:call-template name="GetLanguageCode">
                                <xsl:with-param name="esriCode" select="$FgdcLangCode" />
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Metadata language not found. Defaulted to "eng"</xsl:comment>
                <xsl:element name="gmd:language" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="LanguageCode">
                        <xsl:with-param name="value">
                            <xsl:text>eng</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Topic category                                                             -->
    <!-- ========================================================================== -->
    <xsl:template name="topicCategory">
        <xsl:comment>Topic category</xsl:comment>
        <xsl:choose>
            <xsl:when test="count(./dataIdInfo/tpCat)!=0">
                <xsl:for-each select="./dataIdInfo/tpCat">
                    <xsl:element name="gmd:topicCategory" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:MD_TopicCategoryCode" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="GetTopicCategory">
                                <xsl:with-param name="esriCode" select="./TopicCatCd/@value" />
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="gmd:topicCategory" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:MD_TopicCategoryCode" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:text/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Service Type                                                               -->
    <!-- ========================================================================== -->
    <xsl:template name="serviceType">
        <xsl:element name="srv:serviceType" namespace="http://www.isotc211.org/2005/srv">
            <xsl:element name="gco:LocalName" namespace="http://www.isotc211.org/2005/gco"/>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Extent                                                                     -->
    <!-- ========================================================================== -->
    <xsl:template name="extent">
        <xsl:comment>
            <xsl:value-of select="$resourceType"/>
        </xsl:comment>
        <xsl:choose>
            <xsl:when test="$resourceType='service'">
                <xsl:element name="srv:extent" namespace="http://www.isotc211.org/2005/srv">
                    <xsl:call-template name="EX_Extent"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="gmd:extent" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="EX_Extent"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- EX_Extent                                                                  -->
    <!-- ========================================================================== -->
    <xsl:template name="EX_Extent">
        <xsl:element name="gmd:EX_Extent" namespace="http://www.isotc211.org/2005/gmd">
            <!-- Extent (by geographic keyword) -->
            <xsl:call-template name="geographicDescription"/>
            <!-- Geographic bounding box -->
            <xsl:call-template name="geographicBoundingBox"/>
            <!-- Temporal extent -->
            <xsl:call-template name="temporalExtent"/>
            <!-- Vertical extent -->
            <xsl:call-template name="verticalExtent"/>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Extent (by geographic keyword)                                             -->
    <!-- ========================================================================== -->
    <xsl:template name="geographicDescription">
        <xsl:if test="count(./dataIdInfo/descKeys[@KeyTypCd='002'])!=0">
            <xsl:comment>Extent</xsl:comment>
            <xsl:for-each select="./dataIdInfo/descKeys[@KeyTypCd='002']/keyword">
                <xsl:element name="gmd:geographicElement" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:EX_GeographicDescription" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:geographicIdentifier" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:element name="gmd:MD_Identifier" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:choose>
                                    <xsl:when test="count(../thesaName) = 1">
                                        <xsl:element name="gmd:authority" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:choose>
                                                <xsl:when test="count(../thesaName/resTitle)!=0">
                                                    <xsl:element name="gmd:CI_Citation" namespace="http://www.isotc211.org/2005/gmd">
                                                        <xsl:element name="gmd:title" namespace="http://www.isotc211.org/2005/gmd">
                                                            <xsl:choose>
                                                                <xsl:when test="count(../thesaName/resTitle)!=0">
                                                                    <xsl:call-template name="CharacterString">
                                                                        <xsl:with-param name="value" select="../thesaName/resTitle" />
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:call-template name="CharacterString">
                                                                        <xsl:with-param name="value">
                                                                            <xsl:text/>
                                                                        </xsl:with-param>
                                                                    </xsl:call-template>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:element>
                                                        <xsl:choose>
                                                            <xsl:when test="count(../thesaName/resRefDate)!=0">
                                                                <xsl:for-each select="../thesaName/resRefDate">
                                                                    <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                                                                        <xsl:call-template name="CI_Date">
                                                                            <xsl:with-param name="date" select="./refDate" />
                                                                            <xsl:with-param name="type" select="./refDateType/DateTypCd/@value" />
                                                                        </xsl:call-template>
                                                                    </xsl:element>
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                                                                    <xsl:call-template name="CI_Date">
                                                                        <xsl:with-param name="date">
                                                                            <xsl:text/>
                                                                        </xsl:with-param>
                                                                        <xsl:with-param name="type">
                                                                            <xsl:text/>
                                                                        </xsl:with-param>
                                                                    </xsl:call-template>
                                                                </xsl:element>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:element>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:element name="gmd:code" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value" select="." />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Geographic bounding box                                                    -->
    <!-- ========================================================================== -->
    <xsl:template name="geographicBoundingBox">
        <xsl:variable name="IsoGeoBox" select="./dataIdInfo/geoBox" />
        <xsl:comment>Geographic bounding box</xsl:comment>
        <xsl:element name="gmd:geographicElement" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:EX_GeographicBoundingBox" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:choose>
                    <xsl:when test="count($IsoGeoBox)!=0">
                        <xsl:call-template name="EX_GeographicBoundingBox">
                            <xsl:with-param name="west" select="$IsoGeoBox/westBL" />
                            <xsl:with-param name="east" select="$IsoGeoBox/eastBL" />
                            <xsl:with-param name="south" select="$IsoGeoBox/southBL" />
                            <xsl:with-param name="north" select="$IsoGeoBox/northBL" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="count(./idinfo/spdom/bounding[@Sync=TRUE])!=0 and count($IsoGeoBox) = 0">
                        <xsl:call-template name="EX_GeographicBoundingBox">
                            <xsl:with-param name="west" select="./idinfo/spdom/bounding/westbc" />
                            <xsl:with-param name="east" select="./idinfo/spdom/bounding/eastbc" />
                            <xsl:with-param name="south" select="./idinfo/spdom/bounding/southbc" />
                            <xsl:with-param name="north" select="./idinfo/spdom/bounding/northbc" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="EX_GeographicBoundingBox">
                            <xsl:with-param name="west">
                                <xsl:text/>
                            </xsl:with-param>
                            <xsl:with-param name="east">
                                <xsl:text/>
                            </xsl:with-param>
                            <xsl:with-param name="south">
                                <xsl:text/>
                            </xsl:with-param>
                            <xsl:with-param name="north">
                                <xsl:text/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Temporal extent                                                            -->
    <!-- ========================================================================== -->
    <xsl:template name="temporalExtent">
        <xsl:variable name="IsoTempExt" select="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_GeometricPrimitive/TM_Period" />
        <xsl:variable name="FgdcTempExt" select="/metadata/idinfo/timeperd/timeinfo/rngdates"/>
        <xsl:comment>Temporal extent</xsl:comment>
        <xsl:element name="gmd:temporalElement" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
                <xsl:when test="count($IsoTempExt/begin) !=0 and count($IsoTempExt/end)!=0">
                    <xsl:call-template name="EX_TemporalExtent">
                        <xsl:with-param name="beginDate" select="$IsoTempExt/begin"/>
                        <xsl:with-param name="endDate" select="$IsoTempExt/end"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="count($FgdcTempExt/begdate)!=0 and count($FgdcTempExt/enddate)!=0">
                    <xsl:call-template name="EX_TemporalExtent">
                        <xsl:with-param name="beginDate" select="$FgdcTempExt/begdate"/>
                        <xsl:with-param name="beginTime" select="$FgdcTempExt/begtime"/>
                        <xsl:with-param name="endDate" select="$FgdcTempExt/enddate"/>
                        <xsl:with-param name="endTime" select="$FgdcTempExt/endtime"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="EX_TemporalExtent">
                        <xsl:with-param name="beginDate">
                            <xsl:text/>
                        </xsl:with-param>
                        <xsl:with-param name="endDate">
                            <xsl:text/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Vertical extent                                                            -->
    <!-- ========================================================================== -->
    <xsl:template name="verticalExtent">
        <xsl:if test="count(//dataIdInfo/dataExt/vertEle)!=0">
            <xsl:comment>Vertical extent</xsl:comment>
            <xsl:element name="gmd:verticalElement" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:EX_VerticalExtent" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:minimumValue" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gco:Real" namespace="http://www.isotc211.org/2005/gco">
                            <xsl:value-of select="//dataIdInfo/dataExt/vertEle/vertMinVal"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="gmd:maximumValue" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gco:Real" namespace="http://www.isotc211.org/2005/gco">
                            <xsl:value-of select="//dataIdInfo/dataExt/vertEle/vertMaxVal" />
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="gmd:verticalCRS" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:attribute name="xlink:href" namespace="http://www.w3.org/1999/xlink">
                            <xsl:call-template name="GetEpsgCode">
                                <xsl:with-param name="esriCode" select="//dataIdInfo/dataExt/vertEle/vertDatum/datumID/identCode" />
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Coupling type                                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="couplingType">
        <xsl:element name="srv:couplingType" namespace="http://www.isotc211.org/2005/srv">
            <xsl:call-template name="nilReason">
                <xsl:with-param name="value">missing</xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Contains operations                                                        -->
    <!-- ========================================================================== -->
    <xsl:template name="containsOperations">
        <xsl:element name="srv:containsOperations" namespace="http://www.isotc211.org/2005/srv">
            <xsl:call-template name="nilReason">
                <xsl:with-param name="value">missing</xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Coupled resource                                                           -->
    <!-- ========================================================================== -->
    <xsl:template name="coupledResource">
        <xsl:param name="value">
            <xsl:text/>
        </xsl:param>
        <xsl:element name="srv:operatesOn" namespace="http://www.isotc211.org/2005/srv">
            <xsl:attribute name="xlink:href" namespace="http://www.w3.org/1999/xlink">
                <xsl:value-of select="$value"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Additional information source                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="additionalInformationSource">
        <xsl:comment>Additional information source</xsl:comment>
        <xsl:choose>
            <xsl:when test="./dataIdInfo/suppInfo">
                <xsl:element name="gmd:supplementalInformation" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="./dataIdInfo/suppInfo"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count(./idinfo/descript/supplinf) > 0 and contains(./idinfo/descript/supplinf,'REQUIRED:')=false">
                <xsl:element name="gmd:supplementalInformation" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="./idinfo/descript/supplinf"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Distribution information                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="distributionInfo">
        <xsl:choose>
            <xsl:when test="count(distInfo) > 0">
                <xsl:element name="gmd:distributionInfo" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:MD_Distribution" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:distributionFormat" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:call-template name="MD_Format"/>
                        </xsl:element>
                        <xsl:for-each select="distInfo/distributor">
                            <xsl:element name="gmd:distributor" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:element name="gmd:MD_Distributor" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:for-each select="distorCont">
                                        <xsl:element name="gmd:distributorContact" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:call-template name="CI_ResponsibleParty">
                                                <xsl:with-param name="value" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="distorOrdPrc">
                                        <xsl:element name="gmd:distributionOrderProcess" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:element name="gmd:MD_StandardOrderProcess" namespace="http://www.isotc211.org/2005/gmd">
                                                <xsl:if test="count(resFees) = 1">
                                                    <xsl:element name="gmd:fees" namespace="http://www.isotc211.org/2005/gmd">
                                                        <xsl:call-template name="CharacterString">
                                                            <xsl:with-param name="value" select="resFees"/>
                                                        </xsl:call-template>
                                                    </xsl:element>
                                                </xsl:if>
                                                <xsl:if test="count(ordInstr) = 1">
                                                    <xsl:element name="gmd:orderingInstructions" namespace="http://www.isotc211.org/2005/gmd">
                                                        <xsl:call-template name="CharacterString">
                                                            <xsl:with-param name="value" select="ordInstr"/>
                                                        </xsl:call-template>
                                                    </xsl:element>
                                                </xsl:if>
                                                <xsl:if test="count(ordTurn) = 1">
                                                    <xsl:element name="gmd:turnaround" namespace="http://www.isotc211.org/2005/gmd">
                                                        <xsl:call-template name="CharacterString">
                                                            <xsl:with-param name="value" select="ordTurn"/>
                                                        </xsl:call-template>
                                                    </xsl:element>
                                                </xsl:if>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="distorFormat">
                                        <xsl:element name="gmd:distributorFormat" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:call-template name="MD_Format">
                                                <xsl:with-param name="name" select="formatName"/>
                                                <xsl:with-param name="version" select="formatVer"/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="count(distorFormat) = 0">
                                        <xsl:call-template name="MD_Format"/>
                                    </xsl:if>
                                    <!-- Distributor Transfer Options -->
                                    <xsl:for-each select="distorTran">
                                        <xsl:element name="gmd:distributorTransferOptions" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:call-template name="MD_DigitalTransferOptions">
                                                <xsl:with-param name="distorTran" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                        <xsl:for-each select="distInfo/*/distorTran">
                            <xsl:element name="gmd:transferOptions" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="MD_DigitalTransferOptions">
                                    <xsl:with-param name="distorTran" select="."/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Data quality information                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="dataQualityInfo">
        <xsl:element name="gmd:dataQualityInfo" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:DQ_DataQuality" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:comment>Data quality scope</xsl:comment>
                <xsl:element name="gmd:scope" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:DQ_Scope" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:level" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:element name="gmd:MD_ScopeCode" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:call-template name="CodeListAttributes">
                                    <xsl:with-param name="CodeList">
                                        <xsl:text>MD_ScopeCode</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="CodeListValue">
                                        <xsl:call-template name="GetScopeCode">
                                            <xsl:with-param name="esriScopeCode" select="./dqInfo/dqScope/scpLvl/ScopeCd/@value" />
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                        <!-- If the scope is 'service' (ESRI code = 014) then levelDescription must be given (ISO 19115 constraint) -->
                        <xsl:if test="./dqInfo/dqScope/scpLvl/ScopeCd/@value = '014'">
                            <xsl:element name="gmd:levelDescription" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:element name="gmd:MD_ScopeDescription" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:element name="gmd:other" namespace="http://www.isotc211.org/2005/gmd">
                                        <xsl:call-template name="CharacterString">
                                            <xsl:with-param name="value">
                                                <xsl:text>service</xsl:text>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
                <xsl:comment>Lineage</xsl:comment>
                <xsl:element name="gmd:lineage" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:LI_Lineage" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:statement" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:choose>
                                <xsl:when test="count(./dqInfo/dataLineage/statement)!=0">
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value" select="./dqInfo/dataLineage/statement" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value">
                                            <xsl:text/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- EX_TemporalExtent                                                          -->
    <!-- ========================================================================== -->
    <xsl:template name="EX_TemporalExtent">
        <xsl:param name="beginDate"/>
        <xsl:param name="beginTime">
            <xsl:text/>
        </xsl:param>
        <xsl:param name="endDate"/>
        <xsl:param name="endTime">
            <xsl:text/>
        </xsl:param>
        <xsl:element name="gmd:EX_TemporalExtent" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:extent" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gml:TimePeriod" namespace="http://www.opengis.net/gml">
                    <xsl:attribute name="gml:id" namespace="http://www.opengis.net/gml">
                        <xsl:value-of select="concat('_',generate-id(..))" />
                    </xsl:attribute>
                    <!-- begin date -->
                    <xsl:element name="gml:beginPosition" namespace="http://www.opengis.net/gml">
                        <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="$beginDate"/>
                            <xsl:with-param name="time" select="$beginTime"/>
                        </xsl:call-template>
                    </xsl:element>
                    <!-- end date -->
                    <xsl:element name="gml:endPosition" namespace="http://www.opengis.net/gml">
                        <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="$endDate"/>
                            <xsl:with-param name="time" select="$endTime"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- EX_GeographicBoundingBox                                                   -->
    <!-- ========================================================================== -->
    <xsl:template name="EX_GeographicBoundingBox">
        <xsl:param name="west" />
        <xsl:param name="east" />
        <xsl:param name="south" />
        <xsl:param name="north" />
        <xsl:comment>West bounding longitude</xsl:comment>
        <xsl:element name="gmd:westBoundLongitude" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="Decimal">
                <xsl:with-param name="value" select="$west" />
            </xsl:call-template>
        </xsl:element>
        <xsl:comment>East bounding longitude</xsl:comment>
        <xsl:element name="gmd:eastBoundLongitude" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="Decimal">
                <xsl:with-param name="value" select="$east" />
            </xsl:call-template>
        </xsl:element>
        <xsl:comment>South bounding latitude</xsl:comment>
        <xsl:element name="gmd:southBoundLatitude" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="Decimal">
                <xsl:with-param name="value" select="$south" />
            </xsl:call-template>
        </xsl:element>
        <xsl:comment>North bounding latitude</xsl:comment>
        <xsl:element name="gmd:northBoundLatitude" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:call-template name="Decimal">
                <xsl:with-param name="value" select="$north" />
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- MD_Resolution - Equivalent Scale                                           -->
    <!-- ========================================================================== -->
    <xsl:template name="MD_Resolution_EquivalentScale">
        <xsl:param name="value"/>
        <xsl:element name="gmd:MD_Resolution" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:equivalentScale" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:MD_RepresentativeFraction" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:denominator" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="Integer">
                            <xsl:with-param name="value" select="$value"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- CI_ResponsibleParty                                                        -->
    <!-- ========================================================================== -->
    <xsl:template name="CI_ResponsibleParty">
        <xsl:param name="value" />
        <xsl:param name="metadataContact">
            <xsl:text>false</xsl:text>
        </xsl:param>
        <xsl:element name="gmd:CI_ResponsibleParty" namespace="http://www.isotc211.org/2005/gmd">
            <!-- Individual name -->
            <xsl:choose>
                <!-- ESRI-ISO -->
                <xsl:when test="count($value/rpIndName)!=0">
                    <xsl:element name="gmd:individualName" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value" select="$value/rpIndName" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
                <!-- FGDC -->
                <xsl:when test="count($value/cntperp/cntper)!=0">
                    <xsl:call-template name="CharacterString">
                        <xsl:with-param name="value" select="$value/cntperp/cntper" />
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
            <!-- Organisation name -->
            <xsl:choose>
                <xsl:when test="count($value/rpOrgName)!=0">
                    <xsl:element name="gmd:organisationName" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value" select="$value/rpOrgName" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="count($value/cntperp/cntorg)!=0">
                    <xsl:element name="gmd:organisationName" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value" select="$value/cntperp/cntorg" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="gmd:organisationName" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value">
                                <xsl:text/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Position name -->
            <xsl:choose>
                <xsl:when test="count($value/rpPosName)!=0">
                    <xsl:element name="gmd:positionName" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value" select="$value/rpPosName" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="count($value/cntpos)!=0">
                    <xsl:element name="gmd:positionName" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:call-template name="CharacterString">
                            <xsl:with-param name="value" select="$value/cntpos" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <!-- Contact information -->
            <xsl:element name="gmd:contactInfo" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:CI_Contact" namespace="http://www.isotc211.org/2005/gmd">
                    <!-- Telephone -->
                    <xsl:if test="count($value/rpCntInfo/cntPhone/*) + count($value/cntvoice) + count($value/cntfax) != 0">
                        <xsl:element name="gmd:phone" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:element name="gmd:CI_Telephone" namespace="http://www.isotc211.org/2005/gmd">
                                <!--add a phone number for each voice number-->
                                <xsl:for-each select="$value/rpCntInfo/cntPhone/voiceNum | $value/cntvoice">
                                    <xsl:element name="gmd:voice" namespace="http://www.isotc211.org/2005/gmd">
                                        <xsl:call-template name="CharacterString">
                                            <xsl:with-param name="value" select="." />
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:for-each>
                                <!--add a fax number for each fax number-->
                                <xsl:for-each select="$value/rpCntInfo/cntPhone/faxNum | $value/cntfax">
                                    <xsl:element name="gmd:facsimile" namespace="http://www.isotc211.org/2005/gmd">
                                        <xsl:call-template name="CharacterString">
                                            <xsl:with-param name="value" select="." />
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <!-- Address -->
                    <xsl:element name="gmd:address" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:CI_Address" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:for-each select="$value/rpCntInfo/cntAddress/delPoint | $value/cntaddr/address">
                                <xsl:element name="gmd:deliveryPoint" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value" select="." />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$value/rpCntInfo/cntAddress/city | $value/cntaddr/city">
                                <xsl:element name="gmd:city" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value" select="." />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$value/rpCntInfo/cntAddress/adminArea | $value/cntaddr/state">
                                <xsl:element name="gmd:administrativeArea" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value" select="." />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$value/rpCntInfo/cntAddress/postCode | $value/cntaddr/postal">
                                <xsl:element name="gmd:postalCode" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CharacterString">
                                        <xsl:with-param name="value" select="." />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- add a country but where a 2 letter code can be converted, convert it to the full name -->
                            <xsl:for-each select="$value/rpCntInfo/cntAddress/country | $value/cntaddr/country">
                                <xsl:element name="gmd:country" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:element name="gco:CharacterString" namespace="http://www.isotc211.org/2005/gco">
                                        <xsl:call-template name="GetCountryCode">
                                            <xsl:with-param name="esriCode" select="." />
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- add an email address for each that exists -->
                            <xsl:choose>
                                <xsl:when test="count($value/rpCntInfo/cntAddress/eMailAdd) + count($value/cntemail)!=0">
                                    <xsl:for-each select="$value/rpCntInfo/cntAddress/eMailAdd | $value/cntemail">
                                        <xsl:element name="gmd:electronicMailAddress" namespace="http://www.isotc211.org/2005/gmd">
                                            <xsl:call-template name="CharacterString">
                                                <xsl:with-param name="value" select="." />
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="gmd:electronicMailAddress" namespace="http://www.isotc211.org/2005/gmd">
                                        <xsl:call-template name="CharacterString">
                                            <xsl:with-param name="value">
                                                <xsl:text/>  <!-- Add an empty CharacterString element -->
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- NOTE: it is not possible to add an online resource for a contact with the ESRI ISO wizard-->
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!-- role -->
            <xsl:element name="gmd:role" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:element name="gmd:CI_RoleCode" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:choose>
                        <xsl:when test="$metadataContact = 'true'">
                            <xsl:call-template name="CodeListAttributes">
                                <xsl:with-param name="CodeList">
                                    <xsl:text>CI_RoleCode</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="CodeListValue">
                                    <xsl:text>pointOfContact</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="CodeListAttributes">
                                <xsl:with-param name="CodeList">
                                    <xsl:text>CI_RoleCode</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="CodeListValue">
                                    <xsl:call-template name="GetRoleCode">
                                        <xsl:with-param name="esriCode" select="$value/role/RoleCd/@value" />
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- CI_Date                                                                    -->
    <!-- ========================================================================== -->
    <xsl:template name="CI_Date">
        <xsl:param name="date" />
        <xsl:param name="type" />
        <xsl:element name="gmd:CI_Date" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:choose>
                <xsl:when test="count($date) + count($type) != 0">
                    <!-- DATE -->
                    <xsl:element name="gmd:date" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:choose>
                            <xsl:when test="count($date)!=0">
                                <xsl:call-template name="Date">
                                    <xsl:with-param name="value" select="$date"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                    <!-- Date Type Code -->
                    <xsl:element name="gmd:dateType" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:choose>
                            <xsl:when test="count($type)!=0">
                                <xsl:element name="gmd:CI_DateTypeCode" namespace="http://www.isotc211.org/2005/gmd">
                                    <xsl:call-template name="CodeListAttributes">
                                        <xsl:with-param name="CodeList">
                                            <xsl:text>CI_DateTypeCode</xsl:text>
                                        </xsl:with-param>
                                        <xsl:with-param name="CodeListValue">
                                            <xsl:call-template name="GetDateTypeCode">
                                                <xsl:with-param name="esriCode" select="$type" />
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- MD_Format                                                                  -->
    <!-- ========================================================================== -->
    <xsl:template name="MD_Format">
        <xsl:param name="name">
            <xsl:text>Unknown</xsl:text>
        </xsl:param>
        <xsl:param name="version">
            <xsl:text>Unknown</xsl:text>
        </xsl:param>
        <xsl:element name="gmd:MD_Format" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:element name="gmd:name" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="CharacterString">
                    <xsl:with-param name="value" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:element name="gmd:version" namespace="http://www.isotc211.org/2005/gmd">
                <xsl:call-template name="CharacterString">
                    <xsl:with-param name="value" select="$version"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- MD_DigitalTransferOptions                                                  -->
    <!-- ========================================================================== -->
    <xsl:template name="MD_DigitalTransferOptions">
        <xsl:param name="distorTran"/>
        <xsl:element name="gmd:MD_DigitalTransferOptions" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:for-each select="$distorTran/onLineSrc/linkage">
                <xsl:element name="gmd:onLine" namespace="http://www.isotc211.org/2005/gmd">
                    <xsl:element name="gmd:CI_OnlineResource" namespace="http://www.isotc211.org/2005/gmd">
                        <xsl:element name="gmd:linkage" namespace="http://www.isotc211.org/2005/gmd">
                            <xsl:element name="gmd:URL" namespace="http://www.isotc211.org/2005/gmd">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gco:nilReason attribute                                              -->
    <!-- ========================================================================== -->
    <xsl:template name="nilReason">
        <xsl:param name="value"/>
        <xsl:attribute name="gco:nilReason" namespace="http://www.isotc211.org/2005/gco">
            <xsl:value-of select="$value"/>
        </xsl:attribute>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gco:CharacterString elements                                         -->
    <!-- ========================================================================== -->
    <xsl:template name="CharacterString">
        <xsl:param name="value" />
        <xsl:element name="gco:CharacterString" namespace="http://www.isotc211.org/2005/gco">
            <xsl:value-of select="$value" />
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gco:Date elements                                                    -->
    <!-- ========================================================================== -->
    <xsl:template name="Date">
        <xsl:param name="value"/>
        <xsl:element name="gco:Date" namespace="http://www.isotc211.org/2005/gco">
            <xsl:call-template name="FormatDate">
                <xsl:with-param name="date" select="$value"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gco:Decimal elements                                                 -->
    <!-- ========================================================================== -->
    <xsl:template name="Decimal">
        <xsl:param name="value" />
        <xsl:element name="gco:Decimal" namespace="http://www.isotc211.org/2005/gco">
            <xsl:value-of select="$value" />
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gco:Distance elements                                                -->
    <!-- ========================================================================== -->
    <xsl:template name="Distance">
        <xsl:param name="value"/>
        <xsl:param name="uom"/>
        <xsl:element name="gco:Distance" namespace="http://www.isotc211.org/2005/gco">
            <xsl:attribute name="uom">
                <xsl:choose>
                    <xsl:when test="$uom='Meters'">
                        <xsl:text>urn:ogc:def:uom:EPSG::9001</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$uom"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="$value"/>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gmd:LanguageCode elements                                            -->
    <!-- ========================================================================== -->
    <xsl:template name="Integer">
        <xsl:param name="value"/>
        <xsl:element name="gco:Integer" namespace="http://www.isotc211.org/2005/gco">
            <xsl:value-of select="$value"/>
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write gmd:LanguageCode elements                                            -->
    <!-- ========================================================================== -->
    <xsl:template name="LanguageCode">
        <xsl:param name="value" />
        <xsl:element name="gmd:LanguageCode" namespace="http://www.isotc211.org/2005/gmd">
            <xsl:attribute name="codeList">
                <xsl:value-of select="$LanguageCodeUri"/>
            </xsl:attribute>
            <xsl:attribute name="codeListValue">
                <xsl:value-of select="$value"/>
            </xsl:attribute>
            <xsl:value-of select="$value" />
        </xsl:element>
    </xsl:template>
    <!-- ========================================================================== -->
    <!-- Write code list attributes                                                 -->
    <!-- ========================================================================== -->
    <xsl:template name="CodeListAttributes">
        <xsl:param name="CodeList"/>
        <xsl:param name="CodeListValue"/>
        <xsl:attribute name="codeList">
            <xsl:value-of select="$CodeListUri"/>
            <xsl:value-of select="$CodeList"/>
        </xsl:attribute>
        <xsl:attribute name="codeListValue">
            <xsl:value-of select="$CodeListValue"/>
        </xsl:attribute>
        <xsl:value-of select="$CodeListValue"/>
    </xsl:template>
    <!-- ========================================================= -->
    <!-- Convert 2 letter language codes to 3 where possible       -->
    <!-- ========================================================= -->
    <xsl:template name="GetLanguageCode">
        <xsl:param name="esriCode" />
        <!-- Only the four language codes below can be encoded using ESRI software -->
        <xsl:choose>
            <xsl:when test="$esriCode='en'">
                <xsl:text>eng</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='cy'">
                <xsl:text>cym</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='gd'">
                <xsl:text>gla</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ga'">
                <xsl:text>gle</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- =============================================================== -->
    <!-- Convert 2 letter country codes to ordinary where possible       -->
    <!-- =============================================================== -->
    <xsl:template name="GetCountryCode">
        <xsl:param name="esriCode" />
        <!-- Only the four 2-letter country abbreviations below have been translated
        from ESRI code as no list is published by ESRI -->
        <xsl:choose>
            <xsl:when test="$esriCode='dk'">
                <xsl:text>Denmark</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='fr'">
                <xsl:text>France</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='us'">
                <xsl:text>United States of America</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='gb'">
                <xsl:text>United Kingdom</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ====================================================== -->
    <!-- Convert Scope Code from ESRI Code to ISO19115/19139    -->
    <!-- ====================================================== -->
    <xsl:template name="GetScopeCode">
        <xsl:param name="esriScopeCode" />
        <!-- Only the Sixteen scope codes below can be encoded using ESRI software -->
        <xsl:choose>
            <xsl:when test="$esriScopeCode='001'">
                <xsl:text>attribute</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='002'">
                <xsl:text>attributeType</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='003'">
                <xsl:text>collectionHardware</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='004'">
                <xsl:text>collectionSession</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='005'">
                <xsl:text>dataset</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='006'">
                <xsl:text>series</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='007'">
                <xsl:text>nonGeographicDataset</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='008'">
                <xsl:text>dimensionGroup</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='009'">
                <xsl:text>feature</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='010'">
                <xsl:text>featureType</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='011'">
                <xsl:text>propertyType</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='012'">
                <xsl:text>fielSession</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='013'">
                <xsl:text>software</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='014'">
                <xsl:text>service</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='015'">
                <xsl:text>model</xsl:text>
            </xsl:when>
            <xsl:when test="$esriScopeCode='016'">
                <xsl:text>title</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriScopeCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ======================================================================= -->
    <!-- Convert Presentation Form Code from ESRI Code to ISO19115               -->
    <!-- ======================================================================= -->
    <xsl:template name="GetPresentationFormCode">
        <xsl:param name="esriCode"/>
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>documentDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>documentHardcopy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>imageDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>imageHardcopy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>mapDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>mapHardcopy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>modelDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>modelHardcopy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='009'">
                <xsl:text>profileDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='010'">
                <xsl:text>profileHardcopy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='011'">
                <xsl:text>tableDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='012'">
                <xsl:text>tableHardcopy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='013'">
                <xsl:text>videoDigital</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='014'">
                <xsl:text>videoHardcopy</xsl:text> <!-- Whatever that means -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ======================================================================= -->
    <!-- Convert Responsible Party Role Code from ESRI Code to ISO19115/19139    -->
    <!-- ======================================================================= -->
    <xsl:template name="GetRoleCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>resourceProvider</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>custodian</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>owner</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>user</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>distributor</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>originator</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>pointOfContact</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>principalInvestigator</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='009'">
                <xsl:text>processor</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='010'">
                <xsl:text>publisher</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='011'">
                <xsl:text>author</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ============================================================ -->
    <!-- Convert ESRI CRS Identifiers to EPSG URNs                    -->
    <!-- ============================================================ -->
    <xsl:template name="GetEpsgCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='GCS_Airy_1830'">
                <xsl:text>urn:ogc:def:crs:EPSG::4001</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_ETRS_1989'">
                <xsl:text>urn:ogc:def:crs:EPSG::4258</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_Airy_Modified'">
                <xsl:text>urn:ogc:def:crs:EPSG::4002</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='British_National_Grid'">
                <xsl:text>urn:ogc:def:crs:EPSG::27700</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_WGS_1972'">
                <xsl:text>urn:ogc:def:crs:EPSG::4322</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_WGS_1972_BE'">
                <xsl:text>urn:ogc:def:crs:EPSG::4324</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_WGS_1984'">
                <xsl:text>urn:ogc:def:crs:EPSG::4326</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_GRS_1980'">
                <xsl:text>urn:ogc:def:crs:EPSG::4019</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_OSNI_1952'">
                <xsl:text>urn:ogc:def:crs:EPSG::4188</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_European_1950_ED77'">
                <xsl:text>urn:ogc:def:crs:EPSG::4154</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_IRENET95'">
                <xsl:text>urn:ogc:def:crs:EPSG::4173</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_OSGB_1936'">
                <xsl:text>urn:ogc:def:crs:EPSG::4277</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_OSGB_1970_SN'">
                <xsl:text>urn:ogc:def:crs:EPSG::4278</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_OS_SN_1980'">
                <xsl:text>urn:ogc:def:crs:EPSG::4279</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='IRENET95_Irish_Transverse_Mercator'">
                <xsl:text>urn:ogc:def:crs:EPSG::2157</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='IRENET95_UTM_Zone_29N'">
                <xsl:text>urn:ogc:def:crs:EPSG::2158</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_28N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23028</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_29N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23029</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_30N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23030</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_31N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23031</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_32N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23032</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_33N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23033</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_34N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23034</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_35N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23035</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_36N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23036</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_37N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23037</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_UTM_Zone_38N'">
                <xsl:text>urn:ogc:def:crs:EPSG::23038</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_TM65'">
                <xsl:text>urn:ogc:def:crs:EPSG::4299</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='GCS_TM75'">
                <xsl:text>urn:ogc:def:crs:EPSG::4300</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_ED77_UTM_Zone_38N'">
                <xsl:text>urn:ogc:def:crs:EPSG::2058</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_ED77_UTM_Zone_39N'">
                <xsl:text>urn:ogc:def:crs:EPSG::2059</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_ED77_UTM_Zone_40N'">
                <xsl:text>urn:ogc:def:crs:EPSG::2060</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ED_1950_ED77_UTM_Zone_41N'">
                <xsl:text>urn:ogc:def:crs:EPSG::2061</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_28N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25828</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_29N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25829</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Pulkovo_1942_3_Degree_GK_CM_24E'">
                <xsl:text>urn:ogc:def:crs:EPSG::2583</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_30N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25830</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_31N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25831</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_32N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25832</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_33N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25833</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_34N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25834</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_35N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25835</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_36N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25836</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_37N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25837</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_UTM_Zone_38N'">
                <xsl:text>urn:ogc:def:crs:EPSG::25838</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='TM65_Irish_Grid'">
                <xsl:text>urn:ogc:def:crs:EPSG::29900</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='OSNI_1952_Irish_National_Grid'">
                <xsl:text>urn:ogc:def:crs:EPSG::29901</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='TM65_Irish_Grid'">
                <xsl:text>urn:ogc:def:crs:EPSG::29902</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='TM75_Irish_Grid'">
                <xsl:text>urn:ogc:def:crs:EPSG::29903</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_LAEA'">
                <xsl:text>urn:ogc:def:crs:EPSG::3035</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_Guernsey_Grid'">
                <xsl:text>urn:ogc:def:crs:EPSG::3108</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='ETRS_1989_Jersey_Transverse_Mercator'">
                <xsl:text>urn:ogc:def:crs:EPSG::3109</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_1N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32201</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_2N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32202</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_3N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32203</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_4N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32204</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_5N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32205</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_6N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32206</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_7N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32207</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_8N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32208</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_9N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32209</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_10N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32210</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_11N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32211</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_12N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32212</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_13N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32213</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_14N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32214</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_15N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32215</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_16N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32216</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_17N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32217</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_18N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32218</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_19N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32219</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_20N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32220</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_21N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32221</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_22N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32222</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_23N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32223</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_24N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32224</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_25N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32225</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_26N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32226</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_27N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32227</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_28N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32228</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_29N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32229</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_30N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32230</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_31N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32231</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_32N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32232</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_33N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32233</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_34N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32234</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_35N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32235</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_36N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32236</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_37N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32237</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_38N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32238</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_39N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32239</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_40N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32240</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_41N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32241</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_42N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32242</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_43N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32243</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_44N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32244</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_45N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32245</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_46N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32246</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_47N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32247</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_48N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32248</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_49N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32249</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_50N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32250</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_51N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32251</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_52N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32252</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_53N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32253</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_54N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32254</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_55N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32255</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_56N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32256</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_57N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32257</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_58N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32258</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_59N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32259</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_60N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32260</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_1S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32301</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_2S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32302</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_3S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32303</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_4S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32304</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_5S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32305</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_6S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32306</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_7S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32307</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_8S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32308</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_9S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32309</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_10S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32310</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_11S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32311</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_12S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32312</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_13S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32313</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_14S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32314</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_15S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32315</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_16S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32316</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_17S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32317</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_18S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32318</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_19S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32319</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_20S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32320</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_21S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32321</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_22S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32322</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_23S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32323</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_24S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32324</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_25S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32325</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_26S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32326</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_27S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32327</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_28S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32328</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_29S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32329</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_30S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32330</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_31S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32331</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_32S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32332</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_33S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32333</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_34S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32334</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_35S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32335</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_36S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32336</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_37S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32337</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_38S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32338</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_39S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32339</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_40S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32340</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_41S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32341</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_42S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32342</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_43S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32343</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_44S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32344</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_45S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32345</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_46S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32346</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_47S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32347</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_48S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32348</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_49S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32349</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_50S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32350</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_51S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32351</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_52S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32352</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_53S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32353</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_54S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32354</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_55S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32355</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_56S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32356</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_57S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32357</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_58S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32358</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_59S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32359</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1972_UTM_Zone_60S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32360</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_1N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32601</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_2N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32602</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_3N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32603</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_4N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32604</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_5N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32605</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_6N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32606</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_7N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32607</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_8N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32608</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_9N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32609</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_10N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32610</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_11N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32611</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_12N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32612</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_13N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32613</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_14N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32614</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_15N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32615</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_16N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32616</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_17N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32617</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_18N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32618</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_19N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32619</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_20N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32620</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_21N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32621</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_22N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32622</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_23N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32623</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_24N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32624</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_25N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32625</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_26N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32626</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_27N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32627</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_28N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32628</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_29N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32629</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_30N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32630</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_31N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32631</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_32N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32632</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_33N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32633</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_34N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32634</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_35N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32635</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_36N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32636</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_37N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32637</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_38N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32638</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_39N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32639</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_40N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32640</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_41N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32641</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_42N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32642</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_43N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32643</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_44N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32644</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_45N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32645</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_46N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32646</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_47N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32647</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_48N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32648</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_49N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32649</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_50N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32650</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_51N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32651</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_52N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32652</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_53N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32653</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_54N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32654</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_55N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32655</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_56N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32656</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_57N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32657</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_58N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32658</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_59N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32659</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_60N'">
                <xsl:text>urn:ogc:def:crs:EPSG::32660</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='UPS_North'">
                <xsl:text>urn:ogc:def:crs:EPSG::32661</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_Plate_Carree'">
                <xsl:text>urn:ogc:def:crs:EPSG::32662</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_BLM_Zone_14N_ftUS'">
                <xsl:text>urn:ogc:def:crs:EPSG::32664</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_BLM_Zone_15N_ftUS'">
                <xsl:text>urn:ogc:def:crs:EPSG::32665</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_BLM_Zone_16N_ftUS'">
                <xsl:text>urn:ogc:def:crs:EPSG::32666</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_BLM_Zone_17N_ftUS'">
                <xsl:text>urn:ogc:def:crs:EPSG::32667</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_1S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32701</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_2S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32702</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_3S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32703</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_4S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32704</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_5S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32705</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_6S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32706</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_7S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32707</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_8S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32708</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_9S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32709</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_10S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32710</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_11S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32711</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_12S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32712</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_13S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32713</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_14S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32714</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_15S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32715</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_16S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32716</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_17S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32717</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_18S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32718</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_19S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32719</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_20S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32720</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_21S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32721</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_22S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32722</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_23S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32723</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_24S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32724</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_25S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32725</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_26S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32726</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_27S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32727</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_28S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32728</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_29S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32729</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_30S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32730</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_31S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32731</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_32S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32732</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_33S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32733</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_34S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32734</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_35S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32735</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_36S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32736</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_37S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32737</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_38S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32738</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_39S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32739</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_40S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32740</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_41S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32741</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_42S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32742</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_43S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32743</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_44S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32744</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_45S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32745</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_46S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32746</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_47S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32747</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_48S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32748</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_49S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32749</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_50S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32750</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_51S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32751</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_52S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32752</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_53S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32753</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_54S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32754</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_55S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32755</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_56S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32756</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_57S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32757</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_58S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32758</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_59S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32759</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_UTM_Zone_60S'">
                <xsl:text>urn:ogc:def:crs:EPSG::32760</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='UPS_South'">
                <xsl:text>urn:ogc:def:crs:EPSG::32761</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_TM_36_SE'">
                <xsl:text>urn:ogc:def:crs:EPSG::32766</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_USGS_Transantarctic_Mountains'">
                <xsl:text>urn:ogc:def:crs:EPSG::3294</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='WGS_1984_World_Mercator'">
                <xsl:text>urn:ogc:def:crs:EPSG::3395</xsl:text>
            </xsl:when>
            <!-- Vertical Reference Datums -->
            <xsl:when test="$esriCode='European Vertical Reference Frame 2000'">
                <xsl:text>urn:ogc:def:crs:EPSG::5129</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Australian Height Datum'">
                <xsl:text>urn:ogc:def:crs:EPSG::5111</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Australian Height Datum (Tasmania)'">
                <xsl:text>urn:ogc:def:crs:EPSG::5112</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Baltic Sea'">
                <xsl:text>urn:ogc:def:crs:EPSG::5105</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Canadian Vertical Datum of 1928'">
                <xsl:text>urn:ogc:def:crs:EPSG::5114</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Caspian Sea'">
                <xsl:text>urn:ogc:def:crs:EPSG::5106</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Fahud Height Datum'">
                <xsl:text>urn:ogc:def:crs:EPSG::5124</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Ha Tien 1960'">
                <xsl:text>urn:ogc:def:crs:EPSG::5125</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Helsinki 1960'">
                <xsl:text>urn:ogc:def:crs:EPSG::5116</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Hon Dau 1992'">
                <xsl:text>urn:ogc:def:crs:EPSG::5126</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Japanese Standard Levelling Datum 1949'">
                <xsl:text>urn:ogc:def:crs:EPSG::5122</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Landeshohennetz 1995'">
                <xsl:text>urn:ogc:def:crs:EPSG::5128</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Landesnivellement 1902'">
                <xsl:text>urn:ogc:def:crs:EPSG::5127</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Maputo'">
                <xsl:text>urn:ogc:def:crs:EPSG::5121</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Mean Sea Level'">
                <xsl:text>urn:ogc:def:crs:EPSG::5100</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='National Geodetic Vertical Datum 1929'">
                <xsl:text>urn:ogc:def:crs:EPSG::5102</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Nivellement general de la France - IGN69'">
                <xsl:text>urn:ogc:def:crs:EPSG::5119</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Nivellement general de la France - Lalle'">
                <xsl:text>urn:ogc:def:crs:EPSG::5118</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Normaal Amsterdams Peil'">
                <xsl:text>urn:ogc:def:crs:EPSG::5109</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='North American Vertical Datum 1988'">
                <xsl:text>urn:ogc:def:crs:EPSG::5103</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Oostende'">
                <xsl:text>urn:ogc:def:crs:EPSG::5110</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Ordnance Datum Newlyn'">
                <xsl:text>urn:ogc:def:crs:EPSG::5101</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='PDO Height Datum 1993'">
                <xsl:text>urn:ogc:def:crs:EPSG::5123</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Piraeus Harbour 1986'">
                <xsl:text>urn:ogc:def:crs:EPSG::5115</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Rikets hoghtsystem 1970'">
                <xsl:text>urn:ogc:def:crs:EPSG::5117</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Sea Level'">
                <xsl:text>urn:ogc:def:crs:EPSG::5113</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='Yellow Sea 1956'">
                <xsl:text>urn:ogc:def:crs:EPSG::5104</xsl:text>
            </xsl:when>
            <!-- If the code is not identified return input   -->
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ============================================================================== -->
    <!-- Convert spatial representation type code to ISO List name                      -->
    <!-- ============================================================================== -->
    <xsl:template name="GetSpatialRepresentationTypeCode">
        <xsl:param name="esriCode"/>
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>vector</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>grid</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>textTable</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>tin</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>stereoModel</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>video</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ============================================================ -->
    <!-- Convert Date type code to ISO List name                      -->
    <!-- ============================================================ -->
    <xsl:template name="GetDateTypeCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>creation</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>publication</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>revision</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ============================================================ -->
    <!-- Convert maintenance code to ISO List name                    -->
    <!-- ============================================================ -->
    <xsl:template name="GetMaintenanceCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>continual</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>daily</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>weekly</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>Fortnightly</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>monthly</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>quarterly</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>biannually</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>annually</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='009'">
                <xsl:text>asNeeded</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='010'">
                <xsl:text>irregular</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='011'">
                <xsl:text>notPlanned</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='012'">
                <xsl:text>unknown</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- =========================================================== -->
    <!--	 Convert access/use constraint code to ISO List name     -->
    <!-- =========================================================== -->
    <xsl:template name="GetConstraintCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>copyright</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>patent</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>patentPending</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>trademark</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>license</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>intellectualPropertyRights</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>restricted</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>otherRestrictions</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ======================================================== -->
    <!--	 	Convert characterset code to ISO List name  	        -->
    <!-- ======================================================== -->
    <xsl:template name="GetCharacterSetCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>ucs2</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>ucs4</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>utf7</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>utf8</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>utf16</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>8859part1</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>8859part2</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>8859part3</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='009'">
                <xsl:text>8859part4</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='010'">
                <xsl:text>8859part5</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='011'">
                <xsl:text>8859part6</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='012'">
                <xsl:text>8859part7</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='013'">
                <xsl:text>8859part8</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='014'">
                <xsl:text>8859part9</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='015'">
                <xsl:text>8859part10</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='016'">
                <xsl:text>8859part11</xsl:text>
            </xsl:when>
            <!-- FROM ESRI CODELIST CATALOG - no 017 because reserved:
             a future ISO/IEC 8-bit single byte coded graphic character set
            (e.g. possibly 8859 part 12-->
            <xsl:when test="$esriCode='018'">
                <xsl:text>8859part13</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='019'">
                <xsl:text>8859part14</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='020'">
                <xsl:text>8859part15</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='021'">
                <xsl:text>8859part16</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='022'">
                <xsl:text>jis</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='023'">
                <xsl:text>shiftJIS</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='024'">
                <xsl:text>eucJP</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='025'">
                <xsl:text>usAscii</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='026'">
                <xsl:text>ebcdic</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='027'">
                <xsl:text>eucKR</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='028'">
                <xsl:text>big5</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='029'">
                <xsl:text>GB2312</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ======================================================== -->
    <!--	 	Convert Topic category code to ISO List name          -->
    <!-- ======================================================== -->
    <xsl:template name="GetTopicCategory">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>farming</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>biota</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>boundaries</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>climatologyMeteorologyAtmosphere</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>economy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>elevation</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>environment</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>geoscientificInformation</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='009'">
                <xsl:text>health</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='010'">
                <xsl:text>imageryBaseMapsEarthCover</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='011'">
                <xsl:text>intelligenceMilitary</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='012'">
                <xsl:text>inlandWaters</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='013'">
                <xsl:text>location</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='014'">
                <xsl:text>oceans</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='015'">
                <xsl:text>planningCadastre</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='016'">
                <xsl:text>society</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='017'">
                <xsl:text>structure</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='018'">
                <xsl:text>transportation</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='019'">
                <xsl:text>utilitiesCommunication</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ======================================================== -->
    <!--	 		Convert Medium Name code to ISO List name           -->
    <!-- ======================================================== -->
    <xsl:template name="GetMediumCode">
        <xsl:param name="esriCode" />
        <xsl:choose>
            <xsl:when test="$esriCode='001'">
                <xsl:text>cdRom</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='002'">
                <xsl:text>dvd</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='003'">
                <xsl:text>dvdRom</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='004'">
                <xsl:text>3halfInchFloppy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='005'">
                <xsl:text>5quarterInchFloppy</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='006'">
                <xsl:text>7trackTape</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='007'">
                <xsl:text>9trackType</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='008'">
                <xsl:text>3480Cartridge</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='009'">
                <xsl:text>3490Cartridge</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='010'">
                <xsl:text>3580Cartridge</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='011'">
                <xsl:text>4mmCartridgeTape</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='012'">
                <xsl:text>8mmCartridgeTape</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='013'">
                <xsl:text>1quarterInchCartridgeTape</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='014'">
                <xsl:text>digitalLinearTape</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='015'">
                <xsl:text>onLine</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='016'">
                <xsl:text>satellite</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='017'">
                <xsl:text>telephoneLink</xsl:text>
            </xsl:when>
            <xsl:when test="$esriCode='018'">
                <xsl:text>hardcopy</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$esriCode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ============================================================ -->
    <!--	 Convert Date from YYYYMMDD to YYYY-MM-DD/YYYY-MM/YYYY 	  -->
    <!-- ============================================================ -->
    <xsl:template name="FormatDate">
        <xsl:param name="date" />
        <xsl:param name="time">
            <xsl:text/>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="string-length($time)=0">
                <xsl:choose>
                    <xsl:when test="string-length($date)=15">
                        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T',substring($date,10,2),':',substring($date,12,2),':',substring($date,14,2))" />
                    </xsl:when>
                    <xsl:when test="string-length($date)=8">
                        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))" />
                    </xsl:when>
                    <xsl:when test="string-length($date)=6">
                        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2))" />
                    </xsl:when>
                    <xsl:when test="string-length($date)=4">
                        <xsl:value-of select="$date" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$date" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($date)=8">
                        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T',$time)" />
                    </xsl:when>
                    <xsl:when test="string-length($date)=6">
                        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2))" />
                    </xsl:when>
                    <xsl:when test="string-length($date)=4">
                        <xsl:value-of select="$date" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$date" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
