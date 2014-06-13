<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"                  xmlns:gmd="http://www.isotc211.org/2005/gmd"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xmlns:gml="http://www.opengis.net/gml"
                 xmlns:gco="http://www.isotc211.org/2005/gco"
                 xmlns:gts="http://www.isotc211.org/2005/gts"
                 xmlns:geonet="http://www.fao.org/geonetwork"
                 xmlns:gmx="http://www.isotc211.org/2005/gmx"
                 xmlns:oai="http://www.openarchives.org/OAI/2.0/"  
                 xmlns:fn="http://www.w3.org/2005/xpath-functions"
                 xmlns="http://ands.org.au/standards/rif-cs/registryObjects">

<!-- stylesheet to convert iso19139.anzlic in OAI-PMH ListRecords response to RIF-CS -->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="root">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="gmd:MD_Metadata">
	<xsl:element name="registryObjects">
		<xsl:attribute name="xsi:schemaLocation">
        	<xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates select="." mode="collection"/>
	</xsl:element>
</xsl:template>

<xsl:template match="gmd:voice[not(@gco:nilReason)]">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>voice</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="concat('tel:',translate(translate(.,'+',''),' ','-'))"/>
		</xsl:element>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:facsimile[not(@gco:nilReason)]">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>fax</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="concat('tel:',translate(translate(.,'+',''),' ','-'))"/>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="gmd:electronicMailAddress[not(@gco:nilReason)]">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>email</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="gmd:URL[not(@gco:nilReason)]">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>url</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:element>
</xsl:template>



<xsl:template match="gml:timePosition[not(@gco:nilReason)]">
    <xsl:choose>
        <xsl:when test='contains(., "T")'>
            <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(., 'T00:00:00Z')"/> 
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="gml:beginPosition[not(@gco:nilReason)]">
    <xsl:choose>
        <xsl:when test='contains(., "T")'>
            <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(., 'T00:00:00Z')"/> 
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="gml:endPosition[not(@gco:nilReason)]">
    <xsl:choose>
        <xsl:when test='contains(., "T")'>
            <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(., 'T00:00:00Z')"/> 
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template match="gmd:organisationName[not(@gco:nilReason)]">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>locationDescriptor</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:deliveryPoint[not(@gco:nilReason)]">
    <xsl:for-each select="*">
        <xsl:element name="addressPart">
            <xsl:attribute name="type">
                <xsl:text>addressLine</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:for-each>
</xsl:template>


<xsl:template match="gmd:city[not(@gco:nilReason)]">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>suburbOrPlaceOrLocality</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:administrativeArea[not(@gco:nilReason)]">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>stateOrTerritory</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:postalCode[not(@gco:nilReason)]">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>postCode</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:country[not(@gco:nilReason)]">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>country</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:title">
	<xsl:value-of select="."/>
</xsl:template>


<xsl:template match="gmd:EX_GeographicBoundingBox">
	<xsl:element name="spatial">
		<xsl:attribute name="type">
			<xsl:text>iso19139dcmiBox</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="concat('northlimit=',gmd:northBoundLatitude/gco:Decimal,'; southlimit=',gmd:southBoundLatitude/gco:Decimal,'; westlimit=',gmd:westBoundLongitude/gco:Decimal,'; eastLimit=',gmd:eastBoundLongitude/gco:Decimal)"/>
		<xsl:apply-templates select="../gmd:verticalElement"/>
		<xsl:text>; projection=WGS84</xsl:text>
	</xsl:element>
</xsl:template>


<xsl:template match="gmd:verticalElement">
	<xsl:value-of select="concat('; uplimit=',gmd:EX_VerticalExtent/gmd:maximumValue/gco:Real,'; downlimit=',gmd:EX_VerticalExtent/gmd:minimumValue/gco:Real)"/>
</xsl:template>


