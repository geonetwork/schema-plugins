<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:lan="http://standards.iso.org/19115/-3/lan/1.0/2014-12-25"
  xmlns:gn-fn-prov-xml="http://geonetwork-opensource.org/xsl/functions/profiles/prov-xml"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  exclude-result-prefixes="#all">


  <!-- Language is at present always eng -->
  <xsl:function name="gn-fn-prov-xml:getLangId" as="xs:string">
    <xsl:param name="md"/>
    <xsl:param name="lang"/>

    <xsl:value-of select="concat('#', upper-case($lang))"/>
  </xsl:function>


  <xsl:function name="gn-fn-prov-xml:getCodeListType" as="xs:string">
    <xsl:param name="name" as="xs:string"/>
    
    <xsl:variable name="configType" select="$editorConfig/editor/fields/for[@name = $name]/@use"/>
    
    <xsl:value-of select="if ($configType) then $configType else 'select'"/>
  </xsl:function>
</xsl:stylesheet>
