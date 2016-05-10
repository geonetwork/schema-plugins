<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:grg="http://www.isotc211.org/2005/grg"
	xmlns:gnreg="http://geonetwork-opensource.org/register"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="grg gmx xsi gmd gco gml gts xlink exslt geonet">

	<xsl:include href="../../../xsl/utils-fn.xsl"/>

	<xsl:template name="iso19135Brief">
			<metadata>
			
				<xsl:variable name="langId">
        	<xsl:call-template name="getLangId">
          	<xsl:with-param name="langGui" select="/root/gui/language"/>
          	<xsl:with-param name="md" select="."/>
        	</xsl:call-template>
      	</xsl:variable>
	
				<title>
					<xsl:apply-templates mode="localised" select="grg:name">
						<xsl:with-param name="langId" select="$langId"></xsl:with-param>
					</xsl:apply-templates>	
				</title>
	
				<abstract>
					<xsl:apply-templates mode="localised" select="grg:contentSummary">
						<xsl:with-param name="langId" select="$langId"></xsl:with-param>
					</xsl:apply-templates>
				</abstract>
	
				<!-- Put valid register items out as dc:subject keywords -->
      	<xsl:for-each select="grg:containedItem[*/grg:status/grg:RE_ItemStatus='valid']">
        	<keyword>
          	<xsl:apply-templates mode="localised" select="*/grg:name">
            	<xsl:with-param name="langId" select="$langId"/>
          	</xsl:apply-templates>
        	</keyword>
      	</xsl:for-each>
	
				<xsl:for-each-group select="//grg:contact/*" group-by="gmd:organisationName/gco:CharacterString">
        	<xsl:variable name="roles" select="string-join(current-group()/gmd:role/*/geonet:getCodeListValue(/root/gui/schemas, 'iso19139', 'gmd:CI_RoleCode', @codeListValue), ', ')"/>
        	<xsl:if test="normalize-space($roles)!=''">
          	<responsibleParty role="{$roles}" appliesTo="resource">
            	<xsl:if test="descendant::*/gmx:FileName">
              	<xsl:attribute name="logo"><xsl:value-of select="descendant::*/gmx:FileName/@src"/></xsl:attribute>
            	</xsl:if>
            	<xsl:apply-templates mode="responsiblepartysimple" select="."/>
          	</responsibleParty>
        	</xsl:if>
      	</xsl:for-each-group>
	
				<xsl:for-each select="grg:uniformResourceIdentifier/gmd:CI_OnlineResource">
        	<xsl:variable name="protocol" select="gmd:protocol[1]/gco:CharacterString"/>
        	<xsl:variable name="linkage"  select="normalize-space(gmd:linkage/gmd:URL)"/>
        	<xsl:variable name="name">
          	<xsl:for-each select="gmd:name">
            	<xsl:call-template name="localised">
              	<xsl:with-param name="langId" select="$langId"/>
            	</xsl:call-template>
          	</xsl:for-each>
        	</xsl:variable>
	
        	<xsl:variable name="mimeType" select="normalize-space(gmd:name/gmx:MimeFileType/@type)"/>
	
        	<xsl:variable name="desc">
          	<xsl:for-each select="gmd:description">
            	<xsl:call-template name="localised">
              	<xsl:with-param name="langId" select="$langId"/>
            	</xsl:call-template>
          	</xsl:for-each>
        	</xsl:variable>
	
        	<xsl:if test="string($linkage)!=''">
	
            	<xsl:element name="link">
              	<xsl:attribute name="title"><xsl:value-of select="$desc"/></xsl:attribute>
              	<xsl:attribute name="href"><xsl:value-of select="$linkage"/></xsl:attribute>
              	<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
              	<xsl:attribute name="protocol"><xsl:value-of select="$protocol"/></xsl:attribute>
              	<xsl:attribute name="type" select="geonet:protocolMimeType($linkage, $protocol, $mimeType)"/>
            	</xsl:element>
	
        	</xsl:if>
				</xsl:for-each>
	
				<geonet:info>
        	<xsl:copy-of select="geonet:info/*[name(.)!='edit']"/>
        	<xsl:choose>
          	<xsl:when test="/root/gui/env/harvester/enableEditing='false' and geonet:info/isHarvested='y'">
            	<edit>false</edit>
          	</xsl:when>
          	<xsl:otherwise>
            	<xsl:copy-of select="geonet:info/edit"/>
          	</xsl:otherwise>
        	</xsl:choose>
				</geonet:info>
			</metadata>
	</xsl:template>

</xsl:stylesheet>
