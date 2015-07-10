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
  xmlns:ogc="http://www.opengis.net/rdf#"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  extension-element-prefixes="saxon" exclude-result-prefixes="#all">


  <!--
    Convert prov-xml.iso record to DCAT
    -->
  <xsl:template match="prov:document" mode="to-dcat"/>

</xsl:stylesheet>
