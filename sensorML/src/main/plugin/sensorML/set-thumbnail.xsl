<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:sml="http://www.opengis.net/sensorML/1.0.1">

	<!-- ================================================================= -->
	
	<xsl:template match="/root">
		 <xsl:apply-templates select="sml:SensorML"/>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="@*|node()">
		 <xsl:copy>
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

    <xsl:template match="sml:DocumentList">
        <xsl:copy>
            <xsl:copy-of select="@*"/>

            <xsl:for-each select="sml:member[@name!='thumbnail']">
                <xsl:apply-templates select="."/>
            </xsl:for-each>


            <xsl:apply-templates select="sml:member[@name='thumbnail' and sml:Document/gml:description != /root/env/type]" />

            <xsl:call-template name="fill" />
        </xsl:copy>
    </xsl:template>

    <xsl:template name="fill">
                <sml:member name="thumbnail">
                    <sml:Document>
                        <gml:description><xsl:value-of select="/root/env/type"/></gml:description>
                        <sml:format><xsl:value-of select="/root/env/ext"/></sml:format>
                        <sml:onlineResource
                                xlink:href="{/root/env/file}" xlink:actuate="none" xlink:show="none"/>


                    </sml:Document>
                </sml:member>
    </xsl:template>
</xsl:stylesheet>
