<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- RNDT SCHEMATRON-->
	<sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation for ISO
		19115(19139) RNDT Profile</sch:title>
	<sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
	<sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
	<sch:ns prefix="srv" uri="http://www.isotc211.org/2005/srv"/>
	<sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
	<sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	
	
<!--	<sch:let name="inspireKeyWords">
		<keyword>Condizioni atmosferiche</keyword>
		<keyword>Atmospheric conditions</keyword>
		<keyword>Copertura del suolo</keyword>
		<keyword>Land cover</keyword>
		<keyword>Distribuzione della popolazione - demografia</keyword>
		<keyword>Population distribution — demography</keyword>
		<keyword>Distribuzione delle specie</keyword>
		<keyword>Species distribution</keyword>
		<keyword>Edifici</keyword>
		<keyword>Buildings</keyword>
		<keyword>Elementi geografici meteorologici</keyword>
		<keyword>Meteorological geographical features</keyword>
		<keyword>Elementi geografici oceanografici</keyword>
		<keyword>Oceanographic geographical features</keyword>
		<keyword>Elevazione</keyword>
		<keyword>Elevation</keyword>
		<keyword>Geologia</keyword>
		<keyword>Geology</keyword>
		<keyword>Habitat e biotopi</keyword>
		<keyword>Habitats and biotopes</keyword>
		<keyword>Idrografia</keyword>
		<keyword>Hydrography</keyword>
		<keyword>Impianti agricoli e di acquacoltura</keyword>
		<keyword>Agricultural and aquaculture facilities</keyword>
		<keyword>Impianti di monitoraggio ambientale</keyword>
		<keyword>Environmental monitoring facilities</keyword>
		<keyword>Indirizzi</keyword>
		<keyword>Addresses</keyword>
		<keyword>Nomi geografici</keyword>
		<keyword>Geographical names</keyword>
		<keyword>Orto immagini</keyword>
		<keyword>Orthoimagery</keyword>
		<keyword>Parcelle catastali</keyword>
		<keyword>Cadastral parcels</keyword>
		<keyword>Produzione e impianti industriali</keyword>
		<keyword>Production and industrial facilities</keyword>
		<keyword>Regioni biogeografiche</keyword>
		<keyword>Bio-geographical regions</keyword>
		<keyword>Regioni marine</keyword>
		<keyword>Sea regions</keyword>
		<keyword>Reti di trasporto</keyword>
		<keyword>Transport networks</keyword>
		<keyword>Risorse energetiche</keyword>
		<keyword>Energy resources</keyword>
		<keyword>Risorse minerarie</keyword>
		<keyword>Mineral resources</keyword>
		<keyword>Salute umana e sicurezza</keyword>
		<keyword>Human health and safety</keyword>
		<keyword>Servizi di pubblica utilità e servizi amministrativi</keyword>
		<keyword>Utility and governmental services</keyword>
		<keyword>Sistemi di coordinate</keyword>
		<keyword>Coordinate reference systems</keyword>
		<keyword>Sistemi di griglie geografiche</keyword>
		<keyword>Geographical grid systems</keyword>
		<keyword>Siti protetti</keyword>
		<keyword>Protected sites</keyword>
		<keyword>Suolo</keyword>
		<keyword>Soil</keyword>
		<keyword>Unità amministrative</keyword>
		<keyword>Administrative units</keyword>
		<keyword>Unità statistiche</keyword>
		<keyword>Statistical units</keyword>
		<keyword>Utilizzo del territorio</keyword>
		<keyword>Land use</keyword>
		<keyword>Zone a rischio naturale</keyword>
		<keyword>Natural risk zones</keyword>
		<keyword>Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati</keyword>
		<keyword>Area management/restriction/regulation zones and reporting units</keyword>
	</sch:let>
-->	
		<sch:let name="gemetThesaurusTitle">GEMET - INSPIRE themes, version 1.0</sch:let>
		<sch:let name="gemetThesaurusDate">2008-06-01</sch:let>
		<sch:let name="gemetThesaurusDateType">publication</sch:let>
