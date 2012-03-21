<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"  
		xmlns:grg="http://www.isotc211.org/2005/grg"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:gco="http://www.isotc211.org/2005/gco" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:dct="http://purl.org/dc/terms/" 
		xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:gml="http://www.opengis.net/gml" 
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
		xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
		xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="fn gmd gco grg xsi geonet xsl gml xdt xs rdfs">

  <!-- This stylesheet produces SKOS in XML format from ISO19135 -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- Metadata is passed under /root XPath -->
  <xsl:template match="/root">
    <!-- Export ISO19135 -->
    <xsl:if test="grg:RE_Register">
			<rdf:RDF>
      	<xsl:apply-templates select="grg:RE_Register"/>
			</rdf:RDF>
    </xsl:if>
  </xsl:template>

	<xsl:template match="grg:RE_Register">
		<xsl:variable name="about" select="/root/grg:RE_Register/grg:uniformResourceIdentifier/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
		<xsl:variable name="aboutScheme" select="concat($about,'#scheme')"/>
		<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>

		<skos:ConceptScheme rdf:about="{$aboutScheme}">
			<dc:identifier><xsl:value-of select="@uuid"/></dc:identifier>
			<xsl:apply-templates select="grg:name|grg:contentSummary|grg:uniformResourceIdentifier|grg:dateOfLastChange|grg:version|grg:manager|grg:submitter"/>
			<dct:issued><xsl:value-of select="format-dateTime(current-dateTime(),$df)"/></dct:issued>
		</skos:ConceptScheme>

		<!-- and now all the concepts -->

		<xsl:apply-templates select="grg:containedItem/grg:RE_RegisterItem[grg:status/grg:RE_ItemStatus='valid']">
			<xsl:with-param name="about" select="$about"/>
			<xsl:with-param name="aboutScheme" select="$aboutScheme"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:name">
		<dc:title><xsl:value-of select="gco:CharacterString"/></dc:title>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:contentSummary">
		<dc:description><xsl:value-of select="gco:CharacterString"/></dc:description>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:uniformResourceIdentifier">
		<dc:URI><xsl:value-of select="gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/></dc:URI>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:version">
		<dct:modified><xsl:value-of select="grg:RE_Version/grg:versionDate/gco:Date"/></dct:modified>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:dateOfLastChange">
		<dct:modified><xsl:value-of select="gco:Date"/></dct:modified>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:manager">
		<dc:publisher>
			<xsl:for-each select="grg:RE_RegisterManager/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName[normalize-space(gco:CharacterString)!='']">
				<foaf:Organization>
					<foaf:name>
						<xsl:value-of select="gco:CharacterString"/>
					</foaf:name>
				</foaf:Organization>
			</xsl:for-each>

			<xsl:for-each select="RE_RegisterManager/grg:contact/gmd:CI_ResponsibleParty/gmd:individualName[normalize-space(gco:CharacterString)!='']">
				<foaf:Person>
					<foaf:name>
						<xsl:value-of select="gco:CharacterString"/>
					</foaf:name>
				</foaf:Person>
			</xsl:for-each>
		</dc:publisher>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:submitter">
		<dc:creator>
			<xsl:for-each select="grg:RE_SubmittingOrganization/grg:contact/gmd:CI_ResponsibleParty/gmd:organisationName[normalize-space(gco:CharacterString)!='']|grg:RE_SubmittingOrganization/grg:name[normalize-space(gco:CharacterString)!='']">
				<foaf:Organization>
					<foaf:name>
						<xsl:value-of select="gco:CharacterString"/>
					</foaf:name>
				</foaf:Organization>
			</xsl:for-each>

			<xsl:for-each select="RE_RegisterManager/grg:contact/gmd:CI_ResponsibleParty/gmd:individualName[normalize-space(gco:CharacterString)!='']">
				<foaf:Person>
					<foaf:name>
						<xsl:value-of select="gco:CharacterString"/>
					</foaf:name>
				</foaf:Person>
			</xsl:for-each>
		</dc:creator>
	</xsl:template>

<!-- ................................................................... -->

	<xsl:template match="grg:RE_RegisterItem">
		<xsl:param name="about"/>
		<xsl:param name="aboutScheme"/>

		<skos:Concept rdf:about="{concat($about,'#',grg:itemIdentifier/gco:Integer)}">
			<skos:prefLabel xml:lang="en"><xsl:value-of select="grg:name/gco:CharacterString"/></skos:prefLabel>
			<skos:inScheme rdf:resource="{$aboutScheme}"/>
			<xsl:for-each select="grg:specificationLineage/grg:RE_Reference">
				<xsl:variable name="sim" select="grg:similarity/grg:RE_SimilarityToSource/@codeListValue"/>
				<xsl:variable name="item" select="grg:itemIdentifierAtSource/gco:CharacterString"/>

				<xsl:choose>
					<xsl:when test="$sim='generalization'">
						<skos:broader rdf:resource="{concat($about,'#',$item)}"/>
					</xsl:when>
					<xsl:when test="$sim='specialization'">
						<skos:narrower rdf:resource="{concat($about,'#',$item)}"/>
					</xsl:when>
					<xsl:otherwise>
						<skos:related rdf:resource="{concat($about,'#',$item)}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<skos:definition xml:lang="en"><xsl:value-of select="grg:definition/gco:CharacterString"/></skos:definition>
			<xsl:if test="normalize-space(grg:description/gco:CharacterString)!=''">
				<skos:scopeNote xml:lang="en"><xsl:value-of select="grg:description/gco:CharacterString"/></skos:scopeNote>
			</xsl:if>
			<xsl:for-each select="grg:fieldOfApplication/grg:RE_FieldOfApplication">
				<skos:scopeNote xml:lang="en"><xsl:value-of select="concat('Name of field of Application: ',grg:name/gco:CharacterString,', Description: ',grg:description/gco:CharacterString)"/></skos:scopeNote>
			</xsl:for-each>
		</skos:Concept>
	</xsl:template>

<!-- ................................................................... -->

	<!-- Delete any GeoNetwork specific elements -->
  <xsl:template match="geonet:*"/> 

<!-- ................................................................... -->

</xsl:stylesheet>