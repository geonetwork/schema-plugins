<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
	xmlns:swe="http://www.opengis.net/swe"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:geonet="http://www.fao.org/geonetwork">

	<xsl:template name="metadata-sensorML">
	  <xsl:param name="schema"/>
	  <xsl:param name="edit" select="false()"/>
	  <xsl:param name="embedded"/>

	  <xsl:apply-templates mode="sensorML" select="." >
	    <xsl:with-param name="schema" select="$schema"/>
	    <xsl:with-param name="edit"   select="$edit"/>
	    <xsl:with-param name="embedded" select="$embedded" />
	  </xsl:apply-templates>
	</xsl:template>

	<xsl:template name="sensorMLCompleteTab">
	  <xsl:param name="tabLink"/>

	</xsl:template>

	<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT          -->
	<!-- =================================================================== -->
	<xsl:template name="sensorML-javascript"/>

	<!-- ==================================================================== -->
	<!-- default: in simple mode display only the xml  -->
	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="*|@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<!-- do not show empty elements in view mode -->

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:apply-templates mode="element" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="true()"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:variable name="empty">
					<xsl:apply-templates mode="sensorMLIsEmpty" select="."/>
				</xsl:variable>
			
				<xsl:if test="normalize-space($empty)!=''">
					<xsl:apply-templates mode="element" select=".">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="false()"/>
					</xsl:apply-templates>
				</xsl:if>
				
			</xsl:otherwise>
		</xsl:choose>
			
	</xsl:template>
	
	<!-- ==================================================================== -->
	<!-- these elements should be boxed -->
	<!-- ==================================================================== -->

	<xsl:template mode="sensorML" match="sml:System|sml:keywords|sml:identification|sml:classification|sml:validTime|sml:characteristics|sml:capabilities|sml:contact|sml:documentation|gml:location|sml:interfaces|sml:inputs|sml:outputs|sml:components">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ==================================================================== -->
		
	<xsl:template mode="sensorML" match="sml:identifier[@name='GeoNetwork-UUID']" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema"  select="$schema"/>
			<xsl:with-param name="edit"    select="false()"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- abstract -->
	<!-- ================================================================= -->

	<xsl:template mode="sensorML" match="//sml:System/gml:description" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="sensorMLString">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="rows"   select="10"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==================================================================== -->

  <xsl:template name="sensorMLString">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="rows" select="1"/>
    <xsl:param name="cols" select="50"/>

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
    <xsl:variable name="text">
       <xsl:call-template name="getElementText">
         <xsl:with-param name="edit"   select="$edit"/>
         <xsl:with-param name="schema" select="$schema"/>
         <xsl:with-param name="rows"   select="$rows"/>
         <xsl:with-param name="cols"   select="$cols"/>
       </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates mode="simpleElement" select=".">
      <xsl:with-param name="schema"   select="$schema"/>
      <xsl:with-param name="edit"     select="$edit"/>
      <xsl:with-param name="title"    select="$title"/>
      <xsl:with-param name="helpLink" select="$helpLink"/>
      <xsl:with-param name="text"     select="$text"/>
    </xsl:apply-templates>
  </xsl:template>
	
	<!-- ================================================================== -->
  <!-- gml:TimePeriod and gml:TimeInstant (format = %Y-%m-%dThh:mm:ss)	  -->
  <!-- ================================================================== -->

  <xsl:template mode="sensorML" match="gml:TimeInstant[gml:timePosition]" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

    <xsl:for-each select="gml:beginPosition|gml:endPosition|gml:timePosition">
    <xsl:choose>
      <xsl:when test="$edit=true()">
        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema"  select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
          <xsl:with-param name="text">
            <xsl:variable name="ref" select="geonet:element/@ref"/>

            <table width="100%"><tr>
              <td>
                            <input class="md" type="text" name="_{$ref}" id="_{$ref}_cal" value="{text()}" size="30" readonly="1"/>
              </td>
              <td align="center" width="30" valign="middle">
                <img src="{/root/gui/url}/scripts/calendar/img.gif"
                   id="_{$ref}_trigger"
                   style="cursor: pointer; border: 1px solid;"
                   title="Date selector"
                   onmouseover="this.style.background='red';"
                   onmouseout="this.style.background=''" />
                <script type="text/javascript">
                  Calendar.setup(
                    {
                      inputField  : &quot;_<xsl:value-of select="$ref"/>_cal&quot;,         // ID of the input field
                                ifFormat    : "%Y-%m-%dT%H:%M:00", // the date format
                                showsTime : false, // Do not show the time
                      button      : &quot;_<xsl:value-of select="$ref"/>_trigger&quot;  // ID of the button
                    }
                  );
                </script>
              </td>
              <td align="left" width="100%">
                <xsl:text>  </xsl:text><a href="JavaScript:clear{$ref}();"> clear</a>
								<script type="text/javascript">
                  function clear<xsl:value-of select="$ref"/>() {
                    document.mainForm._<xsl:value-of select="$ref"/>.value = &quot;&quot;
                  }
                </script>
              </td>
            </tr></table>
          </xsl:with-param>
        </xsl:apply-templates>
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

	<!-- ================================================================= -->
	<!-- === sensorML CHOICE_ELEMENT handling === -->
	<!-- ================================================================= -->

  <xsl:template mode="sensorML" match="*[contains(name(),'CHOICE_ELEMENT')]" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

		<xsl:variable name="nongeonet" select="*[not(starts-with(string(name(.)),'geonet'))]"/>
		<xsl:choose>
			
			<xsl:when test="$nongeonet">
				<xsl:for-each select="*[not(starts-with(name(.),'geonet'))]">
					<xsl:apply-templates mode="elementEP" select=".">
						<xsl:with-param name="schema"  select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================================================================= -->
	<!-- === sensorML brief formatting === -->
	<!-- ================================================================= -->
	
	<xsl:template name="sensorMLBrief">
			<xsl:variable name="id" select="geonet:info/id"/>

		<metadata>
			<xsl:apply-templates mode="sensorMLbriefster" select="sml:member">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
			
			<xsl:copy-of select="geonet:info"/>
		</metadata>
	</xsl:template>	

	<xsl:template mode="sensorMLbriefster" match="*">
		<xsl:param name="id"/>

			<xsl:if test="sml:System/sml:identification/sml:IdentifierList/sml:identifier/@name='Long Name'">
				<title><xsl:value-of select="sml:System/sml:identification/sml:IdentifierList/sml:identifier[@name='Long Name']/sml:Term/sml:value"/></title>
			</xsl:if>
			
			<xsl:if test="sml:System/gml:description">
				<abstract><xsl:value-of select="sml:System/gml:description"/></abstract>
			</xsl:if>

			<xsl:for-each select="sml:System/sml:keywords/sml:KeywordList/sml:keyword[text()]">
				<keyword><xsl:value-of select="."/></keyword>
			</xsl:for-each>

	</xsl:template>
	
	<!-- =============================================================== -->
	<!-- utilities -->
	<!-- =============================================================== -->
	
	<xsl:template mode="sensorMLIsEmpty" match="*|@*">
		<xsl:choose>
			<!-- normal element -->
			<xsl:when test="*">
				<xsl:apply-templates mode="sensorMLIsEmpty"/>
			</xsl:when>
			<!-- text element -->
			<xsl:when test="string-length(.)!=0">txt</xsl:when>
			<!-- empty element -->
			<xsl:otherwise>
				<!-- codelist? -->
				<xsl:if test="@codeList">
					<xsl:if test="@codeListValue!=''">cdl</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
