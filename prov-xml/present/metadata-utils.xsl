<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dct="http://purl.org/dc/terms/"
    xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
    xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
    xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
    xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
    xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
    xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
    xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
    xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
    xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
    xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:java="java:org.fao.geonet.util.XslUtil"
		xmlns:prov="http://www.w3.org/ns/prov#"
    version="2.0"
    exclude-result-prefixes="#all">


	<!-- Display related metadata records.
		
		Related resources are:
		* entities which point to dataset metadata records
		* software agents pointing to services that process entities

		In view mode link to related resources are displayed
		In edit mode link to add elements are provided.
	-->
	<xsl:template name="relatedResourcesprov-xml.iso">
		<xsl:param name="edit"/>

		<xsl:variable name="metadata" select="/root/mdb:MD_Metadata|/root/*[contains(@gco:isoType,'MD_Metadata')]"/>
		<xsl:if test="starts-with(geonet:info/schema, 'iso19115-3') or geonet:info/schema = 'iso19110'">

			<xsl:variable name="uuid" select="$metadata/geonet:info/uuid"/>
			
			<xsl:variable name="isService" select="$metadata/mdb:identificationInfo/srv:SV_ServiceIdentification|
			$metadata/mdb:identificationInfo/*[contains(@gco:isoType, 'SV_ServiceIdentification')]"/>
			
			
			<!-- Related elements -->			
			<xsl:variable name="siblings" select="/root/gui/relation/siblings/response/sibling"/>

			<xsl:if test="count($siblings)>0 or $edit">

		    <div class="relatedElements">

		        	<xsl:if test="count($siblings)>0 and not($edit)">
								<xsl:for-each-group select="$siblings" group-by="@type">
									<div>
										<h3 style="text-transform:capitalize;"><xsl:value-of select="concat('related ',current-grouping-key(),'(s)')"/></h3>
										<xsl:for-each select="current-group()/*/geonet:info">
		        					<ul>
		        						<li>
			        						<a class="arrow" href="metadata.show?uuid={uuid}">Metadata record</a>
		        						</li>
		        					</ul>
										</xsl:for-each>
										<br/>
		        			</div>
								</xsl:for-each-group>
		        	</xsl:if>
		        		
				</div>
			</xsl:if>
		</xsl:if>

	</xsl:template>

	<xsl:template mode="prov-xmlIsEmpty" match="*|@*">
		<xsl:choose>
			<!-- normal element or attribute -->
			<xsl:when test="*|@*">
				<xsl:apply-templates mode="prov-xmlIsEmpty"/>
			</xsl:when>
			<!-- text element -->
			<xsl:when test="text()!=''">txt</xsl:when>
			<xsl:otherwise>
				<!-- attributes -->
				<xsl:if test="string-length(.)!=0">att</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="extractDCMIBox">
		<xsl:param name="coverage"/>

		<!-- Assume that we have DCMI box encoding present in $coverage -->
		<box>
    	<xsl:for-each select="tokenize($coverage,';')">
      	<xsl:choose>
        	<xsl:when test="contains(.,'northlimit')">
          	<northBL><xsl:value-of select="substring-after(.,'=')"/></northBL>
        	</xsl:when>
        	<xsl:when test="contains(.,'southlimit')">
          	<southBL><xsl:value-of select="substring-after(.,'=')"/></southBL>
        	</xsl:when>
        	<xsl:when test="contains(.,'eastlimit')">
          	<eastBL><xsl:value-of select="substring-after(.,'=')"/></eastBL>
        	</xsl:when>
        	<xsl:when test="contains(.,'westlimit')">
          	<westBL><xsl:value-of select="substring-after(.,'=')"/></westBL>
        	</xsl:when>
        	<xsl:when test="contains(.,'place')">
          	<place><xsl:value-of select="substring-after(.,'=')"/></place>
        	</xsl:when>
      	</xsl:choose>
    	</xsl:for-each>
		</box>
	</xsl:template>

</xsl:stylesheet>
