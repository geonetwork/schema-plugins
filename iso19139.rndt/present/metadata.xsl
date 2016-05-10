<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" 
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco" 
                xmlns:gmx="http://www.isotc211.org/2005/gmx" 
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml" 
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork" 
                xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">

    <xsl:import href="metadata-fop.xsl"/>
    <xsl:include href="metadata-rndt.xsl"/>
    <xsl:include href="metadata-view.xsl"/>  
    <xsl:include href="metadata-ovr.xsl"/>
	
    <xsl:template name="iso19139.rndtCompleteTab">
        <xsl:param name="tabLink"/>
        <xsl:param name="schema"/>
  	
        <!-- RNDT tab -->
        <xsl:call-template name="displayTab">
            <xsl:with-param name="tab"     select="'rndt'"/>
            <xsl:with-param name="text"    select="/root/gui/schemas/iso19139.rndt/strings/rndtTab"/>
            <xsl:with-param name="tabLink" select="$tabLink"/>
        </xsl:call-template>  	
  	
        <xsl:call-template name="iso19139CompleteTab">
            <xsl:with-param name="tabLink" select="$tabLink"/>
            <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
    </xsl:template>

    <!-- ===================================================================== -->
    <!-- Overrides iso19139/metadata template at #1304                         -->
    <!-- Forces format to date only (no time)                                  -->
    <!-- gml:TimePeriod (format = %Y-%m-%d)                                    -->
    <!-- ===================================================================== -->

    <xsl:template mode="iso19139" match="gml:*[gml:beginPosition|gml:endPosition]|gml:TimeInstant[gml:timePosition]" priority="3">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:for-each select="*">
            <xsl:choose>
                <xsl:when test="$edit=true() and (name(.)='gml:beginPosition' or name(.)='gml:endPosition' or name(.)='gml:timePosition')">
                    <xsl:apply-templates mode="simpleElement" select=".">
                        <xsl:with-param name="schema"  select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                        <xsl:with-param name="editAttributes" select="$currTab!='rndt' and $currTab!='simple' "/>
                        <xsl:with-param name="text">
                            <xsl:variable name="ref" select="geonet:element/@ref"/>
                            <xsl:variable name="format" select="'%Y-%m-%d'"/>

                            <xsl:call-template name="calendar">
                                <xsl:with-param name="ref" select="$ref"/>
                                <xsl:with-param name="date" select="text()"/>
                                <xsl:with-param name="format" select="$format"/>
                            </xsl:call-template>

                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name(.)='gml:timeInterval'">
                    <xsl:apply-templates mode="iso19139" select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="simpleElement" select=".">
                        <xsl:with-param name="schema"  select="$schema"/>
                        <xsl:with-param name="text">
                            <xsl:value-of select="text()"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
	
    <!-- ===================================================================== -->
    <!-- descriptiveKeywords                                                   -->
    <!-- ===================================================================== -->
    <!-- ===================================================================== -->
    <!-- Overrides iso19139/metadata template at #1056                         -->
    <!-- Uses a complex element also in presentation mode in order to          -->
    <!-- show the thesaurus part of a metadata keyword.                        -->
    <!-- ===================================================================== -->
    <xsl:template mode="iso19139" match="gmd:descriptiveKeywords" priority="2">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
		
        <xsl:choose>
            <xsl:when test="$edit=true()">
				
                <xsl:variable name="content">
                    <xsl:for-each select="gmd:MD_Keywords">
                        <tr>
                            <td class="padded-content" width="100%" colspan="2">
                                <table width="100%">
                                    <tr>
                                        <td width="50%" valign="top">
                                            <table width="100%">
                                                <xsl:apply-templates mode="elementEP" select="gmd:keyword|geonet:child[string(@name)='keyword']">
                                                    <xsl:with-param name="schema" select="$schema"/>
                                                    <xsl:with-param name="edit"   select="$edit"/>
                                                </xsl:apply-templates>
                                                <xsl:apply-templates mode="elementEP" select="gmd:type|geonet:child[string(@name)='type']">
                                                    <xsl:with-param name="schema" select="$schema"/>
                                                    <xsl:with-param name="edit"   select="$edit"/>
                                                </xsl:apply-templates>
                                            </table>
                                        </td>
                                        <td valign="top">
                                            <table width="100%">
                                                <xsl:apply-templates mode="elementEP" select="gmd:thesaurusName|geonet:child[string(@name)='thesaurusName']">
                                                    <xsl:with-param name="schema" select="$schema"/>
                                                    <xsl:with-param name="edit"   select="$edit"/>
                                                </xsl:apply-templates>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:variable>
				
                <xsl:apply-templates mode="complexElement" select=".">
                    <xsl:with-param name="schema"  select="$schema"/>
                    <xsl:with-param name="edit"    select="$edit"/>
                    <xsl:with-param name="content" select="$content"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- We use a complexElement here in order to show the thesaurus part -->
                <xsl:apply-templates mode="complexElement" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="text">
                        <xsl:variable name="value">
                            <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="gmx:Anchor">
                                        <a href="{gmx:Anchor/@xlink:href}">
                                            <xsl:value-of select="if (gmx:Anchor/text()) then gmx:Anchor/text() else gmx:Anchor/@xlink:href"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
										
                                        <xsl:call-template name="translatedString">
                                            <xsl:with-param name="schema" select="$schema"/>
                                            <xsl:with-param name="langId">
                                                <xsl:call-template name="getLangId">
                                                    <xsl:with-param name="langGui" select="/root/gui/language"/>
                                                    <xsl:with-param name="md" select="ancestor-or-self::*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']" />
                                                </xsl:call-template>
                                            </xsl:with-param>
                                        </xsl:call-template>
										
                                    </xsl:otherwise>
                                </xsl:choose>
								
                            </xsl:for-each>
                            <xsl:if test="gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue!=''">
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                            <xsl:text>.</xsl:text>
                        </xsl:variable>
                        <table width="100%">
                            <tr>
                                <td colspan="2">
                                    <xsl:copy-of select="$value"/>
                                </td>
                            </tr>
                            <xsl:variable name="thesaurusTitle" select="gmd:MD_Keywords/gmd:thesaurusName/*/gmd:title/*[1]"/>
                            <xsl:for-each select="gmd:MD_Keywords/gmd:thesaurusName/*/gmd:identifier/*/gmd:code/gmx:Anchor[starts-with(string(),'geonetwork.thesaurus')]">
                                <tr>
                                    <td width="20%">
                                        <xsl:value-of select="/root/gui/strings/thesaurus/thesaurus"/>
                                    </td>
                                    <td>
                                        <a href="{@xlink:href}">
                                            <xsl:choose>
                                                <xsl:when test="normalize-space($thesaurusTitle)!=''">
                                                    <xsl:value-of select="$thesaurusTitle"/>
                                                </xsl:when>
                                                <xsl:when test="normalize-space()!=''">
                                                    <xsl:value-of select="text()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@src"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