<xsl:template match="gmd:description[not(@gco:nilReason)]">
	<xsl:element name="spatial">
		<xsl:attribute name="type">
			<xsl:text>text</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="gml:coordinates">
	<xsl:element name="spatial">
		<xsl:attribute name="type">
			<xsl:text>gmlKmlPolyCoords</xsl:text>
		</xsl:attribute>
		<xsl:call-template name="gmlToKml">
			<xsl:with-param name="coords" select="."/>
		</xsl:call-template>
	</xsl:element>
</xsl:template>


<xsl:template name="gmd:MD_Keywords">
    <xsl:for-each select="gmd:keyword">
        <xsl:element name="subject">
            <xsl:attribute name="type">
                <xsl:text>local</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:for-each>

    <xsl:for-each-group select="gmd:keyword" group-by="substring-before(substring-after(., 'EARTH SCIENCE &gt; '), '&gt;')">
        <xsl:call-template name="splitSubject">
            <xsl:with-param name="string" select="current-grouping-key()"/>
        </xsl:call-template>        
    </xsl:for-each-group>

    <xsl:for-each-group select="gmd:keyword" group-by="substring-after(., '|')">
        <xsl:call-template name="splitSubject">
            <xsl:with-param name="string" select="current-grouping-key()"/>
        </xsl:call-template>    
    </xsl:for-each-group>

</xsl:template>



<xsl:template match="gmd:MD_Keywords">
    <xsl:for-each select="gmd:keyword">
        <xsl:element name="subject">
            <xsl:attribute name="type">
                <xsl:text>local</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:for-each>

    <xsl:for-each-group select="gmd:keyword" group-by="substring-before(substring-after(., 'EARTH SCIENCE &gt; '), '&gt;')">
        <xsl:call-template name="splitSubject">
            <xsl:with-param name="string" select="current-grouping-key()"/>
        </xsl:call-template>	
    </xsl:for-each-group>
</xsl:template>


<xsl:template match="gmd:MD_TopicCategoryCode">			
    <xsl:call-template name="splitSubject">
        <xsl:with-param name="string" select="."/>
    </xsl:call-template>  
</xsl:template>

<xsl:template match="gmd:abstract">
	<xsl:element name="description">
		<xsl:attribute name="type">
			<xsl:text>brief</xsl:text>
		</xsl:attribute>
	    <xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<!-- =================================================================================== -->
<!-- Create a description element from a gmd:lineage element                             --> 
<!-- =================================================================================== -->

<xsl:template match="gmd:lineage">
    <xsl:if test="normalize-space(gmd:LI_Lineage/gmd:statement)!=''">
        <xsl:element name="description">
            <xsl:attribute name="type">
                <xsl:text>brief</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="gmd:LI_Lineage/gmd:statement"/>
        </xsl:element>
    </xsl:if>
</xsl:template>
	
<!--
    Current way of handling relation.  We need to modify this for RIF-CS terms
-->
<xsl:template name="collectionToPersonRole">
        <xsl:param name="code"/>
        <xsl:element name="relation">
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="compare($code, 'resourceProvider') = 0">
                        <xsl:value-of select="'isManagedBy'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'author') = 0">
                        <xsl:value-of select="'isOwnedBy'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'originator') = 0">
                        <xsl:value-of select="'hasCollector'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'resourceProvider') = 0">
                        <xsl:value-of select="'hasCollector'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'distributor') = 0">
                        <xsl:value-of select="'isManagedBy'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'processor') = 0">
                        <xsl:value-of select="'isManagedBy'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'principalInvestigator') = 0">
                        <xsl:value-of select="'hasCollector'" />
                    </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$code"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
</xsl:template>

