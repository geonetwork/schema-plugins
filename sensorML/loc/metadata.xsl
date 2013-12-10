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
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="sml swe gml geonet xlink rdf ns2 rdfs skos">


  <xsl:include href="metadata-fop.xsl"/>
	
	<xsl:variable name="ogcID" select="'http://www.opengis.net/def/identifier/OGC/uniqueID'"/>
	<xsl:variable name="thesaurusList" select="document('http://localhost:8080/geonetwork/srv/eng/xml.thesaurus.getList')"/>

	<!-- Template called by outside -->
	<xsl:template name="metadata-sensorML">
	  <xsl:param name="schema"/>
	  <xsl:param name="edit" select="false()"/>
	  <xsl:param name="embedded"/>

		<xsl:message>Processing <xsl:value-of select="name(.)"/></xsl:message>

	  <xsl:apply-templates mode="sensorML" select="." >
	    <xsl:with-param name="schema" select="$schema"/>
	    <xsl:with-param name="edit"   select="$edit"/>
	    <xsl:with-param name="embedded" select="$embedded" />
	  </xsl:apply-templates>
	</xsl:template>

	<xsl:template name="sensorMLCompleteTab">
	  <xsl:param name="tabLink"/>

	</xsl:template>

	<!-- Main template -->
	<xsl:template mode="sensorML" match="sml:SensorML">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded"/>

		<xsl:call-template name="sensorMLSimple">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ===================================================================== -->
	<!-- some sml: elements swallowed to reduce layout complexity              -->
	<!-- ===================================================================== -->

	<!-- should work for *[@name]/*[@definition]/* -->
	<xsl:template mode="sensorML" match="sml:*[sml:Term/sml:value]|sml:*[swe:Quantity/swe:description]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="ref" select="concat('_',*/*/geonet:element/@ref)"/>
		<!-- <xsl:variable name="thesaurus" select="@name"/> FIXME -->
		<xsl:variable name="thesaurus" select="'external.place.regions'"/>
		<xsl:variable name="definition" select="*/@definition"/>
		<xsl:variable name="defTermRef" select="concat('_', */geonet:element/@ref, '_definition')"/>
		<xsl:variable name="thesaurusRef" select="concat('_',geonet:element/@ref,'_name')"/>
		<xsl:message>Thesaurus: <xsl:value-of select="$thesaurus"/> Key: <xsl:value-of select="$thesaurusList/response/thesauri/thesaurus[ends-with(key,$thesaurus)]/url"/></xsl:message>

		<xsl:call-template name="sensorMLThesaurus">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text" select="sml:Term/sml:value"/>
			<xsl:with-param name="name" select="name()"/>
			<xsl:with-param name="ref" select="$ref"/>
			<xsl:with-param name="definition" select="$definition"/>
			<xsl:with-param name="defTermRef" select="$defTermRef"/>
			<xsl:with-param name="thesaurus" select="$thesaurus"/>
			<xsl:with-param name="thesaurusRef" select="$thesaurusRef"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="sml:*[swe:ObservableProperty]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="ref" select="''"/> <!-- not used here -->
		<!-- <xsl:variable name="thesaurus" select="@name"/> FIXME -->
		<xsl:variable name="thesaurus" select="'external.place.regions'"/>
		<xsl:variable name="definition" select="swe:ObservableProperty/@definition"/>
		<xsl:variable name="defTermRef" select="concat('_', swe:ObservableProperty/geonet:element/@ref, '_definition')"/>
		<xsl:variable name="thesaurusRef" select="concat('_',geonet:element/@ref,'_name')"/>
		<xsl:message>Thesaurus: <xsl:value-of select="$thesaurus"/> Key: <xsl:value-of select="$thesaurusList/response/thesauri/thesaurus[ends-with(key,$thesaurus)]/url"/></xsl:message>

		<xsl:call-template name="sensorMLThesaurus">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text" select="''"/>
			<xsl:with-param name="name" select="name()"/>
			<xsl:with-param name="ref" select="$ref"/>
			<xsl:with-param name="definition" select="$definition"/>
			<xsl:with-param name="defTermRef" select="$defTermRef"/>
			<xsl:with-param name="thesaurus" select="$thesaurus"/>
			<xsl:with-param name="thesaurusRef" select="$thesaurusRef"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="sensorMLThesaurus">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="text"/>
		<xsl:param name="name"/>
		<xsl:param name="ref"/>
		<xsl:param name="definition"/>
		<xsl:param name="defTermRef"/>
		<xsl:param name="thesaurus"/>
		<xsl:param name="thesaurusRef"/>

		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="normalize-space($thesaurus)!=''">
					<xsl:call-template name="getTitle-sensorML">
						<xsl:with-param name="name"   select="$name"/>
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="id"     select="$thesaurus"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/root/gui/schemas/sensorML/strings/term"/>		
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:call-template name="doSensorMLThesaurus">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="edit"     select="$edit"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="tooltip"  select="$tooltip"/>
					<xsl:with-param name="text" select="$text"/>
					<xsl:with-param name="ref" select="$ref"/>
					<xsl:with-param name="definition" select="$definition"/>
					<xsl:with-param name="defTermRef" select="$defTermRef"/>
					<xsl:with-param name="thesaurus" select="$thesaurus"/>
					<xsl:with-param name="thesaurusRef" select="$thesaurusRef"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="edit"     select="false()"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="tooltip"  select="$tooltip"/>
					<xsl:with-param name="text">
						<table width="100%">
				  		<tr>
				    		<td>
									<xsl:value-of select="$text"/>
				    		</td>
				    		<td>
									Term: <xsl:value-of select="$definition"/>
				    		</td>
							</tr>
						</table>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="doSensorMLThesaurus">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="title"/>
		<xsl:param name="tooltip"/>
		<xsl:param name="text"/>
		<xsl:param name="ref"/>
		<xsl:param name="definition"/>
		<xsl:param name="defTermRef"/>
		<xsl:param name="thesaurus"/>
		<xsl:param name="thesaurusRef"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"   select="$schema"/>
			<xsl:with-param name="edit"     select="$edit"/>
			<xsl:with-param name="title"    select="$title"/>
			<xsl:with-param name="tooltip"  select="$tooltip"/>
			<xsl:with-param name="editAttributes" select="false()"/>
			<xsl:with-param name="text">
				<xsl:variable name="gnThesaurus" select="$thesaurusList/response/thesauri/thesaurus[ends-with(key,$thesaurus)]/key"/>
				<xsl:variable name="gnThesaurusTitle" select="$thesaurusList/response/thesauri/thesaurus[ends-with(key,$thesaurus)]/title"/>
				<table width="100%">
				  <tr>
				    <td>
							<xsl:choose>
								<xsl:when test="$ref!=''">
									<!-- The term text field -->
									<input class="md" name="{$ref}" id="{$ref}" value="{$text}"/>
									<!--- hide term id (*/@name attribute) -->
									<input id="{$defTermRef}" name="{$defTermRef}" type="hidden" value="{$definition}"/>
								</xsl:when>
								<xsl:otherwise>
									<!--- show term id */@name attribute) -->
									<!-- FIXME: Lookup thesaurus for term id -->
									<input class="md" id="{$defTermRef}" name="{$defTermRef}" value="{$definition}"/>
								</xsl:otherwise>
							</xsl:choose>
							<!-- showThesaurusSelectionPanel:
							     - if gnThesaurus is empty: offer selector with all thesauri
									 - ref = input to place term value in
									 - defTermRef = input to place term-uri in
									 - thesaurusRef = input to place thesaurus name in -->
							<a style="cursor:pointer;" onclick="javascript:csiro.showThesaurusSelectionPanel('{$gnThesaurusTitle}','{$gnThesaurus}','{$ref}','{$defTermRef}','{$thesaurusRef}');">
								<img src="{/root/gui/url}/images/find.png" alt="{/root/gui/schemas/sensorML/strings/thesaurusPicker}" title="{/root/gui/schemas/sensorML/strings/thesaurusPicker}"/>
							</a>
						</td>
				    <td>
							Name: <input class="md" id="{$thesaurusRef}" name="{$thesaurusRef}" value="{$thesaurus}"/>
				    </td>
				  </tr>
			  </table>
			</xsl:with-param>
		</xsl:apply-templates>		
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- Template for simple edit view -->
	<xsl:template name="sensorMLSimple">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="lang"  select="/root/gui/language"/>

		<xsl:call-template name="complexElementGuiWrapper">
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="'sml:identification'"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'site'"/>
				</xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="content">

				<!-- Metadata identifier -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name=$ogcID]">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name=$ogcID]">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!-- Effective date -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:validTime">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:validTime">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>	
					</xsl:otherwise>
				</xsl:choose>

				<!-- Identification Terms -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:identification/sml:IdentifierList">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:identification/sml:IdentifierList">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>	
					</xsl:otherwise>
				</xsl:choose>

				<!-- Classifier list aka categories for sensor site -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:classification/sml:ClassifierList">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:classification/sml:ClassifierList">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!-- Capabilities aka sensor site status -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System//sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>	
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- Keywords - need to process as terms with term id as id attribute
				     and codeSpace attribute describing thesaurus -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:keywords/sml:KeywordList/sml:keyword">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!-- Point location of sensor site -->
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:location'"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id" select="'site'"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="content">
						<!-- Datum and Point location -->
						<xsl:choose>
							<xsl:when test="$edit">
								<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/sml:position/swe:Position/@referenceFrame">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:apply-templates>	

								<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/sml:position/swe:Position/swe:location/swe:Vector">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:apply-templates>	
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:position/swe:Position/@referenceFrame">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:apply-templates>	

								<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:apply-templates>	
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
						
				<!-- BBOX - observation bbox at site -->	
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'swe:field'"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id" select="'observedBBOX'"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:if test="$edit">
							<p style="padding:10px"><xsl:value-of select="/root/gui/schemas/sensorML/strings/bbox" /></p>
						</xsl:if>

						<xsl:choose>
							<xsl:when test="$edit">
								<xsl:for-each select="sml:member/*/sml:System/*/*/sml:capabilities/swe:DataRecord">
									<xsl:if test="swe:field[@name='observedBBOX']">
										<xsl:apply-templates mode="elementEP" select="swe:field[@name='observedBBOX']">
											<xsl:with-param name="schema" select="$schema"/>
											<xsl:with-param name="edit"   select="$edit"/>
										</xsl:apply-templates>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="sml:member/sml:System/sml:capabilities/swe:DataRecord">
									<xsl:if test="swe:field[@name='observedBBOX']">
										<xsl:apply-templates mode="elementEP" select="swe:field[@name='observedBBOX']">
											<xsl:with-param name="schema" select="$schema"/>
											<xsl:with-param name="edit"   select="$edit"/>
										</xsl:apply-templates>
									</xsl:if>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>

				<!-- Input containers -->
				<xsl:choose>
					<xsl:when test="$edit">
						<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/sml:inputs/sml:InputList">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:inputs/sml:InputList">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!-- History of events at sensor site -->
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:history'"/>
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="tooltip">
						<xsl:call-template name="getTooltipTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:history'"/>
							<xsl:with-param name="schema" select="$schema"/>
						 </xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:choose>
							<xsl:when test="$edit">
								<xsl:message>GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG</xsl:message>
								<xsl:apply-templates mode="elementEP" select="sml:member/*/sml:System/*/*/sml:history/sml:EventList">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<xsl:message>HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH</xsl:message>
								<xsl:apply-templates mode="elementEP" select="sml:member/sml:System/sml:history/sml:EventList">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>

				<!-- Documentation: related datasets from GeoNetwork and any 
				     onlineResource elements relating to the sensor site -->
				<xsl:call-template name="complexElementGuiWrapper">

					<xsl:with-param name="title">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:DocumentList'"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id" select="'documents'"/>
						</xsl:call-template>
					</xsl:with-param>

					<xsl:with-param name="tooltip">
						<xsl:call-template name="getTooltipTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:DocumentList'"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id" select="'documents'"/>
						</xsl:call-template>
					</xsl:with-param>

					<xsl:with-param name="content">

						<xsl:variable name="documentCounter" select="count(sml:member/*/sml:System/*/*/sml:documentation/sml:DocumentList//sml:member[@name='siteOnlineResource'])" />

						<xsl:for-each select="sml:member/*/sml:System//sml:documentation/sml:DocumentList//sml:member[@name='siteOnlineResource']">


							<xsl:variable name="componentIndex" select="position()" />
						
							<xsl:variable name="id">siteOnlineResource_<xsl:value-of select="generate-id(.)"/></xsl:variable>

							<xsl:call-template name="complexElementGuiWrapper">
								<xsl:with-param  name="id" select="$id"/>

								<xsl:with-param name="title">
									<xsl:call-template name="getTitle-sensorML">
										<xsl:with-param name="name"   select="name(.)"/>
										<xsl:with-param name="schema" select="$schema"/>
										<xsl:with-param name="id" select="'siteOnlineResource'"/>
									</xsl:call-template>
								</xsl:with-param>

								<xsl:with-param name="content">
	
									<xsl:choose>
										<xsl:when test="$edit=true()">
											<xsl:variable name= "tooltip">
												<xsl:call-template name="getTooltipTitle-sensorML">
														<xsl:with-param name="name"   select="'sml:date'"/>
														<xsl:with-param name="schema" select="$schema"/>
												</xsl:call-template>
											</xsl:variable>
											
										<div id="buttons_{$id}">

										<!-- Add button -->					
										<xsl:variable name="parent" select="sml:member/*/sml:System//sml:documentation/sml:DocumentList//sml:member[$componentIndex]/geonet:element/@parent" />

										<xsl:variable name="addLink">
												<xsl:value-of select="concat('addSiteOnlineResource(',$apos,geonet:element/@parent,$apos,',',$apos,$parent,$apos,',',$apos,name(.),$apos,',',$apos,'buttons_',$id,$apos,');')"/>
										</xsl:variable>	
										<a id="add_{$id}" onclick="if (noDoubleClick()) {$addLink}" target="_blank">
											<xsl:attribute name="style">
											cursor:hand;cursor:pointer;
											<xsl:if test="not(position() = last())">display:none;</xsl:if>	
											</xsl:attribute> 
											<img src="{/root/gui/url}/images/plus.gif" alt="{/root/gui/strings/add}" title="{/root/gui/strings/add}"/>
										</a>&#160;

										<xsl:variable name="removeLink" select="concat('{ doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',geonet:element/@ref,',',geonet:element/@parent,',',$apos,$id,$apos,',',geonet:element/@min,'); }')"/>

											<a id="remove_{$id}" onclick="if (noDoubleClick()) {$removeLink}" target="_blank">
												<xsl:attribute name="style">
												cursor:hand;cursor:pointer;
												<xsl:if test="not($documentCounter > 1)">display:none;</xsl:if>	
												</xsl:attribute> 

												<img src="{/root/gui/url}/images/del.gif" alt="{/root/gui/strings/del}" title="{/root/gui/strings/del}"/></a>

										</div>	

										<xsl:apply-templates mode="simpleElement" select="sml:Document/sml:onlineResource">
											<xsl:with-param name="schema" select="$schema"/>
											<xsl:with-param name="edit"   select="$edit"/>
											<xsl:with-param name="tooltip">
												<xsl:call-template name="getTooltipTitle-sensorML">
													<xsl:with-param name="name"   select="'href'"/>
													<xsl:with-param name="schema" select="$schema"/>
                          <xsl:with-param name="id" select="'onlineResource'"/>
												</xsl:call-template>
											</xsl:with-param>
											<xsl:with-param name="title">
												<xsl:call-template name="getTitle-sensorML">
													<xsl:with-param name="name"   select="'href'"/>
													<xsl:with-param name="schema" select="$schema"/>
												</xsl:call-template> 
											</xsl:with-param>
										</xsl:apply-templates>


										<xsl:apply-templates mode="simpleElement" select="sml:Document/gml:description">
											<xsl:with-param name="schema" select="$schema"/>
											<xsl:with-param name="edit"   select="$edit"/>
											<xsl:with-param name="tooltip">
												<xsl:call-template name="getTooltipTitle-sensorML">
													<xsl:with-param name="name" select="'gml:description'"/>
													<xsl:with-param name="schema" select="$schema"/>
													<xsl:with-param name="id" select="'siteOnlineResource'" />
												</xsl:call-template> 
											</xsl:with-param>
											<xsl:with-param name="title">
												<xsl:call-template name="getTitle-sensorML">
													<xsl:with-param name="name" select="'gml:description'"/>
													<xsl:with-param name="schema" select="$schema"/>
													<xsl:with-param name="id" select="'siteOnlineResource'" />
												</xsl:call-template> 
											</xsl:with-param>
										</xsl:apply-templates>

										<xsl:apply-templates mode="simpleElement" select="sml:Document/sml:format">
											<xsl:with-param name="schema" select="$schema"/>
											<xsl:with-param name="edit"   select="$edit"/>
										</xsl:apply-templates>	
									</xsl:when>

									<!-- viewing is simple -->
									<xsl:otherwise>
										<xsl:apply-templates mode="simpleElement" select="*">
											<xsl:with-param name="schema"  select="$schema"/>
											<xsl:with-param name="edit"   select="false()"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>

							</xsl:with-param>
						</xsl:call-template>

					</xsl:for-each>

				</xsl:with-param>
				</xsl:call-template>

				<!-- Related datasets -->
				<xsl:call-template name="complexElementGuiWrapper">

					<xsl:with-param name="title">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:DocumentList'"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id" select="'datasets'"/>
						</xsl:call-template>
					</xsl:with-param>

					<xsl:with-param name="tooltip">
						<xsl:call-template name="getTooltipTitle-sensorML">
							<xsl:with-param name="name"   select="'sml:DocumentList'"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id" select="'datasets'"/>
						</xsl:call-template>
					</xsl:with-param>

				<xsl:with-param name="content">
					<xsl:variable name="documentCounter" select="count(sml:member/*/sml:System/*/*/sml:documentation/sml:DocumentList//sml:member[@name='relatedDataset-GeoNetworkUUID'])" />

					<xsl:for-each select="sml:member/*/sml:System//sml:documentation/sml:DocumentList//sml:member[@name='relatedDataset-GeoNetworkUUID']">

						<xsl:variable name="componentIndex" select="position()" />
						
						<xsl:choose>
							<xsl:when test="$edit=true()">
								<xsl:variable name= "tooltip">
									<xsl:call-template name="getTooltipTitle-sensorML">
										<xsl:with-param name="name"   select="'sml:member'"/>
										<xsl:with-param name="schema" select="$schema"/>
                  	<xsl:with-param name="id" select="'dataset'"/>
									</xsl:call-template>
								</xsl:variable>


								<xsl:variable name="id">relatedDataset_<xsl:value-of select="generate-id(.)"/></xsl:variable>

              	<xsl:variable name="parent" select="sml:member/*/sml:System//sml:documentation/sml:DocumentList//sml:member[@name='relatedDataset-GeoNetworkUUID'][$componentIndex]/geonet:element/@parent" />

               	<xsl:apply-templates mode="simpleElement" select="@xlink:href">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit"   select="$edit"/>
                  <xsl:with-param name="id"   select="$id"/>
                  <xsl:with-param name="tooltip"   select="$tooltip"/>
									<xsl:with-param name="title">
                    <xsl:call-template name="getTitle-sensorML">
                    <xsl:with-param name="name"   select="'sml:member'"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="'dataset'"/>
                  </xsl:call-template>&#160;

									<xsl:variable name="removeId1">_<xsl:value-of select="geonet:element/@ref" />_xlinkCOLONhref</xsl:variable>

									<!-- Remove button -->

									<xsl:variable name="removeLink" select="concat('{ doRemoveElementAction2(',$apos,'/metadata.elem.delete',$apos,',',geonet:element/@ref,',',geonet:element/@parent,',',$apos,$removeId1,$apos,',',geonet:element/@min,'); }')"/>

									<a id="del_{$removeId1}"  style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$removeLink}"  role="button">
										<xsl:attribute name="style">
											cursor:hand;cursor:pointer;
											<xsl:if test="not($documentCounter > 1)">display:none;</xsl:if>				
										</xsl:attribute>

										<img src="{/root/gui/url}/images/del.gif" alt="{/root/gui/strings/del}" title="{/root/gui/strings/del}"/></a>&#160;

										<!-- Add button -->					
										<xsl:variable name="addLink">
											<xsl:value-of select="concat('addRelatedDataset(',$apos,geonet:element/@parent,$apos,',',$apos,$parent,$apos,',',$apos,name(.),$apos,',',$apos,'add_',$removeId1,$apos,');')"/>
										</xsl:variable>	

										<a id="add_{$removeId1}" style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$addLink}" target="_blank" role="button">
											<xsl:attribute name="style">
												cursor:hand;cursor:pointer;
												<xsl:if test="position() != last()">display:none;</xsl:if>				
											</xsl:attribute>

											<img src="{/root/gui/url}/images/plus.gif" alt="{/root/gui/strings/add}" title="{/root/gui/strings/add}"/>
										</a>
													
									</xsl:with-param>

									<xsl:with-param name="text">
										<xsl:variable name="value" select="@xlink:href"/>
											<input type="text" class="md" title="{/root/gui/strings/searchforarecord}" size="40" name="_{geonet:element/@ref}_xlinkCOLONhref" id="_{geonet:element/@ref}_xlinkCOLONhref" value="{$value}" onfocus="javascript:showLinkedMetadataSelectionPanelSM('{geonet:element/@ref}', 'xlinkCOLONhref', '{geonet:element/@parent}', '{$parent}');"  />
											<img src="{/root/gui/url}/images/find.png" alt="{/root/gui/strings/searchforarecord}" title="{/root/gui/strings/searchforarecord}." onclick="javascript:showLinkedMetadataSelectionPanelSM('{geonet:element/@ref}', 'xlinkCOLONhref', '{geonet:element/@parent}', '{$parent}');"  /><br/>
											<!-- If available display the title -->
											<xsl:if test="/root/gui/relation/*/response//metadata[geonet:info/uuid/text()=$value]/title!=''">
												<xsl:value-of select="/root/gui/relation/*/response//metadata[geonet:info/uuid/text()=$value]/title"/>
											</xsl:if>
									</xsl:with-param>
								</xsl:apply-templates>	
							
							</xsl:when>

							<xsl:otherwise>
								<xsl:apply-templates mode="simpleElement" select="*">
									<xsl:with-param name="schema"  select="$schema"/>
									<xsl:with-param name="edit"   select="false()"/>
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>

			<!-- Contact -->
			<xsl:variable name="contactCounter" select="count(sml:member/*/sml:System/*/*/sml:contact)" />

			<xsl:for-each select="sml:member/*/sml:System/*/*/sml:contact">

					<xsl:call-template name="complexElementGuiWrapper">

						<xsl:with-param name="title">
							<xsl:call-template name="getTitle-sensorML">
								<xsl:with-param name="name"   select="'sml:contact'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
						</xsl:with-param>

						<xsl:with-param name="tooltip">
							<xsl:call-template name="getTooltipTitle-sensorML">
								<xsl:with-param name="name"   select="'sml:contact'"/>
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
						</xsl:with-param>

						<xsl:with-param name="content">

							<xsl:variable name="id" select="generate-id(.)"/>

							<xsl:if test="$contactCounter > 1">

							<xsl:variable name="ref" select="geonet:element/@ref" />


							<xsl:variable name="parent" select="geonet:element/@parent" />

							<xsl:variable name="min" select="geonet:element/@min" />

							<xsl:variable name="removeLink" select="concat('{ doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',geonet:element/@ref,',',geonet:element/@parent,',',$apos,$id,$apos,',',geonet:element/@min,');','doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',$ref,',',$parent,',',$apos,$id,$apos,',',$min,'); }')"/>

								<a id="remove_{$id}"  style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$removeLink}" target="_blank"><img src="{/root/gui/url}/images/del.gif" alt="{/root/gui/strings/del}" title="{/root/gui/strings/del}"/></a>&#160;
							</xsl:if>	


							<!-- Add button -->					
							<xsl:if test="position() = last()">

							<xsl:variable name="parent" select="geonet:element/@parent" />


							<xsl:variable name="addLink">
									<xsl:value-of select="concat('addContactSectionXmlFragment(',$apos,geonet:element/@parent,$apos,',',$apos,$parent,$apos,',',$apos,name(.),$apos,',',$apos,'add_',$id,$apos,');')"/>
							</xsl:variable>	
								<a id="add_{$id}" style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$addLink}" target="_blank"><img src="{/root/gui/url}/images/plus.gif" alt="{/root/gui/strings/add}" title="{/root/gui/strings/add}"/></a>

							</xsl:if>
							
							<xsl:call-template name="ResponsibleParty">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit" select="$edit"/>
									<xsl:with-param name="resp" select=".//sml:ResponsibleParty"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

				<!-- Sensor identification -->
				<xsl:variable name="sensorCounter" select="count(//sml:SensorML/sml:member/*/sml:System/sml:components/sml:ComponentList/sml:component)" />

				<xsl:for-each select="sml:member/*/sml:System/sml:components/sml:ComponentList/sml:component">

					<xsl:variable name="componentIndex" select="position()" />
		
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title">
							<xsl:call-template name="getTitle-sensorML">
								<xsl:with-param name="name"   select="'sml:identification'"/>
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="id" select="'sensor'"/>
							</xsl:call-template>
						</xsl:with-param>
		
						<xsl:with-param name="content">
							<xsl:variable name="id" select="generate-id(.)"/>

							<!-- Delete button -->
							<xsl:if test="$sensorCounter > 1">

							<xsl:variable name="ref" select="//sml:SensorML/sml:member/*/sml:System/sml:components/sml:ComponentList/sml:component[$componentIndex]/geonet:element/@ref" />


							<xsl:variable name="parent" select="//sml:SensorML/sml:member/*/sml:System/sml:components/sml:ComponentList/sml:component[$componentIndex]/geonet:element/@parent" />

							<xsl:variable name="min" select="//sml:SensorML/sml:member/*/sml:System/sml:components/sml:ComponentList/sml:component[$componentIndex]/geonet:element/@min" />

							<xsl:variable name="removeLink" select="concat('{ doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',geonet:element/@ref,',',geonet:element/@parent,',',$apos,$id,$apos,',',geonet:element/@min,');','doRemoveElementAction(',$apos,'/metadata.elem.delete',$apos,',',$ref,',',$parent,',',$apos,$id,$apos,',',$min,'); }')"/>

								<a id="remove_{$id}"  style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$removeLink}" target="_blank"><img src="{/root/gui/url}/images/del.gif" alt="{/root/gui/strings/del}" title="{/root/gui/strings/del}"/></a>&#160;
							</xsl:if>	


							<!-- Add button -->					
							<xsl:if test="position() = last()">

							<xsl:variable name="parent" select="//sml:SensorML/sml:member/*/sml:System/sml:components/sml:ComponentList/sml:component[$componentIndex]/geonet:element/@parent" />

							<xsl:variable name="addLink">
									<xsl:value-of select="concat('addSensorSectionXmlFragment(',$apos,geonet:element/@parent,$apos,',',$apos,$parent,$apos,',',$apos,name(.),$apos,',',$apos,'add_',$id,$apos,');')"/>

							</xsl:variable>	
								<a id="add_{$id}" style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$addLink}" target="_blank"><img src="{/root/gui/url}/images/plus.gif" alt="{/root/gui/strings/add}" title="{/root/gui/strings/add}"/></a>

							</xsl:if>

							<!-- Sensor identifiers -->
              <xsl:apply-templates mode="elementEP" select="*//sml:identification/sml:IdentifierList">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>

							<!-- Sensor type -->
							<xsl:apply-templates mode="elementEP" select=".//sml:classification/sml:ClassifierList">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>

							<!-- Sensor status -->
							<xsl:apply-templates mode="elementEP" select=".//sml:capabilities/swe:DataRecord/swe:field[@name='sensorStatus']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>	

							<!-- Sensor keywords -->
							<xsl:apply-templates mode="elementEP" select=".//sml:keywords/sml:KeywordList/sml:keyword">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>

							<!-- Sensor location -->
							<xsl:call-template name="complexElementGuiWrapper">

								<xsl:with-param name="title">
									<xsl:call-template name="getTitle-sensorML">
										<xsl:with-param name="name"   select="'sml:location'"/>
										<xsl:with-param name="schema" select="$schema"/>
										<xsl:with-param name="id" select="'sensor'"/>
									</xsl:call-template>
								</xsl:with-param>

								<xsl:with-param name="content">

									<!-- Datum -->
									<xsl:apply-templates mode="elementEP" select=".//sml:position/swe:Position/@referenceFrame">
										<xsl:with-param name="schema" select="$schema"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>	

									<!-- Location -->
									<xsl:apply-templates mode="elementEP" select=".//sml:position/swe:Position/swe:location/swe:Vector">
										<xsl:with-param name="schema" select="$schema"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>	

									<!-- BBOX --> 		
									<xsl:call-template name="complexElementGuiWrapper">

										<xsl:with-param name="title">
											<xsl:call-template name="getTitle-sensorML">
												<xsl:with-param name="name"   select="'swe:field'"/>
												<xsl:with-param name="schema" select="$schema"/>
												<xsl:with-param name="id" select="'observedBBOX'"/>
											</xsl:call-template>
										</xsl:with-param>

										<xsl:with-param name="content">
							
											<xsl:for-each select=".//sml:capabilities/swe:DataRecord">
												<xsl:if test="swe:field[@name='observedBBOX']">
													<xsl:apply-templates mode="elementEP" select="swe:field[@name='observedBBOX']">
														<xsl:with-param name="schema" select="$schema"/>
														<xsl:with-param name="edit"   select="$edit"/>
													</xsl:apply-templates>
												</xsl:if>
											</xsl:for-each>
								
										</xsl:with-param>

									</xsl:call-template>

									<xsl:apply-templates mode="elementEP" select=".//sml:inputs/sml:InputList">
										<xsl:with-param name="schema" select="$schema"/>
										<xsl:with-param name="edit"   select="$edit"/>
									</xsl:apply-templates>

								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:with-param>
	</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="sml:member[ancestor::sml:EventList]" priority="30">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="eventName" select="@name"/>

		<!-- show sml:member with $eventName as title with content set to
		     sml:date and sml:classification children -->
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name()"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="$eventName"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:variable name= "tooltip">
					<xsl:call-template name="getTooltipTitle-sensorML">
						<xsl:with-param name="name"   select="name()"/>
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$edit=true()">

						<xsl:apply-templates mode="simpleElement" select="sml:Event/sml:date">
							<xsl:with-param name="schema"  select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
							<xsl:with-param name="tooltip" select="$tooltip"/>
							<xsl:with-param name="title">
								<xsl:call-template name="getTitle-sensorML">
									<xsl:with-param name="name"   select="'sml:date'"/>
									<xsl:with-param name="schema" select="$schema"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="text">
								<xsl:variable name="ref" select="sml:Event/sml:date/geonet:element/@ref"/>
								<xsl:variable name="format">%Y-%m-%d</xsl:variable>
								<xsl:call-template name="calendar">
									<xsl:with-param name="ref" select="$ref"/>
									<xsl:with-param name="date" select="sml:Event/sml:date/text()"/>
									<xsl:with-param name="format" select="$format"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="simpleElement" select="sml:Event/sml:date">
							<xsl:with-param name="schema" select="$schema"/>
             	<xsl:with-param name="edit"   select="$edit"/>
              <xsl:with-param name="tooltip" select="$tooltip"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="sml:Event/*/sml:classification/sml:ClassifierList|sml:Event/sml:classification/sml:ClassifierList">
						<xsl:apply-templates mode="elementEP" select="sml:Event/*/sml:classification|sml:Event/sml:classification">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
        		</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="elementEP" select="sml:Event/*/geonet:child[@name='classification']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
        		</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!-- FIXME: ignore gml:description for now -->
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- Get list of countries from XPaths and display for sml:country -->
	<xsl:template mode="sensorML" match="sml:country">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="tooltip" select="$tooltip"/>	

					<xsl:with-param name="text">
						<xsl:variable name="value" select="."/>
						<xsl:variable name="lang" select="/root/gui/language"/>
						<select class="md" name="_{geonet:element/@ref}" id="_{geonet:element/@ref}" size="1" title="{$tooltip}">
								<option name="" />
								<xsl:for-each select="/root/gui/regions/record">
									<xsl:sort select="label/child::*[name() = $lang]" order="ascending"/>

									<option value="{label/child::*[name() = $lang]}">
										<xsl:if test="$value = label/child::*[name() = $lang]">
											<xsl:attribute name="selected"/>
										</xsl:if>
										<xsl:value-of select="label/child::*[name() = $lang]"/>
									</option>
								</xsl:for-each>
						</select>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="sensorMLString">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- Template for metadata effective date -->
	<xsl:template mode="sensorML" match="sml:validTime" priority="30">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:apply-templates mode="simpleElement" select="gml:TimeInstant/gml:timePosition">
					<xsl:with-param name="schema"  select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="text">
						<xsl:variable name="ref" select="gml:TimeInstant/gml:timePosition/geonet:element/@ref"/>

						<xsl:variable name="format">
							%Y-%m-%d
						</xsl:variable>

						<xsl:variable name="tooltip">
							<xsl:call-template name="getTooltipTitle-sensorML">
									<xsl:with-param name="name"   select="name(.)"/>
									<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:variable name="mandatory" select="gml:TimeInstant/gml:timePosition/geonet:element/@min='1'" />

						<xsl:call-template name="calendar">
							<xsl:with-param name="ref" select="$ref"/>
							<xsl:with-param name="date" select="gml:TimeInstant/gml:timePosition"/>
							<xsl:with-param name="format" select="$format"/>
							<xsl:with-param name="tooltip" select="$tooltip"/>
							<xsl:with-param name="mandatory" select="$mandatory"/>
						</xsl:call-template> 
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise>
				<xsl:apply-templates mode="simpleElement" select="gml:TimeInstant/gml:timePosition">
					<xsl:with-param name="schema"  select="$schema"/>
					<xsl:with-param name="edit"   select="false()"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- Handle GeoNetwork-UUID or $ogcID in sml:identifier -->
	<xsl:template mode="sensorML" match="sml:identifier[@name='GeoNetwork-UUID' or @name=$ogcID]" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="tooltip">
				<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'GeoNetwork-UUID'"/>
				</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select="sml:Term/sml:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="false()"/>
			<xsl:with-param name="tooltip" select="$tooltip" />

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'GeoNetwork-UUID'"/>
				</xsl:call-template>

			</xsl:with-param>

			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="$edit = true()">
						<input type="text" readonly="readonly" value="{sml:Term/sml:value}" class="md readonly" size="40" title="{$tooltip}"/><span>&#160;</span>
					</xsl:when>
							
					<xsl:otherwise>
						<span title="{$tooltip}"><xsl:value-of select="sml:Term/sml:value"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="swe:Position/@referenceFrame" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="value" select="."/>	

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>


		<xsl:variable name="id" select="concat('_', ../geonet:element/@ref, '_referenceFrame')"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:call-template> 

				<xsl:if test="$edit and not(contains(name(../../..), 'sml:Component'))">
					<sup><font size="-1" color="#FF0000">&#xA0;*</font></sup> 	
			</xsl:if>
			</xsl:with-param>
			
			<xsl:with-param name="text">
				<xsl:choose>                    
					<xsl:when test="$edit=true()">
						<select class="md" name="{$id}"
