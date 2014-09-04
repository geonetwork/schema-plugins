<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<xsl:template match="sml:SensorML">
        <thumbnail>
        <xsl:for-each select="sml:member/sml:System/sml:documentation/sml:DocumentList/sml:member[@name='thumbnail']/sml:Document">
            <xsl:choose>
                <xsl:when test="gml:description = 'large_thumbnail'">
                    <large>
                        <xsl:value-of select="sml:onlineResource/@xlink:href" />
                    </large>
                </xsl:when>
                <xsl:when test="gml:description = 'thumbnail'">
                    <small>
                        <xsl:value-of select="sml:onlineResource/@xlink:href" />
                    </small>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
		</thumbnail>
	</xsl:template>

</xsl:stylesheet>
