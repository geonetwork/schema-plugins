<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gts="http://www.isotc211.org/2005/gts"
        xmlns:gco="http://www.isotc211.org/2005/gco"
        xmlns:gmx="http://www.isotc211.org/2005/gmx"
        xmlns:srv="http://www.isotc211.org/2005/srv"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:gml="http://www.opengis.net/gml"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:geonet="http://www.fao.org/geonetwork"
        xmlns:exslt="http://exslt.org/common"
        xmlns:ngmp="urn:int:nato:geometoc:geo:metadata:ngmp:1.0"
        
        exclude-result-prefixes="#all">

        <xsl:template name="iso19139.ngmpBrief">
                <metadata>
                        <xsl:choose>
                                <xsl:when test="geonet:info/isTemplate='s'">
                                        <xsl:call-template name="iso19139-subtemplate"/>
                                        <xsl:copy-of select="geonet:info" copy-namespaces="no"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:call-template name="iso19139-brief"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </metadata>
        </xsl:template>

	<!-- delegates to iso19139 -->
        <xsl:template name="iso19139.ngmpCompleteTab">
                <xsl:param name="tabLink"/>

                <xsl:call-template name="iso19139CompleteTab"> 
                        <xsl:with-param name="tabLink"   select="$tabLink"/>
                        <xsl:with-param name="schema"    select="'iso19139'"/>
                </xsl:call-template>
        </xsl:template>

        <!-- main template - the way into processing iso19139.ngmp -->
        <xsl:template name="metadata-iso19139.ngmp">
                <xsl:param name="schema"/>
                <xsl:param name="edit" select="false()"/>
                <xsl:param name="embedded"/>

                <xsl:apply-templates mode="iso19139" select="." >
                     <xsl:with-param name="schema" select="$schema"/>
                     <xsl:with-param name="edit"   select="$edit"/>
                     <xsl:with-param name="embedded" select="$embedded" />
                </xsl:apply-templates>
        </xsl:template>

  <!-- ==================================================================== -->
  <!-- === Javascript used by functions in this presentation XSLT -->
  <!-- ==================================================================== -->

        <!-- Javascript used by functions in this XSLT -->
        <xsl:template name="iso19139.ngmp-javascript">
            <xsl:call-template name="iso19139-javascript" />
        </xsl:template>

  <!-- ==================================================================== -->
  <!-- === Codelists in keywords -->
  <!-- ==================================================================== -->

	<xsl:template mode="iso19139" match="gmd:descriptiveKeywords[.//ngmp:*]">
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
			<xsl:otherwise> <!-- not editing -->

                <xsl:apply-templates mode="simpleElement" select="gmd:MD_Keywords/gmd:keyword">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title">
                        <xsl:call-template name="getTitle">
                            <xsl:with-param name="name"   select="name(.//ngmp:*)"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name"   select="name(.//ngmp:*)"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text">
                        <!--<xsl:apply-templates mode="iso19139GetAttributeText" select="*/@codeListValue">-->
                        <xsl:apply-templates mode="iso19139GetAttributeText" select=".//ngmp:*/@codeListValue">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>
                    </xsl:with-param>
                </xsl:apply-templates>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <!-- ==================================================================== -->
  <!-- === Constraints: releasibility -->
  <!-- ==================================================================== -->


	<xsl:template mode="iso19139" match="ngmp:NGMP_Constraints">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">
                <xsl:comment>TODO ngmp:NGMP_Constraints </xsl:comment>
            </xsl:when>
			<xsl:otherwise> <!-- not editing -->
                <xsl:apply-templates mode="complexElement" select=".//ngmp:NGMP_Releasibility">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title">
                        <xsl:call-template name="getTitle">
                            <xsl:with-param name="name"   select="'ngmp:NGMP_Releasibility'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name"   select="'ngmp:NGMP_Releasibility'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:apply-templates>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="iso19139" match="ngmp:statement">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">
                <xsl:comment>TODO ngmp:NGMP_Constraints </xsl:comment>
            </xsl:when>
			<xsl:otherwise> <!-- not editing -->

                <xsl:apply-templates mode="simpleElement" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title">
                        <xsl:call-template name="getTitle">
                            <xsl:with-param name="name"   select="name(.//ngmp:*)"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name"   select="name(.//ngmp:*)"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="text">
                        <!--<xsl:apply-templates mode="iso19139GetAttributeText" select="*/@codeListValue">-->
                        <xsl:apply-templates mode="iso19139GetAttributeText" select=".//ngmp:*/@codeListValue">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>
                    </xsl:with-param>
                </xsl:apply-templates>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template mode="iso19139" match="gmd:EX_VerticalExtent">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

    <xsl:template mode="iso19139" match="gmd:verticalCRS">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>

<!--    <xsl:template mode="elementEP" match="gmd:verticalCRS/@xlink:title">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

        <xsl:apply-templates mode="simpleElement" select=".">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>-->

<!--  <xsl:template mode="block" match="gmd:verticalCRS/@xlink:title">
    <xsl:apply-templates mode="block" select="*"/>
  </xsl:template>-->

	<!--<xsl:template mode="iso19139" match="gmd:*[*/@codeList]|srv:*[*/@codeList]">-->
<!--	<xsl:template mode="iso19139" match="gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword[ngmp:*/@codeList]" priority="1999">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
        <b>ECCO</b>
		<xsl:call-template name="iso19139Codelist">
			<xsl:with-param name="schema" select="'iso19139.ngmp'"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>-->

  <!-- these elements should be boxed -->
<!--  <xsl:template mode="iso19139-simple"
    match="gmd:identificationInfo|gmd:distributionInfo
    |gmd:descriptiveKeywords|gmd:thesaurusName
    |gmd:spatialRepresentationInfo
    |gmd:pointOfContact|gmd:contact
    |gmd:dataQualityInfo
    |gmd:MD_Constraints|gmd:MD_LegalConstraints|gmd:MD_SecurityConstraints
    |gmd:referenceSystemInfo|gmd:equivalentScale|gmd:projection|gmd:ellipsoid
    |gmd:extent|gmd:geographicBox|gmd:EX_TemporalExtent
    |gmd:MD_Distributor
    |srv:containsOperations|srv:SV_CoupledResource|gmd:metadataConstraints"
    priority="2">-->
<!--  <xsl:template mode="iso19139-simple"
    match="ngmp:NGMP_Constraints"
    priority="2">

	<xsl:variable name="schema" select="'iso19139.ngmp'"/>

    <xsl:call-template name="complexElement">
      <xsl:with-param name="id" select="generate-id(.)"/>
      <xsl:with-param name="title">
        <xsl:call-template name="getTitle">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="helpLink">
        <xsl:call-template name="getHelpLink">
          <xsl:with-param name="name" select="name(.)"/>
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="iso19139-simple" select="@*|*">
          <xsl:with-param name="schema" select="$schema"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>-->

</xsl:stylesheet>
