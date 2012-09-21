<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:grg="http://www.isotc211.org/2005/grg"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all">

  <xsl:template match="grg:RE_Register" mode="record-reference"/>
  <xsl:template match="grg:RE_Register" mode="to-dcat"/>
  <xsl:template match="grg:RE_Register" mode="references"/>
  <xsl:template mode="metadata" match="grg:RE_Register"/>
  
</xsl:stylesheet>
