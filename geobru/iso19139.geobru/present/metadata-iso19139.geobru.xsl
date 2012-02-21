<?xml version="1.0" encoding="UTF-8"?>
	<!-- heikki: added geobru namespace declaration -->
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:geobru="http://geobru.irisnet.be"
    xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="gmx xsi gmd gco gml gts srv xlink exslt geonet">
  
    <!-- heikki: changed iso19139 to iso19139.geobru -->
	<!-- main template - the way into processing iso19139.geobru -->
	<xsl:template name="metadata-iso19139.geobru">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>

   	<xsl:apply-templates mode="iso19139" select="." >
    	<xsl:with-param name="schema" select="$schema"/>
     	<xsl:with-param name="edit"   select="$edit"/>
     	<xsl:with-param name="embedded" select="$embedded" />
   	</xsl:apply-templates>
  </xsl:template>

	
	<!-- ===================================================================== -->
	<!-- === iso19139 brief formatting === -->
	<!-- ===================================================================== -->
	<!-- heikki: changed name to iso19139.geobruBrief -->
	<xsl:template match="iso19139.geobruBrief">
	 <xsl:for-each select="/metadata/*[1]">
		<metadata>
		  <xsl:choose>
		    <xsl:when test="geonet:info/isTemplate='s'">
		      <xsl:apply-templates mode="iso19139-subtemplate" select="."/>
		      <xsl:copy-of select="geonet:info" copy-namespaces="no"/>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:call-template name="iso19139-brief"/>
		    </xsl:otherwise>
		  </xsl:choose>
		</metadata>
	 </xsl:for-each>
	</xsl:template>
  
  
	<!-- In order to add profil specific tabs 
		add a template in this mode.
		
		To add some more tabs.
		<xsl:template mode="extraTab" match="/">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>
		<xsl:if test="$schema='iso19139.fra'">
		...
		</xsl:if>
		</xsl:template>
	-->
	<xsl:template mode="extraTab" match="/"/>
		
	<!-- ============================================================================= -->
	<!-- iso19139 complete tab template	-->
	<!-- ============================================================================= -->
	<!-- heikki: changed name to iso19139.geobruCompleteTab -->
	<xsl:template name="iso19139.geobruCompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>
			
		<xsl:call-template name="iso19139CompleteTab">
		  <xsl:with-param name="tabLink" select="$tabLink"/>
		  <xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>
    
	</xsl:template>
	
	<xsl:template mode="iso19139" match="geobru:*[gco:CharacterString|gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- ============================================================================= -->
	<!-- utilities -->
	<!-- ============================================================================= -->
	
		
	<!-- heikki: added handling of geobru extension elements -->
	<xsl:template mode="iso19139.geobru" match="geobru:BXL_Lineage">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>		

	
	<!-- heikki: added handling of geobru extension elements -->
	<xsl:template mode="iso19139.geobru" match="geobru:BXL_Address">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:apply-templates>		
	</xsl:template>		
	

	<!-- heikki: added handling of geobru extension elements -->
	<xsl:template mode="iso19139.geobru" match="geobru:featureType">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>	
        <xsl:apply-templates mode="complexElement" select=".">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>			
	</xsl:template>		
	
	<!-- heikki: added handling of geobru extension elements -->
	<xsl:template mode="iso19139.geobru" match="geobru:BXL_Distribution">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:apply-templates>		
	</xsl:template>		
	
</xsl:stylesheet>