id="{$id}"
								size="1" title="{$tooltip}">
								<option name="" />

								<xsl:for-each select="/root/gui/rdf:ecSensorRefSystem/rdf:Description/ns2:prefLabel[@xml:lang='en']">
								    <xsl:sort select="." order="ascending"/>

								    <option value="{.}">
								        <xsl:if test=". = $value">
								            <xsl:attribute name="selected"/>
								        </xsl:if>
								        <xsl:value-of select="."/>
								    </option>
								</xsl:for-each>

							    <!--<xsl:call-template name="output-tokens">
									<xsl:with-param name="list"><xsl:value-of select="/root/gui/schemas/sensorML/strings/codelist_srids"/></xsl:with-param>
										<xsl:with-param name="delimiter">::</xsl:with-param>
							    	<xsl:with-param name="value" select="$value" />
									</xsl:call-template>-->
						</select>

					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="$value" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>

		</xsl:apply-templates>	
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- For every sml:identifier|sml:classifier:
				if new then allow name and definition (thesaurus) to be chosen
				if existing then use name as label and offer values from
				definition (thesaurus) as a select box if the thesaurus
				exists otherwise just offer a textbox
		-->
	<xsl:template mode="sensorML" match="sml:IdentifierList|sml:ClassifierList|sml:InputList" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
	
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
			
				<xsl:for-each select="sml:identifier[@name!='GeoNetwork-UUID' and @name!=$ogcID]|sml:classifier|sml:input">
					<xsl:apply-templates mode="elementEP" select=".">
						<xsl:with-param name="schema"  select="$schema"/>
						<xsl:with-param name="edit"    select="$edit"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
				
	<!-- ==================================================================== -->

	<!-- handle siteStatus swe:field in sml:capabilities/swe:DataRecord -->
	<xsl:template mode="sensorML" match="swe:field[@name='siteStatus']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="value" select=".//swe:Text/swe:value"/>	

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'siteStatus'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Text/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="@name"/>
				</xsl:call-template> 

                <xsl:if test="$edit">
				    <sup><font size="-1" color="#FF0000">&#xA0;*</font></sup>
                </xsl:if>
			</xsl:with-param>


			<xsl:with-param name="text">
				<xsl:choose>                    
					<xsl:when test="$edit=true()">
						<select class="md" name="_{.//swe:Text/swe:value/geonet:element/@ref}"
								size="1" title="{$tooltip}">
								<option name="" />

								<!-- FIXME -->
								<xsl:for-each select="/root/gui/rdf:ecSiteStatus/rdf:Description/ns2:prefLabel">
								    <xsl:sort select="." order="ascending"/>

								    <option value="{.}">
								        <xsl:if test=". = $value">
								            <xsl:attribute name="selected"/>
								        </xsl:if>
								        <xsl:value-of select="."/>
								    </option>
								</xsl:for-each>

							   <!-- <xsl:call-template name="output-tokens">
									<xsl:with-param name="list"><xsl:value-of select="/root/gui/schemas/sensorML/strings/codelist_device_status"/></xsl:with-param>
									<xsl:with-param name="delimiter">::</xsl:with-param>
							    	<xsl:with-param name="value" select="$value" />
									</xsl:call-template> -->
							</select>

					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="$value" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<!-- handle sensorStatus swe:field in sml:capabilities/swe:DataRecord 
	     for sensor -->
	<xsl:template mode="sensorML" match="swe:field[@name='sensorStatus']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="value" select=".//swe:Text/swe:value"/>	

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'sensorStatus'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Text/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="'swe:field'"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'sensorStatus'"/>
				</xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="text">
				<xsl:choose>                    
					<xsl:when test="$edit=true()">
						<select class="md" name="_{.//swe:Text/swe:value/geonet:element/@ref}"
								size="1" title="{$tooltip}">
								<option name="" />

														<!-- FIXME -->
                            <xsl:for-each select="/root/gui/rdf:ecSensorStatus/rdf:Description/ns2:prefLabel">
                                <xsl:sort select="." order="ascending"/>

                                <option value="{.}">
                                    <xsl:if test=". = $value">
                                        <xsl:attribute name="selected"/>
                                    </xsl:if>
                                    <xsl:value-of select="."/>
                                </option>
                            </xsl:for-each>
							    
							</select>

					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="$value" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="swe:field[@name='observedBBOX']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

  
				<!-- swe:coordinate can both contain easting or longitude -->	
				<xsl:variable name="nEl">
				<xsl:choose>
                  <xsl:when test=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='latitude']">
					<xsl:value-of select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='latitude']"/>
				  </xsl:when>
                  <xsl:otherwise>
					<xsl:value-of select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']"/>
				  </xsl:otherwise>
                </xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="sEl">
				<xsl:choose>
                  <xsl:when test=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='latitude']">
					<xsl:value-of select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='latitude']"/>
				  </xsl:when>
                  <xsl:otherwise>
					<xsl:value-of select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']"/>
				  </xsl:otherwise>
                </xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="wEl">
				<xsl:choose>
                  <xsl:when test=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='longitude']">
					<xsl:value-of select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='longitude']"/>
				  </xsl:when>
                  <xsl:otherwise>
					<xsl:value-of select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']"/>
				  </xsl:otherwise>
                </xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="eEl">
				<xsl:choose>
                  <xsl:when test=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='longitude']">
					<xsl:value-of select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='longitude']"/>
				  </xsl:when>
                  <xsl:otherwise>
					<xsl:value-of select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']"/>
				  </xsl:otherwise>
                </xsl:choose>
				</xsl:variable>

  
  <!-- regions combobox -->
        <xsl:variable name="places">
          <!-- <xsl:if test="$edit=true() and /root/gui/regions/record">
            <xsl:variable name="ref" select="geonet:element/@ref"/>
            <xsl:variable name="keyword" select="string(.)"/>
            
            <xsl:variable name="selection" select="concat(gmd:westBoundLongitude/gco:Decimal,';',gmd:eastBoundLongitude/gco:Decimal,';',gmd:southBoundLatitude/gco:Decimal,';',gmd:northBoundLatitude/gco:Decimal)"/>
            <xsl:variable name="lang" select="/root/gui/language"/>
            
            <select name="place" size="1" onChange="javascript:setRegion('{gmd:westBoundLongitude/gco:Decimal/geonet:element/@ref}', '{gmd:eastBoundLongitude/gco:Decimal/geonet:element/@ref}', '{gmd:southBoundLatitude/gco:Decimal/geonet:element/@ref}', '{gmd:northBoundLatitude/gco:Decimal/geonet:element/@ref}', this.options[this.selectedIndex], {geonet:element/@ref}, '{../../gmd:description/gco:CharacterString/geonet:element/@ref}')" class="md">
              <option value=""/>
              <xsl:for-each select="/root/gui/regions/record">
                <xsl:sort select="label/child::*[name() = $lang]" order="ascending"/>
                
                <xsl:variable name="value" select="concat(west,',',east,',',south,',',north)"/>
                <option value="{$value}">
                  <xsl:if test="$value=$selection">
                    <xsl:attribute name="selected"/>
                  </xsl:if>
                  <xsl:value-of select="label/child::*[name() = $lang]"/>
                </option>
              </xsl:for-each>
            </select>
          </xsl:if> -->
        </xsl:variable>
        <xsl:choose>
					<xsl:when test="$edit">
						<xsl:call-template name="geoBoxGUISWE">
              <xsl:with-param name="schema" select="$schema"/>
              <xsl:with-param name="edit"   select="$edit"/>
              <xsl:with-param name="id"   select="'observedBBOX'"/>
              <xsl:with-param name="sEl" select="$sEl"/>
              <xsl:with-param name="nEl" select="$nEl"/>
              <xsl:with-param name="eEl" select="$eEl"/>
              <xsl:with-param name="wEl" select="$wEl"/>
              <xsl:with-param name="sValue" select="$sEl/swe:Quantity/swe:value/text()"/>
              <xsl:with-param name="nValue" select="$nEl/swe:Quantity/swe:value/text()"/>
              <xsl:with-param name="eValue" select="$eEl/swe:Quantity/swe:value/text()"/>
              <xsl:with-param name="wValue" select="$wEl/swe:Quantity/swe:value/text()"/>
				<!-- this one assumes easting/northing -->
              <xsl:with-param name="sId" select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']//swe:Quantity/swe:value/geonet:element/@ref"/>
              <xsl:with-param name="nId" select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']//swe:Quantity/swe:value/geonet:element/@ref"/>
              <xsl:with-param name="eId" select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']//swe:Quantity/swe:value/geonet:element/@ref"/>
              <xsl:with-param name="wId" select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']//swe:Quantity/swe:value/geonet:element/@ref"/>
              <xsl:with-param name="descId" select="'observedBBOX'"/>
              <xsl:with-param name="places" select="$places"/>
						</xsl:call-template>
					</xsl:when>
          <xsl:otherwise>
						<xsl:call-template name="geoBoxGUISWE">
           		<xsl:with-param name="schema" select="$schema"/>
           		<xsl:with-param name="edit"   select="$edit"/>
           		<xsl:with-param name="id"   select="'observedBBOX'"/>
           		<xsl:with-param name="sEl" select="$sEl"/>
           		<xsl:with-param name="nEl" select="$nEl"/>
           		<xsl:with-param name="eEl" select="$eEl"/>
           		<xsl:with-param name="wEl" select="$wEl"/>
           		<xsl:with-param name="sValue" select="$sEl/swe:Quantity/swe:value/text()"/>
           		<xsl:with-param name="nValue" select="$nEl/swe:Quantity/swe:value/text()"/>
           		<xsl:with-param name="eValue" select="$eEl/swe:Quantity/swe:value/text()"/>
           		<xsl:with-param name="wValue" select="$wEl/swe:Quantity/swe:value/text()"/>
           		<!-- this one assumes easting/northing -->
           		<xsl:with-param name="sId" select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing']//swe:Quantity/swe:value/geonet:element/@ref"/>
           		<xsl:with-param name="nId" select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing']//swe:Quantity/swe:value/geonet:element/@ref"/>
           		<xsl:with-param name="eId" select=".//swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting']//swe:Quantity/swe:value/geonet:element/@ref"/>
           		<xsl:with-param name="wId" select=".//swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting']//swe:Quantity/swe:value/geonet:element/@ref"/>
           		<xsl:with-param name="descId" select="'observedBBOX'"/>
           		<xsl:with-param name="places" select="$places"/>
       			</xsl:call-template>
					</xsl:otherwise>
   			</xsl:choose>
	</xsl:template>



	<xsl:template mode="sensorML" match="sml:position//swe:coordinate[@name='easting']" priority="20">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="concat(@name, '_', ../../../../@name)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="concat(@name, '_', ../../../../@name)"/>
				</xsl:call-template>
				
				<!-- Don't display as mandatory in sensor section -->
				<xsl:if test="$edit and not(contains(name(../../../../..), 'sml:Component'))">
					<sup><font size="-1" color="#FF0000">&#xA0;*</font></sup> 
			</xsl:if>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="sensorML" match="swe:lowerCorner//swe:coordinate[@name='easting']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="@name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'w'"/>
				</xsl:call-template>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="sensorML" match="swe:upperCorner//swe:coordinate[@name='easting']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="@name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'e'"/>
				</xsl:call-template>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="sensorML" match="sml:position//swe:coordinate[@name='northing']" priority="20">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
                <xsl:with-param name="id" select="concat(@name, '_', ../../../../@name)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="concat(@name, '_', ../../../../@name)"/>
				</xsl:call-template>

				<!-- Don't display as mandatory in sensor section -->
				<xsl:if test="$edit and not(contains(name(../../../../..), 'sml:Component'))">
					<sup><font size="-1" color="#FF0000">&#xA0;*</font></sup>
			</xsl:if>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="sensorML" match="swe:lowerCorner//swe:coordinate[@name='northing']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="@name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'s'"/>
				</xsl:call-template>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="sensorML" match="swe:upperCorner//swe:coordinate[@name='northing']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="@name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id" select="'n'"/>
				</xsl:call-template>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="sensorML" match="swe:coordinate[@name='altitude']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
                <xsl:with-param name="id" select="concat(@name, '_', ../../../../@name)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(.)"/>
					<xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="concat(@name, '_', ../../../../@name)"/>
				</xsl:call-template>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="sensorML" match="swe:Envelope[@name='altitude']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".//swe:Quantity/swe:value">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>

			<xsl:with-param name="title">
				Altitude
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="ResponsibleParty">
	<!--<xsl:template mode="sensorML" match="sml:ResponsibleParty" priority="10">-->
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="resp"/>
		
		<xsl:apply-templates mode="elementEP" select="$resp/sml:individualName|$resp/geonet:child[string(@name)='individualName']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$resp/sml:organizationName|$resp/geonet:child[string(@name)='organizationName']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$resp/sml:positionName|$resp/geonet:child[string(@name)='positionName']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:call-template name="contactInfo">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="info"   select="$resp/sml:contactInfo"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="contactInfo">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="info"/>
		
		<xsl:apply-templates mode="elementEP" select="$info/sml:phone/sml:voice|$info/geonet:child[string(@name)='voice']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:phone/sml:facsimile|$info/geonet:child[string(@name)='voice']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:address/sml:deliveryPoint|$info/geonet:child[string(@name)='deliveryPoint']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:address/sml:city|$info/geonet:child[string(@name)='city']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:address/sml:administrativeArea|$info/geonet:child[string(@name)='administrativeArea']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:address/sml:postalCode|$info/geonet:child[string(@name)='postalCode']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:address/sml:country|$info/geonet:child[string(@name)='country']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:address/sml:electronicMailAddress|$info/geonet:child[string(@name)='electronicMailAddress']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<!-- see template below
		<xsl:apply-templates mode="elementEP" select="$info/sml:onlineResource|$info/geonet:child[string(@name)='onlineResource']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
		-->

		<xsl:apply-templates mode="elementEP" select="$info/sml:hoursOfService|$info/geonet:child[string(@name)='hoursOfService']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>

		<xsl:apply-templates mode="elementEP" select="$info/sml:contactInstructions|$info/geonet:child[string(@name)='contactInstructions']">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="sml:onlineResource" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
					<xsl:with-param name="name"   select="'href'"/>
					<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="id" select="generate-id(.)"/>
		<xsl:variable name="nextBrother" select="following-sibling::sml:onlineResource"/>

		<xsl:variable name="addLink">
				<xsl:value-of select="concat('addSensorMLXmlFragment(',$apos,geonet:element/@parent,$apos,',',$apos,name(.),$apos,',',$apos,'OnlineResource',$apos,',',$apos,'buttons_',$id,$apos,');')"/>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select="@xlink:href">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="$edit"/>
			<xsl:with-param name="tooltip"    select="$tooltip"/>

			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="'href'"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:call-template>

				<xsl:if test="$edit and not($nextBrother)">
				&#160;<a id="add_{$id}" style="cursor:hand;cursor:pointer;" onclick="if (noDoubleClick()) {$addLink}" target="_blank"><img src="{/root/gui/url}/images/plus.gif" alt="{/root/gui/strings/add}" title="{/root/gui/strings/add}"/></a>
				</xsl:if>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ==================================================================== -->

	<!-- the following templates eat up things we don't care about -->

	<xsl:template mode="sensorML" match="swe:ObservableProperty" />
	
	<xsl:template mode="sensorML" match="@definition" priority="11" />
	
	<xsl:template mode="simpleElement" match="sml:SensorML/@*" priority="11" />
	<xsl:template mode="simpleElement" match="geonet:attribute" priority="11" />

	<!-- ==================================================================== -->

	<xsl:template mode="simpleElement" match="@*" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"   select="false()"/>
        <xsl:param name="id"     select="generate-id()"/>

		<xsl:param name="title">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:param name="text">
			<xsl:call-template name="getAttributeText">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="tooltip"   select="$tooltip"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>

        <xsl:variable name="validationLink">
            <xsl:variable name="ref" select="concat('#_',../geonet:element/@ref)"/>
            <xsl:call-template name="validationLink">
                <xsl:with-param name="ref" select="$ref"/>
            </xsl:call-template>
        </xsl:variable>

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:call-template name="editAttribute">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="tooltip"  select="$tooltip"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
                    <xsl:with-param name="id"       select="$id"/>
                    <xsl:with-param name="validationLink"       select="$validationLink"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="showSimpleElement">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="tooltip"  select="$tooltip"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT          -->
	<!-- =================================================================== -->

	<xsl:template name="sensorML-javascript"/>

	<!-- ==================================================================== -->

	<xsl:template name="getTitle-sensorML">
		<xsl:param name="name" />
		<xsl:param name="schema"/>
		<xsl:param name="id" select="''"/>

		<xsl:param name="context" select="name(parent::node())" />

        <xsl:variable name="fullContext">
            <xsl:call-template name="getXPath" />
        </xsl:variable>

        <xsl:variable name="tooltip">
           <!-- Name with context in current schema -->
            <xsl:variable name="schematitleWithContext"
                          select="string(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name=$name and (@context=$fullContext or @context=$context)]/label)"/>

            <!-- Name in current schema with id -->
            <xsl:variable name="schematitleWithId" select="string(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name=$name and not(@context) and @id=$id]/label)"/>

            <!-- Name in current schema with no id -->
            <xsl:variable name="schematitle" select="string(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name=$name and not(@context)]/label)"/>

						<xsl:message>Passed <xsl:value-of select="concat($name,' (id: ',$id,')')"/> Candidates: <xsl:value-of select="concat($schematitleWithContext,':',$schematitleWithId,':',$schematitle)"/></xsl:message>
            <xsl:choose>

                <xsl:when test="normalize-space($schematitleWithId)='' and
                				normalize-space($schematitle)='' and
                                normalize-space($schematitleWithContext)=''">
                    <xsl:value-of select="string(/root/gui/schemas/sensorML/labels/element[@name=$name][0]/label)"/>
                </xsl:when>
                <xsl:when test="normalize-space($schematitleWithContext)!=''">
                        <xsl:value-of select="normalize-space($schematitleWithContext)"/>
                </xsl:when>
                <xsl:when test="normalize-space($schematitleWithId)!=''">
                        <xsl:value-of select="normalize-space($schematitleWithId)"/>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="normalize-space($schematitle)"/>
                </xsl:otherwise>

            </xsl:choose>
        </xsl:variable>


        <xsl:choose>
            <xsl:when test="normalize-space($tooltip)!=''">
                <xsl:value-of select="$tooltip"/>
            </xsl:when>
            <xsl:otherwise>                
            </xsl:otherwise>
        </xsl:choose>
		
    </xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="getTooltipTitle-sensorML">
		<xsl:param name="name" />
		<xsl:param name="schema"/>
		<xsl:param name="id"></xsl:param>

		<xsl:param name="context" select="name(parent::node())" />

        <xsl:variable name="fullContext">
            <xsl:call-template name="getXPath" />
        </xsl:variable>

        <xsl:variable name="tooltip">
           <!-- Name with context in current schema -->
            <xsl:variable name="schematitleWithContext"
                          select="string(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name=$name and (@context=$fullContext or @context=$context)]/description)"/>

            <!-- Name in current schema -->
            <xsl:variable name="schematitleWithId" select="string(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name=$name and not(@context) and @id=$id]/description)"/>

            <xsl:variable name="schematitle" select="string(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name=$name and not(@context)]/description)"/>

            <xsl:choose>

                <xsl:when test="normalize-space($schematitleWithId)='' and
                				normalize-space($schematitle)='' and
                                normalize-space($schematitleWithContext)=''">
                    <xsl:value-of select="string(/root/gui/schemas/sensorML/labels/element[@name=$name][0]/description)"/>
                </xsl:when>
                <xsl:when test="normalize-space($schematitleWithContext)!=''">
                        <xsl:value-of select="normalize-space($schematitleWithContext)"/>
                </xsl:when>
                <xsl:when test="normalize-space($schematitleWithId)!=''">
                        <xsl:value-of select="normalize-space($schematitleWithId)"/>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="normalize-space($schematitle)"/>
                </xsl:otherwise>

            </xsl:choose>
        </xsl:variable>


        <xsl:choose>
            <xsl:when test="normalize-space($tooltip)!=''">
                <xsl:value-of select="$tooltip"/>
            </xsl:when>
            <xsl:otherwise>                
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>


	<!-- ==================================================================== -->
	<!-- default: in simple mode display only the xml  -->
	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="*|@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<!-- do not show empty elements in view mode -->

		<xsl:choose>
			<xsl:when test="$edit=true()">
				
				<!--element: <xsl:value-of select="name()" />-->

				<xsl:apply-templates mode="element" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="true()"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:variable name="empty">
					<xsl:apply-templates mode="sensorMLIsEmpty" select="."/>
				</xsl:variable>
			
				<xsl:if test="normalize-space($empty)!=''">
					<xsl:apply-templates mode="element" select=".">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="false()"/>
					</xsl:apply-templates>
				</xsl:if>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- ==================================================================== -->
	<!-- these elements should be boxed -->
	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="sml:System|sml:identification|sml:classification|sml:characteristics|sml:capabilities|sml:documentation|gml:location|sml:interfaces|sml:inputs|sml:outputs|sml:components">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ==================================================================== -->

	<!-- ================================================================= -->
	<!-- abstract -->
	<!-- ================================================================= -->

	<xsl:template mode="sensorML" match="//sml:System/gml:description" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="sensorMLString">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="rows"   select="10"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->

  <xsl:template name="sensorMLString">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="rows" select="1"/>
    <xsl:param name="cols" select="50"/>

    <xsl:variable name="title">
      <xsl:call-template name="getTitle">
        <xsl:with-param name="name"   select="name(.)"/>
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="helpLink">
      <xsl:call-template name="getHelpLink">
        <xsl:with-param name="name"   select="name(.)"/>
        <xsl:with-param name="schema" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="text">
       <xsl:call-template name="getElementText">
         <xsl:with-param name="edit"   select="$edit"/>
         <xsl:with-param name="schema" select="$schema"/>
         <xsl:with-param name="rows"   select="$rows"/>
         <xsl:with-param name="cols"   select="$cols"/>
       </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates mode="simpleElement" select=".">
      <xsl:with-param name="schema"   select="$schema"/>
      <xsl:with-param name="edit"     select="$edit"/>
      <xsl:with-param name="title"    select="$title"/>
      <xsl:with-param name="helpLink" select="$helpLink"/>
      <xsl:with-param name="text"     select="$text"/>
    </xsl:apply-templates>
  </xsl:template>
	
  <!-- ================================================================== -->
  <!-- gml:TimePeriod and gml:TimeInstant (format = %Y-%m-%dThh:mm:ss)	  -->
  <!-- ================================================================== -->

