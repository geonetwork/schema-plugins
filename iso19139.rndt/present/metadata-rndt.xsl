<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:java="java:org.fao.geonet.util.XslUtil" version="2.0">
	
	<!--
		Template for INSPIRE RNDT tab
	-->
	<xsl:template name="rndttabs">
		<xsl:param name="schema" />
		<xsl:param name="edit" />
		<xsl:param name="dataset" />

		<xsl:for-each
			select="gmd:identificationInfo/gmd:MD_DataIdentification|
			gmd:identificationInfo/srv:SV_ServiceIdentification|
			gmd:identificationInfo/*[@gco:isoType='gmd:MD_DataIdentification']|
			gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification']">
			
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/identification/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/identification/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:title">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:title)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='title']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>		
					
					<xsl:apply-templates mode="elementEP" select="
						gmd:citation/gmd:CI_Citation/gmd:presentationForm">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:presentationForm)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='presentationForm']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Identifier -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='code']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Id Livello superiore -->
					<xsl:apply-templates mode="elementEP" 
						select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/geonet:child[string(@name)='issueIdentification']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Optional for RNDT -->
					<xsl:apply-templates mode="simpleElement" 
						select="gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='otherCitationDetails']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:abstract">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:abstract)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='abstract']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Spatial Representation -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:spatialRepresentationType">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:spatialRepresentationType)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='spatialRepresentationType']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Language -->
					<xsl:apply-templates mode="elementEP" select="gmd:language">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:language)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='language']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Character Set -->
					<xsl:apply-templates mode="elementEP" select="gmd:characterSet">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:characterSet)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='characterSet']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- SupplementalInformation (Optional for RNDT) -->						
					<xsl:apply-templates mode="elementEP" select="gmd:supplementalInformation">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>	
					<xsl:if test="not(gmd:supplementalInformation)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='supplementalInformation']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Topic Category -->
					<xsl:apply-templates mode="elementEP" select="gmd:topicCategory">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:topicCategory)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='topicCategory']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Date -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:date">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:date)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='date']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!--  Responsible -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='citedResponsibleParty']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!--  Keywords -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/keywords/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/keywords/title)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:descriptiveKeywords">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(gmd:descriptiveKeywords)">
								<xsl:apply-templates mode="elementEP"
									select="geonet:child[string(@name)='descriptiveKeywords']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
						</xsl:with-param>
					</xsl:call-template>
					
					<!-- Point of Contact -->
					<xsl:apply-templates mode="elementEP" 
						select="gmd:pointOfContact">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit" select="$edit"/>
						<xsl:with-param name="force" select="true()"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:pointOfContact)">
						<xsl:apply-templates mode="elementEP" select="
							geonet:child[string(@name)='pointOfContact']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit" select="$edit"/>
							<xsl:with-param name="force" select="true()"/>
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Spatial Resolution -->
					<xsl:apply-templates mode="elementEP" select="gmd:spatialResolution">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:spatialResolution)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='spatialResolution']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Service info-->
			<xsl:if test="not($dataset)">				
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title"
						select="/root/gui/schemas/iso19139.rndt/strings/service/title" />
					<xsl:with-param name="id"
						select="generate-id(/root/gui/schemas/iso19139.rndt/strings/service/title)" />
					<xsl:with-param name="content">
						
						<!-- Coupling Type -->
						<xsl:apply-templates mode="elementEP"
							select="srv:couplingType">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(srv:couplingType)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='couplingType']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Resource Coupled -->
						<xsl:apply-templates mode="elementEP"
							select="srv:operatesOn">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(srv:operatesOn)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='operatesOn']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Service Type -->
						<xsl:apply-templates mode="elementEP"
							select="srv:serviceType">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(gmd:serviceType)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='serviceType']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Contains Operations -->
						<xsl:apply-templates mode="elementEP"
							select="srv:containsOperations">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(srv:containsOperations)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='containsOperations']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			
			<!-- Constraint  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/constraint/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/constraint/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:resourceConstraints/gmd:MD_Constraints/geonet:child[string(@name)='useLimitation']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:resourceConstraints/gmd:MD_LegalConstraints/geonet:child[string(@name)='accessConstraints']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:resourceConstraints/gmd:MD_LegalConstraints/geonet:child[string(@name)='useConstraints']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:resourceConstraints/gmd:MD_SecurityConstraints/geonet:child[string(@name)='classification']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:resourceConstraints/gmd:MD_LegalConstraints/geonet:child[string(@name)='otherConstraints']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
				</xsl:with-param>
			</xsl:call-template>	
			
			<!-- Extent information -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/geoloc/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/geoloc/title)" />
				<xsl:with-param name="content">
					
					<!-- Geographic Extent -->
					<xsl:choose>
						<xsl:when test="exists(gmd:extent)">
							<xsl:apply-templates mode="elementEP"
								select="gmd:extent/gmd:EX_Extent/gmd:geographicElement">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:geographicElement)">
								<xsl:apply-templates mode="elementEP"
									select="gmd:extent/gmd:EX_Extent/geonet:child[string(@name)='geographicElement']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>													
						</xsl:when>
						
						<xsl:when test="exists(srv:extent)">
							<xsl:apply-templates mode="elementEP"
								select="srv:extent/gmd:EX_Extent/gmd:geographicElement">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(srv:extent/gmd:EX_Extent/gmd:geographicElement)">
								<xsl:apply-templates mode="elementEP"
									select="srv:extent/gmd:EX_Extent/geonet:child[string(@name)='geographicElement']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
					
					<!-- Vertical Extent -->					
					<xsl:choose>
						<xsl:when test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement)">
							<xsl:apply-templates mode="elementEP"
								select="gmd:extent/gmd:EX_Extent/geonet:child[string(@name)='verticalElement']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>														
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="complexElementGuiWrapper">
								<xsl:with-param name="title"
									select="/root/gui/schemas/iso19139.rndt/strings/verticalExtent/title" />
								<xsl:with-param name="id"
									select="generate-id(/root/gui/schemas/iso19139.rndt/strings/verticalExtent/title)" />
								<xsl:with-param name="content">

		                        <xsl:apply-templates mode="complexElement"
									select="*:extent/gmd:EX_Extent/gmd:verticalElement">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
		                        	<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
									
<!--									<xsl:apply-templates mode="elementEP"
					                    select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue">
					                    <xsl:with-param name="schema" select="$schema" />
					                    <xsl:with-param name="edit" select="$edit" />
					                  </xsl:apply-templates>									
					                  <xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue)">
					                    	<xsl:apply-templates mode="elementEP"
						                      select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/geonet:child[string(@name)='minimumValue']">
						                      <xsl:with-param name="schema" select="$schema" />
						                      <xsl:with-param name="edit" select="$edit" />
						                    </xsl:apply-templates>
					                  </xsl:if>

									  <xsl:apply-templates mode="elementEP"
						                   select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue">
						                    <xsl:with-param name="schema" select="$schema" />
						                    <xsl:with-param name="edit" select="$edit" />
						              </xsl:apply-templates>					
					                  <xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue)">
						                    <xsl:apply-templates mode="elementEP"
						                      select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/geonet:child[string(@name)='maximumValue']">
						                      <xsl:with-param name="schema" select="$schema" />
						                      <xsl:with-param name="edit" select="$edit" />
						                    </xsl:apply-templates>
					                  </xsl:if>
					
									  <xsl:apply-templates mode="elementEP"
					                    	select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS">
					                    <xsl:with-param name="schema" select="$schema" />
					                    <xsl:with-param name="edit" select="$edit" />
					                  </xsl:apply-templates>	-->				
	

								</xsl:with-param>
							</xsl:call-template>	
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- Temporal extent -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:extent/gmd:EX_Extent/gmd:temporalElement">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:temporalElement)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:extent/gmd:EX_Extent/geonet:child[string(@name)='temporalElement']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
				</xsl:with-param>					
			</xsl:call-template>
			
			<!-- Quality and validity  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/quality/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/quality/title)" />
				<xsl:with-param name="content">
					
					<!-- Quality level -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/geonet:child[string(@name)='level']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Lineage -->
					<xsl:apply-templates mode="elementEP"
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>					
					<xsl:if	test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/geonet:child[string(@name)='statement']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Positional Accuracy -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/positionalAccuracy/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/positionalAccuracy/title)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP" 
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/geonet:child[string(@name)='valueUnit']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
							<xsl:apply-templates mode="elementEP" 
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/geonet:child[string(@name)='value']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
						</xsl:with-param>
					</xsl:call-template>
					
					<!-- Specific Conformity  -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/conformity/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/conformity/title)" />
						<xsl:with-param name="content">
							
<!--							<xsl:apply-templates mode="elementEP"
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>	
							<xsl:if
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/geonet:child[string(@name)='DQ_ConformanceResult']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>-->
							
							<!-- Title -->
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>	
							<xsl:if
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/geonet:child[string(@name)='title']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>
							
							<!-- Date -->
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>	
							<xsl:if
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/geonet:child[string(@name)='date']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>
							
							<!-- Date Type -->
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>	
							<xsl:if
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/geonet:child[string(@name)='dateType']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>
							
							<!-- Conformity Level -->
							<xsl:variable name="conformity">
								<xsl:value-of select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass"/>
							</xsl:variable>
							
							<xsl:if test="$conformity != ''">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>	
							</xsl:if>

							<xsl:if
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/geonet:child[string(@name)='pass']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>
							
						</xsl:with-param>
					</xsl:call-template>
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Spatial Reference System -->
			<xsl:apply-templates mode="elementEP"
				select="../../gmd:referenceSystemInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>	
			<xsl:if	test="not(../../gmd:referenceSystemInfo)">
				<xsl:apply-templates mode="elementEP"
					select="../../geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- Distribution -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/distribution/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/distribution/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='distributionFormat']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='distributor']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='transferOptions']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Data management -->
			<xsl:apply-templates mode="complexElement"
				select="gmd:resourceMaintenance">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			<xsl:if	test="not(gmd:resourceMaintenance)">
				<xsl:apply-templates mode="elementEP"
					select="geonet:child[string(@name)='resourceMaintenance']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- Raster data content -->
			<xsl:if test="exists(../../gmd:contentInfo/gmd:MD_ImageDescription)">
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title"
						select="/root/gui/schemas/iso19139.rndt/strings/rasterContent/title" />
					<xsl:with-param name="id"
						select="generate-id(/root/gui/schemas/iso19139.rndt/strings/rasterContent/title)" />
					<xsl:with-param name="content">
						
						<!-- Attribute Description -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:contentInfo/gmd:MD_ImageDescription/geonet:child[string(@name)='attributeDescription']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Content Type -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:contentInfo/gmd:MD_ImageDescription/geonet:child[string(@name)='contentType']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Radiometric Resolution -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/gmd:bitsPerValue">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/gmd:bitsPerValue)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/geonet:child[string(@name)='bitsPerValue']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Triangulation Area -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:triangulationIndicator">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:contentInfo/gmd:MD_ImageDescription/gmd:triangulationIndicator)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:contentInfo/gmd:MD_ImageDescription/geonet:child[string(@name)='triangulationIndicator']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<!-- Spatial Representation information for Raster data -->	
			<xsl:if test="exists(../../gmd:spatialRepresentationInfo)">
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title"
						select="/root/gui/schemas/iso19139.rndt/strings/rasterSpatialRepresentation/title" />
					<xsl:with-param name="id"
						select="generate-id(/root/gui/schemas/iso19139.rndt/strings/rasterSpatialRepresentation/title)" />
					<xsl:with-param name="content">
						
						<!-- Number of Dimension -->
						
						<!-- MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='numberOfDimensions']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='numberOfDimensions']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Dimension Properties -->
						
						<!-- MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='axisDimensionProperties']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='axisDimensionProperties']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Cell Geometry -->
						
						<!-- MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='cellGeometry']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='cellGeometry']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Transformation Parameter Availability -->
						
						<!-- MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='transformationParameterAvailability']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:transformationParameterAvailability">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:transformationParameterAvailability)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='transformationParameterAvailability']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Chak Point Availability -->
						
						<!-- Only for MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='checkPointAvailability']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Chak Point Description -->
						
						<!-- Only for MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointDescription">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointDescription)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='checkPointDescription']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Coorner Points Coordinates -->
						
						<!-- Only for MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cornerPoints">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cornerPoints)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='cornerPoints']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Pixel Point -->
						
						<!-- Only for MD_Georectified -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:pointInPixel">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:pointInPixel)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georectified/geonet:child[string(@name)='pointInPixel']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Control Point Availability -->
						
						<!-- Only for MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:controlPointAvailability">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:controlPointAvailability)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='controlPointAvailability']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Orentation Parameter Availability -->
						
						<!-- Only for MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:orientationParameterAvailability">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:orientationParameterAvailability)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='orientationParameterAvailability']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Georeferenced Parameters -->
						
						<!-- Only for MD_Georeferenceable -->
						<xsl:apply-templates mode="elementEP" 
							select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:georeferencedParameters">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>			
						<xsl:if	test="not(../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:georeferencedParameters)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/geonet:child[string(@name)='georeferencedParameters']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
						
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
						
			<!-- Metadata  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/metadata/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/metadata/title)" />
				<xsl:with-param name="content">
					
					<!-- fileIdentifier -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:fileIdentifier">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:fileIdentifier)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='fileIdentifier']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- language -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:language">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:language)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='language']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- metadataStandardName -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:metadataStandardName">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:metadataStandardName)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='metadataStandardName']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- metadataStandardVersion -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:metadataStandardVersion">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:metadataStandardVersion)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='metadataStandardVersion']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- characterSet -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:characterSet">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:characterSet)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='characterSet']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>	
					
					<!-- parentIdentifier -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:parentIdentifier">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:parentIdentifier)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='parentIdentifier']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>		
					
					<!-- hierarchyLevel -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:hierarchyLevel">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:hierarchyLevel)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='hierarchyLevel']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>	
								
					<!-- dateStamp -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:dateStamp">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:dateStamp)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='dateStamp']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- contact -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:contact">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:contact)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='contact']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>	
					
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>