<xsl:template match="gmd:role">
        <xsl:variable name="code">
           <xsl:value-of select="gmd:CI_RoleCode/@codeListValue"/>
        </xsl:variable>

        <xsl:variable name="codelist">
            <xsl:value-of select="substring-after(gmd:CI_RoleCode/@codeList, '#')"/>
        </xsl:variable>

        <xsl:variable name="url">
            <xsl:value-of select="substring-before(gmd:CI_RoleCode/@codeList, '#')"/>
        </xsl:variable>

        <xsl:element name="relation">
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="compare($code, 'resourceProvider') = 0">
                        <xsl:value-of select="'isManagerOf'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'author') = 0">
                        <xsl:value-of select="'isOwnerOf'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'originator') = 0">
                        <xsl:value-of select="'isCollectorOf'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'resourceProvider') = 0">
                        <xsl:value-of select="'isCollectorOf'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'distributor') = 0">
                        <xsl:value-of select="'isManagerOf'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'processor') = 0">
                        <xsl:value-of select="'isManagerOf'" />
                    </xsl:when>
                    <xsl:when test="compare($code, 'principalInvestigator') = 0">
                        <xsl:value-of select="'isCollectorOf'" />
                    </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$code"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
</xsl:template>


<!-- thanks to stack overflow http://stackoverflow.com/questions/136500/does-xslt-have-a-split-function -->
<!--
Doing stuff for names
<xsl:template match="gmd:individualName">
    <xsl:variable name="first" select='substring-before(".", " ")' /> 
    <xsl:variable name="remaining" select='substring-after(".", " ")'/> 
    

</xsl:template>
-->
<!--
	CREATE COLLECTION OBJECT
-->
<xsl:template match="gmd:MD_Metadata" mode="collection">


