<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"       xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  xmlns:grg="http://www.isotc211.org/2005/grg"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="gmx xsi gmd grg gco gml gts xlink exslt geonet">

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="view-with-header-iso19135">
		<xsl:param name="tabs"/>

    <xsl:call-template name="md-content">
      <xsl:with-param name="title">
        <xsl:apply-templates mode="localised" select="grg:name">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract">
        <xsl:apply-templates mode="localised" select="grg:contentSummary">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="relatedResources">
        <xsl:apply-templates mode="relatedResources" select="grg:uniformResourceIdentifier"
        />
      </xsl:with-param>
      <xsl:with-param name="tabs" select="$tabs"/>
		</xsl:call-template>
	</xsl:template>

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="metadata-iso19135view-simple" match="metadata-iso19135view-simple">
		<xsl:call-template name="view-with-header-iso19135">
      <xsl:with-param name="tabs">
        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title"
            select="/root/gui/schemas/iso19139/strings/understandResource"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="
  grg:containedItem[grg:RE_RegisterItem/grg:status/grg:RE_ItemStatus='valid']
                "> </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>


        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/contactInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block" select="//grg:contact"/>
          </xsl:with-param>
        </xsl:call-template>

        <span class="madeBy">
          <xsl:value-of select="/root/gui/strings/changeDate"/><xsl:value-of select="grg:version/grg:RE_Version/grg:versionDate/gco:Date|grg:dateOfLastChange/gco:Date"/>
        </span>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
