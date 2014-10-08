<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="gmd gco geonet">

    <xsl:import href="../../iso19139/present/metadata-subtemplates.xsl"/>

    <xsl:template name="iso19139.gemini22-subtemplate">

        <!-- Let the original ISO19139 templates do the work -->

      <xsl:call-template name="iso19139.gemini22-subtemplate" select="."/>
  </xsl:template>
  
</xsl:stylesheet>