<!-- the originating source --> 
  <xsl:param name="origSource" select="/root/env/siteURL"/>
        
    <!-- the registry object group -->
    <xsl:param name="group" select="'Australian Ocean Data Network'"/>


    <!-- Originating source, as ANDS demands it, must be a unique string that can identify the institution where the record comes from.  We are currently adopting the use of
         the URL from the record's pointOfContact.  If non is present, then we'll just use the aodn MEST's URL -->
    <xsl:variable name="originatingSource" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
	
	<xsl:variable name="originatingSourceElement">
		<xsl:element name="originatingSource">
			<xsl:choose>
				<xsl:when test="not($originatingSource) or $originatingSource=''">
					<xsl:value-of select="$origSource"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$originatingSource"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:variable>
	
	<xsl:variable name="ge" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement"/>
	<xsl:variable name="te" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent"/>
	<xsl:variable name="ve" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement"/>
	
    <xsl:if test="not($te='')">
        <xsl:variable name="te" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElementi/gmd:EX_TemporalExtent"/>
    </xsl:if>
    <xsl:variable name="formattedFrom">
		<xsl:choose>
			<xsl:when test="$te[1]/gmd:extent/gml:TimePeriod/gml:beginPosition">
				<xsl:apply-templates select="$te[1]/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
			</xsl:when>
			<xsl:when test="$te[1]/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
				<xsl:apply-templates select="$te[1]/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
			</xsl:when>
		</xsl:choose>					
	</xsl:variable>
			
	<xsl:variable name="formattedTo">
		<xsl:choose>
			<xsl:when test="$te[position()=last()]/gmd:extent/gml:TimePeriod/gml:endPosition">
				<xsl:apply-templates select="$te[position()=last()]/gmd:extent/gml:TimePeriod/gml:endPosition"/>
			</xsl:when>
			<xsl:when test="$te[position()=last()]/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
				<xsl:apply-templates select="$te[position()=last()]/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="from">
		<xsl:choose>
			<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition">
				<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
			</xsl:when>
			<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
				<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
			
	<xsl:variable name="to">
		<xsl:choose>
			<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition">
				<xsl:value-of	select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
			</xsl:when>
			<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
				<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

    <!-- Another ANDS requrirement to have all records to be namespaced by "AODN" -->
    <xsl:variable name="collectionKey">
        <xsl:value-of select="concat('AODN:', gmd:fileIdentifier)" />
    </xsl:variable>

	<!-- Collect parties related to collection (exclude parties responsible for thesauri!) -->
	
	<xsl:variable name="relatedParties" select="descendant::gmd:CI_ResponsibleParty[not(ancestor::gmd:thesaurusName)]"/>  
	
	<xsl:element name="registryObject">
		<xsl:attribute name="group">
			<xsl:value-of select="$group"/>
		</xsl:attribute>
		<xsl:element name="key">
			<xsl:value-of select="$collectionKey"/>
		</xsl:element>
		
		<xsl:copy-of select="$originatingSourceElement"/>
		
		<xsl:element name="collection">
			<xsl:attribute name="type">
				<xsl:value-of select="'dataset'"/>
			</xsl:attribute>
			<xsl:element name="identifier">
				<xsl:attribute name="type">
					<xsl:text>local</xsl:text>
				</xsl:attribute>
				<xsl:value-of select="$collectionKey"/>
			</xsl:element>
			
			<xsl:element name="name">
				<xsl:attribute name="type">
					<xsl:text>primary</xsl:text>
				</xsl:attribute>
				<xsl:element name="namePart">
					<xsl:attribute name="type">
						<xsl:text>full</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
				</xsl:element>
			</xsl:element>

        <!--  Location element  -->
			
		<xsl:variable name="metadataPointOfTruth" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:description = 'Point of truth URL of this metadata record']/gmd:linkage/gmd:URL"/>

		<xsl:call-template name="location">
			<xsl:with-param name="metadataPointOfTruth" select="$metadataPointOfTruth"/>
			<xsl:with-param name="origSource" select="$origSource"/>
		</xsl:call-template>
			
		<!-- Coverage element -->

			<xsl:if test="$ge/gmd:EX_GeographicBoundingBox">
				<xsl:element name="coverage">
					<!-- spatial elements  -->
					<xsl:apply-templates select="$ge/gmd:EX_GeographicBoundingBox"/>
					
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description"/>

					<xsl:apply-templates select="$ge/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:coordinates[text()!='']"/>

					<!-- temporal element -->
					<xsl:if test="$formattedFrom!='' or $formattedTo!='' ">
						<xsl:call-template name="temporalCoverage">
							<xsl:with-param name="from" select="$formattedFrom"/>
							<xsl:with-param name="to" select="$formattedTo"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:element>
			</xsl:if>

			<!-- related parties generated here -->
			<xsl:for-each-group select="$relatedParties[(gmd:individualName[not(@gco:nilReason)] or gmd:positionName[not(@gco:nilReason)] or gmd:organisationName[not(@gco:nilReason)]) and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]"  group-by="gmd:role/gmd:CI_RoleCode">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
                    <xsl:choose>   
                        <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                            <xsl:value-of select="concat('AODN:', gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress[1])" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="string(gmd:individualName)">
                                    <xsl:value-of select="concat('AODN:', gmd:individualName)" />
                                </xsl:when>                        
                                <xsl:when test="string(gmd:positionName)">
                                    <xsl:value-of select="concat('AODN:', gmd:positionName)"/>
                                </xsl:when>
                                <xsl:otherwise>                            
                                    <xsl:value-of select="concat('AODN:', gmd:organisationName)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>

                    

					</xsl:element>	
					<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
						<xsl:variable name="code">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:variable>
		
						<xsl:variable name="codelist">
							<xsl:value-of select="substring-after(gmd:CI_RoleCode/@codeList, '#')"/>
						</xsl:variable>
			
						<xsl:variable name="url">
							<xsl:value-of select="substring-before(gmd:CI_RoleCode/@codeList, '#')"/>
						</xsl:variable>

                        <xsl:call-template name="collectionToPersonRole">
                            <xsl:with-param name="code" select="$code" />
                        </xsl:call-template>
					</xsl:for-each-group> 
				</xsl:element>
			</xsl:for-each-group>

			<xsl:for-each-group select="$relatedParties[gmd:organisationName[not(@gco:nilReason)] and not(gmd:role/gmd:CI_RoleCode/@codeListValue='') and gmd:individualName='']" group-by="gmd:organisationName">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="current-grouping-key()"/>
					</xsl:element>
					<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
						<xsl:variable name="code">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:variable>

						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="$code"/>
							</xsl:attribute>
						</xsl:element>		
					</xsl:for-each-group>
				</xsl:element>
			</xsl:for-each-group>
			
            <xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords"/>
			<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>
			<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract"/>
			<xsl:apply-templates select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage"/>
			

            <!-- for access constraints -->
            <xsl:variable name="legals" select="descendant::gmd:resourceConstraints[not(@gco:nilReason)]/*"/>
              <xsl:for-each select="$legals/node()">
                <xsl:if test="count(tokenize(., ' ' )) &gt; 1">
                    <xsl:element name="description">
                        <xsl:attribute name="type">
                            <xsl:choose>
                                <xsl:when test="name(.) eq 'gmd:accessConstraints'">
                                    <xsl:text>accessRights</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>rights</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="." />
                   </xsl:element>
                </xsl:if>
            </xsl:for-each>

