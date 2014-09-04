<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	 xmlns:gml="http://www.opengis.net/gml"
   xmlns:gco="http://www.isotc211.org/2005/gco"
   xmlns:gmx="http://www.isotc211.org/2005/gmx"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:gmd="http://www.isotc211.org/2005/gmd"
   xmlns:grg="http://www.isotc211.org/2005/grg"
   xmlns:gnreg="http://geonetwork-opensource.org/register"
	 exclude-result-prefixes="gmd">

	<xsl:include href="convert/functions.xsl"/>

	<!-- ================================================================= -->

	<xsl:template match="/root">
		<xsl:apply-templates select="grg:RE_Register"/>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="grg:RE_Register">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='xsi:schemaLocation' and 
			                        name()!='uuid']"/>
			<xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/grg http://www.isotc211.org/2005/grg/grg.xsd http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/gco http://www.isotc211.org/2005/gco/gco.xsd http://geonetwork-opensource.org/register http://geonetwork-opensource.org/schemas/register/register.xsd</xsl:attribute>
			<xsl:attribute name="uuid">
				<xsl:value-of select="/root/env/uuid"/>
			</xsl:attribute>
			
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="grg:dateOfLastChange">
		<xsl:choose>
			<xsl:when test="/root/env/updateDateStamp='yes'">
				<grg:dateOfLastChange>
					<gco:DateTime><xsl:value-of select="/root/env/changeDate"/></gco:DateTime>
				</grg:dateOfLastChange>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="@gml:id">
		<xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<xsl:attribute name="gml:id">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- codelists: set @codeList path -->
	<!-- ================================================================= -->
	
	<xsl:template match="gmd:*[@codeListValue]|grg:*[@codeListValue]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="codeList">
				<xsl:value-of select="concat('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#',local-name(.))"/>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmd:CI_OnlineResource[starts-with(gmd:protocol/gco:CharacterString,'WWW:DOWNLOAD-') and contains(gmd:protocol/gco:CharacterString,'http--download') and gmd:name]">
		<xsl:variable name="fname" select="gmd:name/gco:CharacterString|gmd:name/gmx:MimeFileType"/>
		<xsl:variable name="mimeType">
			<xsl:call-template name="getMimeTypeFile">
				<xsl:with-param name="datadir" select="/root/env/datadir"/>
				<xsl:with-param name="fname" select="$fname"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<gmd:linkage>
				<gmd:URL>
					<xsl:choose>
						<xsl:when test="/root/env/config/downloadservice/simple='true'">
							<xsl:value-of select="concat(/root/env/siteURL,'/resources.get?id=',/root/env/id,'&amp;fname=',$fname,'&amp;access=private')"/>
						</xsl:when>
						<xsl:when test="/root/env/config/downloadservice/withdisclaimer='true'">
							<xsl:value-of select="concat(/root/env/siteURL,'/file.disclaimer?id=',/root/env/id,'&amp;fname=',$fname,'&amp;access=private')"/>
						</xsl:when>
						<xsl:otherwise> <!-- /root/env/config/downloadservice/leave='true' -->
							<xsl:value-of select="gmd:linkage/gmd:URL"/>
						</xsl:otherwise>
					</xsl:choose>
				</gmd:URL>
			</gmd:linkage>
			<xsl:copy-of select="gmd:protocol"/>
			<xsl:copy-of select="gmd:applicationProfile"/>
			<gmd:name>
				<gmx:MimeFileType type="{$mimeType}">
					<xsl:value-of select="$fname"/>
				</gmx:MimeFileType>
			</gmd:name>
			<xsl:copy-of select="gmd:description"/>
			<xsl:copy-of select="gmd:function"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- online resources: link-to-downloadable data etc -->
	<!-- ================================================================= -->

	<xsl:template match="gmd:CI_OnlineResource[starts-with(gmd:protocol/gco:CharacterString,'WWW:LINK-') and contains(gmd:protocol/gco:CharacterString,'http--download')]">
		<xsl:variable name="mimeType">
			<xsl:call-template name="getMimeTypeUrl">
				<xsl:with-param name="linkage" select="gmd:linkage/gmd:URL"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="gmd:linkage"/>
			<xsl:copy-of select="gmd:protocol"/>
			<xsl:copy-of select="gmd:applicationProfile"/>
			<gmd:name>
				<gmx:MimeFileType type="{$mimeType}"/>
			</gmd:name>
			<xsl:copy-of select="gmd:description"/>
			<xsl:copy-of select="gmd:function"/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gmx:FileName">
		<xsl:copy>
			<xsl:attribute name="src">
				<xsl:choose>
					<xsl:when test="/root/env/config/downloadservice/simple='true'">
						<xsl:value-of select="concat(/root/env/siteURL,'/resources.get?id=',/root/env/id,'&amp;fname=',.,'&amp;access=private')"/>
					</xsl:when>
					<xsl:when test="/root/env/config/downloadservice/withdisclaimer='true'">
						<xsl:value-of select="concat(/root/env/siteURL,'/file.disclaimer?id=',/root/env/id,'&amp;fname=',.,'&amp;access=private')"/>
					</xsl:when>
					<xsl:otherwise> <!-- /root/env/config/downloadservice/leave='true' -->
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- Adjust the namespace declaration - In some cases name() is used to get the 
		element. The assumption is that the name is in the format of  <ns:element> 
		however in some cases it is in the format of <element xmlns=""> so the 
		following will convert them back to the expected value. This also corrects the issue 
		where the <element xmlns=""> loose the xmlns="" due to the exclude-result-prefixes="#all" -->
	<!-- Note: Only included prefix gml, gmd and gco for now. -->
	<!-- TODO: Figure out how to get the namespace prefix via a function so that we don't need to hard code them -->
	<!-- ================================================================= -->

	<xsl:template name="correct_ns_prefix">
		<xsl:param name="element" />
		<xsl:param name="prefix" />
		<xsl:choose>
			<xsl:when test="local-name($element)=name($element) and $prefix != '' ">
				<xsl:element name="{$prefix}:{local-name($element)}">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="gmd:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'gmd'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="gco:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'gco'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="gml:*">
		<xsl:call-template name="correct_ns_prefix">
			<xsl:with-param name="element" select="."/>
			<xsl:with-param name="prefix" select="'gml'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ================================================================= -->
	<!-- copy everything else as is -->
	
	<xsl:template match="@*|node()">
	    <xsl:copy>
	        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
	</xsl:template>

</xsl:stylesheet>
