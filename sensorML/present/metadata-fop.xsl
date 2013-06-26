<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
	xmlns:swe="http://www.opengis.net/swe/1.0.1" 
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:exslt="http://exslt.org/common"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:ns2="http://www.w3.org/2004/02/skos/core#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"  
	exclude-result-prefixes="sml swe gml exslt geonet xlink rdf ns2 rdfs skos xs"
  version="2.0">
  
  <xsl:template name="metadata-fop-sensorML">
     <xsl:param name="schema"/>
    
	  <fo:table-row >
        <fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" margin-right="8pt" >
            <fo:block>
			<fo:block font-weight="bold" font-size="12pt" padding-top="4pt" padding-bottom="4pt" padding-left="4pt" padding-right="4pt">
               <xsl:value-of select="/root/gui/strings/Siteidentification"/>
              </fo:block>
			
			<fo:table width="100%" table-layout="fixed">
				<fo:table-column column-width="6.8cm"/>
				<fo:table-column column-width="5cm"/>
				<fo:table-body>

                <!-- Short site name -->
                <xsl:call-template name="TRFop">
                    <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                        <xsl:with-param name="name"   select="'sml:identifier'"/>
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="id" select="'siteShortName'" />
                    </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteShortName']/sml:Term/sml:value"/>
                </xsl:call-template>

				<!-- Site type -->
                <xsl:call-template name="TRFop">
                    <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                        <xsl:with-param name="name"   select="'sml:classifier'"/>
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="id" select="'siteType'" />
                    </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteType']/sml:Term/sml:value"/>
                </xsl:call-template>

                <!-- Site status -->
                <xsl:call-template name="TRFop">
                    <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                        <xsl:with-param name="name"   select="'swe:field'"/>
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="id" select="'siteStatus'" />
                    </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']/swe:Text/swe:value"/>
                </xsl:call-template>

                <!-- Site id -->
                <!-- Site id type -->
                <xsl:for-each select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteID']">
                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'sml:identifier'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'siteID'" />
                        </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="text" select="sml:Term/sml:value"/>
                    </xsl:call-template>

                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'sml:identifier'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'siteIDType'" />
                        </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="text" select="sml:Term/sml:value"/>
                    </xsl:call-template>
                </xsl:for-each>

				<!-- observed phenomenum -->
                <xsl:for-each select="sml:member/sml:System/sml:inputs/sml:InputList/sml:input[swe:ObservableProperty]">

                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'sml:input'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'observedPhenomenon'" />
                        </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="text" select="@name"/>
                    </xsl:call-template>
                </xsl:for-each>

			<xsl:call-template name="TRFop">
				<xsl:with-param name="label">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:keywords'"/>
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:call-template>
				</xsl:with-param>
                <xsl:with-param name="text"><xsl:for-each select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword">
						<xsl:if test="position()!=1">,&#160;</xsl:if>
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
            </xsl:call-template>
			
			<xsl:call-template name="TRFop">
				<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:spatialReferenceFrame'"/>
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:call-template>
				</xsl:with-param>
                <xsl:with-param name="text" select="sml:member/sml:System/sml:position/swe:Position/@referenceFrame"/>
            </xsl:call-template>

            <xsl:if test="string(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value) or
                          string(sml:SensorML/sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value) or
                          string(sml:SensorML/sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']/swe:Quantity/swe:value)">

                <xsl:call-template name="TRFop">
                    <xsl:with-param name="label">
                        <xsl:call-template name="getTitle-sensorML">
                                <xsl:with-param name="name"   select="'sml:location'"/>
                                <xsl:with-param name="schema" select="$schema"/>
                            </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text">
                        <xsl:if test="string(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value)">
                            <xsl:value-of select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value" />
                            (<xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'swe:coordinate'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'easting'" />
                            </xsl:call-template>)
                        </xsl:if>

                        <xsl:text>, </xsl:text>
                        <xsl:if test="string(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value)">
                        <xsl:value-of select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value" />
                    (<xsl:call-template name="getTitle-sensorML">
                        <xsl:with-param name="name"   select="'swe:coordinate'"/>
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="id" select="'northing'" />
                    </xsl:call-template>)
                        </xsl:if>

                        <xsl:text>, </xsl:text>
                        <xsl:if test="string(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']/swe:Quantity/swe:value)">
                        <xsl:value-of select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']/swe:Quantity/swe:value" />
                    (<xsl:call-template name="getTitle-sensorML">
                        <xsl:with-param name="name"   select="'swe:coordinate'"/>
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="id" select="'altitude'" />
                    </xsl:call-template>)
                        </xsl:if>

                    </xsl:with-param>
                    <!--<xsl:with-param name="text" select="concat(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value,' ',sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value)"/>-->
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="string(sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity) or
                    string(sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity) or
                    string(sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity) or
                    string(sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity)">
                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:value-of select="/root/gui/strings/ObservationBoundingBox"/></xsl:with-param>
                        <xsl:with-param name="text">
                            <xsl:value-of select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity"/>
                            <xsl:value-of select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity"/>,
                            <xsl:value-of select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity"/>
                            <xsl:value-of select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity"/>
                        </xsl:with-param>
                    </xsl:call-template>
            </xsl:if>
			</fo:table-body>
			</fo:table>
			
			
			<xsl:if test="count(sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='siteOnlineResource'])!=0">
			
				<fo:block font-weight="bold" font-size="12pt" padding-top="4pt" padding-bottom="4pt" padding-left="4pt" padding-right="4pt">
				   <xsl:value-of select="/root/gui/strings/Dataresources"/>
				  </fo:block>

				
				<xsl:for-each select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='siteOnlineResource']">
					<xsl:if test="sml:Document/sml:onlineResource/@xlink:href != ''">
							<fo:block padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt">
								<fo:basic-link external-destination="{sml:Document/sml:onlineResource/@xlink:href}">
									<fo:inline text-decoration="underline">
                                        <xsl:choose>
                                            <xsl:when test="string(sml:Document/gml:description)">
                                                <xsl:value-of select="sml:Document/gml:description"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="sml:Document/sml:onlineResource/@xlink:href"/>
                                            </xsl:otherwise>
                                        </xsl:choose></fo:inline>
								</fo:basic-link>
	
							</fo:block>
					</xsl:if>
				</xsl:for-each>
				
				<fo:block margin-top="8pt"/>
			</xsl:if>
			
			<!-- Relateddata -->
			<xsl:if test="count(/root/gui/relation/sensorMLDataset/response/*[geonet:info])!=0">
			<fo:block font-weight="bold" font-size="12pt" padding-top="4pt" padding-bottom="4pt" padding-left="4pt" padding-right="4pt">
				   <xsl:value-of select="/root/gui/strings/Relateddata"/>
			</fo:block>
			<!-- this will work for display of a single record, but not for more then 1 ! -->
			<xsl:for-each select="/root/gui/relation/sensorMLDataset/response/*[geonet:info]" >
               
			   <fo:block padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt">
						<fo:external-graphic content-width="10pt" padding-right="8pt" alignment-adjust="baseline"> 
							<xsl:attribute name="src">
								<xsl:value-of select="concat(//server/protocol, '://', //server/host,':', //server/port, /root/gui/url, '/images/dataset.png')" />
							</xsl:attribute>
					  </fo:external-graphic>
								
					<fo:basic-link external-destination="{concat(/root/gui/url,'/srv/',/root/gui/language,'/pdf?uuid=',geonet:info/uuid)}">
						<fo:inline text-decoration="underline">
							<xsl:choose>	
								 <xsl:when test="name() != 'metadata'">
									<xsl:variable name="md">
										<xsl:apply-templates mode="brief" select="."/>
									</xsl:variable>
									<xsl:variable name="metadata" select="exslt:node-set($md)/*[1]"/>
									<xsl:value-of select="$metadata/title" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="title" />
								</xsl:otherwise>
							</xsl:choose>
						</fo:inline>
					</fo:basic-link>

				</fo:block>
			   	
			</xsl:for-each>
			<fo:block margin-top="8pt"/>
			</xsl:if>
			
			<!-- Additionalinformation -->
			<fo:block font-weight="bold" font-size="12pt" padding-top="4pt" padding-bottom="4pt" padding-left="4pt" padding-right="4pt">
               <xsl:value-of select="/root/gui/strings/Additionalinformation"/>
              </fo:block>

				 <fo:block border-style="solid" border-color="#1b5a9f" border-width="1">
					<fo:table width="100%" table-layout="fixed">
				<fo:table-column column-width="5cm"/>
				<fo:table-column column-width="6.8cm"/>
				<fo:table-body>
				<fo:table-row background-color="#1b5a9f">
					<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" number-columns-spanned="2"  >
						<fo:block font-weight="bold" font-size="10pt" color="#ffffff">
							<xsl:value-of select="/root/gui/strings/Metadatarecord"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>

                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'sml:identifier'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'GeoNetwork-UUID'" />
                        </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="text" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID']/sml:Term/sml:value"/>
                    </xsl:call-template>

					<!-- effective date -->
					<xsl:apply-templates mode="elementFop" select="sml:member/sml:System/sml:validTime">
							<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>
					
				</fo:table-body>
				</fo:table>
				</fo:block>
		<fo:block margin-top="8pt"/>
		
		<!-- Individual sensors -->
		
			<xsl:for-each select="sml:member/sml:System/sml:components/sml:ComponentList/sml:component">
			
			 <fo:block border-style="solid" border-color="#1b5a9f" border-width="1">
					<fo:table width="100%" table-layout="fixed">
				<fo:table-column column-width="5cm"/>
				<fo:table-column column-width="6.8cm"/>
				<fo:table-body>
				<fo:table-row background-color="#1b5a9f">
					<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" number-columns-spanned="2"  >
						<fo:block font-weight="bold" font-size="10pt" color="#ffffff">
							<xsl:choose>
								<xsl:when test="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorFullName']/sml:Term/sml:value!=''">
									<xsl:value-of select="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorFullName']/sml:Term/sml:value"/>
								</xsl:when>
								<xsl:when test="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorShortName']/sml:Term/sml:value!=''">
									<xsl:value-of select="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorShortName']/sml:Term/sml:value"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="/root/gui/strings/NoSensorInformationAvailable"/></xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			
				
				    <xsl:if test="string(*/sml:keywords/sml:keyword)">
					<xsl:apply-templates mode="elementFop" select="*/sml:keywords">
							<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>
                    </xsl:if>

					<xsl:apply-templates mode="elementFop" select="sml:member/sml:System/sml:components/sml:ComponentList/sml:component/sml:Component/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorShortName']/sml:Term/sml:value">
							<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>

                    <!-- Sensor status -->
                    <xsl:if test="string(*/sml:capabilities/swe:DataRecord/swe:field[@name='sensorStatus']/swe:Text/swe:value)">
                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'swe:field'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'sensorStatus'" />
                        </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="text" select="*/sml:capabilities/swe:DataRecord/swe:field[@name='sensorStatus']/swe:Text/swe:value"/>
                    </xsl:call-template>
                    </xsl:if>

                    <!-- Sensor id -->
                    <!-- Sensor id type -->

                    <xsl:for-each select="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorID']">
                        <xsl:if test="string(sml:Term/sml:value)">
                        <xsl:call-template name="TRFop">
                            <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                                <xsl:with-param name="name"   select="'sml:identifier'"/>
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="id" select="'sensorID'" />
                            </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="text" select="sml:Term/sml:value"/>
                        </xsl:call-template>


                        <xsl:call-template name="TRFop">
                            <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                                <xsl:with-param name="name"   select="'sml:identifier'"/>
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="id" select="'sensorIDType'" />
                            </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="text" select="sml:Term/@definition"/>
                        </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>


                    <!-- Sensor type -->
                    <xsl:if test="string(*/sml:classification/sml:ClassifierList/sml:classifier[@name='sensorType']/sml:Term/sml:value)">
                    <xsl:call-template name="TRFop">
                        <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                            <xsl:with-param name="name"   select="'sml:classifier'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="id" select="'sensorType'" />
                        </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="text" select="*/sml:classification/sml:ClassifierList/sml:classifier[@name='sensorType']/sml:Term/sml:value"/>
                    </xsl:call-template>
                    </xsl:if>


                    <xsl:if test="string(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value) or
                          string(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value) or
                          string(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting'][@name='altitude']/swe:Quantity/swe:value)">

                        <xsl:call-template name="TRFop">
                            <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                                <xsl:with-param name="name"   select="'sml:spatialReferenceFrame'"/>
                                <xsl:with-param name="schema" select="$schema"/>
                            </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="text" select="*/sml:position[@name='sensorPosition']/swe:Position/@referenceFrame"/>
                        </xsl:call-template>

                        <xsl:call-template name="TRFop">
                            <xsl:with-param name="label">
                                <xsl:call-template name="getTitle-sensorML">
                                    <xsl:with-param name="name"   select="'sml:location'"/>
                                    <xsl:with-param name="schema" select="$schema"/>
                                    <xsl:with-param name="id" select="'sensor'" />
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="text">
                                <xsl:if test="string(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value)">
                                    <xsl:value-of select="*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value" />
                                    (<xsl:call-template name="getTitle-sensorML">
                                    <xsl:with-param name="name"   select="'swe:coordinate'"/>
                                    <xsl:with-param name="schema" select="$schema"/>
                                    <xsl:with-param name="id" select="'easting'" />
                                </xsl:call-template>)
                                </xsl:if>

                                <xsl:text>, </xsl:text>
                                <xsl:if test="string(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value)">
                                    <xsl:value-of select="*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value" />
                                    (<xsl:call-template name="getTitle-sensorML">
                                    <xsl:with-param name="name"   select="'swe:coordinate'"/>
                                    <xsl:with-param name="schema" select="$schema"/>
                                    <xsl:with-param name="id" select="'northing'" />
                                </xsl:call-template>)
                                </xsl:if>

                                <xsl:text>, </xsl:text>
                                <xsl:if test="string(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']/swe:Quantity/swe:value)">
                                    <xsl:value-of select="*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']/swe:Quantity/swe:value" />
                                    (<xsl:call-template name="getTitle-sensorML">
                                    <xsl:with-param name="name"   select="'swe:coordinate'"/>
                                    <xsl:with-param name="schema" select="$schema"/>
                                    <xsl:with-param name="id" select="'altitude'" />
                                </xsl:call-template>)
                                </xsl:if>

                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="string(*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity) or
                    string(*/sml:capabilities/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity) or
                    string(*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity) or
                    string(*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity)">


                    <xsl:call-template name="TRFop">
							<xsl:with-param name="label"><xsl:value-of select="/root/gui/strings/ObservationBoundingBox"/></xsl:with-param>
							<xsl:with-param name="text">
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity"/>
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity"/>,
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity"/>
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity"/>
							</xsl:with-param>
						</xsl:call-template>
					
					</xsl:if>

                    <!-- Sensor Event type -->
                    <xsl:for-each select="*/sml:inputs/sml:InputList/sml:input[swe:ObservableProperty]">
                        <xsl:call-template name="TRFop">
                            <xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
                                <xsl:with-param name="name"   select="'swe:ObservableProperty'"/>
                                <xsl:with-param name="schema" select="$schema"/>
                            </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="text" select="@name"/>
                        </xsl:call-template>
                    </xsl:for-each>
				</fo:table-body>
				</fo:table>
				</fo:block>
			</xsl:for-each>
		
		
		
			</fo:block>
        </fo:table-cell>
		
		<!-- ** Sidebar ** -->
		
		
		<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" >
            
		<xsl:if test="count(sml:member/sml:System/sml:history/sml:EventList/sml:member/sml:Event) &gt; 0">
		<fo:block border-width="1pt" border-style="solid" border-color="#1b5a9f">
			<fo:table width="100%" table-layout="fixed">
			<fo:table-column column-width="3cm"/>
			<fo:table-column column-width="4.2cm"/>
			<fo:table-body>

			<fo:table-row>
				<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" background-color="#1b5a9f" number-columns-spanned="2">
					<fo:block color="#ffffff">
						<xsl:call-template name="getTitle">
								<xsl:with-param name="name"   select="'sml:history'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>

				<xsl:for-each select="sml:member/sml:System/sml:history/sml:EventList/sml:member/sml:Event">
					<xsl:call-template name="TRFop">
							<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
								<xsl:with-param name="name"   select="'sml:date'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="text" select="sml:date"/>
					</xsl:call-template>
					<xsl:call-template name="TRFop">
							<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
								<xsl:with-param name="name"   select="'gml:description'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="text" select="gml:description"/>
					</xsl:call-template>
					<xsl:call-template name="TRFop">
							<xsl:with-param name="label">
                                <xsl:call-template name="getTitle-sensorML">
                                    <xsl:with-param name="name"   select="'sml:classifier'"/>
                                    <xsl:with-param name="schema" select="$schema"/>
                                    <xsl:with-param name="id" select="'siteEventType'" />
                                </xsl:call-template>     </xsl:with-param>
							<xsl:with-param name="text" select="sml:classification/sml:ClassifierList/sml:classifier[@name='siteEventType']"/>
					</xsl:call-template>
				</xsl:for-each>
				
				</fo:table-body>
			</fo:table>
			</fo:block>
			<fo:block margin-top="5px" />
		</xsl:if>
				
				
			<!-- Contacts-->
			<xsl:for-each select="sml:member/sml:System/sml:contact/sml:ResponsibleParty">
				<fo:block border-width="1pt" border-style="solid" border-color="#1b5a9f">
					<fo:table width="100%" table-layout="fixed">
						<fo:table-column column-width="3cm"/>
						<fo:table-column column-width="4.2cm"/>
						<fo:table-body>
						<fo:table-row background-color="#1b5a9f" >
							<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" number-columns-spanned="2">
								<fo:block color="#ffffff">
									<xsl:value-of select="/root/gui/strings/Contact"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<xsl:call-template name="TRFop">
									<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
										<xsl:with-param name="name"   select="'sml:individualName'"/>
										<xsl:with-param name="schema" select="$schema"/>
									</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="text" select="sml:individualName"/>
								</xsl:call-template>
						<xsl:call-template name="TRFop">
							<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
								<xsl:with-param name="name"   select="'sml:organizationName'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="text" select="sml:organizationName"/>
						</xsl:call-template>
						<xsl:call-template name="TRFop">
							<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
								<xsl:with-param name="name"   select="'sml:positionName'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="text" select="sml:positionName"/>
						</xsl:call-template>
								
								
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:voice'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:phone/sml:voice"/>
							</xsl:call-template>
							
							
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:facsimile'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:phone/sml:facsimile"/>
							</xsl:call-template>
							
							
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:deliveryPoint'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:address/sml:deliveryPoint"/>
							</xsl:call-template>
						
							
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:city'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:address/sml:city"/>
							</xsl:call-template>
						
							
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:administrativeArea'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:address/sml:administrativeArea"/>
							</xsl:call-template>
						
							
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:postalCode'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:address/sml:postalCode"/>
							</xsl:call-template>
							
							
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:country'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:address/sml:country"/>
							</xsl:call-template>
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:electronicMailAddress'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:address/sml:electronicMailAddress"/>
							</xsl:call-template>
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:onlineResource'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:onlineResource/xlink:href"/>
							</xsl:call-template>
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:hoursOfService'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:hoursOfService"/>
							</xsl:call-template>
							<xsl:call-template name="TRFop">
								<xsl:with-param name="label"><xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:contactInstructions'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="text" select="sml:contactInfo/sml:contactInstructions"/>
							</xsl:call-template>
							
						</fo:table-body>
					</fo:table>
				</fo:block>	
				<fo:block margin-top="5px" />
			</xsl:for-each>
			
        </fo:table-cell>
      </fo:table-row>
			
  </xsl:template>
  
  
   <xsl:template name="TRFop">
    <xsl:param name="label"/>
    <xsl:param name="text"/>
		<xsl:if test="$text!=''"> 
			<fo:table-row>
				<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" >
					<fo:block color="#2e456b">
						<xsl:value-of select="$label"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell padding-left="4pt" padding-right="4pt" padding-top="4pt" margin-top="4pt" >
					<fo:block color="#707070">
					<xsl:value-of select="$text"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
  </xsl:template>
  
  
</xsl:stylesheet>
