<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
	xmlns:swe="http://www.opengis.net/swe/1.0.1" 
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:ns2="http://www.w3.org/2004/02/skos/core#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"  
	exclude-result-prefixes="sml swe gml geonet xlink rdf ns2 rdfs skos">


	<!-- Template for view mode. XML structure with editing information is quite different than "raw" metadata for view -->
	<!-- TODO: Check if possible to unify view and edit templates, no need to be different! -->
	<xsl:template name="sensorMLSimpleView">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

        <style type="text/css">
            fieldset.metadata-block {  margin: 0px !important;padding: 0px !important; border:none !important; }
            legend.block-legend { display:none !important;  }
            img.icon {
            padding-right: 10px;
            vertical-align: bottom;
            width:16px; height 16px;
            }
			.metadata-block table, .metadata-block table th {padding-left:0px;margin-left:0 !important;}
        </style>
			<div class="span-5">
				
				<!-- md title -->
			    <h1 id="cn-cont" style="border-bottom:none;">
				   <img src="{/root/gui/url}/images/monsite.png" style="width: 48px;vertical-align:middle;" alt="{/root/gui/strings/MonitoringSite}: {sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteFullName']/sml:Term/sml:value}" />
				   &#160;<xsl:value-of select="/sml:SensorML/sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteFullName']/sml:Term/sml:value"/>
				</h1>
				
				<!-- Site identifier -->
				<h3><xsl:value-of select="/root/gui/strings/Siteidentification"/></h3>
				
				<!-- Site shortname -->
                <table>
                <xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteShortName']">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
				<!-- Site type -->
                <xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteType']">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
                <!-- Site status -->
                <xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
                <!-- Site type id -->
				<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteID']">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
				<!-- observed phenomenum -->
				<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:inputs/sml:InputList/sml:input[swe:ObservableProperty/@definition='http://www.ec.gc.ca/data_donnees/standards/codes/1-0/observedPhenomenon']">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
				<!-- keywords -->
				<tr><th class="md"><xsl:value-of select="/root/gui/strings/Keywords"/></th><td>
				<xsl:for-each select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword">
					<xsl:if test="position()!=1">,&#160;</xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
				</td></tr>
                   </table>
	
			<xsl:if test="(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value!='') and number(sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value)!=0">
				<div style="float:left;margin-right:10px;" role="application" aria-label="{/root/gui/stings/page_advanced/where_explained}">
				<!-- put a map here -->

				<xsl:variable name="crdX" select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity/swe:value"/>
				<xsl:variable name="crdY" select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity/swe:value"/>
				<xsl:variable name="geom" select="concat('POINT(', $crdX, ' ', $crdY, ')')"/>
				
				<xsl:call-template name="showMap">
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="mode" select="'bbox'" />
					<xsl:with-param name="coords" select="$geom"/>
					<xsl:with-param name="watchedBbox" select="'x1,y1,x2,y2'"/>
					<xsl:with-param name="eltRef" select="'Sitelocation'"/>
					<xsl:with-param name="width" select="'400px'"/>
					<xsl:with-param name="height" select="'250px'"/>
				</xsl:call-template>
				
				<input type="hidden" id="_x1" value="{$crdX}-1"/>
				<input type="hidden" id="_y1" value="{$crdY}-1"/>
				<input type="hidden" id="_x2" value="{$crdX}+1"/>
				<input type="hidden" id="_y2" value="{$crdY}+1"/>

				
				</div>
				<div style="float:left;width:300px;">
				<table>
					<!-- Datum -->
					<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:position/swe:Position/@referenceFrame">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>	

					<!-- Location -->
					<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>	
					</table>
				</div>
			<div style="clear:left"></div>
		</xsl:if>

				<h3><xsl:value-of select="/root/gui/strings/Dataresources"/></h3>
				
				<!-- Documents -->
				<xsl:for-each select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='siteOnlineResource']">
					<xsl:if test="sml:Document/sml:onlineResource/@xlink:href != ''">
					<div style="min-height:30px">
					<div style="float:left">

					<xsl:choose>
					<xsl:when test="sml:Document/gml:description!=''">
						<xsl:value-of select="substring(sml:Document/gml:description,0,50)"/>
						<xsl:if test="string-length(sml:Document/gml:description)&gt;50">...</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(sml:Document/sml:onlineResource/@xlink:href,0,50)"/>
						<xsl:if test="string-length(sml:Document/gml:onlineResource/@xlink:href)&gt;50">...</xsl:if>
					</xsl:otherwise>
					</xsl:choose>
					</div>
					<div style="float:right">
                        <button class="content" onclick="window.open('{sml:Document/sml:onlineResource/@xlink:href}')" type="button"><xsl:value-of select="/root/gui/strings/AccessData"/></button>
                        </div>
					<div style="clear:both"></div>
					</div>
					</xsl:if>
				</xsl:for-each>
							
				
			
			 <!-- this template is in /rest/metadata.xsl, and includes a title, if any relations -->
			 <!--
			<xsl:call-template name="relatedDatasets">
				<xsl:with-param name="schema" select="$schema"/>
                <xsl:with-param name="resources" select="/root/gui/relation/services/response/*[geonet:info]|/root/gui/relation/sensorMLDataset/response/*[geonet:info]|/root/gui/relation/children/response/*[geonet:info]|/root/gui/relation/related/response/*[geonet:info]"/>
            </xsl:call-template>
				-->
				
			
				
				<h3><xsl:value-of select="/root/gui/strings/Additionalinformation"/></h3>
				<table class="striped border">
				<thead>
				<tr><th colspan="2"><xsl:value-of select="/root/gui/strings/Metadatarecord"/></th></tr>
				</thead>
				<tbody>
				<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				<!-- effective date -->
				<!--
				<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:validTime">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				-->
				</tbody>
				</table>
				
			
			<xsl:for-each select="sml:member/sml:System/sml:components/sml:ComponentList/sml:component">
				<table class="striped border">
				<thead>
				<tr><th colspan="2">
				<xsl:choose>
				<xsl:when test="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorFullName']/sml:Term/sml:value!=''">
					<xsl:value-of select="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorFullName']/sml:Term/sml:value"/>
				</xsl:when>
				<xsl:when test="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorShortName']/sml:Term/sml:value!=''">
					<xsl:value-of select="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorShortName']/sml:Term/sml:value"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="/root/gui/strings/NoSensorInformationAvailable"/></xsl:otherwise>
				</xsl:choose>
				</th></tr>
				</thead>
				<tbody>
				<!-- Keywords -->
				<xsl:apply-templates mode="elementEP" select="*/sml:keywords">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				<!-- Short sensor name -->
				<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:components/sml:ComponentList/sml:component/sml:Component/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorShortName']/sml:Term/sml:value">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				<!-- Sensor status -->
					<xsl:apply-templates mode="elementEP" select="*/sml:capabilities/swe:DataRecord/swe:field[@name='sensorStatus']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:apply-templates mode="elementEP" select="*/sml:identification/sml:IdentifierList/sml:identifier[@name='sensorID']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:apply-templates mode="elementEP" select="*/sml:classification/sml:ClassifierList/sml:classifier[@name='sensorType']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']!='') and number(*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting'])!=0">	
						<!-- Longitude -->
						<xsl:apply-templates mode="elementEP" select="*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='easting']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
						<!-- Latitude -->
						<xsl:apply-templates mode="elementEP" select="*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='northing']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
						<!-- altitude -->
						<xsl:apply-templates mode="elementEP" select="*/sml:position[@name='sensorPosition']/swe:Position/swe:location/swe:Vector/swe:coordinate[@name='altitude']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
						<!-- obsbounds-->
						<xsl:if test="(*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity!='') and number(*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity)!=0">
						<tr><th class="md"><xsl:value-of select="/root/gui/strings/ObservationBoundingBox"/></th><td>
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity"/>
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity"/>,
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']/swe:Quantity"/>
							<xsl:value-of select="*/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']/swe:Quantity"/>
						</td></tr>
						</xsl:if>
					</xsl:if>

                    <!-- Sensor Event type -->
                    <xsl:for-each select="*/sml:inputs/sml:InputList/sml:input[swe:ObservableProperty/@definition='http://www.ec.gc.ca/data_donnees/standards/codes/1-0/observedPhenomenon']">
                        <xsl:apply-templates mode="elementEP"  select="@name">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                    </xsl:for-each>
					</tbody>
				</table><br/>
			</xsl:for-each>
			</div>
			
			<!-- side bar-->
			<div class="span-3 row-end">

				<!-- as defined in md-show -->
				<!--
				<xsl:call-template name="md-sidebar-title">
					<xsl:with-param name="metadata" select="/root/ec:MonitoringSite"/>
				</xsl:call-template>
				-->
			
                <xsl:if test="*//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document">
                    <table class="sidebar">
                        <thead>
                            <tr><th colspan="2"><xsl:value-of select="/root/gui/schemas/iso19139.napec/strings/Thumbnail"/></th></tr>
                        </thead>
                        <tbody><tr><td>
                            <xsl:variable name="fileName">
                                <xsl:choose>
                                    <!-- large thumbnail -->
                                    <xsl:when test="*//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document/gml:description = 'large_thumbnail' and
                           *//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document[gml:description = 'large_thumbnail']/sml:onlineResource/@xlink:href != ''">
                                        <xsl:value-of select="/root/*//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document[gml:description = 'large_thumbnail']/sml:onlineResource/@xlink:href"/>
                                    </xsl:when>
                                    <!-- small thumbnail -->
                                    <xsl:when test="*//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document/gml:description = 'thumbnail' and
                           *//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document[gml:description = 'thumbnail']/sml:onlineResource/@xlink:href != ''">
                                        <xsl:value-of select="/root/*//sml:DocumentList/sml:member[@name='thumbnail']/sml:Document[gml:description = 'thumbnail']/sml:onlineResource/@xlink:href"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <img src="{concat(/root/gui/url,'/srv/eng/resources.get?uuid=', sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID'], '&amp;fname=', $fileName, '&amp;access=public')}" title="{/root/gui/schemas/iso19139.napec/strings/Thumbnail}" /></td></tr></tbody>
                    </table><br/>
                </xsl:if>

				<!-- site history -->	
				<xsl:if test="count(sml:member/sml:System/sml:history/sml:EventList/sml:member)>0">		
					<table class="sidebar">
					<thead>
					<tr> <th colspan="2">
					
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name"   select="'sml:history'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
					</th></tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:history/sml:EventList/sml:member">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</tbody>
					</table>
				</xsl:if>
				
				
				<!-- Contact -->
				<xsl:for-each select="sml:member/sml:System/sml:contact/sml:ResponsibleParty">
				
				<table class="sidebar">
				<thead>
					<tr><th colspan="2"><xsl:value-of select="/root/gui/strings/Contact"/></th></tr>
				</thead>
				<tbody>
					<xsl:apply-templates mode="elementEP" select="*">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</tbody>	
				</table>
				</xsl:for-each>
			</div>
		<div class="clear"></div>

	</xsl:template>
</xsl:stylesheet>