<!--		<sch:let name="inspireServicesKeyWords">humanInteractionService;humanCatalogueViewer;humanGeographicViewer;humanGeographicSpreadsheetViewer;humanServiceEditor;humanChainDefinitionEditor;humanWorkflowEnactmentManager;humanGeographicFeatureEditor;humanGeographicSymbolEditor;humanFeatureGeneralizationEditor;humanGeographicDataStructureViewer;infoManagementService;infoFeatureAccessService;infoMapAccessService;infoCoverageAccessService;infoSensorDescriptionService;infoProductAccessService;infoFeatureTypeService;infoCatalogueService;infoRegistryService;infoGazetteerService;infoOrderHandlingService;infoStandingOrderService;taskManagementService;chainDefinitionService;workflowEnactmentService;subscriptionService;spatialProcessingService;spatialCoordinateConversionService;spatialCoordinateTransformationService;spatialCoverageVectorConversionService;spatialImageCoordinateConversionService;spatialRectificationService;spatialOrthorectificationService;spatialSensorGeometryModelAdjustmentService;
spatialImageGeometryModelConversionService;spatialSubsettingService;spatialSamplingService;spatialTilingChangeService;spatialDimensionMeasurementService;spatialFeatureManipulationService;spatialFeatureMatchingService;spatialFeatureGeneralizationService;spatialRouteDeterminationService;spatialPositioningService;spatialProximityAnalysisService;thematicProcessingService;thematicGeoparameterCalculationService;thematicClassificationService;thematicFeatureGeneralizationService;thematicSubsettingService;thematicSpatialCountingService;thematicChangeDetectionService;thematicGeographicInformationExtractionService;thematicImageProcessingService;thematicReducedResolutionGenerationService;thematicImageManipulationService;thematicImageUnderstandingService;thematicImageSynthesisService;thematicMultibandImageManipulationService;thematicObjectDetectionService;thematicGeoparsingService;thematicGeocodingService;temporalProcessingService;temporalReferenceSystemTransformationService;temporalSubsettingService;
temporalSamplingService;temporalProximityAnalysisService;metadataProcessingService;metadataStatisticalCalculationService;metadataGeographicAnnotationService;comService;comEncodingService;comTransferService;comGeographicCompressionService;comMessagingService;comRemoteFileAndExecutableManagement</sch:let>
-->

	<!--FILE IDENTIFIER-->
	<sch:pattern>
		<sch:title>$loc/strings/M1</sch:title>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:assert test="gmd:fileIdentifier/gco:CharacterString">$loc/strings/alert.M1</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--METADATA LANGUAGE-->
	<sch:pattern>
		<sch:title>$loc/strings/M2</sch:title>
		<sch:let name="langCodeList">bul;cze;dan;est;fin;fre;gre;eng;gle;ita;lav;lit;mlt;dut;pol;por;rum;slo;slv;spa;swe;ger;hun</sch:let>
		<sch:let name="langCodeURI">http://www.loc.gov/standards/iso639-2</sch:let>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:let name="value" value="gmd:language/gmd:LanguageCode/@codeListValue"/>
			<!-- <sch:assert test="contains($langCodeList,gmd:language/gmd:LanguageCode/@codeListValue) and gmd:language/gmd:LanguageCode!='' and gmd:language/gmd:LanguageCode/@codeList= $langCodeURI">$loc/strings/alert.M2</sch:assert> -->
			<sch:assert test="exists(tokenize($langCodeList, ';')[. = $value]) and gmd:language/gmd:LanguageCode!='' 
			and (gmd:language/gmd:LanguageCode/@codeList= $langCodeURI or
			gmd:language/gmd:LanguageCode/@codeList = concat($langCodeURI,'/'))">$loc/strings/alert.M2</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--PARENT IDENTIFIER-->
