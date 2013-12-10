<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation / Monitoring Site</sch:title>

    <sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
    <sch:ns prefix="sml" uri="http://www.opengis.net/sensorML/1.0.1"/>
    <sch:ns prefix="swe" uri="http://www.opengis.net/swe/1.0.1"/>
    <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>    

    <!-- =============================================================
    Monitoring Site schematron rules:
    ============================================================= -->

    <!-- SiteIDType -->
    <!--<sch:pattern>
        <sch:title>$loc/strings/SiteID</sch:title>

        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:identifier[@name='siteID']/sml:Term">
            <sch:let name="missingSiteIDType" value="normalize-space(translate(@definition, 'http://www.ec.gc.ca/data_donnees/standards/definitions/1-0/siteID/', ''))" />
            <sch:assert test="$missingSiteIDType">$loc/strings/SiteIDType</sch:assert>
        </sch:rule>
    </sch:pattern>-->

    <!-- Site status -->
    <sch:pattern>
        <sch:title>$loc/strings/SiteStatus</sch:title>

        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']//swe:Text/swe:value">
          <sch:let name="missingSiteStatus" value="normalize-space(.)" />
          <sch:assert test="$missingSiteStatus">$loc/strings/SiteStatus</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- Site ShortName -->
    <!--<sch:pattern>
        <sch:title>$loc/strings/ShortName</sch:title>

        <sch:rule context="//ec:EnglishVersion/sml:SensorML/sml:member//sml:System//sml:identifier[@name='siteShortName']/sml:Term/sml:value">
            <sch:let name="missingShortName" value="normalize-space(text())" />
            <sch:assert test="$missingShortName">$loc/strings/ShortName</sch:assert>
            <sch:report test="$missingShortName"><sch:value-of select="text()"/></sch:report>
        </sch:rule>
    </sch:pattern>-->

   <!-- Site ShortName -->
    <!--<sch:pattern>
        <sch:title>$loc/strings/ShortName</sch:title>

        <sch:rule context="//ec:FrenchVersion/sml:SensorML/sml:member//sml:System//sml:identifier[@name='siteShortName']/sml:Term/sml:value">
            <sch:let name="missingShortName" value="normalize-space(text())" />
            <sch:assert test="$missingShortName">$loc/strings/ShortName</sch:assert>
            <sch:report test="$missingShortName"><sch:value-of select="text()"/></sch:report>
        </sch:rule>
    </sch:pattern>-->

    <!-- Site FullName -->
    <!--<sch:pattern>
       <sch:title>$loc/strings/FullName</sch:title>

        <sch:rule context="//ec:EnglishVersion/sml:SensorML/sml:member//sml:System//sml:identifier[@name='siteFullName']/sml:Term/sml:value">
            <sch:let name="missingFullName" value="normalize-space(text())" />
            <sch:assert test="$missingFullName">$loc/strings/FullName</sch:assert>
            <sch:report test="$missingFullName"><sch:value-of select="text()"/></sch:report>
        </sch:rule>
    </sch:pattern>-->

    <!-- Observed phenomenum -->
    <sch:pattern>
        <sch:title>$loc/strings/ObservedPhenomenum</sch:title>

        <sch:rule context="//sml:SensorML/sml:member//sml:System/sml:inputs/sml:InputList/sml:input[swe:ObservableProperty/@definition='']">
            <sch:let name="missingObservedPhenomenum" value="normalize-space(@name)" />
            <sch:assert test="$missingObservedPhenomenum">$loc/strings/ObservedPhenomenum</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- Site keywords -->
    <sch:pattern>
        <sch:title>$loc/strings/Keyword</sch:title>

         <sch:rule context="//sml:SensorML/sml:member//sml:System/*/*/sml:keywords/sml:KeywordList/sml:keyword">
                   <sch:let name="missingKeyword" value="normalize-space(text())" />
                   <sch:assert test="$missingKeyword">$loc/strings/Keyword</sch:assert>
               </sch:rule>
    </sch:pattern>

    <!-- Site Documentation - Online Resource description -->
    <sch:pattern>
        <sch:title>$loc/strings/Description</sch:title>

        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:documentation/sml:DocumentList/sml:member[@name='siteOnlineResource']/sml:Document/gml:description">
            <sch:assert test="((normalize-space(../sml:onlineResource/@xlink:href) != '') and (normalize-space(text()) != '')) or
                                        ((normalize-space(../sml:onlineResource/@xlink:href) = '') and (normalize-space(text()) = '')) or
                                        (normalize-space(text()) != '')
                                  " >$loc/strings/Description</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- Site Documentation - Online Resource format -->
    <sch:pattern>
        <sch:title>$loc/strings/Format</sch:title>

        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:documentation/sml:DocumentList/sml:member[@name='siteOnlineResource']/sml:Document/sml:format">
            <sch:assert test="((normalize-space(../sml:onlineResource/@xlink:href) != '') and (normalize-space(text()) != '')) or
                              ((normalize-space(../sml:onlineResource/@xlink:href) = '') and (normalize-space(text()) = '')) or
                              (normalize-space(text()) != '')
                        " >$loc/strings/Format</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>$loc/strings/EC1</sch:title>
        
        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:position[@name='sitePosition']/swe:Position">

            <sch:let name="missing" value="not(string(@referenceFrame))" />
            
            <sch:assert
                test="not($missing)"
                >$loc/strings/EC1</sch:assert>
        
        </sch:rule>
        
    </sch:pattern>

     <sch:pattern>
        <sch:title>$loc/strings/EC2</sch:title>
        
        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:position[@name='sitePosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']//swe:Quantity/swe:value">

            <sch:let name="missing" value="not(string(.))" />
            
            <sch:assert
                test="not($missing)"
                >$loc/strings/EC2</sch:assert>
        
            <sch:report
                test="not($missing)"
                > -- <sch:value-of select="."/> -- </sch:report>

        </sch:rule>
        
    </sch:pattern>

    <sch:pattern>
        <sch:title>$loc/strings/EC3</sch:title>
        
        <sch:rule context="//sml:SensorML/sml:member//sml:System//sml:position[@name='sitePosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']//swe:Quantity/swe:value">

          
            <sch:let name="missing" value="not(string(.))" />
            
            <sch:assert
                test="not($missing)"
                >$loc/strings/EC3</sch:assert>
    
            <sch:report
                test="not($missing)"
                > -- <sch:value-of select="."/> -- </sch:report>    
        </sch:rule>
        
    </sch:pattern>

</sch:schema>
