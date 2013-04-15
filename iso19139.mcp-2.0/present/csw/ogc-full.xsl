<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmd="http://www.isotc211.org/2005/gmd" 
										xmlns:gmx="http://www.isotc211.org/2005/gmx"
										xmlns:srv="http://www.isotc211.org/2005/srv"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:ows="http://www.opengis.net/ows">

	<xsl:param name="displayInfo"/>

	<!-- ============================================================================= -->

	<xsl:template match="mcp:MD_Metadata">
		<xsl:variable name="info" select="geonet:info"/>
		<csw:Record>

			<xsl:for-each select="gmd:fileIdentifier">
				<dc:identifier><xsl:value-of select="gco:CharacterString"/></dc:identifier>
			</xsl:for-each>

			<xsl:for-each select="gmd:dateStamp">
				<dc:date><xsl:value-of select="gco:Date|gco:DateTime"/></dc:date>
			</xsl:for-each>

			<!-- DataIdentification - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:identificationInfo/mcp:MD_DataIdentification">

				<xsl:for-each select="gmd:citation/*">	
					<xsl:for-each select="gmd:title/gco:CharacterString">
						<dc:title><xsl:value-of select="."/></dc:title>
					</xsl:for-each>

					<xsl:for-each select="gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='revision']/gmd:date/gco:Date">
						<dct:modified><xsl:value-of select="."/></dct:modified>
					</xsl:for-each>

					<xsl:apply-templates select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty|mcp:responsibleParty/mcp:CI_Responsibility"/>

				</xsl:for-each>

				<xsl:apply-templates select="gmd:pointOfContact/gmd:CI_ResponsibleParty|mcp:resourceContactInfo/mcp:CI_Responsibility"/>

				<!-- subject -->

				<xsl:for-each select="gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
					<dc:subject><xsl:value-of select="."/></dc:subject>
				</xsl:for-each>

				<!-- abstract -->

				<xsl:for-each select="gmd:abstract/gco:CharacterString">
					<dct:abstract><xsl:value-of select="."/></dct:abstract>
					<dc:description><xsl:value-of select="."/></dc:description>
				</xsl:for-each>

				<!-- rights -->

				<xsl:for-each select="gmd:resourceConstraints/gmd:MD_LegalConstraints">
					<xsl:for-each select="*/gmd:MD_RestrictionCode/@codeListValue">
						<dc:rights><xsl:value-of select="."/></dc:rights>
					</xsl:for-each>

					<xsl:for-each select="otherConstraints/gco:CharacterString">
						<dc:rights><xsl:value-of select="."/></dc:rights>
					</xsl:for-each>
				</xsl:for-each>

				<!-- language -->

				<xsl:for-each select="gmd:language/gco:CharacterString">
					<dc:language><xsl:value-of select="."/></dc:language>
				</xsl:for-each>

				<!-- temporal extent -->

				<xsl:for-each select="gmd:extent/*/gmd:temporalElement/mcp:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
					<dc:coverage>name="<xsl:value-of select="@gml:id"/>"; start="<xsl:value-of select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/>"; end="<xsl:value-of select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/>"
					</dc:coverage>
				</xsl:for-each>

				<!-- bounding box -->

				<xsl:for-each select="gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
					<xsl:variable name="rsi"  select="/mcp:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier"/>
					<xsl:variable name="auth" select="$rsi/gmd:codeSpace/gco:CharacterString"/>
					<xsl:variable name="id"   select="$rsi/gmd:code/gco:CharacterString"/>
	
					<ows:BoundingBox crs="{$auth}::{$id}">
						<ows:LowerCorner>
							<xsl:value-of select="concat(gmd:eastBoundLongitude/gco:Decimal, ' ', gmd:southBoundLatitude/gco:Decimal)"/>
						</ows:LowerCorner>
		
						<ows:UpperCorner>
							<xsl:value-of select="concat(gmd:westBoundLongitude/gco:Decimal, ' ', gmd:northBoundLatitude/gco:Decimal)"/>
						</ows:UpperCorner>
					</ows:BoundingBox>
				</xsl:for-each>

			</xsl:for-each>

			<!-- Type - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue">
				<dc:type><xsl:value-of select="."/></dc:type>
			</xsl:for-each>

			<!-- Distribution - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<!-- Create as many URI element 
				* thumbnails
				* dataset online source elements
				* as coupledResource defined for a WMS service. 
				 * Get one connect point for the service
				 * Add as many layers defined in coupled resource elements.

				With this information, client could access to onlinesource defined in the metadata.
				
				CSW 2.0.2 ISO profil does not support dc:URI elements.
				What could be done is to add an output format supporting dclite4g 
				http://wiki.osgeo.org/wiki/DCLite4G (TODO)
				-->
			<xsl:for-each select="
				gmd:identificationInfo/srv:SV_ServiceIdentification[srv:serviceType/gco:LocalName='OGC:WMS']|
				gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification' and srv:serviceType/gco:LocalName='OGC:WMS']">
				
				<xsl:variable name="connectPoint" select="srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
				<xsl:variable name="serviceUrl">
					<xsl:choose>
						<xsl:when test="$connectPoint=''">
							<xsl:value-of select="../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$connectPoint"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<dc:URI protocol="OGC:WMS-1.1.1-http-get-capabilities"><xsl:value-of select="$serviceUrl"/></dc:URI>
				<xsl:for-each select="srv:coupledResource/srv:SV_CoupledResource">
					<xsl:if test="gco:ScopedName!=''">
						<dc:URI protocol="OGC:WMS" name="{gco:ScopedName}"><xsl:value-of select="$serviceUrl"/></dc:URI>
					</xsl:if>
				</xsl:for-each>
				 
			</xsl:for-each>
			
			
			<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
				<xsl:for-each select="gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
					<xsl:if test="gmd:linkage">
						<dc:URI>
							<xsl:if test="gmd:protocol">
								<xsl:attribute name="protocol"><xsl:value-of select="gmd:protocol/gco:CharacterString"/></xsl:attribute>
							</xsl:if>
							
							<xsl:if test="normalize-space(gmd:name/*)!=''">
								<xsl:attribute name="name">
									<xsl:for-each select="gmd:name">
										<xsl:value-of select="gco:CharacterString|gmx:MimeFileType"/>
									</xsl:for-each>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:if test="gmd:name/gmx:MimeFileType/@type">
								<xsl:attribute name="type">
									<xsl:value-of select="gmd:name/gmx:MimeFileType/@type"/>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:if test="gmd:description">
								<xsl:attribute name="description">
									<xsl:for-each select="gmd:description">
										<xsl:value-of select="gco:CharacterString"/>
									</xsl:for-each>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:value-of select="gmd:linkage/gmd:URL"/>
						</dc:URI>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic">
				<xsl:variable name="fileName" select="gmd:fileName/gco:CharacterString"/>
				<xsl:variable name="fileDescr" select="gmd:fileDescription/gco:CharacterString"/>
				
				<xsl:if test="$fileName!='' and $fileDescr='thumbnail'">
					<dc:URI>
						<xsl:choose>
							<xsl:when test="contains(gmd:fileName/gco:CharacterString, '.gif')">
								<xsl:attribute name="protocol">image/gif</xsl:attribute>
							</xsl:when>
							<xsl:when test="contains(gmd:fileName/gco:CharacterString, '.png')">
								<xsl:attribute name="protocol">image/png</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						
						<xsl:if test="$fileDescr">
							<xsl:attribute name="name"><xsl:value-of select="$fileDescr"/></xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="contains($fileName ,'://')"><xsl:value-of select="$fileName"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="concat('resources.get?id=',$info/id,'&amp;fname=',$fileName,'&amp;access=public')"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</dc:URI>
				</xsl:if>
			</xsl:for-each>
			
			<!-- Data Parameters - select those used in dataset only -->

			<xsl:for-each select="gmd:identificationInfo/*/mcp:dataParameters/*/mcp:dataParameter/*/mcp:parameterName/*[mcp:usedInDataset/*='true']">
				<dc:dataParameter 
						definition="{string(mcp:localDefinition/*)}" 
						units="{string(../../mcp:parameterUnits/*/mcp:name/*)}" 
						minValue="{string(../../mcp:parameterMinimumValue/*)}" 
						maxValue="{string(../../mcp:parameterMaximumValue/*)}" 
						desc="{string(../../mcp:parameterDescription/*)}">
					<xsl:value-of select="string(mcp:name/*)"/>
				</dc:dataParameter>
			</xsl:for-each>
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</csw:Record>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="gmd:CI_ResponsibleParty">

		<xsl:if test="gmd:role/gmd:CI_RoleCode/@codeListValue='originator'">
			<dc:creator><xsl:value-of select="gmd:organisationName/gco:CharacterString"/></dc:creator>
		</xsl:if>

		<xsl:if test="gmd:role/gmd:CI_RoleCode/@codeListValue='custodian'">
			<dc:custodian><xsl:value-of select="gmd:organisationName/gco:CharacterString"/></dc:custodian>
		</xsl:if>

		<xsl:if test="gmd:role/gmd:CI_RoleCode/@codeListValue='publisher'">
			<dc:publisher><xsl:value-of select="gmd:organisationName/gco:CharacterString"/></dc:publisher>
		</xsl:if>

		<xsl:if test="gmd:role/gmd:CI_RoleCode/@codeListValue='author'">
			<dc:contributor><xsl:value-of select="gmd:organisationName/gco:CharacterString"/></dc:contributor>
		</xsl:if>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="mcp:CI_Responsibility">

		<xsl:if test="mcp:role/gmd:CI_RoleCode/@codeListValue='originator'">
			<dc:creator><xsl:value-of select="mcp:party/*/mcp:name/gco:CharacterString"/></dc:creator>
		</xsl:if>

		<xsl:if test="mcp:role/gmd:CI_RoleCode/@codeListValue='custodian'">
			<dc:custodian><xsl:value-of select="mcp:party/*/mcp:name/gco:CharacterString"/></dc:custodian>
		</xsl:if>

		<xsl:if test="mcp:role/gmd:CI_RoleCode/@codeListValue='publisher'">
			<dc:publisher><xsl:value-of select="mcp:party/*/mcp:name/gco:CharacterString"/></dc:publisher>
		</xsl:if>

		<xsl:if test="mcp:role/gmd:CI_RoleCode/@codeListValue='author'">
			<dc:contributor><xsl:value-of select="mcp:party/*/mcp:name/gco:CharacterString"/></dc:contributor>
		</xsl:if>

	</xsl:template>

	<!-- ============================================================================= -->

	<!--
	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	-->

	<!-- ============================================================================= -->

</xsl:stylesheet>
