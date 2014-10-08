<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- GEMINI v2.2 SCHEMATRON-->

    <sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation for ISO 19115(19139) UK GEMINI 2.2 Profile</sch:title>

    <sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
    <sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
    <sch:ns prefix="srv" uri="http://www.isotc211.org/2005/srv"/>
    <sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
    <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

    <sch:let name="langCodeList">eng;cym;gle;gla;cor;sco</sch:let>

    <!-- 5.3 DATA LANGUAGE-->
    <sch:pattern>
        <sch:title>$loc/strings/UK0503</sch:title>
        <sch:rule context="gmd:MD_DataIdentification">
            <sch:let name="value" value=".//gmd:language/gmd:LanguageCode/@codeListValue"/>

            <sch:assert test="exists(tokenize($langCodeList, ';')[. = $value])">$loc/strings/alert.UK0503</sch:assert>
            <sch:report test="true()">
                <sch:value-of select="$loc/strings/UK0503.selected"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>

    <!-- 6.1 METADATA LANGUAGE-->
    <sch:pattern>
        <sch:title>$loc/strings/UK0601</sch:title>
        <sch:rule context="//gmd:MD_Metadata">
            <sch:let name="value" value="gmd:language/gmd:LanguageCode/@codeListValue"/>

            <sch:assert test="exists(tokenize($langCodeList, ';')[. = $value])">$loc/strings/alert.UK0601</sch:assert>
            <sch:report test="true()"><sch:value-of select="$loc/strings/UK0601.selected"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>

    <!-- 5.16 Responsible organization -->
    <sch:pattern>
        <sch:title>$loc/strings/UK0516r</sch:title>
        <sch:rule context="gmd:identificationInfo/gmd:MD_DataIdentification">

            <sch:let name="distributorNeeded" value="//gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset'
                or //gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='series'"/>
            <sch:let name="distributorCount" value="count(gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='distributor'])"/>

            <sch:let name="orgName" value="gmd:pointOfContact/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='distributor']/gmd:organisationName/gco:CharacterString/text()"/>

            <sch:assert test="not($distributorNeeded) or ($distributorNeeded and $distributorCount>0)">$loc/strings/UK0516.alert.distributor</sch:assert>
            <sch:report test="not($distributorNeeded)">$loc/strings/UK0516.report.nodistributor</sch:report>
            <sch:report test="$distributorNeeded and $distributorCount>0"><sch:value-of select="$loc/strings/UK0516.report.distributorfound"/>: <sch:value-of select="$orgName"/></sch:report>

        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>$loc/strings/UK0516</sch:title>
        <sch:rule context="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty">
            <sch:let name="distributorNeeded" value="//gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset'
                or //gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='series'"/>

            <sch:report test="gmd:organisationName/gco:CharacterString/text()"><sch:value-of select="$loc/strings/UK0516.report.organisation"/><sch:value-of select="gmd:organisationName/gco:CharacterString/text()"/></sch:report>

            <sch:assert test="not(boolean(gmd:individualName/gco:CharacterString))">$loc/strings/UK0516.alert.individual</sch:assert>

            <sch:assert test="gmd:organisationName/gco:CharacterString/text()">$loc/strings/UK0516.alert.organisation</sch:assert>
            <sch:assert test="gmd:organisationName/gco:CharacterString/text()">$loc/strings/UK0516.alert.organisation</sch:assert>

            <sch:assert test="not(boolean(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city))">$loc/strings/UK0516.alert.city</sch:assert>
            <sch:assert test="not(boolean(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea))">$loc/strings/UK0516.alert.administrativeArea</sch:assert>
            <sch:assert test="not(boolean(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode))">$loc/strings/UK0516.alert.postalCode</sch:assert>
            <sch:assert test="not(boolean(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country))">$loc/strings/UK0516.alert.country</sch:assert>

            <sch:assert test="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()">$loc/strings/UK0516.alert.email</sch:assert>

        </sch:rule>
    </sch:pattern>


    <!--METADATA STANDARD-->
    <sch:pattern>
        <sch:title>$loc/strings/UK999</sch:title>
        <sch:rule context="//gmd:MD_Metadata">

            <sch:report test="true()"><sch:value-of select="$loc/strings/UK999.report.name"/> <sch:value-of select="gmd:metadataStandardName/gco:CharacterString"/></sch:report>
            <sch:assert test="gmd:metadataStandardName/gco:CharacterString and gmd:metadataStandardName/gco:CharacterString = 'UK GEMINI'">$loc/strings/UK999.alert.name</sch:assert>

            <sch:report test="true()"><sch:value-of select="$loc/strings/UK999.report.version"/><sch:value-of select="gmd:metadataStandardVersion/gco:CharacterString"/></sch:report>
            <sch:assert test="gmd:metadataStandardVersion/gco:CharacterString and gmd:metadataStandardVersion/gco:CharacterString= '2.2'">$loc/strings/UK999.alert.version</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- ORIGINAL RULES -->



    <!--PATTERN Title -->
    <sch:pattern>
        <sch:title>Title</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi1-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title">
            <sch:assert test="string-length(.)>0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Alternative title</sch:title>
    </sch:pattern>

    <!--PATTERN Gemini2-mi2-Nillable -->
    <sch:pattern>
        <sch:title>Gemini2-mi2-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:alternateTitle">

            <sch:assert test="(string-length(.)>0) or (@gco:nilReason = 'inapplicable' or
                               @gco:nilReason = 'missing' or
                               @gco:nilReason = 'template' or
                               @gco:nilReason = 'unknown' or
                               @gco:nilReason = 'withheld' or
                               starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>



    <!--PATTERN Dataset Language -->
    <sch:pattern>
        <sch:title>Dataset Language</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi3-Language</sch:title>

        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:language">
            <sch:assert test="count(gmd:LanguageCode) = 1">Language shall be implemented with gmd:LanguageCode.</sch:assert>
        </sch:rule>

        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:language/gmd:LanguageCode">
            <sch:assert test="string-length(@codeListValue) > 0">The language code list value is absent.</sch:assert>
        </sch:rule>

    </sch:pattern>

    <sch:pattern>
        <sch:title>Abstract</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi4-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:abstract">

            <sch:assert test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>

        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Topic Category</sch:title>

        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]">

            <sch:assert test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or
                                ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series')
                               and
                                 count(gmd:topicCategory) &gt;= 1)
                              or
                               (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and
                                ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series')
                              or
                                count(../../gmd:hierarchyLevel) = 0">Topic category is mandatory for datasets and series. One or more shall be provided.</sch:assert>
        </sch:rule>

        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:topicCategory">

            <sch:assert test="((../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or
                                ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series')
                               and
                                 count(@gco:nilReason) = 0) or
                                 (../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and
                                  ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series')
                               or
                                count(../../../gmd:hierarchyLevel) = 0">Topic Category shall not be null.</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:pattern>
        <sch:title>Keyword</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]">
            <sch:assert test="count(gmd:descriptiveKeywords) &gt;= 1">Descriptive keywords are mandatory.</sch:assert>
        </sch:rule>
    </sch:pattern>


    <sch:pattern>
        <sch:title>Gemini2-mi6-Keyword-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:keyword">

            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>

        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi6-Thesaurus-Title-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:title">
            <sch:assert test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi6-Thesaurus-DateType-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:date/*[1]/gmd:dateType/*[1]">
            <sch:assert test="string-length(@codeListValue) &gt; 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Temporal extent</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType='gmd:EX_TemporalExtent'][1]/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType='gmd:EX_TemporalExtent'][1]/gmd:extent">

            <sch:assert test="count(gml:TimePeriod) = 1 or count(gml:TimeInstant) = 1">Temporal extent shall be implemented using gml:TimePeriod or
                        gml:TimeInstant</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Dataset reference date</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi8-ReferenceDate-DateType-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:date/*[1]/gmd:dateType/*[1]">
            <sch:assert test="string-length(@codeListValue) &gt; 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Lineage</sch:title>

        <sch:rule context="/*[1]">

            <sch:assert test="((gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or
                   gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and
                   count(gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement) = 1) or
                   (gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and
                   gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or
                    count(gmd:hierarchyLevel) = 0">Lineage is mandatory for datasets and series. One shall be provided.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi10-Statement-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement">

            <sch:assert test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld'
                     or starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>West and east longitude, north and south latitude </sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]">

            <sch:assert test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                    ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and                    (count(gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or                   count(gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]) &gt;= 1) or                   (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and                    ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or
                    count(../../gmd:hierarchyLevel) = 0">Geographic bounding box is mandatory for datasets and series. One or more
                        shall be provided.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi11-BoundingBox</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] [1]|                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]">

            <sch:assert test="string-length(gmd:westBoundLongitude) = 0
                              or (gmd:westBoundLongitude &gt;= -180.0 and
                                  gmd:westBoundLongitude &lt;= 180.0)">West bound longitude has a value of
                        <xsl:copy-of select="gmd:westBoundLongitude" />
                        which is outside bounds.</sch:assert>

            <sch:assert test="string-length(gmd:eastBoundLongitude) = 0
                              or (gmd:eastBoundLongitude &gt;= -180.0 and
                              gmd:eastBoundLongitude &lt;= 180.0)">East bound longitude has a value of
                        <xsl:copy-of select="gmd:eastBoundLongitude" />
                        which is outside bounds.</sch:assert>

            <sch:assert test="string-length(gmd:southBoundLatitude) = 0
                              or (gmd:southBoundLatitude &gt;= -90.0 and
                                  gmd:southBoundLatitude &lt;= gmd:northBoundLatitude)">South bound latitude has a value of
                        <xsl:copy-of select="gmd:southBoundLatitude" />
                        which is outside bounds.</sch:assert>

            <sch:assert test="string-length(gmd:northBoundLatitude) = 0
                              or (gmd:northBoundLatitude &lt;= 90.0 and
                                  gmd:northBoundLatitude &gt;= gmd:southBoundLatitude)">North bound latitude has a value of
                        <xsl:copy-of select="gmd:northBoundLatitude" />
                        which is outside bounds.</sch:assert>

        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi11-West-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude">
            <sch:assert test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi11-East-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude">
            <sch:assert test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi11-South-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude">
            <sch:assert test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mill-North-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude">
            <sch:assert test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Extent</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi15-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |
                           /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code |
                           /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |
                           /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Vertical extent information</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi16-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:minimumValue |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:maximumValue">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Spatial reference system</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi17-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Spatial Resolution</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi18-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:distance">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Resource locator</sch:title>
        <sch:rule context="/*[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]">
            <sch:assert test="count(gmd:linkage) = 0 or
                               (starts-with(normalize-space(gmd:linkage/*[1]), 'http://')  or
                                starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or
                                starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))">The value of resource locator does not appear to be a valid URL.
                        It has a value of '<xsl:copy-of select="gmd:linkage/*[1]" />'. The URL must start with either http://, https:// or ftp://.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi19-Nillable</sch:title>
        <sch:rule context="*[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]/gmd:linkage">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Data Format</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi21-Name-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:name">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi21-Version-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:version">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Responsible organisation</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]">
            <sch:assert test="count(gmd:pointOfContact) &gt;= 1">Responsible organisation is mandatory. At least one shall be provided.</sch:assert>
        </sch:rule>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact">
            <sch:assert test="count(@gco:nilReason) = 0">The value of responsible organisation shall not be null.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi23-ResponsibleParty</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact">
            <sch:assert test="count(*/gmd:organisationName) = 1">One organisation name shall be provided.</sch:assert>
            <sch:assert test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1">One email address shall be provided</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi23-OrganisationName-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:organisationName |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress">
            <sch:assert test="string-length(.) > 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi23-Role-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:role/*[1]">
            <sch:assert test="string-length(@codeListValue) > 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Frequency of update</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi24-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceMaintenance/*[1]/gmd:maintenanceAndUpdateFrequency/*[1]">
            <sch:assert test="string-length(@codeListValue) > 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Limitations on public access</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/gmd:MD_LegalConstraints |
                           /*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1][gco:isoType='gmd:MD_LegalConstraints']">
            <sch:assert test="count(gmd:accessConstraints[*/@codeListValue='otherRestrictions']) = 1">Limitations on public access code list value shall be 'otherRestrictions'.</sch:assert>
            <sch:assert test="count(gmd:otherConstraints) >= 1">Limitations on public access shall be expressed using gmd:otherConstraints.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi25-OtherConstraints-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi25-AccessConstraints-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]">
            <sch:assert test="string-length(@codeListValue) > 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Use constraints</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]">
            <sch:assert test="count(gmd:resourceConstraints/*[1]/gmd:useLimitation) &gt;= 1">Use limitation shall be provided.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi26-UseLimitation-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useLimitation">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Additional information source</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi27-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:supplementalInformation">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Unique resource identifier</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]">
            <sch:assert test="((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or
                    ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and
                    count(gmd:identifier) &gt;= 1) or
                    (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and
                    ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or
                    count(../../../../gmd:hierarchyLevel) = 0">Unique resource identifier is mandatory for datasets and series. One or
                        more shall be provided.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi36-Code-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code">
            <sch:assert test="string-length(.) > 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi36-CodeSpace-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Resource type</sch:title>
        <sch:rule context="/*[1]">
            <sch:assert test="count(gmd:hierarchyLevel) = 1">Resource type is mandatory. One shall be provided.</sch:assert>
            <sch:assert test="gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or
                              gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series' or
                              gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'service'">Value of resource type shall be 'dataset', 'series' or 'service'.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi39-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:hierarchyLevel/*[1]">
            <sch:assert test="string-length(@codeListValue) > 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Conformity</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi41-Pass-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:pass">
            <sch:assert test="string-length(.) > 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi41-Explanation-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:explanation">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Specification</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi42-Title-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:title">
            <sch:assert test="string-length(.) > 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi42-Date-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi42-DateType-CodeList</sch:title>
        <sch:rule context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date/*[1]/gmd:dateType/*[1]">
            <sch:assert test="string-length(@codeListValue) > 0">The codeListValue attribute does not have a value.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Equivalent scale</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi43-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:equivalentScale/*[1]/gmd:denominator">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Metadata language</sch:title>
        <sch:rule context="/*[1]">
            <sch:assert test="count(gmd:language) = 1">Metadata language is mandatory. One shall be provided.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi33-Language</sch:title>
        <sch:rule context="/*[1]/gmd:language">
            <sch:assert test="count(gmd:LanguageCode) = 1">Language shall be implemented with gmd:LanguageCode.</sch:assert>
        </sch:rule>
        <sch:rule context="/*[1]/gmd:language/gmd:LanguageCode">
            <sch:assert test="string-length(@codeListValue) &gt; 0">The language code list value is absent.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Metadata date</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi30-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:dateStamp">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Metadata point of contact</sch:title>
        <sch:rule context="/*[1]/gmd:contact">
            <sch:assert test="count(@gco:nilReason) = 0">The value of metadata point of contact shall not be null.</sch:assert>
            <sch:assert test="count(parent::node()[gmd:contact/*[1]/gmd:role/*[1]/@codeListValue='pointOfContact']) &gt;= 1">At least one metadata point of contact shall have the role
                        'pointOfContact'.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi35-ResponsibleParty</sch:title>
        <sch:rule context="/*[1]/gmd:contact">
            <sch:assert test="count(*/gmd:organisationName) = 1">One organisation name shall be provided.</sch:assert>
            <sch:assert test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1">One email address shall be provided</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi35-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:contact/*[1]/gmd:organisationName | /*[1]/gmd:contact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress">
            <sch:assert test="string-length(.) > 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Spatial data service type</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/srv:SV_ServiceIdentification |
                           /*[1]/gmd:identificationInfo[1]/*[@gco:isoType='srv:SV_ServiceIdentification'][1]">
            <sch:assert test="(../../gmd:hierarchyLevel/*[1]/@codeListValue = 'service' and
                               count(srv:serviceType) = 1) or
                              ../../gmd:hierarchyLevel/*[1]/@codeListValue != 'service'">If the resource type is service, one spatial data service type shall
                        be provided.</sch:assert>
            <sch:assert test="srv:serviceType/*[1] = 'discovery' or
                              srv:serviceType/*[1] = 'view' or
                              srv:serviceType/*[1] = 'download' or
                              srv:serviceType/*[1] = 'transformation' or
                              srv:serviceType/*[1] = 'invoke' or
                              srv:serviceType/*[1] = 'other'">Service type shall be one of 'discovery', 'view', 'download',
                        'transformation', 'invoke' or 'other' following INSPIRE generic
                        names.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-mi37-Nillable</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/srv:serviceType">
            <sch:assert test="(string-length(.) &gt; 0) or
                    (@gco:nilReason = 'inapplicable' or
                     @gco:nilReason = 'missing' or
                     @gco:nilReason = 'template' or
                     @gco:nilReason = 'unknown' or
                     @gco:nilReason = 'withheld' or
                   starts-with(@gco:nilReason, 'other:'))">Element shall have a value or a valid Nil Reason: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Coupled resource</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn">
            <sch:assert test="count(@xlink:href) = 1">Coupled resource shall be implemented by reference using the xlink:href
                        attribute.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Data identification citation</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation">
            <sch:assert test="count(@gco:nilReason) = 0">Identification information citation shall not be null.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Metadata resource type test</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]">

            <sch:let name="isData" value="../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='dataset' or
                                      ../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='series'"/>

            <sch:let name="isService" value="../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='service'"/>

            <sch:let name="dataIdExists" value="count(*[local-name()='MD_DataIdentification'])=1 or
                                            count(*[@gco:isoType='gmd:MD_DataIdentification'])=1"/>

            <sch:let name="serviceIdExists" value="count(*[local-name()='SV_ServiceIdentification'])=1 or
                                            count(*[@gco:isoType='srv:SV_ServiceIdentification'])=1"/>

            <sch:report test="$isData">Resource type is data</sch:report>
            <sch:report test="$isService">Resource type is service</sch:report>

            <sch:assert test="not($isData) or
                          ( $isData and $dataIdExists ) or
                          count(../gmd:hierarchyLevel) = 0">The first identification information element shall be of type
                gmd:MD_DataIdentification.</sch:assert>

            <sch:assert test="not($isService) or
                          ( $isService and $serviceIdExists ) or
                          count(../gmd:hierarchyLevel) = 0">The first identification information element shall be of type
                srv:SV_ServiceIdentification.</sch:assert>

        <!-- This pattern has been revised in GEMINI2.2 because old one could throw this error:
            A sequence of more than one item is not allowed as the first argument of local-name() (<gmd:MD_DataIdentification/>, <geonet:element/>, ...)  -->

    <!--
        <sch:assert test="((../gmd:hierarchyLevel[1]/*[1]/@codeListValue='dataset' or
                ../gmd:hierarchyLevel[1]/*[1]/@codeListValue='series') and
                (local-name(*) = 'MD_DataIdentification' or */@gco:isoType='gmd:MD_DataIdentification')) or
                (../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and
                ../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or
                count(../gmd:hierarchyLevel) = 0">The first identification information element shall be of type
                    gmd:MD_DataIdentification.</sch:assert>

                              <sch:assert test="((../gmd:hierarchyLevel[1]/*[1]/@codeListValue='service') and
                                  (local-name(*) = 'SV_ServiceIdentification' or */@gco:isoType='srv:SV_ServiceIdentification')) or
                                 (../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'service') or
                                  count(../gmd:hierarchyLevel) = 0">The first identification information element shall be of type
                                      srv:SV_ServiceIdentification.</sch:assert>-->
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Metadata file identifier</sch:title>
        <sch:rule context="/*[1]">
            <sch:assert test="count(gmd:fileIdentifier) = 1">A metadata file identifier shall be provided. Its value shall be a
                system generated GUID.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Gemini2-at3-NotNillable</sch:title>
        <sch:rule context="/*[1]/gmd:fileIdentifier">
            <sch:assert test="string-length(.) > 0 and count(./@gco:nilReason) = 0">Element is not nillable and shall have a value: <sch:value-of select="name(.)" /></sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Constraints</sch:title>
        <sch:rule context="/*[1]/gmd:identificationInfo[1]/*[1]">
            <sch:assert test="count(gmd:resourceConstraints) &gt;= 1">Limitations on public access and use constrains are required.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>Creation date type</sch:title>
        <sch:rule context="//gmd:CI_Citation | //*[@gco:isoType='gmd:CI_Citation'][1]">
            <sch:assert test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue='creation']) &lt;= 1">There shall not be more than one creation date.</sch:assert>
        </sch:rule>
    </sch:pattern>

</sch:schema>
