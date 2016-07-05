<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:geonet="http://www.fao.org/geonetwork" 
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:void="http://www.w3.org/TR/void/" 
  xmlns:dcat="http://www.w3.org/ns/dcat#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:dctype="http://purl.org/dc/dcmitype/" 
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:gco="http://www.isotc211.org/2005/gco" 
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:grg="http://www.isotc211.org/2005/grg"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gml="http://www.opengis.net/gml" 
  xmlns:ogc="http://www.opengis.net/rdf#"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:iso19139="http://geonetwork-opensource.org/schemas/iso19139"
  extension-element-prefixes="saxon" exclude-result-prefixes="#all">

	<xsl:template match="grg:RE_Register|*[@gco:isoType='grg:RE_Register']" mode="record-reference">
    <dcat:dataset rdf:resource="{$url}/resource/register"/>
    <dcat:record rdf:resource="{$url}/metadata/{@uuid}"/>
		<xsl:apply-templates/>
  </xsl:template>

	<xsl:template match="grg:RE_Register|*[@gco:isoType='grg:RE_Register']" mode="references"/>

	<xsl:template match="grg:RE_Register|*[@gco:isoType='grg:RE_Register']" mode="to-dcat">
		<dcat:CatalogRecord rdf:about="{$url}/metadata/{@uuid}">
		</dcat:CatalogRecord>
	</xsl:template>

	<xsl:template match="node()|@*"/>

	<xsl:template match="node()|@*" mode="to-dcat"/>

	<xsl:template match="node()|@*" mode="references"/>

	<xsl:template match="node()|@*" mode="record-reference"/>

</xsl:stylesheet>
