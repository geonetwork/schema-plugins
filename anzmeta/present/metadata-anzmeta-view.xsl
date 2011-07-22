<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:geonet="http://www.fao.org/geonetwork" 
	xmlns:exslt="http://exslt.org/common"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="exslt geonet">

  <!-- View templates are available only in view mode and does not provide 
	     editing capabilities. Template MUST start with "view". -->
  <!-- ===================================================================== -->
  <!-- anzmeta-simple -->
  <xsl:template name="metadata-anzmetaview-simple" match="metadata-anzmetaview-simple">

    <xsl:call-template name="md-content">
      <xsl:with-param name="title">
        <xsl:value-of select="citeinfo/title"/>
      </xsl:with-param>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract">
       	<xsl:value-of select="descript/abstract"/>
      </xsl:with-param>
			<!-- no logo image for anzmeta records -->
      <xsl:with-param name="logo"/>
			<!-- no related resources for anzmeta records -->
      <xsl:with-param name="relatedResources"/>
      <xsl:with-param name="tabs">
        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title"
            select="/root/gui/schemas/iso19139/strings/understandResource"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block-anzmeta"
              select="
                 timeperd
                |descript/theme
                |descript/spdom
                "> </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>


        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/contactInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block-anzmeta" select="cntinfo"/> 
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/eml-gbif/strings/otherInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block-anzmeta"
              select="
							 status
              |distinfo
							|dataqual
              "
            > </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>


        <span class="madeBy">
          <xsl:value-of select="concat(/root/gui/strings/changeDate,' ')"/>
					<xsl:choose>
						<xsl:when test="metainfo/metd/date">
							<xsl:value-of select="metainfo/metd/date"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Unknown</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
        </span>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-anzmeta" match="cntinfo|status|distinfo|dataqual|timeperd">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
     	<xsl:with-param name="content">
    		<xsl:apply-templates mode="anzmeta-simple" select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-anzmeta" match="theme">
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
            select="@thesaurus"/>) </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-anzmeta" match="spdom">
    <xsl:apply-templates mode="anzmeta" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit" select="false()"/>
    </xsl:apply-templates>
  </xsl:template>
 
  <xsl:template mode="block-anzmeta" match="*|@*">
    <xsl:apply-templates mode="anzmeta-simple" select="."/>
  </xsl:template>

  <!-- Hide them -->
  <xsl:template mode="anzmeta-simple" match="geonet:*"/>
  
  <!-- Process elements that have <p> (paragraph) children -->

  <xsl:template mode="anzmeta-simple" match="*[p]">
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
				<xsl:for-each select="p">
      		<xsl:value-of select="concat(string(.),'  ')"/>
				</xsl:for-each>
    	</xsl:with-param>
   	</xsl:call-template>
	</xsl:template>

  <!-- Reduce everything to single level -->

  <xsl:template mode="anzmeta-simple" match="*|@*">
    <xsl:choose>
			<xsl:when test="count(*)>0">
       	<xsl:apply-templates mode="anzmeta-simple" select="*|@*"/>
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