<!--
  <xsl:template mode="sensorML" match="gml:TimeInstant[gml:timePosition]" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:for-each select="gml:beginPosition|gml:endPosition|gml:timePosition">
    <xsl:choose>
      <xsl:when test="$edit=true()">
        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema"  select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
          <xsl:with-param name="text">
            <xsl:variable name="ref" select="geonet:element/@ref"/>

			<xsl:variable name="format">
				<xsl:text>%Y-%m-%d</xsl:text>
			</xsl:variable>

            <xsl:call-template name="calendar">
				<xsl:with-param name="ref" select="$ref"/>
				<xsl:with-param name="date" select="text()"/>
				<xsl:with-param name="format" select="$format"/>
			</xsl:call-template>

          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema"  select="$schema"/>
          <xsl:with-param name="text">
            <xsl:value-of select="text()"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:for-each>
  </xsl:template>
	-->

	<!-- ================================================================= -->
	<!-- === sensorML CHOICE_ELEMENT handling === -->
	<!-- ================================================================= -->

  <xsl:template mode="sensorML" match="*[contains(name(),'CHOICE_ELEMENT')]|*[contains(name(),'GROUP_ELEMENT')]|*[contains(name(),'SEQUENCE_ELEMENT')]|sml:member|sml:Term|sml:KeywordList|sml:ClassifierList|swe:Text" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="contact"/>
	
		<xsl:variable name="nongeonet" select="*[not(starts-with(string(name(.)),'geonet'))]"/>
		<xsl:choose>
			<xsl:when test="$nongeonet">
				<xsl:for-each select="*[not(starts-with(name(.),'geonet'))]">
					<xsl:apply-templates mode="elementEP" select=".">
						<xsl:with-param name="schema"  select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="contact"   select="$contact"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Avoid boxing of these elements -->
	<xsl:template mode="elementEP" match="sml:contactInfo|sml:phone|sml:address|sml:keywords|swe:Vector">
		<xsl:param name="schema"/>
    	<xsl:param name="edit"/>
		<xsl:param name="contact"/>

    	<xsl:apply-templates mode="elementEP" select="*">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="contact" select="$contact"/>
		</xsl:apply-templates>
			
	</xsl:template>


	<!--<xsl:template mode="elementEP" match="sml:keywords">
		<xsl:param name="schema"/>
    	<xsl:param name="edit"/>-->

		<!--<xsl:call-template name="complexElementGuiWrapper">

			<xsl:with-param name="title">
				<xsl:value-of select="'Keywords'"/>
			</xsl:with-param>

			<xsl:with-param name="content">-->

		    	<!--<xsl:apply-templates mode="elementEP" select="*">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit" select="$edit"/>

				</xsl:apply-templates>-->
			<!--</xsl:with-param>
		</xsl:call-template>-->

	<!--</xsl:template>-->

	<!-- ================================================================= -->
	<!-- === sensorML brief formatting === -->
	<!-- ================================================================= -->

	<xsl:template name="sensorMLBrief">
		<xsl:variable name="id" select="geonet:info/id"/>
			
		<xsl:variable name="title" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteFullName']/sml:Term/sml:value" />

		<metadata>
			<title><xsl:value-of select="$title"/></title>
			
			<xsl:for-each select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='siteOnlineResource']">
				<xsl:if test="sml:Document/sml:onlineResource/@xlink:href != ''">
					<link type="download">
						<xsl:attribute name="title" select="sml:Document/gml:description"/>
						<xsl:attribute name="href" select="sml:Document/sml:onlineResource/@xlink:href"/>
					</link>
				</xsl:if>
			</xsl:for-each>
			
			<xsl:for-each select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword[text()]">
				<keyword><xsl:value-of select="."/></keyword>
			</xsl:for-each>

			
			<xsl:for-each select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']/swe:Text/swe:value">
				<status><xsl:value-of select="."/></status>
			</xsl:for-each>

			<xsl:for-each select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier[@name='siteType']/sml:Term/sml:value">
				<category><xsl:value-of select="."/></category>
			</xsl:for-each>

			<xsl:for-each select="sml:member/sml:System/sml:inputs/sml:InputList/sml:input">
				<observedphenomenum><xsl:value-of select="@name"/></observedphenomenum>
			</xsl:for-each>

			<xsl:for-each select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='relatedDataset-GeoNetworkUUID']">
				<dataset><xsl:value-of select="@xlink:href"/></dataset>
			</xsl:for-each>


       <xsl:for-each select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='thumbnail']/sml:Document">
					<xsl:variable name="fileName"  select="sml:onlineResource/@xlink:href"/>
                <xsl:if test="$fileName != ''">
                    <xsl:choose>
                        <xsl:when test="contains($fileName ,'://')">
                            <image type="unknown"><xsl:value-of select="$fileName"/></image>
                        </xsl:when>
                        <xsl:otherwise>
                            <image type="thumbnail">
                                <xsl:value-of select="concat(/root/gui/locService,'/resources.get?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"/>
                            </image>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>

			<xsl:copy-of select="geonet:info"/>
		</metadata>
	</xsl:template>	
	
	<!-- =============================================================== -->
	<!-- utilities -->
	<!-- =============================================================== -->
	
	<xsl:template mode="sensorMLIsEmpty" match="*|@*">
		<xsl:choose>
			<!-- normal element -->
			<xsl:when test="*">
				<xsl:apply-templates mode="sensorMLIsEmpty"/>
			</xsl:when>
			<!-- text element -->
			<xsl:when test="string-length(.)!=0">txt</xsl:when>
			<!-- empty element -->
			<xsl:otherwise>
				<!-- codelist? -->
				<xsl:if test="@codeList">
					<xsl:if test="@codeListValue!=''">cdl</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="simpleElementTextArea" match="*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"   select="false()"/>
		<xsl:param name="rows" select="'10'" />

		<xsl:param name="title">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="tooltip">
			<xsl:call-template name="getTooltipTitle-sensorML">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:param name="text">
			<xsl:call-template name="getElementText">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="tooltip"   select="$tooltip"/>
				<xsl:with-param name="rows" select="$rows"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:param>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:call-template name="editSimpleElement">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="tooltip"  select="$tooltip"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>					
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="showSimpleElement">
					<xsl:with-param name="schema"   select="$schema"/>
					<xsl:with-param name="title"    select="$title"/>
					<xsl:with-param name="tooltip"  select="$tooltip"/>
					<xsl:with-param name="text"     select="$text"/>
					<xsl:with-param name="helpLink" select="$helpLink"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="output-tokens">
	    <xsl:param name="list" />
	    <xsl:param name="delimiter" />
	    <xsl:param name="value" />

	    <xsl:variable name="newlist">
			<xsl:choose>
				<xsl:when test="contains($list, $delimiter)"><xsl:value-of select="normalize-space($list)" /></xsl:when>
				
				<xsl:otherwise><xsl:value-of select="concat(normalize-space($list), $delimiter)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	    <xsl:variable name="first" select="substring-before($newlist, $delimiter)" />
	    <xsl:variable name="remaining" select="substring-after($newlist, $delimiter)" />
	    
		<option value="{$first}">
			<xsl:if test="$value = $first">
				<xsl:attribute name="selected"/>
			</xsl:if>
	    	<xsl:value-of select="$first" />
	   	</option>

	    <xsl:if test="$remaining">
	        <xsl:call-template name="output-tokens">
	            <xsl:with-param name="list" select="$remaining" />
				<xsl:with-param name="delimiter"><xsl:value-of select="$delimiter"/></xsl:with-param>
				<xsl:with-param name="value"><xsl:value-of select="$value"/></xsl:with-param>
	        </xsl:call-template>
	    </xsl:if>
	</xsl:template>



	<!-- Display the extent widget composed of
	* 4 input text fields with bounds coordinates
	* a coordinate system switcher. Coordinates are stored in WGS84 but could be displayed 
	or editied in antother projection. 
	* copied (and renamed) from geoBoxGUI in metadata.xsl - that one only seems to works for iso19139)
	-->
	<xsl:template name="geoBoxGUISWE">
	<xsl:param name="schema"/>
	<xsl:param name="edit"/>
	<xsl:param name="nEl"/>
	<xsl:param name="nId"/>
	<xsl:param name="nValue"/>
	<xsl:param name="sEl"/>
	<xsl:param name="sId"/>
	<xsl:param name="sValue"/>
	<xsl:param name="wEl"/>
	<xsl:param name="wId"/>
	<xsl:param name="wValue"/>
	<xsl:param name="eEl"/>
	<xsl:param name="eId"/>
	<xsl:param name="eValue"/>
	<xsl:param name="descId"/>
	<xsl:param name="id"/>


	<xsl:variable name="eltRef">
	  <!--<xsl:choose>
	    <xsl:when test="$edit=true()">
	      <xsl:value-of select="$id"/>
	    </xsl:when>
	    <xsl:otherwise>-->
	      <xsl:value-of select="generate-id(.)"/>
	    <!--</xsl:otherwise>
	  </xsl:choose>-->
	</xsl:variable>

	    <tr>
	      <td colspan="3">
	        <!-- Loop on all projections defined in config-gui.xml -->
	        <xsl:for-each select="/root/gui/config/map/proj/crs">
	          <!-- Set label from loc file -->
	          <label for="{@code}_{$eltRef}">
	            <xsl:variable name="code" select="@code"/>
	            <xsl:choose>
	              <xsl:when test="/root/gui/strings/*[@code=$code]">
	                <xsl:value-of select="/root/gui/strings/*[@code=$code]"/>
	              </xsl:when>
	              <xsl:otherwise>
	                <xsl:value-of select="@code"/>
	              </xsl:otherwise>
	            </xsl:choose>
	            <input id="{@code}_{$eltRef}" class="proj" type="radio" name="proj_{$eltRef}"
	              value="{@code}">
	              <xsl:if test="@default='1'">
	                <xsl:attribute name="checked">checked</xsl:attribute>
	              </xsl:if>
	            </input>
	          </label>
	        </xsl:for-each>

	      </td>
	    </tr>

	      <tr>
	        <td colspan="3" align="center">
                <input type="hidden" id="{concat('_',$nId)}" name="{concat('_',$nId)}" value="{$nEl/text()}"/>
			  <xsl:choose>
	              <xsl:when test="$edit">
                      <xsl:variable name="tooltip-north">
                          <xsl:call-template name="getTooltipTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('n_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="title-north">
                          <xsl:call-template name="getTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('n_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
					<label for="{$nId}" title="{$tooltip-north}"><xsl:value-of select="$title-north"/></label>
	                <input type="text" class="md" title="{$tooltip-north}" id="{$nId}" value="{$nEl/text()}"/>
	              </xsl:when>
	              <xsl:otherwise>
	                <xsl:value-of select="$nEl/text()"/>
	              </xsl:otherwise>
	            </xsl:choose>
			  
	        </td>
	      </tr>

	    <tr>

	        <td  style="vertical-align:middle">
              <input type="hidden" id="{concat('_',$wId)}" name="{concat('_',$wId)}"  value="{$wEl/text()}"/>
	         <xsl:choose>
	              <xsl:when test="$edit">
                      <xsl:variable name="tooltip-west">
                          <xsl:call-template name="getTooltipTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('w_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="title-west">
                          <xsl:call-template name="getTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('w_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
					<label for="{$wId}" title="{$tooltip-west}"><xsl:value-of select="$title-west"/></label><br/>
	                <input type="text" class="md" title="{$tooltip-west}" id="{$wId}" value="{$wEl/text()}"/>
	              </xsl:when>
	              <xsl:otherwise>
	                <xsl:value-of select="$wEl/text()"/>
	              </xsl:otherwise>
	            </xsl:choose>
	        </td>

	      <td >
	        <xsl:variable name="wID">
	          <xsl:choose>
	            <xsl:when test="$edit=true()">
	              <xsl:value-of select="$wId"/>
	            </xsl:when>
	            <xsl:otherwise>w<xsl:value-of select="$eltRef"/></xsl:otherwise>
	          </xsl:choose>
	        </xsl:variable>

	        <xsl:variable name="eID">
	          <xsl:choose>
	            <xsl:when test="$edit=true()">
	              <xsl:value-of select="$eId"/>
	            </xsl:when>
	            <xsl:otherwise>e<xsl:value-of select="$eltRef"/></xsl:otherwise>
	          </xsl:choose>
	        </xsl:variable>

	        <xsl:variable name="nID">
	          <xsl:choose>
	            <xsl:when test="$edit=true()">
	              <xsl:value-of select="$nId"/>
	            </xsl:when>
	            <xsl:otherwise>n<xsl:value-of select="$eltRef"/></xsl:otherwise>
	          </xsl:choose>
	        </xsl:variable>

	        <xsl:variable name="sID">
	          <xsl:choose>
	            <xsl:when test="$edit=true()">
	              <xsl:value-of select="$sId"/>
	            </xsl:when>
	            <xsl:otherwise>s<xsl:value-of select="$eltRef"/></xsl:otherwise>
	          </xsl:choose>
	        </xsl:variable>

			<xsl:variable name="geom">
				<xsl:choose>
				<xsl:when test="$wEl/text()+$eEl/text()=0">
					<!-- default extent Canada -->
					<!--<xsl:value-of select="concat('Polygon((', -141.00300, ' ', 41.67550,',',-52.61740,' ',41.67550,',',-52.61740,' ',83.11390,',',-141.00300,' ',83.11390,',',-141.00300,' ',41.67550, '))')"/>-->

					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('Polygon((', $wEl/text(), ' ', $sEl/text(),',',$eEl/text(),' ',$sEl/text(),',',$eEl/text(),' ',$nEl/text(),',',$wEl/text(),' ',$nEl/text(),',',$wEl/text(),' ',$sEl/text(), '))')"/>
				</xsl:otherwise>
				</xsl:choose>
            </xsl:variable>
	        
	        <xsl:call-template name="showMap">
	          <xsl:with-param name="edit" select="$edit"/>
	          <xsl:with-param name="mode" select="'bbox'"/>
	          <xsl:with-param name="coords" select="$geom"/>
	          <xsl:with-param name="watchedBbox" select="concat($wId, ',', $sId, ',', $eId, ',', $nId)"/>
	          <xsl:with-param name="eltRef" select="$eltRef"/>
	          <xsl:with-param name="descRef" select="$descId"/>
			  <xsl:with-param name="width" select="'400px'"/>
	        </xsl:call-template>
	      </td>
	     
	        <td  style="vertical-align:middle">
                <input type="hidden" id="{concat('_',$eId)}" name="{concat('_',$eId)}" value="{$eEl/text()}"/>
	          <xsl:choose>
	              <xsl:when test="$edit">
                      <xsl:variable name="tooltip-east">
                          <xsl:call-template name="getTooltipTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('e_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="title-east">
                          <xsl:call-template name="getTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('e_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
				    <label for="{$eId}" title="{$tooltip-east}"><xsl:value-of select="$title-east"/></label><br/>
	                <input type="text" class="md" title="${$tooltip-east}"  id="{$eId}" value="{$eEl/text()}"/>

	              </xsl:when>
	              <xsl:otherwise>
	                <xsl:value-of select="$eEl/text()"/>
	              </xsl:otherwise>
	            </xsl:choose>
	        </td>
	     
	    </tr>
	 
	      <tr>
	        <td colspan="3" align="center">
                <input type="hidden" id="{concat('_',$sId)}" name="{concat('_',$sId)}"  value="{$sEl/text()}"/>
	          <xsl:choose>
	              <xsl:when test="$edit">
                      <xsl:variable name="tooltip-south">
                          <xsl:call-template name="getTooltipTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('s_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="title-south">
                          <xsl:call-template name="getTitle-sensorML">
                              <xsl:with-param name="name"   select="'swe:coordinate'"/>
                              <xsl:with-param name="schema" select="$schema"/>
                              <xsl:with-param name="id" select="concat('s_', name(../../../../..))"/>
                          </xsl:call-template>
                      </xsl:variable>
					<label for="{$sId}" title="{$tooltip-south}"><xsl:value-of select="$title-south"/></label>
	                <input type="text" class="md" title="{$tooltip-south}" id="{$sId}" value="{$sEl/text()}"/>
	              </xsl:when>
	              <xsl:otherwise>
	                <xsl:value-of select="$sEl/text()"/>
	              </xsl:otherwise>
	            </xsl:choose>
	        </td>
	      </tr>

	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template name="sensorML-relatedResources">
		<xsl:param name="edit"/>

		<xsl:variable name="metadata" select="/root/ecMonitoringSite"/>
		<xsl:if test="geonet:info/schema = 'sensorML'">

			<xsl:variable name="uuid" select="$metadata/geonet:info/uuid"/>
			
			
			<!-- Related elements -->			
			<xsl:variable name="relatedDatasetsForSensorMLRecords" select="/root/gui/relation/sensorMLDataset/response/*[geonet:info]"/> <!-- Usually feature catalogues -->


            <!-- <xsl:variable name="relatedRecords" select="/root/gui/relation/fcats/response/*[geonet:info]"/> -->
	
			<xsl:if test="$relatedDatasetsForSensorMLRecords or $edit">

		        <div class="relatedElements">
					<!-- Related datasets for sensorML -->
					<xsl:if test="($relatedDatasetsForSensorMLRecords or $edit) and geonet:info/schema = 'sensorML'">
							<h3><xsl:value-of select="/root/gui/strings/Relateddata"/></h3>
							
								<xsl:for-each select="$relatedDatasetsForSensorMLRecords">
									<img src="{/root/gui/url}/images/database.png"  title="{/root/gui/strings/associateService}" align="absmiddle" alt="{/root/gui/strings/dataset}"/>
								<a class="arrow" href="metadata.show?uuid={geonet:info/uuid}">
										<xsl:call-template name="getMetadataTitle">
											<xsl:with-param name="uuid" select="geonet:info/uuid"/>
										</xsl:call-template>
									</a><br/>
								</xsl:for-each>
							
					</xsl:if>
				</div>
			</xsl:if>

		</xsl:if>

	</xsl:template>

	<!-- ==================================================================== -->

  <xsl:template mode="sensorML" match="@geonet:addedObj " priority="2" />

	<!-- ==================================================================== -->
	<!-- Functions -->
	<!-- ==================================================================== -->

	<!-- return separator character used in thesaurus URI -->
	<xsl:function name="geonet:getSeparatorChar" as="xs:string">
		<xsl:param name="uriString"/>
		<xsl:choose>
			<xsl:when test="contains($uriString,'/')">
				<xsl:value-of select="'/'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="':'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- get options from Thesaurus -->
	<xsl:function name="geonet:getOptionsFromThesaurus">
		<xsl:param name="thesaurusName"/>

		<xsl:variable name="theUrl" select="$thesaurusList/response/thesauri/thesaurus[key=$thesaurusName]/url"/>
		<xsl:variable name="thesaurus" select="document($theUrl)"/>

		<xsl:for-each select="$thesaurus/rdf:RDF/skos:Concept[not(skos:narrower)]">
			<xsl:sequence select="concat(skos:prefLabel[xml:lang='en']|skos:prefLabel,'==',@rdf:about)"/>
		</xsl:for-each>
	</xsl:function>
</xsl:stylesheet>
