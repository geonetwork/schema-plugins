<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                  xmlns:swe="http://www.opengis.net/swe/1.0.1"
                  xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
                  xmlns:gml="http://www.opengis.net/gml"
                  xmlns:xlink="http://www.w3.org/1999/xlink"
                  exclude-result-prefixes="swe sml gml xlink">

    <xsl:variable name="lang"><xsl:value-of select="/root/env/lang"/></xsl:variable>

    <!-- ================================================================= -->

    <xsl:template match="/root">
        <xsl:apply-templates select="sml:SensorML"/>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="sml:System">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <!-- keywords -->
            <xsl:choose>
                <xsl:when test="not(sml:keywords)">
                    <xsl:call-template name="keywordsContent" />                  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:keywords" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- identification -->
            <xsl:apply-templates select="sml:identification" />

            <!-- classification -->
            <xsl:choose>
                <xsl:when test="not(sml:classification)">
                    <xsl:call-template name="siteClassificationContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:classification" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- valid time -->
            <xsl:choose>
                <xsl:when test="not(sml:validTime)">
                    <xsl:call-template name="validTimeContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:validTime" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- capabilities -->
            <xsl:apply-templates select="sml:capabilities" />

            <!-- contact -->
            <xsl:choose>
                <xsl:when test="not(sml:contact)">
                    <xsl:call-template name="contactContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:contact" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- documentation -->
            <xsl:choose>
                <xsl:when test="not(sml:documentation)">
                    <xsl:call-template name="documentationContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:documentation" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- history -->
            <xsl:choose>
                <xsl:when test="not(sml:history)">
                    <xsl:call-template name="historyContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:history" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- position -->
            <xsl:choose>
                <xsl:when test="not(sml:position)">
                    <xsl:call-template name="sitePositionContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:position" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- inputs -->
            <xsl:choose>
                <xsl:when test="not(sml:inputs)">
                    <xsl:call-template name="inputsContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:inputs" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- components -->
            <xsl:apply-templates select="sml:components" />

        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <!-- Template to process the component sections -->
    <xsl:template match="sml:Component">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <!-- keywords -->
            <xsl:choose>
                <xsl:when test="not(sml:keywords)">
                    <xsl:call-template name="keywordsContent" />                  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:keywords" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- identification -->
            <xsl:apply-templates select="sml:identification" />

            <!-- classification -->
            <xsl:choose>
                <xsl:when test="not(sml:classification)">
                    <xsl:call-template name="sensorClassificationContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:classification" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- capabilities -->
            <xsl:apply-templates select="sml:capabilities" />

            <!-- position -->
            <xsl:choose>
                <xsl:when test="not(sml:position)">
                    <xsl:call-template name="sensorPositionContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:position" />
                </xsl:otherwise>
            </xsl:choose>

            <!-- inputs -->
            <xsl:choose>
                <xsl:when test="not(sml:inputs)">
                    <xsl:call-template name="inputsContent" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="sml:inputs" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="sml:position[@name='sitePosition']|sml:position[@name='sensorPosition']">
        <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <swe:Position referenceFrame="{swe:Position/@referenceFrame}">
            <swe:location>
                <swe:Vector>
                    <swe:coordinate name="easting">
                        <swe:Quantity axisID="x">
                            <swe:uom code="m"/>
                            <swe:value><xsl:value-of select="swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value" /></swe:value>
                        </swe:Quantity>
                    </swe:coordinate>
                    <swe:coordinate name="northing">
                        <swe:Quantity axisID="y">
                            <swe:uom code="m"/>
                            <swe:value><xsl:value-of select="swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value" /></swe:value>
                        </swe:Quantity>
                    </swe:coordinate>
                    <swe:coordinate name="altitude">
                        <swe:Quantity axisID="z">
                            <swe:uom code="m"/>
                            <swe:value><xsl:value-of select="swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']/swe:Quantity/swe:value" /></swe:value>
                        </swe:Quantity>
                    </swe:coordinate>
                </swe:Vector>
            </swe:location>
        </swe:Position>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="sml:Event[../@name='siteEvent']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

                <xsl:if test="not(sml:date)">
                    <sml:date/>
                </xsl:if>

                <xsl:if test="not(gml:description)">
                    <gml:description/>
                </xsl:if>

                <xsl:if test="not(sml:classification)">
                    <xsl:call-template name="siteEventClassificationContent" />   
                </xsl:if>

            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>


    <!-- ================================================================= -->

    <xsl:template match="sml:DocumentList">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:choose>
                <xsl:when test="count(sml:member[@name='siteOnlineResource']) > 0">
                    <xsl:apply-templates select="sml:member[@name='siteOnlineResource']"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:call-template name="siteOnlineResourceContent" />
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="count(sml:member[@name='relatedDataset-GeoNetworkUUID']) > 0">
                    <xsl:apply-templates select="sml:member[@name='relatedDataset-GeoNetworkUUID']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="relatedDatasetContent" />
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="sml:member[@name!='relatedDataset-GeoNetworkUUID' and @name != 'siteOnlineResource']"/>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="sml:ResponsiblyParty">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:apply-templates select="sml:individualName"/>
            <xsl:apply-templates select="sml:organizationName"/>

            <xsl:if test="not(sml:positionName)">
                <sml:positionName/>
            </xsl:if>

            <xsl:if test="not(sml:contactInfo)">
                <xsl:call-template name="contactInfoContent" />
            </xsl:if>

            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="swe:field[@name='observedBBOX']">
       <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:if test="not(swe:Envelope)">
                <xsl:call-template name="envelopeContent" />
            </xsl:if>

            <xsl:apply-templates select="node()"/>
        </xsl:copy>   

    </xsl:template> 

    <xsl:template match="swe:lowerCorner|swe:upperCorner">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:if test="not(swe:Vector)">
                <xsl:call-template name="cornerContent" />
            </xsl:if>

            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->
    <!-- ==== Content templates                                       ==== -->
    <!-- ================================================================= -->

    <xsl:template name="keywordsContent">
        <sml:keywords>
            <sml:KeywordList>
                <sml:keyword/>
            </sml:KeywordList>
        </sml:keywords>
    </xsl:template>

    <xsl:template name="validTimeContent">
        <sml:validTime>
            <gml:TimeInstant>
                <gml:timePosition/>
            </gml:TimeInstant>
        </sml:validTime>
    </xsl:template>

    <xsl:template name="documentationContent">
        <sml:documentation>
            <sml:DocumentList>
                <xsl:call-template name="relatedDatasetContent" />
                <xsl:call-template name="siteOnlineResourceContent" />
            </sml:DocumentList>
        </sml:documentation>
    </xsl:template>

    <xsl:template name="siteOnlineResourceContent">
        <sml:member name="siteOnlineResource">
            <sml:Document>
                <gml:description></gml:description>
                <sml:format></sml:format>
                <sml:onlineResource
                        xlink:type="simple" xlink:href="" xlink:show="new" xlink:role="urn:xml:lang:eng-CAN" xlink:title="sor1"/>
            </sml:Document>
        </sml:member>
    </xsl:template>

    <xsl:template name="relatedDatasetContent">
        <sml:member name="relatedDataset-GeoNetworkUUID" xlink:href="" xlink:actuate="none" xlink:show="none"/>
    </xsl:template>

    <xsl:template name="historyContent">
         <sml:history>
            <sml:EventList>
                <xsl:call-template name="siteEventMemberContent" />
            </sml:EventList>
        </sml:history>                    
    </xsl:template>

    <xsl:template name="siteEventMemberContent">
        <sml:member name="siteEvent">
            <sml:Event>
                <sml:date/>
                <gml:description/>
                <xsl:call-template name="siteEventClassificationContent" />
            </sml:Event>
        </sml:member>
    </xsl:template>

    <xsl:template name="siteEventClassificationContent">
        <sml:classification>
            <sml:ClassifierList>
                <sml:classifier name="siteEventType">
                    <sml:Term definition="">
                        <sml:value/>
                    </sml:Term>
                </sml:classifier>
            </sml:ClassifierList>
        </sml:classification>
    </xsl:template>

    <xsl:template name="contactContent">
        <sml:contact>
            <sml:ResponsibleParty>
                <sml:individualName/>
                <sml:organizationName/>
                <sml:positionName/>
                <xsl:call-template name="contactInfoContent" />
            </sml:ResponsibleParty>
        </sml:contact>
    </xsl:template>

    <xsl:template name="contactInfoContent">
        <sml:contactInfo>
            <sml:phone>
                <sml:voice/>
                <sml:facsimile/>
            </sml:phone>
            <sml:address>
                <sml:deliveryPoint/>
                <sml:city/>
                <sml:administrativeArea/>
                <sml:postalCode/>
                <sml:country>CAN (Canada)</sml:country>
                <sml:electronicMailAddress/>
            </sml:address>
            <sml:onlineResource xlink:href="" xlink:role="urn:xml:lang:eng-CAN" xlink:title="cor1"/>
            <sml:hoursOfService/>
            <sml:contactInstructions/>
        </sml:contactInfo>
    </xsl:template>

    <xsl:template name="sitePositionContent">
        <sml:position name="sitePosition">  
            <xsl:call-template name="PositionElementContent" />   
        </sml:position>
    </xsl:template>

    <xsl:template name="sensorPositionContent">
        <sml:position name="sensorPosition">  
            <xsl:call-template name="PositionElementContent" />   
        </sml:position>
    </xsl:template>

    <xsl:template name="PositionElementContent">
         <swe:Position referenceFrame="">
            <swe:location>
                <swe:Vector>
                    <swe:coordinate name="easting">
                        <swe:Quantity axisID="x">
                            <swe:uom code="m"/>
                            <swe:value></swe:value>
                        </swe:Quantity>
                    </swe:coordinate>
                    <swe:coordinate name="northing">
                        <swe:Quantity axisID="y">
                            <swe:uom code="m"/>
                            <swe:value></swe:value>
                        </swe:Quantity>
                    </swe:coordinate>
                    <swe:coordinate name="altitude">
                        <swe:Quantity axisID="z">
                            <swe:uom code="m"/>
                            <swe:value></swe:value>
                        </swe:Quantity>
                    </swe:coordinate>
                </swe:Vector>
            </swe:location>
        </swe:Position>
    </xsl:template>

    <xsl:template name="siteClassificationContent">
        <sml:classification>
            <sml:ClassifierList>
                <sml:classifier name="siteType">
                    <sml:Term definition="">
                        <sml:value/>
                    </sml:Term>
                </sml:classifier>
            </sml:ClassifierList>
        </sml:classification>
    </xsl:template>

    <xsl:template name="sensorClassificationContent">
        <sml:classification>
            <sml:ClassifierList>
                <sml:classifier name="sensorType">
                    <sml:Term definition="">
                        <sml:value/>
                    </sml:Term>
                </sml:classifier>
            </sml:ClassifierList>
        </sml:classification>
    </xsl:template>

    <xsl:template name="inputsContent">
        <sml:inputs>
            <sml:InputList>
                <sml:input name="">
                    <xsl:call-template name="observablePropertyContent" />
                </sml:input>
            </sml:InputList>
        </sml:inputs>
    </xsl:template>

    <xsl:template name="observablePropertyContent">
        <swe:ObservableProperty definition=""></swe:ObservableProperty>
    </xsl:template>

    <xsl:template name="cornerContent">
        <swe:Vector>
            <swe:coordinate name="easting">
                <swe:Quantity axisID="x">
                    <swe:uom code="m"/>
                    <swe:value></swe:value>
                </swe:Quantity>
            </swe:coordinate>
            <swe:coordinate name="northing">
                <swe:Quantity axisID="y">
                    <swe:uom code="m"/>
                    <swe:value></swe:value>
                </swe:Quantity>
            </swe:coordinate>
        </swe:Vector>
    </xsl:template>

    <xsl:template name="envelopeContent">
        <swe:Envelope definition="urn:ogc:def:property:OGC:1.0:observedBBOX">
            <swe:lowerCorner>
                <xsl:call-template name="cornerContent" />
            </swe:lowerCorner>
            <swe:upperCorner>
                <xsl:call-template name="cornerContent" />
            </swe:upperCorner>
        </swe:Envelope>
    </xsl:template>
</xsl:stylesheet>
