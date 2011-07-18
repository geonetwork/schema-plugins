<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:exslt= "http://exslt.org/common">

<!-- Good old ANZLIC Metadata Format Version 1.3/2.0 as delivered from Z39.50
     servers in the ASDD

		 Simon Pigot, September-January 2006 -->

	<!-- main template - the way into processing anzmeta -->
	<xsl:template name="metadata-anzmetaview-simple">
		<xsl:message>ANZMETA SIMPLE VIEW</xsl:message>
	</xsl:template>

  <xsl:template name="metadata-anzmeta">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

    <xsl:apply-templates mode="anzmeta" select="." >
    	<xsl:with-param name="schema" select="$schema"/>
     	<xsl:with-param name="edit"   select="$edit"/>
     	<xsl:with-param name="embedded" select="$embedded" />
    </xsl:apply-templates>
  </xsl:template>	

	<!-- CompleteTab template - anzmeta just calls completeTab from 
	     metadata-utils.xsl -->
	<xsl:template name="anzmetaCompleteTab">
		<xsl:param name="tabLink"/>

		<xsl:call-template name="completeTab">
			<xsl:with-param name="tabLink" select="$tabLink"/>
		</xsl:call-template>
	</xsl:template>

<!-- default: in simple mode just a flat list -->

  <xsl:template mode="anzmeta" match="*|@*">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

   	<xsl:apply-templates mode="element" select=".">
    	<xsl:with-param name="schema" select="$schema"/>
     	<xsl:with-param name="edit"   select="$edit"/>
     	<xsl:with-param name="flat"   select="$currTab='simple'"/>
   	</xsl:apply-templates>
  </xsl:template>

<!-- these elements should be boxed + citeinfo and spdom below -->

  <xsl:template mode="anzmeta" match="timeperd|status|distinfo|dataqual|cntinfo|metainfo|attrinf|qsiispage1">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

  	<xsl:apply-templates mode="complexElement" select=".">
    		<xsl:with-param name="schema" select="$schema"/>
    		<xsl:with-param name="edit"   select="$edit"/>
   	</xsl:apply-templates>
  </xsl:template>

<!-- these elements are ignored because their contents are processed 
elsewhere -->

  <xsl:template mode="anzmeta" match="coordref">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
	</xsl:template>

<!-- these elements need internal processing to remove additional xml tags -->

<!-- jurisdic -->

	<xsl:template mode="anzmeta" match="jurisdic">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" select="keyword"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- abstract,lineage,posacc,logic,complete -->

	<xsl:template mode="anzmeta" match="abstract|lineage|posacc|attracc|logic|complete|accconst">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="text">
				<!-- <div style="text-align: left;"><xsl:copy-of select="."/></div> -->
				<xsl:copy-of select="."/>
		</xsl:variable>

		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" select="$text"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- native, avlform -->

	<xsl:template mode="anzmeta" match="native|avlform">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:variable name="digform">
			<xsl:for-each select="digform|nondig">
				<xsl:if test="name(.)='digform'">
						<xsl:text>Digital: </xsl:text>
				</xsl:if>
				<xsl:value-of select="formname"/><br/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" 	 select="$digform"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- theme, progress, update, place, sprep-vector, sprep-raster -->

	<xsl:template mode="anzmeta" match="theme|progress|update|place|sprep-vector|sprep-raster">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:variable name="keyword">
			<xsl:for-each select="keyword">
				<xsl:choose>
				<xsl:when test="contains(.,'()')">
					<xsl:value-of select="normalize-space(substring-before(.,'()'))"/><br/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/><br/>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" 	 select="$keyword"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- begdate, enddate -->

	<xsl:template mode="anzmeta" match="begdate|enddate">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" 	 select="date|keyword"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- metd -->

	<xsl:template mode="anzmeta" match="metd">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="text" select="date"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- supplinf -->

	<xsl:template mode="anzmeta" match="supplinf">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:variable name="content">
				<div style="text-align: left;"><xsl:copy-of select="."/></div>
		</xsl:variable>
		<xsl:apply-templates mode="complexElement" select=".">
		   <xsl:with-param name="schema" select="$schema"/>
		   <xsl:with-param name="edit"   select="$edit"/>
		   <xsl:with-param name="content"  select="$content"/>
		</xsl:apply-templates>
	</xsl:template>

