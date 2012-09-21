<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dc="http://purl.org/dc/terms/" 
	xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
	xmlns:exslt= "http://exslt.org/common">

	<xsl:import href="metadata-fop.xsl"/>

<!-- EML-GBIF Presentation xslt -->

	<!-- main template - the way into processing eml-gbif -->
  <xsl:template name="metadata-eml-gbif">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

    <xsl:apply-templates mode="eml-gbif" select="." >
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="embedded" select="$embedded" />
    </xsl:apply-templates>
  </xsl:template>	

	<!-- CompleteTab template - eml-gbif just calls completeTab from 
	     metadata-utils.xsl -->
	<xsl:template name="eml-gbifCompleteTab">
		<xsl:param name="tabLink"/>

		<xsl:call-template name="displayTab">
      <xsl:with-param name="tab"     select="'dataset'"/>
      <xsl:with-param name="text"    select="'Dataset'"/>
      <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
      <xsl:with-param name="tabLink" select="$tabLink"/>
    </xsl:call-template>

		<xsl:call-template name="displayTab">
      <xsl:with-param name="tab"     select="'additional'"/>
      <xsl:with-param name="text"    select="'Additional'"/>
      <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
      <xsl:with-param name="tabLink" select="$tabLink"/>
    </xsl:call-template>
	</xsl:template>

	<!-- default template -->

	<xsl:template mode="eml-gbif" match="*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:apply-templates mode="element" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="true()"/>
					<xsl:with-param name="flat"   select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:apply-templates mode="element" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="false()"/>
					<xsl:with-param name="flat"   select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
				</xsl:apply-templates>
				
			</xsl:otherwise>
		</xsl:choose>
			
	</xsl:template>

	<!-- The main template that gets called on the root element eml:eml -->

  <xsl:template mode="eml-gbif" match="eml:eml">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<xsl:choose>
			
		<!-- dataset tab -->
		<xsl:when test="$currTab='dataset'">
   		<xsl:apply-templates mode="elementEP" select="dataset">
    		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
   		</xsl:apply-templates>
		</xsl:when>

		<!-- additional tab -->
		<xsl:when test="$currTab='additional'">
   		<xsl:apply-templates mode="elementEP" select="additionalMetadata">
    		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
   		</xsl:apply-templates>
		</xsl:when>

		<xsl:otherwise>
   		<xsl:apply-templates mode="elementEP" select="dataset">
    		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
   		</xsl:apply-templates>
			
   		<xsl:apply-templates mode="elementEP" select="additionalMetadata">
    		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
   		</xsl:apply-templates>
		</xsl:otherwise>

		</xsl:choose>
  </xsl:template>

	<!-- these elements should be boxed -->

  <xsl:template mode="eml-gbif" match="dataset|additionalMetadata|creator|metadataProvider|associatedParty|keywordSet|contact|methods|project|physical|collection|coverage|geographicCoverage|temporalCoverage|taxonomicCoverage">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

  	<xsl:apply-templates mode="complexElement" select=".">
    		<xsl:with-param name="schema" select="$schema"/>
    		<xsl:with-param name="edit"   select="$edit"/>
   	</xsl:apply-templates>
  </xsl:template>

	<!-- handle the url element - sometimes has an attribute 'function' -->

	<xsl:template mode="eml-gbif" match="url">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<!-- FIXME: decide what to do based on attribute function -->
		<xsl:if test="@function='download'">
		</xsl:if>
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
		 	<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>
				
	<!-- handle the title element - sometimes has an attribute xml:lang -->

	<xsl:template mode="eml-gbif" match="title">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
		 	<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>
				
	<!-- keywords are processed to add thesaurus name in brackets afterwards -->

	<xsl:template mode="eml-gbif" match="keywordSet">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=false()">
				<xsl:variable name="keyword">
					<xsl:for-each select="keyword">
						<xsl:if test="position() &gt; 1">,  </xsl:if>
						<xsl:value-of select="."/>
					</xsl:for-each>
					<xsl:if test="keywordThesaurus">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="keywordThesaurus"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
				</xsl:variable>
				<xsl:apply-templates mode="simpleElement" select=".">
		   		<xsl:with-param name="schema" select="$schema"/>
		   		<xsl:with-param name="edit"   select="$edit"/>
		   		<xsl:with-param name="text" 	 select="$keyword"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="complexElement" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- beginDate, endDate -->

	<xsl:template mode="eml-gbif" match="beginDate|endDate">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" 	 select="calendarDate"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- All the fields selected by this template can have embedded <para> tags 
     	 that need to be changed to HTML <p> tags -->

	<xsl:template mode="eml-gbif" match="abstract|additionalInfo|intellectualRights|purpose|description|samplingDescription|funding">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="name(.)='abstract'">10</xsl:when>
        <xsl:otherwise>3</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text">
			 	<xsl:choose>
					<xsl:when test="para">
			 			<xsl:for-each select="para">
							<p><xsl:value-of select="."/></p>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			 </xsl:with-param>
			 <xsl:with-param name="rows" select="$rows" />
		</xsl:apply-templates>
	</xsl:template>

	<!-- boundingCoordinates -->

	<xsl:template mode="eml-gbif" match="boundingCoordinates">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="eltRef" select="generate-id(.)"/>

		<tr>
			<td colspan="2">

		<table>
			<tr>
				<td colspan="3">
		<!-- Loop on all projections defined in config-gui.xml -->
		<xsl:for-each select="/root/gui/config/map/proj/crs">
   	 	 <input id="{@code}_{$eltRef}" type="radio" class="proj" name="proj_{$eltRef}" value="{@code}">
     		<xsl:if test="@default='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
       </input>
       <!-- Set label from loc file -->
       <label for="{@code}_{$eltRef}">
       	<xsl:variable name="code" select="@code"/>
       	<xsl:choose>
        	<xsl:when test="/root/gui/strings/*[@code=$code]"><xsl:value-of select="/root/gui/strings/*[@code=$code]"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="@code"/></xsl:otherwise>
        </xsl:choose>
       </label>
       <xsl:text> </xsl:text>
    </xsl:for-each>
				</td>
			</tr>

		<xsl:variable name="w" select="westBoundingCoordinate"/>
    <xsl:variable name="e" select="eastBoundingCoordinate"/>
    <xsl:variable name="n" select="northBoundingCoordinate"/>
    <xsl:variable name="s" select="southBoundingCoordinate"/>
		
			<tr>
				<td/>
				<td class="padded" align="center">
					<xsl:apply-templates mode="eml-gbifVertElement" select="$n">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="eltRef" select="concat('n', $eltRef)"/>
					</xsl:apply-templates>
				</td>
				<td/>
			</tr>
			<tr>
				<td class="padded" align="center">
					<xsl:apply-templates mode="eml-gbifVertElement" select="$w">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="eltRef" select="concat('w', $eltRef)"/>
					</xsl:apply-templates>
				</td>
				
				<td width="100" height="100" align="center">
					<xsl:variable name="wID" select="concat('w',$eltRef)"/>
        	<xsl:variable name="eID" select="concat('e',$eltRef)"/>
        	<xsl:variable name="sID" select="concat('s',$eltRef)"/>
        	<xsl:variable name="nID" select="concat('n',$eltRef)"/>
					<xsl:variable name="geom" >
						<xsl:value-of select="concat('Polygon((', $w, ' ', $s,',',$e,' ',$s,',',$e,' ',$n,',',$w,' ',$n,',',$w,' ',$s, '))')"/>
        	</xsl:variable>
					<xsl:call-template name="showMap">
						<xsl:with-param name="edit" select="$edit" />
          	<xsl:with-param name="mode" select="'bbox'" />
          	<xsl:with-param name="coords" select="$geom"/>
          	<xsl:with-param name="watchedBbox" select="concat($wID, ',', $sID, ',', $eID, ',', $nID)"/>
          	<xsl:with-param name="eltRef" select="$eltRef"/>
        	</xsl:call-template>
				</td>
				
				<td class="padded" align="center">
					<xsl:apply-templates mode="eml-gbifVertElement" select="$e">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="eltRef" select="concat('e', $eltRef)"/>
					</xsl:apply-templates>
				</td>
			</tr>
			<tr>
				<td/>
				<td class="padded" align="center">
					<xsl:apply-templates mode="eml-gbifVertElement" select="$s">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="eltRef" select="concat('s', $eltRef)"/>
					</xsl:apply-templates>
				</td>
				<td/>
			</tr>
		</table>

			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="eml-gbifVertElement" match="*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="eltRef" />
		
		<xsl:variable name="title">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="helpLink">
			<xsl:call-template name="getHelpLink">
				<xsl:with-param name="name"   select="name(.)"/>
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<b>
			<xsl:choose>
				<xsl:when test="$helpLink!=''">
					<span id="tip.{$helpLink}" style="cursor:help;">
						<xsl:value-of select="$title" />
            <xsl:call-template name="asterisk">
							<xsl:with-param name="link" select="$helpLink" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:call-template>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$title"/>
				</xsl:otherwise>
			</xsl:choose>
		</b>
		<br/>
		<xsl:variable name="size" select="'8'"/>

        <xsl:choose>
        	<!-- Hidden text field is use to store WGS84 values which are stored in metadata records. -->
            <xsl:when test="$edit=true()">
                <xsl:call-template name="getElementText">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="edit" select="$edit" />
                    <xsl:with-param name="cols" select="$size" />
                    <xsl:with-param name="validator" select="'validateNumber(this, false)'" />
                    <xsl:with-param name="no_name" select="true()" />
                </xsl:call-template>
                <xsl:call-template name="getElementText">
                    <xsl:with-param name="schema" select="$schema" />
                    <xsl:with-param name="edit" select="true()" />
                    <xsl:with-param name="cols" select="$size" />
                    <xsl:with-param name="input_type" select="'hidden'" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <input class="md" type="text" id="{$eltRef}" value="{text()}" readonly="readonly" size="{$size}"/>
                <input class="md" type="hidden" id="_{$eltRef}" name="_{$eltRef}" value="{text()}" readonly="readonly"/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>

	<!-- mailto link -->

  <xsl:template mode="eml-gbif" match="electronicMailAddress">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:apply-templates mode="simpleElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="text">
        <a href="mailto:{.}"><xsl:value-of select="."/></a>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- eml-gbif brief formatting 																			 -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
	<xsl:template name="eml-gbifBrief">
		<metadata>
			<title><xsl:value-of select="normalize-space(dataset/title[1])"/></title>
			<abstract><xsl:value-of select="dataset/abstract"/></abstract>

			<xsl:for-each select="dataset/keywordSet/keyword">
				<xsl:copy-of select="."/>
			</xsl:for-each>

			<geoBox>
					<westBL><xsl:value-of select="dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate"/></westBL>
					<eastBL><xsl:value-of select="dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate"/></eastBL>
				  <southBL><xsl:value-of select="dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate"/></southBL>
				  <northBL><xsl:value-of select="dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate"/></northBL>
			</geoBox>
			<xsl:copy-of select="geonet:info"/>
		</metadata>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT          -->
	<!-- =================================================================== -->
	<xsl:template name="eml-gbif-javascript"/>

</xsl:stylesheet>