<xsl:if test="$te/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
				
				<xsl:if test="not($from='') and $formattedFrom=''">
					<xsl:element name="description">
						<xsl:attribute name="type">
							<xsl:text>temporal</xsl:text>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$from = $to or $to=''">
								<xsl:text>Time period: </xsl:text>
								<xsl:value-of select="$from"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Time period: </xsl:text>
								<xsl:value-of select="concat($from, ' to ', $to)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
			</xsl:if>		
		</xsl:element>
	</xsl:element>
	<xsl:for-each-group select="$relatedParties[(gmd:individualName[not(@gco:nilReason)] or gmd:positionName[not(@gco:nilReason)] or gmd:organisationName[not(@gco:nilReason)]) and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:role/gmd:CI_RoleCode">
        <xsl:if test="count(*) &gt; 2">

		<xsl:element name="registryObject">
			<xsl:attribute name="group">
				<xsl:value-of select="$group"/>
			</xsl:attribute>
                <xsl:element name="key">
                    <xsl:choose>   
                        <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                            <xsl:value-of select="concat('AODN:', gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress[1])" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- if there is an individualName element, we can assume this is a PERSON -->
                                <xsl:when test="string(gmd:individualName)">
                                    <xsl:value-of select="gmd:individualName" />
                                </xsl:when>    
                                <!-- if there is no individualName, but have a position name, then we assume this is a position, which is still a PARTY, not a group -->
                                <xsl:when test="string(gmd:positionName)">
                                    <xsl:value-of select="gmd:positionName"/>
                                </xsl:when>
                                <xsl:otherwise>    
                                    <!-- otherwise, we can only really go with organisationName, so this MUST be a group -->
                                    <xsl:value-of select="gmd:organisationName"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
    			</xsl:element>
			
			<xsl:copy-of select="$originatingSourceElement"/>
			
			<xsl:element name="party">
				<xsl:attribute name="type">
                   <xsl:choose>
                        <xsl:when test="string(gmd:individualName)">
                            <xsl:value-of select="'person'" />                        
                        </xsl:when>
                        <xsl:when test="string(gmd:positionName)">
                            <xsl:value-of select="'person'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'group'"/>
                        </xsl:otherwise>
                    </xsl:choose>


					<!--<xsl:text>person</xsl:text>-->
				</xsl:attribute>
				<xsl:element name="name">
					<xsl:attribute name="type">
						<xsl:text>primary</xsl:text>
					</xsl:attribute>
					<xsl:element name="namePart">
						<xsl:attribute name="type">
							<xsl:text>full</xsl:text>
						</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="string(gmd:individualName)">
                                <xsl:value-of select="gmd:individualName" />
                            </xsl:when>
                            <xsl:when test="string(gmd:positionName)">
                                <xsl:value-of select="gmd:positionName"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="gmd:organisationName"/>
                            </xsl:otherwise>
                        </xsl:choose>

						<!--<xsl:value-of select="current-grouping-key()"/>-->
					</xsl:element>
				</xsl:element>
				
				<!-- to normalise parties within a single record we need to group them, obtain the fragment for each party with the most information, and at the same time cope with rubbish data. In the end the only way to cope is to ensure at least an organisation name, city, phone or fax exists (sigh) -->
							<xsl:if test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:facsimile]">
								<xsl:element name="location">
									<xsl:element name="address">
										<xsl:element name="physical">
											<xsl:attribute name="type">
												<xsl:text>streetAddress</xsl:text>
											</xsl:attribute>
											<xsl:apply-templates select="gmd:organisationName"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
										</xsl:element>
									</xsl:element>
								    <xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:facsimile] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress or gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
                                        <xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:element>
							</xsl:if>

               <xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="$collectionKey"/>
					</xsl:element>	

    				<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
                        <xsl:apply-templates select="current-group()" />
					</xsl:for-each-group>
				</xsl:element>


                <xsl:for-each-group select="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword" group-by="substring-before(substring-after(., 'EARTH SCIENCE &gt; '), '&gt;')">
                    <xsl:call-template name="splitSubject">
                        <xsl:with-param name="string" select="current-grouping-key()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
			</xsl:element>
        </xsl:element>
        </xsl:if>

       </xsl:for-each-group>

	<!-- Create all the associated party objects for organisations -->
	<xsl:for-each-group select="$relatedParties[gmd:individualName[@gco:nilReason] and gmd:organisationName[not(@gco:nilReason)] and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:organisationName">
		<xsl:element name="registryObject">
			<xsl:attribute name="group">
				<xsl:value-of select="$group"/>
			</xsl:attribute>
			<xsl:element name="key">
				<xsl:value-of select="current-grouping-key()"/>
			</xsl:element>
			
			<xsl:copy-of select="$originatingSourceElement"/>
			
			<xsl:element name="party">
				<xsl:attribute name="type">
					<xsl:text>person</xsl:text>
				</xsl:attribute>
				<xsl:element name="name">
					<xsl:attribute name="type">
						<xsl:text>primary</xsl:text>
					</xsl:attribute>
					<xsl:element name="namePart">
						<xsl:attribute name="type">
							<xsl:text>full</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="current-grouping-key()"/>
					</xsl:element>
				</xsl:element>
				
				<!-- to normalise parties within a single record we need to group them, obtain the fragment for each party with the most information, and at the same time cope with rubbish data. In the end the only way to cope is to ensure at least an organisation name, city, phone or fax exists (sigh) -->
				<xsl:for-each select="current-group()">
					<xsl:sort select="count(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*) + count(gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/child::*)" data-type="number" order="descending"/>
					<xsl:choose>
						<xsl:when test="position()=1">
							<xsl:if test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:fax]">
								<xsl:element name="location">
									<xsl:element name="address">
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[not(gmd:voice='')]"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[not(gmd:facsimile='')]"/>

										<xsl:element name="physical">
											<xsl:attribute name="type">
												<xsl:text>streetAddress</xsl:text>
											</xsl:attribute>
											<xsl:apply-templates select="gmd:organisationName"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:if>
                        </xsl:when>
					</xsl:choose>
				</xsl:for-each>
		
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="$collectionKey"/>
					</xsl:element>	

					<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
						<xsl:variable name="code">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:variable>
						
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="$code"/>
							</xsl:attribute>
						</xsl:element>		
					</xsl:for-each-group>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:for-each-group>

