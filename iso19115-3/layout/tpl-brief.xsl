<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2014-07-11"
  xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2014-07-11"
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2014-07-11"
  xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2014-07-11"
  xmlns:mrs="http://www.isotc211.org/2005/mrs/1.0/2014-07-11"
  xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2014-07-11"
  xmlns:mco="http://www.isotc211.org/2005/mco/1.0/2014-07-11"
  xmlns:msr="http://www.isotc211.org/2005/msr/1.0/2014-07-11"
  xmlns:lan="http://www.isotc211.org/2005/lan/1.0/2014-07-11"
  xmlns:gcx="http://www.isotc211.org/2005/gcx/1.0/2014-07-11"
  xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2014-07-11"
  xmlns:dqm="http://www.isotc211.org/2005/dqm/1.0/2014-07-11"
  xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2014-07-11"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

  <xsl:include href="utility-tpl.xsl"/>

  <xsl:template name="iso19115-3Brief">
    <metadata>
      <xsl:call-template name="iso19139-brief"/>
    </metadata>
  </xsl:template>

  <xsl:template name="iso19115-3-brief">
    <xsl:call-template name="iso19139-brief"/>
  </xsl:template>
</xsl:stylesheet>