<!-- spdom - add preview image and rest of the geobox elements -->

	<xsl:template mode="anzmeta" match="spdom">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="content">
			<xsl:apply-templates mode="elementEP" select="place">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:call-template name="geoBox">
	      <xsl:with-param name="schema"  select="$schema"/>
	      <xsl:with-param name="edit"    select="$edit"/>
	  	</xsl:call-template>
		
		</xsl:variable>

		<xsl:variable name="title">
			<xsl:call-template name="getTitle">
			   <xsl:with-param name="name"   select="'spdom'"/>
				 <xsl:with-param name="schema" select="$schema"/>
		  </xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="complexElementGui">
	     <xsl:with-param name="title"  select="$title"/>
	     <xsl:with-param name="content" select="$content"/>
	     <xsl:with-param name="schema"    select="$schema"/>
	  </xsl:call-template>
	</xsl:template>

	<!-- geoBox -->

	<xsl:template name="geoBox">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="eltRef" select="generate-id(.)"/>

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

		<xsl:variable name="w" select="bounding/westbc"/>
    <xsl:variable name="e" select="bounding/eastbc"/>
    <xsl:variable name="n" select="bounding/northbc"/>
    <xsl:variable name="s" select="bounding/southbc"/>
		
		<table>
			<tr>
				<td/>
				<td class="padded" align="center">
					<xsl:apply-templates mode="coordinateElementGUI" select="$n">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name" select="'northbc'" />
						<xsl:with-param name="eltRef" select="concat('n', $eltRef)"/>
					</xsl:apply-templates>
				</td>
				<td/>
			</tr>
			<tr>
				<td class="padded" align="center">
					<xsl:apply-templates mode="coordinateElementGUI" select="$w">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name" select="'westbc'" />
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
					<xsl:apply-templates mode="coordinateElementGUI" select="$e">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name" select="'eastbc'" />
						<xsl:with-param name="eltRef" select="concat('e', $eltRef)"/>
					</xsl:apply-templates>
				</td>
			</tr>
			<tr>
				<td/>
				<td class="padded" align="center">
					<xsl:apply-templates mode="coordinateElementGUI" select="$s">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="name" select="'southbc'" />
						<xsl:with-param name="eltRef" select="concat('s', $eltRef)"/>
					</xsl:apply-templates>
				</td>
				<td/>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template mode="anzmeta" match="descript">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:variable name="content">

			<xsl:apply-templates mode="elementEP" select="abstract">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="theme">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="spatial-representation">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="scale-tip">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="../content/coordref/hdatum">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="../content/coordref/proj">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="../content/coordref/prjparam">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>

			<xsl:apply-templates mode="elementEP" select="spdom">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:apply-templates mode="complexElement" select=".">
	     <xsl:with-param name="schema"  select="$schema"/>
	     <xsl:with-param name="edit"    select="$edit"/>
	     <xsl:with-param name="content" select="$content"/>
	  </xsl:apply-templates>
	</xsl:template>


<!-- citeinfo - add preview image and rest of the box elements -->

	<xsl:template mode="anzmeta" match="citeinfo">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:variable name="content">
			<xsl:apply-templates mode="elementEP" select="uniqueid|title|origin">
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit" select="$edit"/>
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:apply-templates mode="complexElement" select=".">
	     <xsl:with-param name="schema"  select="$schema"/>
	     <xsl:with-param name="edit"    select="$edit"/>
	     <xsl:with-param name="content" select="$content"/>
	  </xsl:apply-templates>
	</xsl:template>

<!-- mailto link -->

  <xsl:template mode="anzmeta" match="cntemail">
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

<!-- download and preview links using the anzmeta tag under <uniqueid> -->

  <xsl:template mode="anzmeta" match="uniqueid">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:apply-templates mode="simpleElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="text">
				<xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- anzmeta brief formatting 																			 -->
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
	<xsl:template match="anzmetaBrief">
	 <xsl:for-each select="/metadata/*[1]">
		<metadata>
			<title><xsl:value-of select="normalize-space(citeinfo/title)"/></title>
			<abstract><xsl:value-of select="descript/abstract"/></abstract>

<!-- now process each of the keywords removing the () stuff if present -->

			<xsl:for-each select="descript/theme/keyword">
				<xsl:element name="keyword">
					<xsl:choose>
						<xsl:when test="contains(.,'()')">
							<xsl:value-of select="normalize-space(substring-before(.,'()'))"/><br/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/><br/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>

			<xsl:variable name="anzmetatag" select="citeinfo/uniqueid"/>
			<convert>anzmeta</convert>

<!-- now the thumbnail from the appropriate site -->

		<xsl:choose>
		<!-- don't abuse this - we use CSIRO for the generator only for
		     CSIRO records -->
			<xsl:when test="starts-with($anzmetatag,'ANZCW0306')">
				<image type="thumbnail"><xsl:value-of select="concat('http://www.marine.csiro.au/cgi-bin/marlin/thumb.pl?','&amp;E=',descript/spdom/bounding/eastbc,'&amp;W=',descript/spdom/bounding/westbc,'&amp;N=',descript/spdom/bounding/northbc,'&amp;S=',descript/spdom/bounding/southbc)"/></image>
			</xsl:when>
		<!-- you could also use a known path to thumbnails based on the ANZ tag
		     like this -->
			<xsl:when test="starts-with($anzmetatag,'ANZTA')">
				<image type="thumbnail"><xsl:value-of select="concat('http://www.thelist.tas.gov.au/asdd/',$anzmetatag,'.gif')"/></image>
			</xsl:when>
			<xsl:otherwise>
				<!-- no image -->
			</xsl:otherwise>
		</xsl:choose>

<!-- and the geoBox -->

			<geoBox>
					<westBL><xsl:value-of select="descript/spdom/bounding/westbc"/></westBL>
					<eastBL><xsl:value-of select="descript/spdom/bounding/eastbc"/></eastBL>
				  <southBL><xsl:value-of select="descript/spdom/bounding/southbc"/></southBL>
				  <northBL><xsl:value-of select="descript/spdom/bounding/northbc"/></northBL>
			</geoBox>
			<xsl:copy-of select="geonet:info"/>
		</metadata>
	 </xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
