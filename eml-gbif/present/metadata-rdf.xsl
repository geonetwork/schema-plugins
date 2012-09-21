<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all">

  <xsl:template match="eml:eml" mode="record-reference"/>
  <xsl:template match="eml:eml" mode="to-dcat"/>
  <xsl:template match="eml:eml" mode="references"/>
  <xsl:template mode="metadata" match="eml:eml"/>
  
</xsl:stylesheet>
