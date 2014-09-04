<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml"
  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:sdn="http://www.seadatanet.org"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="#all">


  <xsl:template mode="iso19139.sdn-csr" match="sdn:SDN_PortCode">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit" select="$edit"/>
    </xsl:call-template>
  </xsl:template>
  
  
  <!-- Those elements should be boxed. -->
  <xsl:template mode="iso19139.sdn-csr" match="gmi:acquisitionInformation">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:apply-templates mode="complexElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  
  <xsl:template mode="iso19139.sdn-csr"
    match="
    gmi:*[gco:CharacterString]|
    sdn:*[gco:CharacterString]
    "
    priority="100">
    <xsl:param name="schema" />
    <xsl:param name="edit" />
    
    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template mode="iso19139.sdn-csr" match="sdn:*"/>
  <xsl:template mode="iso19139.sdn-csr" match="gmi:*"/>
  
  
  
  <xsl:template mode="iso19139.sdn-csr" match="gmd:descriptiveKeywords">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:choose>
      <!-- Same as ISO19139 -->
      <xsl:when test="$edit=true()">
        
        <xsl:apply-templates mode="complexElement" select=".">
          <xsl:with-param name="schema"  select="$schema"/>
          <xsl:with-param name="edit"    select="$edit"/>
          <xsl:with-param name="content">
            
            <xsl:variable name="thesaurusName" select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"></xsl:variable>
            <xsl:variable name="thesaurusCode" select="if (gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/
              gmd:identifier/gmd:MD_Identifier/gmd:code) then gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/
              gmd:identifier/gmd:MD_Identifier/gmd:code else /root/gui/thesaurus/thesauri/thesaurus[title=$thesaurusName]/key"/>
            
            <!-- Check that thesaurus is available locally. Check that the thesaurus is available in the catalogue to not 
              to try to initialize a widget with a non existing thesaurus.  -->
            <xsl:variable name="isThesaurusAvailable"
              select="count(/root/gui/thesaurus/thesauri/thesaurus[key = $thesaurusCode]) > 0"></xsl:variable>
            
            <xsl:choose>
              <!-- If a thesaurus is attached to that keyword group 
              use a snippet editor.-->
              <xsl:when test="$isThesaurusAvailable">
                <xsl:apply-templates select="gmd:MD_Keywords" mode="snippet-editor">
                  <xsl:with-param name="edit" select="$edit"/>
                  <xsl:with-param name="schema" select="$schema"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="content">
                  <xsl:apply-templates select="gmd:MD_Keywords" mode="classic-editor">
                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="schema" select="$schema"/>
                  </xsl:apply-templates>
                </xsl:variable>
                
                <xsl:call-template name="columnElementGui">
                  <xsl:with-param name="cols" select="$content"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            
            
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="title">
            <xsl:call-template name="getTitle">
              <xsl:with-param name="name" select="name(.)"/>
              <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
            <xsl:if test="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString">
              (<xsl:value-of
                select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>)
            </xsl:if>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:variable name="value">
              <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
                <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
                
                <xsl:choose>
                  <xsl:when test="gmx:Anchor">
                    <a href="{gmx:Anchor/@xlink:href}"><xsl:value-of select="if (gmx:Anchor/text()) then gmx:Anchor/text() else gmx:Anchor/@xlink:href"/></a>
                  </xsl:when>
                  <xsl:when test="sdn:*">
                    <xsl:value-of select="sdn:*/text()"/> (<xsl:value-of select="sdn:*/@codeListValue"/>)
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
              <xsl:variable name="type" select="gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/>
              <xsl:if test="$type">
                  <xsl:variable name="typeLabel"
                      select="/root/gui/schemas/*[name(.)='iso19139']/codelists/codelist[@name = 'gmd:MD_KeywordTypeCode']/
                      entry[code = $type]/label"/>
                  (<xsl:value-of select="if ($typeLabel != '') then $typeLabel else $type"/>)
              </xsl:if>
            </xsl:variable>
            <xsl:copy-of select="$value"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  
  
  <!-- In view mode display keywords properly -->
  <xsl:template mode="block" match="gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords"
    priority="91">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
        
        <xsl:if test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString">
          (<xsl:value-of
            select="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>)
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="helpLink">
        <xsl:call-template name="getHelpLink">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="name" select="name(.)"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:for-each select="gmd:keyword">
          <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
          
          
          <xsl:choose>
            <xsl:when test="gmx:Anchor">
              <a href="{gmx:Anchor/@xlink:href}"><xsl:value-of select="if (gmx:Anchor/text()) then gmx:Anchor/text() else gmx:Anchor/@xlink:href"/></a>
            </xsl:when>
            <xsl:when test="sdn:*">
              <xsl:value-of select="."/> (<xsl:value-of select="@codeListValue"/>)
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
        
        
        <xsl:variable name="type" select="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/>
        <xsl:if test="$type">
          (<xsl:value-of
            select="/root/gui/schemas/*[name(.)='iso19139']/codelists/codelist[@name = 'gmd:MD_KeywordTypeCode']/
            entry[code = $type]/label"/>)
        </xsl:if>
        
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
