<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
	<!-- 
        This script was developed for CMRE -
        by GeoSolutions SaS
        as part of a project to develop an XML implementation of the NATO Geospatial Metadata Profile.
    -->
	<sch:title>NGMP: STANAG 2586 Edition 1 validation</sch:title>
	<!-- Modified gml URI to match NGMP codelist catalogue at http://eden.ign.fr/xsd/ngmp/20110916/resources/codelist/ngmpCodelists.xml -->
	<sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2" />
	<sch:ns prefix="gmx" uri="http://www.isotc211.org/2005/gmx"/>
	<sch:ns prefix="ngmp" uri="urn:int:nato:geometoc:geo:metadata:ngmp:1.0"/>
	<sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
	<sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>

	<sch:let name="regexGUID" >\{?[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\}?</sch:let>
	<sch:let name="regexURI" >([a-zA-Z0-9\\-_\\.!\\~\\*'\\(\\);/\\?:\\@\\&amp;=\\+$,]|(%[a-fA-F0-9]{2}))*</sch:let>
	<sch:let name="stanag1059List">ABW;ABB;ATG;AFG;DZA;AZE;ALB;ARM;AND;AGO;ARG;AUS;ACI;AUT;AIA;ATA;BHR;BRB;BWA;BMU;BEL;BHS;BGD;BLZ;BIH;BOL;MMR;BEN;BLR;SLB;BRA;BTN;BGR;BVT;BRN;BDI;CAN;KHM;TCD;LKA;COG;COD;CHN;CHL;CYM;CCK;CMR;COM;COL;MNP;CSI;CRI;CAF;CUB;CPV;COK;CYP;CZE;DNK;DJI;DMA;DOM;ECU;EEE;EGY;IRL;GNQ;EST;ERI;ESP;ETH;FFF;GUF;FIN;FJI;FLK;FSM;FRO;PYF;FRA;ATF;FYR;GMB;GAB;DEU;GEO;GHA;GIB;GRD;GRL;GLP;GUM;GRC;GTM;GIN;GUY;HTI;HKG;HMD;HND;HQI;HRV;HUN;ISL;IDN;IND;IOT;UMI;IRN;ISR;ITA;CIV;IRQ;JPN;JAM;JNM;JOR;JQA;KEN;KGZ;PRK;KIR;KOR;CXR;KWT;KAZ;LAO;LBN;LVA;LTU;LBR;SVK;LIE;LSO;LUX;LBY;MDG;MTQ;MAC;MDA;MNE;MNG;MSR;MWI;MLI;MCO;MAR;MUS;MRT;MLT;OMN;MDV;MEX;MYS;MOZ;ANT;NCL;NIU;NFK;NER;VUT;NGA;NLD;NNN;NOR;NPL;NRU;SUR;NTT;NIC;NZL;PRY;PCN;PER;PFI;PAK;POL;PAN;PRT;PNG;PLW;PSE;GNB;QAT;REU;MHL;ROU;PHL;PRI;SRB;RUS;RWA;SAU;SPM;KNA;SYC;ZAF;SEN;SHN;SVN;SJM;SLE;SMR;SGP;SOM;SRR;ASM;WSM;LCA;SDN;SLV;SWE;SGS;SYR;CHE;ARE;TTO;THA;TJK;TCA;TKL;TLS;TON;TGO;STP;TUN;TUR;TUV;TWN;TKM;TZN;UGA;GBR;UKR;USA;UUU;BFA;URY;UZB;VCT;VEN;VIR;VNM;VGB;VAT;NAM;WLF;ESH;SWZ;XXB;XXE;XXG;XXI;XXL;XXM;XXN;XXP;XXR;XXS;XXW;XXY;YEM;SCG;YUG;ZMB;ZWE</sch:let>
	<sch:let name="topicCatEnum">farming;biota;vegetation;boundaries;climatologyMeteorology;economy;elevation;environment;geoscientificInformation;health;imageryBaseMapsEarth;intelligenceMilitary;inlandWaters;location;oceans;planningCadastre;society;structure;transportation;utilitiesCommunication</sch:let>
	
	<!-- Code List -->
	<sch:pattern id="checkCodeList">
		<sch:title>$loc/strings/M0.1</sch:title>
		<sch:rule context="//ngmp:*[@codeList]">
			<sch:let name="codeListVal" value="string(@codeListValue)"/>
			<sch:let name="codeListDoc" value="document(substring-before(@codeList,'#'))//gmx:CodeListDictionary[@gml:id = substring-after(current()/@codeList,'#')]"/>
			<sch:assert test="$codeListDoc">Unable to find the specified Code List document (<sch:value-of select="substring-before(@codeList,'#')"/>) or Code List Dictionary (<sch:value-of select="substring-after(current()/@codeList,'#')"/>) node.</sch:assert>
			<sch:assert test="@codeListValue = $codeListDoc/gmx:codeEntry/gmx:CodeDefinition/gml:identifier">The specified Code List Value (<sch:value-of select="$codeListVal"/>) is not in the specified Code List Dictionary (<sch:value-of select="substring-after(current()/@codeList,'#')"/>).</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- Code List Element value -->
	<sch:pattern id="checkCodeListVal">
		<sch:title>$loc/strings/M0.2</sch:title>
		<sch:rule context="//*[@codeList]">
			<sch:assert test=".!=''"><sch:value-of select="name(.)"/> element value required (saving metadata the value will be copied from related codeListValue attribute)</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- MDSID -->
	<sch:pattern id="checkFileId">
		<sch:title>$loc/strings/M1</sch:title>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="gmd:fileIdentifier and (normalize-space(gmd:fileIdentifier/gco:CharacterString) != '') 
			and count(gmd:fileIdentifier) = 1">$loc/strings/alert.M1</sch:assert>
			<sch:assert test="matches(gmd:fileIdentifier/gco:CharacterString,$regexGUID)
		or matches(gmd:fileIdentifier/gco:CharacterString,$regexURI)">$loc/strings/warning.M1</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDPTSID -->
	<sch:pattern id="checkParentId">
		<sch:title>$loc/strings/M2</sch:title>
		<sch:let name="parentIdIsPresent" value="gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue = 'series' or (gmd:parentIdentifier and (normalize-space(gmd:parentIdentifier/gco:CharacterString) != ''))"/>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="$parentIdIsPresent">$loc/strings/warning.M2.1</sch:assert>
			<sch:assert test="not($parentIdIsPresent) or (matches(gmd:parentIdentifier/gco:CharacterString,$regexGUID)
		or matches(gmd:parentIdentifier/gco:CharacterString,$regexURI))">$loc/strings/warning.M2.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDLANG -->
	<sch:pattern id="checkMDLang">
		<sch:title>$loc/strings/M3</sch:title>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="gmd:language/gmd:LanguageCode/@codeListValue!='' 
		and gmd:language/gmd:LanguageCode/@codeList!='' 
		and count(gmd:language/gmd:LanguageCode)=1">$loc/strings/alert.M3</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDCSET -->
	<sch:pattern id="checkMDCharSet">
		<sch:title>$loc/strings/M4</sch:title>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue='utf8'
		and gmd:characterSet/gmd:MD_CharacterSetCode/@codeList!=''		
		and count(gmd:characterSet) = 1">$loc/strings/alert.M4</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDPOC -->
	<sch:pattern id="checkPointOfContact">
		<sch:title>$loc/strings/M5</sch:title>
		<sch:let name="pocCheck" value="count(gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName[normalize-space(gco:CharacterString) != '']
		|gmd:contact/gmd:CI_ResponsibleParty/gmd:positionName[normalize-space(gco:CharacterString) != '']
		|gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName[normalize-space(gco:CharacterString) != '']) > 0"/>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="count(gmd:contact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='pointOfContact']) > 0">$loc/strings/alert.M5.1</sch:assert>
			<sch:assert test="$pocCheck">$loc/strings/alert.M5.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDSTD -->
	<sch:pattern id="checkMDStandard">
		<sch:title>$loc/strings/M6</sch:title>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="gmd:metadataStandardName/gco:CharacterString = 'STANAG 2586'">$loc/strings/alert.M6.1</sch:assert>
			<sch:assert test="gmd:metadataStandardVersion/gco:CharacterString = 'Edition 1'">$loc/strings/alert.M6.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDCLVL -->
	<sch:pattern id="checkMDClassificationLvl">
		<sch:title>$loc/strings/M7</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:metadataConstraints/gmd:MD_SecurityConstraints[normalize-space(gmd:classificationSystem/ngmp:NGMP_NatoBodyCode/@codeListValue)!='' 
		and normalize-space(gmd:classificationSystem/ngmp:NGMP_NatoBodyCode/@codeList)!='']">
			<sch:assert test="normalize-space(gmd:classification/gmd:MD_ClassificationCode/@codeListValue)!=''
			and normalize-space(gmd:classification/gmd:MD_ClassificationCode/@codeList)!=''">$loc/strings/alert.M7</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDCSYS -->
	<sch:pattern id="checkMDClassificationSys">  /gmd:MD_Metadata/gmd:metadataConstraints/gmd:MD_SecurityConstraints/gmd:classification/gmd:MD_ClassificationCode
		<sch:title>$loc/strings/M8</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:metadataConstraints/gmd:MD_SecurityConstraints[normalize-space(gmd:classification/gmd:MD_ClassificationCode/@codeListValue)!='' 
		and normalize-space(gmd:classification/gmd:MD_ClassificationCode/@codeList)!='']">
			<sch:let name="value" value="gmd:classificationSystem/gmd:CharacterString"/>
			<sch:assert test="(normalize-space(gmd:classificationSystem/ngmp:NGMP_NatoBodyCode/@codeListValue)!=''
			and normalize-space(gmd:classificationSystem/ngmp:NGMP_NatoBodyCode/@codeList)!='')
			or(exists(tokenize($stanag1059List, ';')[. = $value]))">$loc/strings/alert.M8</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- MDREL -->
	<sch:pattern id="checkMDRelAddr">
		<sch:title>$loc/strings/M9</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:metadataConstraints/ngmp:NGMP_Constraints/ngmp:releasibility/ngmp:NGMP_Releasibility/ngmp:addressee">
			<sch:let name="value" value="gmd:CI_ResponsibleParty/gmd:organisationName/gmd:CharacterString"/>			
			<sch:assert test="(normalize-space(gmd:CI_ResponsibleParty/gmd:organisationName/ngmp:NGMP_NatoBodyCode/@codeListValue)!=''
			and normalize-space(gmd:CI_ResponsibleParty/gmd:organisationName/ngmp:NGMP_NatoBodyCode/@codeList)!='')
			or (normalize-space(gmd:CI_ResponsibleParty/gmd:organisationName/ngmp:NGMP_ReleasibilityCode/@codeListValue)!=''
			and normalize-space(gmd:CI_ResponsibleParty/gmd:organisationName/ngmp:NGMP_ReleasibilityCode/@codeList)!='')
			or(exists(tokenize($stanag1059List, ';')[. = $value]))">$loc/strings/alert.M9.1</sch:assert>
			<sch:assert test="gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue = 'user' 
			and gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeList != ''">$loc/strings/alert.M9.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSTITLE -->
	<!-- RSABSTR -->
	<!-- RSTYPE -->
	<sch:pattern id="checkRsType">
		<sch:title>$loc/strings/M15</sch:title>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="(gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue = 'dataset' or
			gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue = 'series') and gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeList != ''">$loc/strings/alert.M15.1</sch:assert>
			<sch:assert test="count(gmd:hierarchyLevel/gmd:MD_ScopeCode)&lt;2">$loc/strings/alert.M15.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSNRNN, RSSHNA and RSNSNN-->
	<sch:pattern id="checkCodeSpace">
		<sch:title>$loc/strings/M16</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier[gmd:codeSpace/gco:CharacterString!='']">
			<sch:assert test="gmd:codeSpace/gco:CharacterString">$loc/strings/warning.M16.1</sch:assert>
			<sch:assert test="gmd:code/gco:CharacterString and gmd:code/gco:CharacterString!=''">$loc/strings/warning.M16.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSID -->
	<!-- RSLANG -->
	<!-- RSCSET -->
	<sch:pattern id="checkRsCharSet">
		<sch:title>$loc/strings/M17</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="gmd:characterSet/gmd:MD_CharacterSetCode and gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue
		and gmd:characterSet/gmd:MD_CharacterSetCode/@codeList
		and gmd:characterSet/gmd:MD_CharacterSetCode != ''">$loc/strings/alert.M17</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSSCALE and RGSD-->
	<sch:pattern id="checkRsResolution">
		<sch:title>$loc/strings/M18</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator[gco:Integer != '']
			|gmd:spatialResolution/gmd:MD_Resolution/gmd:distance[gco:Distance!=''])> 0">$loc/strings/alert.M18</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSTOPIC -->
	<sch:pattern id="checkRsTopicCat">
		<sch:title>$loc/strings/M42</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory">
			<sch:let name="value" value="gmd:MD_TopicCategoryCode"/>
			<sch:assert test="exists(tokenize($topicCatEnum, ';')[. = $value])">$loc/strings/alert.M42</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSRPTP -->
	<sch:pattern id="checkRSRPTP">
		<sch:title>$loc/strings/M41</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator[gco:Integer != '']
			|gmd:spatialResolution/gmd:MD_Resolution/gmd:distance[gco:Distance!=''])> 0">$loc/strings/warning.M41</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- DGITYP -->
	<sch:pattern id="checkDGITYP">
		<sch:title>$loc/strings/M19</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_DesignationTypeCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_DesignationTypeCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M19</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSGFLV  -->
	<sch:pattern id="checkRSGFLV ">
		<sch:title>$loc/strings/M20</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_GeoreferencingLevelCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_GeoreferencingLevelCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M20</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSPREF  -->
	<sch:pattern id="checkRSPREF ">
		<sch:title>$loc/strings/M21</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_RepresentationFormCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_RepresentationFormCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M21</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSDTLVL  -->
	<sch:pattern id="checkRSDTLVL ">
		<sch:title>$loc/strings/M22</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_DataLevelCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_DataLevelCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M22</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSKEYWD  -->
	<sch:pattern id="checkRSKEYWD ">
		<sch:title>$loc/strings/M23</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_ThematicCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_ThematicCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M23</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSBASLVL  -->
	<sch:pattern id="checkRSBASLVL ">
		<sch:title>$loc/strings/M24</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_BaselineLevelCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_BaselineLevelCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M24</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSDESTP  -->
	<sch:pattern id="checkRSDESTP ">
		<sch:title>$loc/strings/M25</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_DesignationTypeCode]">
			<sch:assert test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='NGMP_DesignationTypeCode' 
			and gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date='2011-09-16' and
			gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue= 'creation'">$loc/strings/alert.M25</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="checkIsPresentRSDESTP">
		<sch:title>$loc/strings/M26</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:keyword/ngmp:NGMP_DesignationTypeCode])=1">$loc/strings/alert.M26</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSDESTD -->
	<sch:pattern id="checkRSDESTD">
		<sch:title>$loc/strings/M27</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep[gmd:processor/gmd:CI_ResponsibleParty]">
			<sch:assert test="gmd:dateTime">$loc/strings/alert.M27</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSDESTA -->
	<sch:pattern id="checkRSDESTA.1">
		<sch:title>$loc/strings/M28</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep[gmd:dateTime]">
			<sch:assert test="gmd:processor/gmd:CI_ResponsibleParty">$loc/strings/alert.M28.1</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="checkRSDESTA.2">
		<sch:title>$loc/strings/M28</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep/gmd:processor/gmd:CI_ResponsibleParty">
			<sch:assert test="gmd:organisationName/ngmp:NGMP_CustodianCode and gmd:role/gmd:CI_RoleCode/@codeListValue='processor'">$loc/strings/alert.M28</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- Resource Designation -->
	<sch:pattern id="checkRSDesignation">
		<sch:title>$loc/strings/M29</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep[gmd:dateTime and gmd:processor/gmd:CI_ResponsibleParty]">
			<sch:assert test="gmd:description/gco:CharacterString='Resource Designation'">$loc/strings/alert.M29</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSCDAT -->
	<sch:pattern id="checkRSCDAT">
		<sch:title>$loc/strings/M30</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation">
			<sch:assert test="count(gmd:date[gmd:CI_Date/gmd:date/gco:Date!='' and gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='creation']) = 1">$loc/strings/alert.M30</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSONAT -->
	<sch:pattern id="checkRSONAT">
		<sch:title>$loc/strings/M31</sch:title>
		<sch:let name="value" value="gmd:CharacterString"/>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country">
			<sch:assert test="(exists(tokenize($stanag1059List, ';')[. = $value]))">$loc/strings/alert.M31</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSMFRQ -->
	<sch:pattern id="checkRSMFRQ">
		<sch:title>$loc/strings/M32</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode) =1">$loc/strings/alert.M32</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSCSYS -->
	<sch:pattern id="checkRSCSYS">
		<sch:title>$loc/strings/M33</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_SecurityConstraints[gmd:classification/gmd:MD_ClassificationCode]">
			<sch:assert test="gmd:classificationSystem">$loc/strings/alert.M33</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSACLV -->
	<sch:pattern id="checkRSACLV">
		<sch:title>$loc/strings/M34</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:resourceConstraints/ngmp:NGMP_Constraints/ngmp:releasibility/ngmp:NGMP_Releasibility/ngmp:statement/ngmp:NGMP_AccessibilityLevelCode) = 1">$loc/strings/alert.M34</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSACLVE -->
	<!-- RSUSE -->
	<!-- RSLCST -->
	<!-- RSLING -->
	<sch:pattern id="checkRsLineage">
		<sch:title>$loc/strings/M35</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality">
			<sch:assert test="gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString and gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString!= ''">$loc/strings/alert.M35</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSRDPRJ -->
	<sch:pattern id="checkRSRDPRJ">
		<sch:title>$loc/strings/M36</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage">
			<sch:assert test="gmd:specificUsage/gco:CharacterString= 'Recommended Display Projection' 
			and gmd:userDeterminedLimitations/gco:CharacterString='RSRDPRJ' 
			and gmd:userContactInfo/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString!='' 
			and gmd:userContactInfo/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue!=''">$loc/strings/alert.M36</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSDFMT -->
	<sch:pattern id="checkRSDFMT.1">
		<sch:title>$loc/strings/M37</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution">
			<sch:assert test="count(gmd:distributionFormat/gmd:MD_Format)>0">$loc/strings/alert.M37.1</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="checkRSDFMT.2">
		<sch:title>$loc/strings/M37</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format">
			<sch:assert test="gmd:name/gco:CharacterString!='' and gmd:version/gco:CharacterString!=''">$loc/strings/alert.M37.2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSCUST -->
	<sch:pattern id="checkRSCUST">
		<sch:title>$loc/strings/M38</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='custodian']">
			<sch:assert test="gmd:organisationName/ngmp:NGMP_CustodianCode/@codeListValue!='' 
			and gmd:organisationName/ngmp:NGMP_CustodianCode/@codeList!=''">$loc/strings/alert.M38</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- RSONLLC -->
	<sch:pattern id="checkRSONLLC">
		<sch:title>$loc/strings/M39</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">
			<sch:assert test="count(gmd:CI_OnlineResource/gmd:linkage[gmd:URL!=''])=1">$loc/strings/alert.M39</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- THUMB -->
	<sch:pattern id="checkThumb">
		<sch:title>$loc/strings/M40</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic[gmd:fileDescription/gco:CharacterString='thumbnail']">
			<sch:assert test="gmd:fileName/gco:CharacterString!=''">$loc/strings/alert.M40</sch:assert>
		</sch:rule>
	</sch:pattern>
</sch:schema>
