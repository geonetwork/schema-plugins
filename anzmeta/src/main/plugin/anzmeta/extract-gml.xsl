<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:gml="http://www.opengis.net/gml" >
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
    
    <xsl:template match="bounding" priority="2">
      <xsl:variable name="w">
				<xsl:call-template name="processNEWS">
					<xsl:with-param name="value" select="./westbc/text()"/>
				</xsl:call-template>
			</xsl:variable>
      <xsl:variable name="e">
				<xsl:call-template name="processNEWS">
					<xsl:with-param name="value" select="./eastbc/text()"/>
				</xsl:call-template>
			</xsl:variable>
      <xsl:variable name="n">
				<xsl:call-template name="processNEWS">
					<xsl:with-param name="value" select="./northbc/text()"/>
				</xsl:call-template>
			</xsl:variable>
      <xsl:variable name="s">
				<xsl:call-template name="processNEWS">
					<xsl:with-param name="value" select="./southbc/text()"/>
				</xsl:call-template>
			</xsl:variable>

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

		<xsl:template name="processNEWS">
			<xsl:param name="value"/>

			<xsl:choose>
				<xsl:when test="contains($value,' S')">
					<xsl:value-of select="concat('-',normalize-space(substring-before($value,'S')))"/>
				</xsl:when>
				<xsl:when test="contains($value,' W')">
					<xsl:value-of select="concat('-',normalize-space(substring-before($value,'W')))"/>
				</xsl:when>
				<xsl:when test="contains($value,' E')">
					<xsl:value-of select="normalize-space(substring-before($value,'E'))"/>
				</xsl:when>
				<xsl:when test="contains($value,' N')">
					<xsl:value-of select="normalize-space(substring-before($value,'N'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($value)"/>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:template>

</xsl:stylesheet>