</xsl:template>

<!-- =================================================================================== -->
<!-- Create a location element from the metadata point of truth url or the originating   -->
<!-- source if the point of truth is missing                                             --> 
<!-- =================================================================================== -->

<xsl:template name="location">
	<xsl:param name="metadataPointOfTruth"/>
	<xsl:param name="origSource"/>
	
	<xsl:element name="location">
		<xsl:element name="address">
			<xsl:element name="electronic">
				<xsl:attribute name="type">
					<xsl:text>url</xsl:text>
				</xsl:attribute>
				<xsl:element name="value">
					<xsl:choose>
						<xsl:when test="$metadataPointOfTruth!=''">
							<!-- Use first metadata point of truth link if present -->
							<xsl:value-of select="$metadataPointOfTruth"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- otherwise try a metadata.show service at the originating source -->
							<xsl:value-of
								select="concat($origSource,'/metadata.show?uuid=',/root/env/uuid)"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>
	
<!-- =================================================================================== -->
<!-- Create a temporal coverage element from a from and/or to date                          -->
<!-- =================================================================================== -->

<xsl:template name="temporalCoverage">
	<xsl:param name="from"/>
	<xsl:param name="to"/>

	<xsl:element name="temporal">
		<xsl:if test="$from and $from != ''">
			<xsl:element name="date">
				<xsl:attribute name="type" select="'dateFrom'"/>
				<xsl:attribute name="dateFormat" select="'W3C'"/>
				<xsl:value-of select="$from"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$to and $to != ''">
			<xsl:element name="date">
				<xsl:attribute name="type" select="'dateTo'"/>
				<xsl:attribute name="dateFormat" select="'W3C'"/>
				<xsl:value-of select="$to"/>
			</xsl:element>
		</xsl:if>
	</xsl:element>
