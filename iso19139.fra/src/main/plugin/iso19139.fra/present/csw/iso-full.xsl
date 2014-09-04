<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
                    xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork">

	<xsl:param name="displayInfo"/>

  <xsl:variable name="schemaLocation">http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:variable>

  <!-- root element  -->
  <xsl:template match="gmd:MD_Metadata" priority="1000">
    <xsl:variable name="info" select="geonet:info"/>

    <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <xsl:attribute name="xsi:schemaLocation">
        <xsl:value-of select="$schemaLocation"/>
      </xsl:attribute>

      <xsl:apply-templates select="*"/>

      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
    </gmd:MD_Metadata>
  </xsl:template>

  <!-- Remap schema element -->
  <xsl:template match="*[@gco:isoType]" priority="100">
    <xsl:element name="{@gco:isoType}">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <!-- Element to skip -->
  <xsl:template match="fra:*[not(@gco:isoType)]|geonet:info" priority="50"/>

  <!-- Copy all -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
