<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/terms/" 
	xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
  xmlns:geonet="http://www.fao.org/geonetwork" 
	xmlns:exslt="http://exslt.org/common"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="eml dc exslt geonet">

  <!-- View templates are available only in view mode and does not provide 
	     editing capabilities. Template MUST start with "view". -->
  <!-- ===================================================================== -->
  <!-- eml-gbif-simple -->
  <xsl:template name="metadata-eml-gbifview-simple" match="metadata-eml-gbifview-simple">

    <xsl:call-template name="md-content">
      <xsl:with-param name="title">
        <xsl:value-of select="dataset/title"/>
      </xsl:with-param>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract">
				<xsl:for-each select="dataset/abstract/para">
        	<xsl:value-of select="concat(string(.),'  ')"/>
				</xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="logo">
				<xsl:variable name="url" select="additionalMetadata/metadata/gbif/resourceLogoUrl"/>
    		<a href="{$url}" rel="lightbox-viewset">
      		<img class="logo" src="{$url}" alt="thumbnail" title="{$url}"/>
    		</a>
      </xsl:with-param>
      <xsl:with-param name="relatedResources">
				<xsl:apply-templates mode="relatedResources" select="dataset/distribution|additionalMetadata/metadata/gbif/physical/distribution"/>
			</xsl:with-param>
      <xsl:with-param name="tabs">
        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title"
            select="/root/gui/schemas/iso19139/strings/understandResource"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block-eml-gbif"
              select="
                 dataset/pubDate
                |dataset/language
                |dataset/keywordSet
                |dataset/coverage/geographicCoverage
                |dataset/coverage/taxonomicCoverage
                "> </xsl:apply-templates>

          </xsl:with-param>
        </xsl:call-template>


        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/contactInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block-eml-gbif" select="dataset/contact"/> 
            <xsl:apply-templates mode="block-eml-gbif" select="dataset/associatedParty[role='pointOfContact']"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/eml-gbif/strings/otherInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block-eml-gbif"
              select="
               dataset/intellectualRights
							|dataset/purpose
							|dataset/methods
							|dataset/project
              "
            > </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>


        <span class="madeBy">
          <xsl:value-of select="/root/gui/strings/changeDate"/>
					<xsl:choose>
						<xsl:when test="additionalMetadata/metadata/gbif/dateStamp">
							<xsl:value-of select="additionalMetadata/metadata/gbif/dateStamp"/>
						</xsl:when>
						<xsl:when test="dataset/pubDate">
							<xsl:value-of select="dataset/pubDate"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Unknown</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
        </span>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-eml-gbif" match="intellectualRights|abstract|samplingDescription|funding|purpose">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
     	<xsl:with-param name="content">
				<xsl:for-each select="para">
					<p><xsl:value-of select="string(.)"/></p>
				</xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-eml-gbif" match="contact|associatedParty|project|methods|taxonomicCoverage">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="eml-gbif-simple" select="@*|*">
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-eml-gbif" match="keywordSet">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:for-each select="keyword">
          <xsl:value-of select="string-join(., ', ')"/> (<xsl:value-of
            select="../keywordThesaurus"/>) </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-eml-gbif" match="geographicCoverage">
    <xsl:apply-templates mode="eml-gbif">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit" select="false()"/>
    </xsl:apply-templates>
  </xsl:template>
 
  <xsl:template mode="block-eml-gbif" match="*|@*">
    <xsl:apply-templates mode="eml-gbif-simple" select="."/>
  </xsl:template>


  <!-- List of related resources defined in the online resource section of the metadata record.
-->
  <xsl:template mode="relatedResources" match="distribution">
    <table class="related">
      <tbody>
        <tr style="display:none;">
          <td class="main"></td><td></td>
        </tr>
        <xsl:for-each-group select="descendant::online[url!='']" group-by="url/@function">
        <tr>
          <td class="main">
            <span><xsl:value-of select="normalize-space(current-grouping-key())"/></span>
          </td>
          <td>
            <ul>
              <xsl:for-each select="current-group()">
                <li>
                  <a href="{url}"><xsl:value-of select="url"/></a>
                </li>
              </xsl:for-each>
            </ul>
          </td>
        </tr>
      </xsl:for-each-group>
      </tbody>
    </table>
  </xsl:template>

  <!-- Hide them -->
  <xsl:template mode="eml-gbif-simple" match="geonet:*"/>
  
  <!-- Process elements that have a description child separately -->

  <xsl:template mode="eml-gbif-simple" match="*[description]">
    <xsl:call-template name="simpleElement">
      <xsl:with-param name="id" select="generate-id(.)"/>
      <xsl:with-param name="title">
      	<xsl:call-template name="getTitle">
         	<xsl:with-param name="name" select="name(.)"/>
         	<xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="help"></xsl:with-param>
      <xsl:with-param name="content">
				<xsl:for-each select="description/para">
      		<xsl:value-of select="string(.)"/>
				</xsl:for-each>
    	</xsl:with-param>
   	</xsl:call-template>
	</xsl:template>

  <!-- Process elements that have a para child separately -->

  <xsl:template mode="eml-gbif-simple" match="*[para]">
    <xsl:call-template name="simpleElement">
      <xsl:with-param name="id" select="generate-id(.)"/>
      <xsl:with-param name="title">
      	<xsl:call-template name="getTitle">
         	<xsl:with-param name="name" select="name(.)"/>
         	<xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="help"></xsl:with-param>
      <xsl:with-param name="content">
				<xsl:for-each select="para">
      		<xsl:value-of select="string(.)"/>
				</xsl:for-each>
    	</xsl:with-param>
   	</xsl:call-template>
	</xsl:template>

  <!-- Reduce everything to single level -->

  <xsl:template mode="eml-gbif-simple" match="*|@*">
    <xsl:choose>
			<xsl:when test="count(*)>0">
       	<xsl:apply-templates mode="eml-gbif-simple" select="*|@*"/>
			</xsl:when>
			<xsl:otherwise>
    		<xsl:call-template name="simpleElement">
      		<xsl:with-param name="id" select="generate-id(.)"/>
      		<xsl:with-param name="title">
        		<xsl:call-template name="getTitle">
          		<xsl:with-param name="name" select="name(.)"/>
          		<xsl:with-param name="schema" select="$schema"/>
        		</xsl:call-template>
      		</xsl:with-param>
      		<xsl:with-param name="help"></xsl:with-param>
      		<xsl:with-param name="content">
        		<xsl:value-of select="string(.)"/>
    	  	</xsl:with-param>
    		</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

</xsl:stylesheet>
