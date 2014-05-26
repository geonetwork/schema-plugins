<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:srv="http://www.isotc211.org/2005/srv"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:gmx="http://www.isotc211.org/2005/gmx"
										xmlns:xlink="http://www.w3.org/1999/xlink"
										xmlns:skos="http://www.w3.org/2004/02/skos/core#">

	<xsl:import href="../iso19139/index-fields.xsl"/>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

	<xsl:template mode="index" match="gmd:MD_Keywords">

				<xsl:variable name="thesaurusId" select="normalize-space(gmd:thesaurusName/*/gmd:identifier/*/gmd:code[starts-with(string(gmx:Anchor),'geonetwork.thesaurus')])"/>

				<xsl:if test="$thesaurusId!=''">
					<Field name="thesaurusName" string="{string($thesaurusId)}" store="true" index="true"/>
				</xsl:if>

				<!-- index keyword codes under lucene index field with name same
				     as thesaurus that contains the keyword codes -->

				<xsl:for-each select="gmd:keyword/*">
					<xsl:if test="name()='gmx:Anchor' and $thesaurusId!=''">
						<!-- expecting something like 
							    	<gmx:Anchor 
									  	xlink:href="http://localhost:8080/geonetwork/srv/en/xml.keyword.get?thesaurus=register.theme.urn:marine.csiro.au:marlin:keywords:standardDataType&id=urn:marine.csiro.au:marlin:keywords:standardDataTypes:concept:3510">CMAR Vessel Data: ADCP</gmx:Anchor>
						-->
	
						<xsl:variable name="keywordId">
							<xsl:for-each select="tokenize(@xlink:href,'&amp;')">
								<xsl:if test="starts-with(string(.),'id=')">
									<xsl:value-of select="substring-after(string(.),'id=')"/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
	
						<xsl:if test="normalize-space($keywordId)!=''">
							<Field name="{$thesaurusId}" string="{replace($keywordId,'%23','#')}" store="true" index="true"/>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>

				<xsl:apply-templates mode="index" select="*"/>
	</xsl:template>
	
</xsl:stylesheet>
