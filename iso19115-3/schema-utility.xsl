<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  
  <xsl:template name="add-iso19115-3-namespaces">
    <!-- new namespaces -->
    <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
    <!-- Namespaces that include concepts outside of metadata -->
    <!-- Catalog (ISO 19115-3) -->
    <xsl:namespace name="cat" select="'http://www.isotc211.org/2005/cat/1.0/2013-06-24'"/>
    <!-- Citation (ISO 19115-3) -->
    <xsl:namespace name="cit" select="'http://www.isotc211.org/2005/cit/1.0/2013-06-24'"/>
    <!-- Geospatial Common eXtension (ISO 19115-3) -->
    <xsl:namespace name="gcx" select="'http://www.isotc211.org/2005/gcx/1.0/2013-06-24'"/>
    <!-- Geospatial EXtent (ISO 19115-3) -->
    <xsl:namespace name="gex" select="'http://www.isotc211.org/2005/gex/1.0/2013-06-24'"/>
    <!-- Language Localization (ISO 19115-3) -->
    <xsl:namespace name="lan" select="'http://www.isotc211.org/2005/lan/1.0/2013-06-24'"/>
    <!-- Metadata for Services (ISO 19115-3) -->
    <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv/2.0/2013-06-24'"/>
    <!-- Metadata for Application Schema (ISO 19115-3) -->
    <xsl:namespace name="mas" select="'http://www.isotc211.org/2005/mas/1.0/2013-06-24'"/>
    <!-- Metadata for Common Classes (ISO 19115-3) -->
    <xsl:namespace name="mcc" select="'http://www.isotc211.org/2005/mcc/1.0/2013-06-24'"/>
    <!-- Metadata for COnstraints (ISO 19115-3) -->
    <xsl:namespace name="mco" select="'http://www.isotc211.org/2005/mco/1.0/2013-06-24'"/>
    <!-- MetaData Application (ISO 19115-3) -->
    <xsl:namespace name="mda" select="'http://www.isotc211.org/2005/mda/1.0/2013-06-24'"/>
    <!-- MetaDataBase (ISO 19115-3) -->
    <xsl:namespace name="mdb" select="'http://www.isotc211.org/2005/mdb/1.0/2013-06-24'"/>
    <!-- Metadata for Data and Services (ISO 19115-3) -->
    <xsl:namespace name="mds" select="'http://www.isotc211.org/2005/mds/1.0/2013-06-24'"/>
    <!-- Metadata based Data Transfer (ISO 19115-3) -->
    <xsl:namespace name="mdt" select="'http://www.isotc211.org/2005/mdt/1.0/2013-06-24'"/>
    <!-- Metadata for EXtensions (ISO 19115-3) -->
    <xsl:namespace name="mex" select="'http://www.isotc211.org/2005/mex/1.0/2013-06-24'"/>
    <!-- Metadata for Maintenance Information (ISO 19115-3) -->
    <xsl:namespace name="mmi" select="'http://www.isotc211.org/2005/mmi/1.0/2013-06-24'"/>
    <!-- Metadata for Portrayal Catalog (ISO 19115-3) -->
    <xsl:namespace name="mpc" select="'http://www.isotc211.org/2005/mpc/1.0/2013-06-24'"/>
    <!-- Metadata for Resource Content (ISO 19115-3) -->
    <xsl:namespace name="mrc" select="'http://www.isotc211.org/2005/mrc/1.0/2013-06-24'"/>
    <!-- Metadata for Resource Distribution (ISO 19115-3) -->
    <xsl:namespace name="mrd" select="'http://www.isotc211.org/2005/mrd/1.0/2013-06-24'"/>
    <!-- Metadata for Resource Identification (ISO 19115-3) -->
    <xsl:namespace name="mri" select="'http://www.isotc211.org/2005/mri/1.0/2013-06-24'"/>
    <!-- Metadata for Resource Lineage (ISO 19115-3) -->
    <xsl:namespace name="mrl" select="'http://www.isotc211.org/2005/mrl/1.0/2013-06-24'"/>
    <!-- Metadata for Reference System (ISO 19115-3) -->
    <xsl:namespace name="mrs" select="'http://www.isotc211.org/2005/mrs/1.0/2013-06-24'"/>
    <!-- Metadata for Spatial Representation (ISO 19115-3) -->
    <xsl:namespace name="msr" select="'http://www.isotc211.org/2005/msr/1.0/2013-06-24'"/>
    <!-- Data Quality Measures (ISO 19157-2) -->
    <xsl:namespace name="mdq" select="'http://www.isotc211.org/2005/mdq/1.0/2013-06-24'"/>
    <!-- Metadata for Data Quality (ISO 19157-2) -->
    <xsl:namespace name="mdq" select="'http://www.isotc211.org/2005/mdq/1.0/2013-06-24'"/>
    <!-- Metadata for Acquisition (ISO 19115-4) -->
    <xsl:namespace name="mac" select="'http://www.isotc211.org/2005/mac/1.0/2013-06-24'"/>
    <!-- Metadata for Acquisition and Imagery (ISO 19115-4) -->
    <xsl:namespace name="mai" select="'http://www.isotc211.org/2005/mai/1.0/2013-06-24'"/>
    <!-- Metadata for Image Content (ISO 19115-4) -->
    <xsl:namespace name="mic" select="'http://www.isotc211.org/2005/mic/1.0/2013-06-24'"/>
    <!-- Metadata for Image Lineage (ISO 19115-4) -->
    <xsl:namespace name="mil" select="'http://www.isotc211.org/2005/mil/1.0/2013-06-24'"/>
    <!-- other ISO namespaces -->
    <!-- Geospatial COmmon -->
    <xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
    <!-- external namespaces -->
    <xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
    <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
  </xsl:template>
</xsl:stylesheet>