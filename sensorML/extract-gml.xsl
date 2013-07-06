<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
		xmlns:swe="http://www.opengis.net/swe/1.0.1"
		xmlns:gml="http://www.opengis.net/gml">
  <xsl:output method="xml" indent="yes"/>

	<xsl:template match="/" priority="2">
   		<gml:GeometryCollection>
				<xsl:apply-templates/>
   		</gml:GeometryCollection>
  </xsl:template>

	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="text()"/>

	<xsl:template match="swe:field[@name='observedBBOX']" priority="2">

    <xsl:variable name="w" select="swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='easting' or @name='longitude']/swe:Quantity/swe:value"/>

    <xsl:variable name="e" select="swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='easting' or @name='longitude']/swe:Quantity/swe:value"/>

    <xsl:variable name="s" select="swe:Envelope/swe:lowerCorner/swe:Vector/swe:coordinate[@name='northing' or @name='latitiude']/swe:Quantity/swe:value"/>

    <xsl:variable name="n" select="swe:Envelope/swe:upperCorner/swe:Vector/swe:coordinate[@name='northing' or @name='latitiude']/swe:Quantity/swe:value"/>

    <!-- <xsl:message>Indexing coordinates: <xsl:value-of select="$w"/>,<xsl:value-of select="$n"/>, <xsl:value-of select="$e"/>,<xsl:value-of select="$n"/>, <xsl:value-of select="$e"/>,<xsl:value-of select="$s"/>, <xsl:value-of select="$w"/>,<xsl:value-of select="$s"/>, <xsl:value-of select="$w"/>,<xsl:value-of select="$n"/></xsl:message> -->

    <xsl:if test="$w!='' and $e!='' and $n!='' and $s!=''">
       <gml:Polygon>
           <gml:exterior>
               <gml:LinearRing>
                   <gml:coordinates><xsl:value-of select="$w"/>,<xsl:value-of select="$n"/>, <xsl:value-of select="$e"/>,<xsl:value-of select="$n"/>, <xsl:value-of select="$e"/>,<xsl:value-of select="$s"/>, <xsl:value-of select="$w"/>,<xsl:value-of select="$s"/>, <xsl:value-of select="$w"/>,<xsl:value-of select="$n"/></gml:coordinates>
               </gml:LinearRing>
           </gml:exterior>
       </gml:Polygon>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
