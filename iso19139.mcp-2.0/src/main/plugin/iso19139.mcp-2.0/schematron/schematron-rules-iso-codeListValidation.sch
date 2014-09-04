<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <!--
        This Schematron schema looks up the codeList and checks that
        the codeListValue in the XML metadata document are valid
        according to that codeList.
    -->
    <!-- 
        This script was developed for ANZLIC - the Spatial Information Council 
        by Geoscience Australia
        as part of a project to develop an XML implementation of the ANZLIC ISO Metadata Profile. 
        
        July 2007.
        
        This work is licensed under the Creative Commons Attribution 2.5 License. 
        To view a copy of this license, visit 
        http://creativecommons.org/licenses/by/2.5/au/ 
        or send a letter to 
        
        Creative Commons, 
        543 Howard Street, 5th Floor, 
        San Francisco, California, 94105, 
        USA.
    -->
    <sch:title>codeList Schematron validation for ANZLIC ISO 19115(19139) Profile Version 1.1</sch:title>
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml" />
    <sch:ns prefix="gmx" uri="http://www.isotc211.org/2005/gmx"/>
    <sch:pattern id="checkCodeList">
        <sch:rule context="//*[@codeList]">
            <sch:let name="codeListDoc" value="document(substring-before(@codeList,'#'))//gmx:CodeListDictionary[@gml:id = substring-after(current()/@codeList,'#')]"/>
            <sch:assert test="$codeListDoc">Unable to find the specified
                codeList document or CodeListDictionary node.</sch:assert>
            <sch:assert test="@codeListValue = $codeListDoc/gmx:codeEntry/gmx:CodeDefinition/gml:identifier">codeListValue is not in the specified codeList.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