<!-- 	<sch:pattern>
		<sch:title>$loc/strings/M3</sch:title>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:assert test="gmd:parentIdentifier/gco:CharacterString">$loc/strings/alert.M3</sch:assert>
		</sch:rule>
	</sch:pattern> -->
	<!--HIERARCHY LEVEL-->
	<sch:pattern>
		<sch:title>$loc/strings/M4</sch:title>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:assert test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue and gmd:hierarchyLevel/gmd:MD_ScopeCode!=''">$loc/strings/alert.M4</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--METADATA STANDARD NAME-->
	<sch:pattern>
		<sch:title>$loc/strings/M5</sch:title>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:assert test="gmd:metadataStandardName/gco:CharacterString and 
			gmd:metadataStandardName/gco:CharacterString = 'DM - Regole tecniche RNDT'">$loc/strings/alert.M5</sch:assert>
			<!--			<sch:assert test="gmd:metadataStandardName/gco:CharacterString and contains(gmd:metadataStandardName/gco:CharacterString,'DM - Regole tecniche RNDT')">$loc/strings/alert.M5</sch:assert>-->
			<!--	<sch:assert test="gmd:metadataStandardName/gco:CharacterString and  gmd:metadataStandardName/gco:CharacterString/@value='DM - Regole tecniche RNDT'">$loc/strings/alert.M5</sch:assert>-->
		</sch:rule>
	</sch:pattern>
	<!--METADATA STANDARD VERSION-->
	<sch:pattern>
		<sch:title>$loc/strings/M6</sch:title>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:assert test="gmd:metadataStandardVersion/gco:CharacterString 
			and gmd:metadataStandardVersion/gco:CharacterString= '10 novembre 2011'">$loc/strings/alert.M6</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--METADATA CHARACTER SET-->
	<sch:pattern>
		<sch:title>$loc/strings/M7</sch:title>
		<sch:rule context="//gmd:MD_Metadata">
			<sch:assert test="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue 
			and gmd:characterSet/gmd:MD_CharacterSetCode!=''">$loc/strings/alert.M7</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - DATE TYPE-->
	<sch:pattern>
		<sch:title>$loc/strings/M8</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation
		|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation">
			<sch:assert test="gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue 
			and gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode!=''">$loc/strings/alert.M8</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - RESPONSIBLE PARTY (POINT OF CONTACT)-->
	<sch:pattern>
		<sch:title>$loc/strings/M9</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:contact">
			<sch:let name="req8test" value="(gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString!='')
			and count(gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue!='')>0
			and (gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString!='')
			and ((gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString!='')
			or (gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL!=''))"/>
            <sch:let name="req9test" value="count(gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue!='pointOfContact'])=0"/>
            <sch:assert test="$req8test">$loc/strings/alert.req8</sch:assert>
            <sch:assert test="$req9test">$loc/strings/alert.req9</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!--DATA/SERVICE IDENTIFICATION - IDENTIFIER-->
	<sch:pattern>
		<sch:title>$loc/strings/M13</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation
		|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation">
			<sch:assert test="gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString">$loc/strings/alert.M13</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - SERIES-->
	<sch:pattern>
		<sch:title>$loc/strings/M14</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation">
			<sch:assert test="gmd:series/gmd:CI_Series/gmd:issueIdentification/gco:CharacterString">$loc/strings/alert.M14</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - DATASET RESPONSIBLE PARTY-->
	<sch:pattern>
		<sch:title>$loc/strings/M15</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty
		                  |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">

            <sch:assert test="gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString!=''">$loc/strings/alert.M15org</sch:assert>
            <sch:assert test="gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue!=''">$loc/strings/alert.M15poc</sch:assert>
            <sch:assert test="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString!=''">$loc/strings/alert.M15mail</sch:assert>
            <sch:assert test="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString!=''
                           or gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL!=''">$loc/strings/alert.M15phone</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - PRESENTATION FORM-->
	<sch:pattern>
		<sch:title>$loc/strings/M30</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation">
			<sch:assert test="gmd:presentationForm/gmd:CI_PresentationFormCode">$loc/strings/alert.M30</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - SPATIAL REPRESENTATION TYPE-->
	<sch:pattern>
		<sch:title>$loc/strings/M31</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode">$loc/strings/alert.M31</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - SPATIAL RESOLUTION-->
	<sch:pattern>
		<sch:title>$loc/strings/M32</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="(gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer
			and gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer!='')
			or (gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance
			and gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance!='')">$loc/strings/alert.M32</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE IDENTIFICATION - GEOGRAPHIC LOCATION-->
	<sch:pattern>
		<sch:title>$loc/strings/M33</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification
                                  |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification">
                    <sch:assert test="count(./srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)>0
			              or
			              count(./gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)>0">$loc/strings/alert.M33</sch:assert>
                    <sch:assert test="count(./srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)&lt;2
			              or
			              count(./gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)&lt;2">$loc/strings/alert.M33a</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE QUALITY - SCOPE-->
	<sch:pattern>
		<sch:title>$loc/strings/M34</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality">
			<sch:assert test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue 
			and gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode!=''">$loc/strings/alert.M34</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE QUALITY - POSITIONAL ACCURACY-->
	<sch:pattern>
		<sch:title>$loc/strings/M35</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality">
			<sch:assert test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service'
			or count(gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult[gmd:valueUnit/gml:BaseUnit/gml:identifier/@codeSpace
			and gmd:valueUnit/gml:BaseUnit/gml:unitsSystem/@xlink:href and  gmd:value/gco:Record/gco:Real])>0">$loc/strings/alert.M35</sch:assert>
			<!--			<sch:assert test="gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:identifier">$loc/strings/alert.M35</sch:assert>-->
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE QUALITY - LINEAGE-->
	<sch:pattern>
		<sch:title>$loc/strings/M36</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality">
			<sch:assert test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service'
			or gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString!=''">$loc/strings/alert.M36</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATA/SERVICE QUALITY - CONFORMANCE REPORT - SPECIFICATION-->
	<sch:pattern>
		<sch:title>$loc/strings/M37</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality">
			<sch:let name="specTitleRNDT" >REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE del 23 novembre 2010 recante attuazione della direttiva 2007/2/CE del Parlamento europeo e del Consiglio per quanto riguarda l'interoperabilità dei set di dati territoriali e dei servizi di dati territoriali</sch:let>			
			<sch:let name="specTitleService" >Service Abstract Test Suite</sch:let>

			<sch:let name="specCitation" value="gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation"/>
			<sch:let name="specTitle"    value="gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
			
			<sch:let name="isTitleRNDT"      value="$specTitle = $specTitleRNDT"/>
			<sch:let name="isTitleRNDTFuzzy" value="contains($specTitle,'1089/2010') and contains($specTitle,'23 novembre 2010') and contains($specTitle,'2007/2/CE')"/>

			<sch:let name="isTitleService"   value="$specTitle = $specTitleService"/>
						
			<sch:let name="isPublication"    value="$specCitation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>

			<sch:assert test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service'
			 or ($isTitleRNDTFuzzy and $specCitation/gmd:date/gmd:CI_Date/gmd:date/gco:Date= '2010-12-08' and $isPublication)
			 or ($isTitleService   and $specCitation/gmd:date/gmd:CI_Date/gmd:date/gco:Date= '2007-11-21' and $isPublication)">$loc/strings/alert.M37</sch:assert>
			
			<sch:report test="$isTitleRNDT">Specifiche di conformità RNDT</sch:report>
			<sch:report test="$isTitleService">Specifiche di conformità Service Abstract</sch:report>
			<sch:report test="$isTitleRNDTFuzzy and not($isTitleRNDT)">Specifiche di conformità RNDT - Controllare</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<!--REFERENCE SYSTEM-->
	<sch:pattern>
		<sch:title>$loc/strings/M38</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset']">

            <sch:assert test="count(gmd:referenceSystemInfo) &gt; 0">$loc/strings/alert.M38missing</sch:assert>
            <sch:assert test="count(gmd:referenceSystemInfo) &lt; 2">$loc/strings/alert.M38toomany</sch:assert>

            <sch:report test="count(gmd:referenceSystemInfo) = 1">$loc/strings/report.M38count</sch:report>

		</sch:rule>

		<sch:rule context="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset']/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier">

            <sch:let name="rslist">WGS84;ETRS89;ETRS89/ETRS-LAEA;ETRS89/ETRS-LCC;ETRS89/ETRS-TM32;ETRS89/ETRS-TM33;ETRS89/UTM-zone32N;ETRS89/UTM-zone33N;ROMA40/EST;ROMA40/OVEST;ED50/UTM 32N;ED50/UTM 33N;IGM95/UTM 32N;IGM95/UTM 33N;WGS84/UTM 32N;WGS84/UTM 33N;WGS84/UTM 34N;BESSEL/Cassini-Soldner;BESSEL/Sanson-Flamsteed;CATASTO / Locale;ROMA40;ROMA40/ROMA;ED50;IGM95;Rete Altimetrica Nazionale;WGS84/3D;Livello medio delle basse maree sizigiali;Livello medio delle alte maree sizigiali;Livello medio lago;ITRS;IGb00;ETRF89;ETRF00</sch:let>
            <sch:let name="varlist">ITRF;IGS</sch:let> <!-- TODO -->
			<sch:let name="rscode" value="gmd:code/gco:CharacterString/text()"/>

			<sch:let name="rndtparsed" value="exists(tokenize($rslist, ';')[. = $rscode])"/>
			<sch:let name="epsgparsed" value="$rscode castable as xs:double"/>

			<sch:let name="isepsgspace"  value="string(gmd:codeSpace/gco:CharacterString) = 'http://www.epsg-registry.org' or
			                                    string(gmd:codeSpace/gco:CharacterString) = 'http://www.epsg-registry.org/'"/>
			<sch:let name="isnospace"  value="not(gmd:codeSpace)"/>

			<sch:assert test="($isnospace and $rndtparsed) or ($isepsgspace and $epsgparsed)">
                <sch:value-of select="$loc/strings/alert.M38code"/> <sch:value-of select="$rscode"/>
            </sch:assert>

            <sch:assert test="($isnospace and $rndtparsed) or not($isnospace)">$loc/strings/alert.M38badrndt</sch:assert>
            <sch:assert test="($isepsgspace and $epsgparsed) or not($isepsgspace)">$loc/strings/alert.M38badepsg</sch:assert>

            <sch:report test="$rndtparsed and $isnospace">$loc/strings/report.M38rndtcode</sch:report>
            <sch:report test="$epsgparsed and $isepsgspace">$loc/strings/report.M38epsgcode</sch:report>

            <sch:assert test="not(gmd:codeSpace) or $isepsgspace">$loc/strings/alert.M38badcodespace</sch:assert>
            <sch:assert test="not(gmd:version)">$loc/strings/alert.M38version</sch:assert>

            <sch:report test="not(gmd:codeSpace)">$loc/strings/report.M38nocodespace</sch:report>
            <sch:report test="$isepsgspace">$loc/strings/report.M38codespace</sch:report>

		</sch:rule>
	</sch:pattern>
	
	<!--DATA/SERVICE IDENTIFICATION - KEYWORDS-->
	<sch:pattern>
		<sch:title>$loc/strings/M39</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:descriptiveKeywords[
			gmd:MD_Keywords/gmd:keyword/*!=''
			and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString = $gemetThesaurusTitle
			and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date = $gemetThesaurusDate
			and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = $gemetThesaurusDateType]) >0">$loc/strings/alert.M39</sch:assert>
		</sch:rule>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification">
			<sch:assert test="count(gmd:descriptiveKeywords[
			gmd:MD_Keywords/gmd:keyword/*!='']) >0">$loc/strings/alert.M39</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!--DISTRIBUTION INFO - DISTRIBUTION FORMAT-->
	<sch:pattern>	
		<sch:title>$loc/strings/M45</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue!='service']">
			<sch:assert test="(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString!='')
			and (gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString!='')">$loc/strings/alert.M45</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!--DISTRIBUTION INFO - DISTRIBUTOR-->
	<sch:pattern>
		<sch:title>$loc/strings/M46</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue!='service']">
			<sch:let name="name" value="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString!=''"/>
			<sch:let name="mail" value="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString!=''"/>
			<sch:let name="url" value="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString!=''"/>
			<sch:let name="phone" value="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact//gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString!=''"/>
			<sch:let name="role" value="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue
			and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='distributor'"/>
			<sch:assert test="$name and $role and $mail and ($url or $phone)">$loc/strings/alert.M46</sch:assert>			
		</sch:rule>
	</sch:pattern>

	<!--CONSTRAINTS - USE LIMITATIONS-->
	<sch:pattern>
		<sch:title>$loc/strings/M50</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification">
			<sch:assert test="count(gmd:resourceConstraints[gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString])>0">$loc/strings/alert.M50</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!--CONSTRAINTS - ACCESS CONSTRAINTS-->
	<sch:pattern>
		<sch:title>$loc/strings/M51</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification">
			<sch:assert test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue])>0">$loc/strings/alert.M51</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!--CONSTRAINTS - USE CONSTRAINTS-->
	<sch:pattern>
		<sch:title>$loc/strings/M52</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification">
			<sch:assert test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue])>0">$loc/strings/alert.M52</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!--CONSTRAINTS - OTHER CONSTRAINTS -->
	<sch:pattern>
		<sch:title>$loc/strings/M53</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints|
			//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints">
			
			<sch:assert test="count(gmd:MD_LegalConstraints[
                                gmd:otherConstraints/gco:CharacterString != ''
                            and gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue!='otherRestrictions'
                            and gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue!='otherRestrictions'])=0">$loc/strings/alert.M53notneeded</sch:assert>

			<sch:assert test="count(gmd:MD_LegalConstraints[
                                /gmd:otherConstraints/gco:CharacterString = ''
                            and (   gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue='otherRestrictions'
				                 or gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue='otherRestrictions')]) = 0">$loc/strings/alert.M53missing</sch:assert>
			
		</sch:rule>
	</sch:pattern>
	
	<!--CONTENT INFO - CONTENT TYPE (RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M60</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']">
			<sch:assert test="gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType/gmd:MD_CoverageContentTypeCode/@codeListValue">$loc/strings/alert.M60</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--CONTENT INFO - ATTRIBUTE DESCRIPTION (RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M61</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']">
			<sch:assert test="gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType">$loc/strings/alert.M61</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--SPATIAL REPRESENTATION INFO - DIMENSIONS NUMBER (RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M62</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']">
			<sch:assert test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer
			or gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer">$loc/strings/alert.M62</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--SPATIAL REPRESENTATION INFO - AXIS DIMENSION PROPERTIES (RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M63</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']">
			<sch:assert test="(gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue
			and gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer
			and gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer!='')
			or (gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue
			and gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer
			and gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer!='')">$loc/strings/alert.M63</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--SPATIAL REPRESENTATION INFO - CELL GEOMETRY (RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M64</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']">
			<sch:assert test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue
			or gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue">$loc/strings/alert.M64</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--SPATIAL REPRESENTATION INFO - TRANSFORMATION PARAMETER AVAILABILITY (RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M65</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']">
			<sch:assert test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability/gco:Boolean
			or gmd:spatialRepresentationInfo//gmd:MD_Georeferenceable/gmd:transformationParameterAvailability/gco:Boolean">$loc/strings/alert.M65</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--SPATIAL REPRESENTATION INFO - CHECK POINT AVAILABILITY (GEORECTIFIED RASTER DATA)-->
	<sch:pattern>
		<sch:title>$loc/strings/M66</sch:title>
		<sch:rule context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid'
		and gmd:spatialRepresentationInfo/gmd:MD_Georectified]">
			<sch:assert test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability/gco:Boolean">$loc/strings/alert.M66</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--METADATA DATE-->
	<sch:pattern>
		<sch:title>$loc/strings/M99</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:dateStamp">
			<sch:assert test="gco:Date">$loc/strings/alert.M99</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--DATE-->
	<sch:pattern>
		<sch:title>$loc/strings/M100</sch:title>
		<sch:rule context="gmd:CI_Date">
			<sch:assert test="gmd:date/gco:Date">$loc/strings/alert.M100</sch:assert>
		</sch:rule>
		<!--			<sch:assert test="matches(gco:Date,'^[0-9]{4}-(((0[13578]|(10|12))-(0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|((0[469]|11)-(0[1-9]|[1-2][0-9]|30)))$') or matches(gco:Date,'^(((\d{4}((0[13578]|1[02])(0[1-9]|[12]\d|3[01])|(0[13456789]|1[012])(0[1-9]|[12]\d|30)|02(0[1-9]|1\d|2[0-8])))|((\d{2}[02468][048]|\d{2}[13579][26]))0229)){0,8}$')">$loc/strings/alert.M100</sch:assert>
		</sch:rule>-->
	</sch:pattern>
	<!--COD IPA-->
	<sch:pattern>
		<sch:title>$loc/strings/M101</sch:title>
		<sch:rule context="gmd:parentIdentifier[.!='']|gmd:fileIdentifier|
		/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification|
		/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code">
			<sch:assert test="contains(gco:CharacterString,':')">$loc/strings/alert.M101</sch:assert>
		</sch:rule>
			</sch:pattern>
	<!--COD IPA - PARENT IDENTIFIER-->
	<sch:pattern>
		<sch:title>$loc/strings/M102</sch:title>
		<sch:rule context="gmd:parentIdentifier[contains(../gmd:fileIdentifier/gco:CharacterString,':') and .!='']">
			<sch:assert test="starts-with(gco:CharacterString,substring-before(../gmd:fileIdentifier/gco:CharacterString,':'))">$loc/strings/alert.M102</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--COD IPA - IDENTIFIER-->
	/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString
	<sch:pattern>
		<sch:title>$loc/strings/M103</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code[contains(../../../../../../../gmd:fileIdentifier/gco:CharacterString,':')]|
		                   /gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code[contains(../../../../../../../gmd:fileIdentifier/gco:CharacterString,':')]">
			<sch:assert test="starts-with(gco:CharacterString,substring-before(../../../../../../../gmd:fileIdentifier/gco:CharacterString,':'))">$loc/strings/alert.M103</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--COD IPA - SERIES-->
	<sch:pattern>
		<sch:title>$loc/strings/M104</sch:title>
		<sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification[contains(../../../../../../../gmd:fileIdentifier/gco:CharacterString,':')]">
			<sch:assert test="starts-with(gco:CharacterString,substring-before(../../../../../../../gmd:fileIdentifier/gco:CharacterString,':'))">$loc/strings/alert.M104</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!--NIL REASON-->
<!--	<sch:pattern>
		<sch:title>$loc/strings/M110</sch:title>
		<sch:rule context="/gmd:MD_Metadata">
			<sch:assert test="count(//*[not(self::gmd:protocol or self::gmd:name or self::gmd:description or self::gmd:pass or self::gmd:otherConstraints)][@gco:nilReason])=0">$loc/strings/alert.M110</sch:assert>
		</sch:rule>
	</sch:pattern>-->
    <!--VERTICAL ELEMENT-->
	<sch:pattern>
		<sch:title>$loc/strings/M111</sch:title>
		<sch:rule context="gmd:verticalCRS">
			<sch:assert test=" @xlink:href">$loc/strings/alert.M111</sch:assert>
			<sch:assert test="(@xlink:href != '')">$loc/strings/alert.M112</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- OPERAZIONI CONTENUTE -->
	<sch:pattern>
		<sch:title>$loc/strings/M121</sch:title>
		<sch:rule context="//srv:SV_OperationMetadata/srv:operationName">
			<sch:let name="elementName" value="local-name()"/>
			<sch:assert test="gco:CharacterString!=''">
                <sch:value-of select="$loc/strings/alert.M121"/>
            </sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern>
		<sch:title>$loc/strings/M120</sch:title>
		<sch:rule context="//gmd:MD_Metadata//*[@codeListValue]">
			<sch:let name="elementName" value="local-name()"/>
			<sch:assert test="@codeListValue!=''">
                <sch:value-of select="$loc/strings/alert.M120"/> <sch:value-of select="$elementName"/>
            </sch:assert>
		</sch:rule>
	</sch:pattern>

    <!--ESTENSIONE TEMPORALE-->
	<sch:pattern>
		<sch:title>$loc/strings/M200</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent[//gml:TimePeriod]
                                  |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent[//gml:TimePeriod]">

			<sch:let name="beginPosition" value="gml:TimePeriod//gml:beginPosition/text()"/>		
			<sch:let name="endPosition"   value="gml:TimePeriod//gml:endPosition/text()"/>

			<sch:assert test="$beginPosition != ''">$loc/strings/alert.M201</sch:assert>
			<sch:assert test="$endPosition   != ''">$loc/strings/alert.M202</sch:assert>

		</sch:rule>
	</sch:pattern>
					
</sch:schema>
