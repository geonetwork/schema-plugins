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

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="view-with-header-sensorML">
		<xsl:param name="tabs"/>

    <xsl:call-template name="md-content">
      <xsl:with-param name="title" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='siteFullName']/sml:Term/sml:value"/>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract" select="sml:member/sml:System/gml:description"/>
      <xsl:with-param name="logo">
        <img src="../../images/logos/{//geonet:info/source}.gif" alt="logo"/>
      </xsl:with-param>
      <xsl:with-param name="relatedResources">
        <xsl:apply-templates mode="relatedResources" select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='relatedDataset-GeoNetworkUUID']/sml:Document/sml:onlineResource/@xlink:href"/>
      </xsl:with-param>
      <xsl:with-param name="tabs" select="$tabs"/>
		</xsl:call-template>

	</xsl:template>

	<!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->

  <xsl:template name="metadata-sensorMLview-simple" match="metadata-sensorMLview-simple">
		<xsl:call-template name="view-with-header-sensorML">
			<xsl:with-param name="tabs">

			<xsl:call-template name="complexElementSimpleGui">
				<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/siteIdentification"/>
				<xsl:with-param name="content">

				<!-- Blank section with general site info -->
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="''"/>
					<xsl:with-param name="content">

						<!-- Metadata identifier -->
     				<xsl:apply-templates mode="simpleElement-sensorML" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name=$ogcID]">
							<xsl:with-param name="id" select="'GeoNetwork-UUID'"/>
						</xsl:apply-templates>
   		 
						<!-- Effective date -->
      			<xsl:apply-templates mode="simpleElement-sensorML" select="sml:member/sml:System/sml:validTime/gml:TimeInstant/gml:timePosition"/>
		
						<!-- Abstract -->
     				<xsl:apply-templates mode="simpleElement-sensorML" select="sml:member/sml:System/gml:description">
							<xsl:with-param name="id"     select="'abstract'"/>
						</xsl:apply-templates>
	
						<!-- Site Status -->
     				<xsl:apply-templates mode="simpleElement-sensorML"
      				select="sml:member/sml:System//sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']">
							<xsl:with-param name="id"     select="'siteStatus'"/>
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:call-template>

				<!-- Contact Information -->
				<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:contact/sml:ContactList/sml:member/sml:ResponsibleParty|sml:member/sml:System/sml:contact/sml:ResponsibleParty"/>

				<!-- InputList -->
				<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:inputs/sml:InputList"/>
	
				<!-- Point location of sensor site -->
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/pointLocation"/>
					<xsl:with-param name="content">
	
						<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:position/swe:Position">
							<xsl:with-param name="suffix" select="'site'"/>
						</xsl:apply-templates>
					</xsl:with-param>
 				</xsl:call-template> 

				<!-- Observed bounding box of site -->
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/observationBoundingBox"/>
					<xsl:with-param name="content">
	
						<xsl:apply-templates mode="sensorML" select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit" select="false()"/>
						</xsl:apply-templates>
	
					</xsl:with-param>
 				</xsl:call-template> 
	
				<!-- Event History of site -->
				<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:history/sml:EventList/sml:member/sml:Event"/>
	
				<!-- Documents relating to/about site -->
				<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member/sml:Document"/>

				<!-- IdentifierList -->
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/identifiers"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name!='GeoNetwork-UUID' and @name!=$ogcID]"/>
					</xsl:with-param>
 				</xsl:call-template> 

				<!-- ClassifierList -->
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/classifiers"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:classification/sml:ClassifierList/sml:classifier"/>
					</xsl:with-param>
 				</xsl:call-template> 
	
				<!-- Keywords -->
				<xsl:call-template name="complexElementSimpleGui">
					<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/keywords"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword"/>
					</xsl:with-param>
 				</xsl:call-template> 

				<!-- Component sensors deployed at this site -->
				<xsl:apply-templates mode="block-sensorML" select="sml:member/sml:System/sml:components/sml:ComponentList/sml:component/sml:Component"/>
	
				</xsl:with-param>
   		</xsl:call-template> <!-- Site Identification -->

			<span class="madeBy">
        <xsl:value-of select="concat(/root/gui/strings/changeDate,' ')"/>
        <xsl:choose>
          <xsl:when test="normalize-space(geonet:info/changeDate)!=''">
            <xsl:value-of select="geonet:info/changeDate"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Unknown</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </span>
		</xsl:with-param>
    </xsl:call-template> <!-- view-with-header-sensorML -->
  </xsl:template>

	<!-- =================================================================== -->
	
	<xsl:template name="bboxId">
		<xsl:param name="suffix"/>

		<xsl:choose>
			<xsl:when test="(@name='easting' or @name='longitude') and ancestor::swe:lowerCorner">
				<xsl:value-of select="concat('w_',$suffix)"/>
			</xsl:when>
			<xsl:when test="(@name='northing' or @name='latitude') and ancestor::swe:lowerCorner">
				<xsl:value-of select="concat('s_',$suffix)"/>
			</xsl:when>
			<xsl:when test="(@name='easting' or @name='longitude') and ancestor::swe:upperCorner">
				<xsl:value-of select="concat('e_',$suffix)"/>
			</xsl:when>
			<xsl:when test="(@name='northing' or @name='latitude') and ancestor::swe:upperCorner">
				<xsl:value-of select="concat('n_',$suffix)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template name="handleTerm">

    <xsl:apply-templates mode="simpleElement-sensorML" select="sml:Term/sml:value">
			<xsl:with-param name="name"   select="name()"/>
			<xsl:with-param name="id"     select="@name"/>
			<xsl:with-param name="content">
				<xsl:value-of select="sml:Term/sml:value"/><xsl:text>&#10;</xsl:text>
				<xsl:if test="normalize-space(sml:Term/@definition)!='' and normalize-space(sml:Term/sml:codeSpace/@xlink:href)!=''">
     			<xsl:value-of select="concat(/root/gui/schemas/sensorML/strings/term,': ',sml:Term/@definition)"/><xsl:text>&#10;</xsl:text>
     			<xsl:value-of select="concat(/root/gui/schemas/sensorML/strings/thesaurus,': ',sml:Term/sml:codeSpace/@xlink:href)"/><xsl:text>&#10;</xsl:text>
   			</xsl:if> 
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template name="handleObservableProperty">

    <xsl:apply-templates mode="simpleElement-sensorML" select="swe:ObservableProperty">
			<xsl:with-param name="name"   select="name()"/>
			<xsl:with-param name="id"     select="'observedPhenomenon'"/>
			<xsl:with-param name="content">
				<xsl:value-of select="@name"/><xsl:text>&#10;</xsl:text>
				<xsl:if test="normalize-space(swe:ObservableProperty/@definition)!='' and normalize-space(@xlink:href)!=''">
     			<xsl:value-of select="concat(/root/gui/schemas/sensorML/strings/term,': ',swe:ObservableProperty/@definition)"/><xsl:text>&#10;</xsl:text>
     			<xsl:value-of select="concat(/root/gui/schemas/sensorML/strings/thesaurus,': ',@xlink:href)"/><xsl:text>&#10;</xsl:text>
   			</xsl:if> 
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================================================================== -->

	<!-- template to help with putting in simpleElements from sensorML -->
  <xsl:template mode="simpleElement-sensorML" match="*|@*">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="id"/>
		<xsl:param name="content" select="normalize-space(string())"/>

		<xsl:message>Doing <xsl:value-of select="name()"/> ID: <xsl:value-of select="$id"/></xsl:message>

		<xsl:call-template name="simpleElementSimpleGUI">
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
			 		<xsl:with-param name="name"   select="$name"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="$id"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="helpLink">
        <xsl:call-template name="getHelpLink-sensorML">
          <xsl:with-param name="name"   select="$name"/>
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="id"     select="$id"/>
        </xsl:call-template>
      </xsl:with-param>
			<xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:InputList">

		<xsl:call-template name="complexElementSimpleGui">
			<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/inputs"/>
			<xsl:with-param name="content">
				<xsl:for-each select="sml:input">
					<xsl:call-template name="handleObservableProperty">
					</xsl:call-template>
				</xsl:for-each>
			</xsl:with-param>
   	</xsl:call-template> 
	</xsl:template> 

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:ResponsibleParty">

		<xsl:call-template name="complexElementSimpleGui">
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="'sml:contact'"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">

     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:individualName">
				</xsl:apply-templates>

     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:organizationName">
				</xsl:apply-templates>

     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:positionName">
				</xsl:apply-templates>

     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:phone/sml:voice">
				</xsl:apply-templates>

     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:phone/sml:facsimile">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:address/sml:deliveryPoint">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:address/sml:city">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:address/sml:administrativeArea">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:address/sml:postalCode">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:address/sml:country">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:contactInfo/sml:address/sml:electronicMailAddress">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
						select="sml:contactInfo/sml:onlineResource/@xlink:href">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
						select="sml:contactInfo/sml:hoursOfService">
				</xsl:apply-templates>

 				<xsl:apply-templates mode="simpleElement-sensorML"
						select="sml:contactInfo/sml:contactInstructions">
				</xsl:apply-templates>

			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="swe:Position">
		<xsl:param name="suffix"/>
		
   	<xsl:apply-templates mode="simpleElement-sensorML"
    			select="@referenceFrame">
		</xsl:apply-templates>

   	<xsl:for-each	select="swe:location/swe:Vector/swe:coordinate">
   		<xsl:apply-templates mode="simpleElement-sensorML"
      				select="swe:Quantity/swe:value">
				<xsl:with-param name="name"   select="name()"/>
				<xsl:with-param name="id"     select="concat(@name,'_',$suffix)"/>
			</xsl:apply-templates>
		</xsl:for-each>

	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="swe:coordinate">
		<xsl:param name="suffix"/>
		
   	<xsl:apply-templates mode="simpleElement-sensorML" select="swe:Quantity/swe:value">
			<xsl:with-param name="name"   select="name()"/>
			<xsl:with-param name="id">
				<xsl:call-template name="bboxId">
					<xsl:with-param name="suffix" select="$suffix"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:Event">

		<xsl:call-template name="complexElementSimpleGui">
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(..)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="context" select="name(../..)"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<!-- event date in sml:date -->
   			<xsl:apply-templates mode="simpleElement-sensorML"
						select="sml:date">
				</xsl:apply-templates>

				<!-- event description in gml:description -->
     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="gml:description">
				</xsl:apply-templates>

				<!-- event classifiers in sml:classification -->
				<!-- FIXME: apply-templates using sml:classifier -->
				<xsl:for-each select="sml:classification/sml:ClassifierList/sml:classifier">
					<xsl:call-template name="handleTerm">
					</xsl:call-template>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:Component">

		<xsl:call-template name="complexElementSimpleGui">
			<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/component"/>
			<xsl:with-param name="content">

				<xsl:variable name="link" select="normalize-space(../@xlink:href)"/>
				<xsl:choose>
					<xsl:when test="$link!=''">
   					<xsl:apply-templates mode="simpleElement-sensorML" select="../@xlink:href">
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>

						<!-- Sensor Info -->
						<xsl:call-template name="complexElementSimpleGui">
							<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/sensorInfo"/>
							<xsl:with-param name="content">
								<!-- Sensor Description -->
     						<xsl:apply-templates mode="simpleElement-sensorML" select="gml:description">
								</xsl:apply-templates>

								<!-- Sensor Status -->
     						<xsl:apply-templates mode="simpleElement-sensorML"
      						select="sml:capabilities/swe:DataRecord/swe:field[@name='sensorStatus']/swe:Text/swe:value">
									<xsl:with-param name="name"   select="'swe:field'"/>
									<xsl:with-param name="id"     select="'sensorStatus'"/>
								</xsl:apply-templates>
							</xsl:with-param>
   					</xsl:call-template> 

						<!-- IdentifierList -->
						<xsl:call-template name="complexElementSimpleGui">
							<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/identifiers"/>
							<xsl:with-param name="content">
								<xsl:apply-templates mode="block-sensorML" select="sml:identification/sml:IdentifierList/sml:identifier">
								</xsl:apply-templates>
							</xsl:with-param>
   					</xsl:call-template> 

						<!-- ClassifierList -->
						<xsl:call-template name="complexElementSimpleGui">
							<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/classifiers"/>
							<xsl:with-param name="content">
								<xsl:apply-templates mode="block-sensorML" select="sml:classification/sml:ClassifierList/sml:classifier">
								</xsl:apply-templates>
							</xsl:with-param>
   					</xsl:call-template> 

						<!-- Keywords -->
						<xsl:call-template name="complexElementSimpleGui">
							<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/keywords"/>
							<xsl:with-param name="content">
								<xsl:apply-templates mode="block-sensorML" select="sml:keywords/sml:KeywordList/sml:keyword">
								</xsl:apply-templates>
							</xsl:with-param>
   					</xsl:call-template> 

						<!-- Point location of sensor -->
						<xsl:call-template name="complexElementSimpleGui">
							<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/pointLocation"/>
							<xsl:with-param name="content">
			
								<xsl:apply-templates mode="block-sensorML" select="sml:position/swe:Position">
									<xsl:with-param name="suffix" select="'sensor'"/>
								</xsl:apply-templates>
							</xsl:with-param>
   					</xsl:call-template> 

						<!-- Observed bounding box of sensor -->
						<xsl:call-template name="complexElementSimpleGui">
							<xsl:with-param name="title" select="/root/gui/schemas/sensorML/strings/observationBoundingBox"/>
							<xsl:with-param name="content">
			
								<xsl:apply-templates mode="sensorML" select="sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']">
									<xsl:with-param name="schema" select="$schema"/>
									<xsl:with-param name="edit" select="false()"/>
								</xsl:apply-templates>

							</xsl:with-param>
   					</xsl:call-template> 

					</xsl:otherwise>
				</xsl:choose>

			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template	mode="block-sensorML" match="sml:Document">

		<xsl:call-template name="complexElementSimpleGui">
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name(..)"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="../@name"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<!-- related document -->
     		<xsl:apply-templates mode="simpleElement-sensorML"
							select="sml:onlineResource/@xlink:href">
					<xsl:with-param name="content">
						<xsl:variable name="value" select="normalize-space(sml:onlineResource/@xlink:href)"/>
						<xsl:choose>
							<xsl:when test="$value!='' and @name='relatedDataset-GeoNetworkUUID'">
								<xsl:value-of select="concat($url,'/',$value)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$value"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>

				<!-- document description in gml:description -->
     		<xsl:apply-templates mode="simpleElement-sensorML"
						select="gml:description">
				</xsl:apply-templates>

				<!-- document format in sml:format -->
     		<xsl:apply-templates mode="simpleElement-sensorML"
						select="sml:format">
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:identifier[@name!='GeoNetwork-UUID' and @name!=$ogcID]">

		<xsl:call-template name="handleTerm">
		</xsl:call-template>
	</xsl:template> 
	
	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:classifier">

		<xsl:call-template name="handleTerm">
		</xsl:call-template>
	</xsl:template>

	<!-- =================================================================== -->

	<xsl:template mode="block-sensorML" match="sml:keyword">

 		<xsl:apply-templates mode="simpleElement-sensorML" select=".">
			<xsl:with-param name="id" select="'siteKeyword'"/>
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
