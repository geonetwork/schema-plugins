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

		<xsl:call-template name="blockElementFop">
			<xsl:with-param name="label" select="/root/gui/schemas/sensorML/strings/siteIdentification"/>
			<xsl:with-param name="block">

			<!-- Metadata identifier -->
     	<xsl:apply-templates mode="simpleElementFop-sensorML" select="sml:member/sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='GeoNetwork-UUID' or @name=$ogcID]">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="id" select="'GeoNetwork-UUID'"/>
			</xsl:apply-templates>
   	 
			<!-- Effective date -->
      <xsl:apply-templates mode="simpleElementFop" select="sml:member/sml:System/sml:validTime/gml:TimeInstant/gml:timePosition">
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:apply-templates>
	
			<!-- Abstract -->
     	<xsl:apply-templates mode="simpleElementFop-sensorML"
      		select="sml:member/sml:System/gml:description">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="id"     select="'abstract'"/>
			</xsl:apply-templates>

			<!-- Site Status -->
     	<xsl:apply-templates mode="simpleElementFop-sensorML"
      	select="sml:member/sml:System//sml:capabilities/swe:DataRecord/swe:field[@name='siteStatus']">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="id"     select="'siteStatus'"/>
			</xsl:apply-templates>

			<!-- IdentifierList -->
			<xsl:for-each select="sml:member/sml:System/sml:identification/sml:IdentifierList">
				<xsl:call-template name="blockElementFop">
					<xsl:with-param name="label" select="/root/gui/schemas/sensorML/strings/identifiers"/>
					<xsl:with-param name="block">
						<xsl:for-each select="sml:identifier[@name!='GeoNetwork-UUID' and @name!=$ogcID]">
							<xsl:call-template name="handleTerm">
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:with-param>
   			</xsl:call-template> 
			</xsl:for-each> <!-- IdentifierList -->
	
			<!-- ClassifierList -->
			<xsl:for-each select="sml:member/sml:System/sml:classification/sml:ClassifierList">
				<xsl:call-template name="blockElementFop">
					<xsl:with-param name="label" select="/root/gui/schemas/sensorML/strings/classifiers"/>
					<xsl:with-param name="block">
						<xsl:for-each select="sml:classifier">
							<xsl:call-template name="handleTerm">
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:with-param>
   			</xsl:call-template> 
			</xsl:for-each> <!-- ClassifierList -->

			<!-- Keywords -->
			<xsl:for-each select="sml:member/sml:System/sml:keywords/sml:KeywordList/sml:keyword">
				<xsl:call-template name="blockElementFop">
					<xsl:with-param name="label" select="/root/gui/schemas/sensorML/strings/keywords"/>
					<xsl:with-param name="block">
     				<xsl:apply-templates mode="simpleElementFop" select=".">
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:apply-templates>
					</xsl:with-param>
   			</xsl:call-template> 
			</xsl:for-each> <!-- Keywords -->

			<!-- Point location of sensor site -->
			<xsl:call-template name="blockElementFop">
				<xsl:with-param name="label" select="/root/gui/schemas/sensorML/strings/pointLocation"/>
				<xsl:with-param name="block">

     			<xsl:apply-templates mode="simpleElementFop-sensorML"
      			select="sml:member/sml:System/sml:position/swe:Position/@referenceFrame">
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>

      		<xsl:for-each	select="sml:member/sml:System/sml:position/swe:Position/swe:location/swe:Vector/swe:coordinate">
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
      				select="swe:Quantity/swe:value">
							<xsl:with-param name="name"   select="name()"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id"     select="concat(@name,'_site')"/>
						</xsl:apply-templates>
					</xsl:for-each>

				</xsl:with-param>
   		</xsl:call-template> 

			<!-- observed bounding box of site -->
			<xsl:call-template name="blockElementFop">
				<xsl:with-param name="label" select="/root/gui/schemas/sensorML/strings/observationBoundingBox"/>
				<xsl:with-param name="block">

      		<xsl:for-each	select="sml:member/sml:System/sml:capabilities/swe:DataRecord/swe:field[@name='observedBBOX']/swe:Envelope/*/swe:Vector/swe:coordinate">
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
      				select="swe:Quantity/swe:value">
							<xsl:with-param name="name"   select="name()"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id">
								<xsl:call-template name="bboxId">
									<xsl:with-param name="suffix" select="'site'"/>
								</xsl:call-template>
							</xsl:with-param>

						</xsl:apply-templates>
					</xsl:for-each>

				</xsl:with-param>
   		</xsl:call-template> 

			<!-- Event History of sensor site -->
     	<xsl:for-each	select="sml:member/sml:System/sml:history/sml:EventList/sml:member">
				<xsl:call-template name="blockElementFop">
					<xsl:with-param name="label">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="name()"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id"     select="@name"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="block">
						<!-- event date in sml:date -->
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
									select="sml:Event/sml:date">
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:apply-templates>

						<!-- event description in gml:description -->
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
									select="sml:Event/gml:description">
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:apply-templates>

						<!-- event classifiers in sml:classifier -->
						<xsl:for-each select="sml:Event/sml:classification/sml:ClassifierList/sml:classifier">
							<xsl:call-template name="handleTerm">
								<xsl:with-param name="schema" select="$schema"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="add-gap"/>
			</xsl:for-each> <!-- Event History -->

			<!-- Documents relating to/about site -->
     	<xsl:for-each	select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member">
				<xsl:call-template name="blockElementFop">
					<xsl:with-param name="label">
						<xsl:call-template name="getTitle-sensorML">
							<xsl:with-param name="name"   select="name()"/>
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="id"     select="@name"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="block">
						<!-- related document -->
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
									select="sml:Document/sml:onlineResource/@xlink:href">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="text">
								<xsl:choose>
									<xsl:when test="normalize-space(sml:Document/sml:onlineResource/@xlink:href)!='' and @name='relatedDataset-GeoNetworkUUID'">
										<xsl:value-of select="concat($url,'/',sml:Document/sml:onlineResource/@xlink:href)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="sml:Document/sml:onlineResource/@xlink:href"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>

						<!-- document description in gml:description -->
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
									select="sml:Document/gml:description">
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:apply-templates>

						<!-- document format in sml:format -->
     				<xsl:apply-templates mode="simpleElementFop-sensorML"
									select="sml:Document/sml:format">
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="add-gap"/>
			</xsl:for-each> <!-- Site Documents -->

			<xsl:call-template name="add-gap"/>

		</xsl:with-param>
   </xsl:call-template> <!-- siteIdentification -->

  </xsl:template>

	<!-- =================================================================== -->

	<xsl:template name="add-gap">
		<fo:table-row height=".3cm">
			<fo:table-cell>
				<fo:block/>
			</fo:table-cell>
		</fo:table-row>
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
		<xsl:param name="schema"/>

    <xsl:apply-templates mode="simpleElementFop" select="sml:Term/sml:value">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
					<xsl:with-param name="name"   select="name()"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="@name"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="text">
				<xsl:value-of select="sml:Term/sml:value"/><xsl:text>&#10;</xsl:text>
				<xsl:if test="normalize-space(sml:Term/@definition)!='' and normalize-space(sml:Term/sml:codeSpace/@xlink:href)!=''">
     			<xsl:value-of select="concat(/root/gui/schemas/sensorML/strings/term,': ',sml:Term/@definition)"/><xsl:text>&#10;</xsl:text>
     			<xsl:value-of select="concat(/root/gui/schemas/sensorML/strings/thesaurus,': ',sml:Term/sml:codeSpace/@xlink:href)"/><xsl:text>&#10;</xsl:text>
   			</xsl:if> 
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================================================================== -->

	<!-- template to help with putting in simpleElements from sensorML -->
  <xsl:template mode="simpleElementFop-sensorML" match="*|@*">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="schema"/>
		<xsl:param name="id"/>

		<xsl:message>Doing <xsl:value-of select="name()"/> ID: <xsl:value-of select="$id"/></xsl:message>

		<xsl:apply-templates mode="simpleElementFop" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="title">
				<xsl:call-template name="getTitle-sensorML">
			 		<xsl:with-param name="name"   select="$name"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="id"     select="$id"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="text" select="normalize-space(string())"/>
    </xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