</xsl:template>

<!-- =================================================================================== -->
	
<xsl:template match="node()"/>

<xsl:template name="splitSubject">
	<xsl:param name="string"/>
    <xsl:param name="showLocal" />
	<xsl:param name="separator" select="', '"/>

    <xsl:choose>
    	<xsl:when test="contains($string, $separator)">
      		<xsl:if test="not(starts-with($string, $separator))">
       			<xsl:element name="subject">
					<xsl:attribute name="type">
						<xsl:text>local</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="substring-before($string, $separator)"/>
				</xsl:element>
	       </xsl:if>
      	   <xsl:call-template name="splitSubject">
			   <xsl:with-param name="string" select="substring-after($string,$separator)" />
	       </xsl:call-template>
   		 </xsl:when>
	     <xsl:otherwise>
            <xsl:choose>
                 <xsl:when test="starts-with(upper-case($string), 'ATMOSPHERE')">
                    <xsl:element name="subject">
                        <xsl:attribute name="type">
                            <xsl:text>anzsrc-for</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="'9602'" />
                    </xsl:element>
                </xsl:when>
                <xsl:when test="starts-with(upper-case($string), 'OCEAN')">
                    <xsl:variable name="codeList"><xsl:value-of select="'0104 0105 0103 04 9699'"/></xsl:variable>
                    <xsl:for-each select="tokenize($codeList, ' ')">
                        <xsl:element name="subject">
                            <xsl:attribute name="type">
                                <xsl:text>anzsrc-for</xsl:text>                    
                            </xsl:attribute>
                            <xsl:value-of select="." />
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="starts-with(upper-case($string), 'OCEANOGRAPHY')">
                    <xsl:variable name="codeList"><xsl:value-of select="'0405 9699'"/></xsl:variable>
                    <xsl:for-each select="tokenize($codeList, ' ')">
                        <xsl:element name="subject">
                            <xsl:attribute name="type">
                                <xsl:text>anzsrc-for</xsl:text>                    
                            </xsl:attribute>
                            <xsl:value-of select="." />
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>

            </xsl:choose>
       </xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template name="gmlToKml">
	<xsl:param name="coords"/>
	
	<xsl:for-each select="tokenize($coords, ', ')">
		<xsl:choose>
			<xsl:when test="position()=last()">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="position() mod 2 = 0">
				<xsl:value-of select="."/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="position() mod 2 = 1">
				<xsl:value-of select="."/>
				<xsl:text>,</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>
