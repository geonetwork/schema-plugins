<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmx="http://www.isotc211.org/2005/gmx" 
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" 
	xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xlink="http://www.w3.org/1999/xlink">
	
	
	<!-- A template to convert thesaurus concept to mcp dataparameter term
	     fragment (mcp:DP_Term) -->
	
<!--
          <mcp:DP_Term>
            <mcp:term>
              <gco:CharacterString>t</gco:CharacterString>
            </mcp:term>
            <mcp:type>
              <mcp:DP_TypeCode
          codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_TypeCode"
          codeListValue="shortName">shortName</mcp:DP_TypeCode>
            </mcp:type>
            <mcp:usedInDataset>
              <gco:Boolean>1</gco:Boolean>
            </mcp:usedInDataset>
            <mcp:vocabularyRelationship>
              <mcp:DP_VocabularyRelationship>
                <mcp:relationshipType>
                  <mcp:DP_RelationshipTypeCode
          codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_RelationshipTypeCode"
          codeListValue="skos:exactmatch">skos:exactmatch</mcp:DP_RelationshipTypeCode>
                </mcp:relationshipType>
                <mcp:vocabularyTermURL>
                 <gmd:URL>http://www.imos.org.au/vocabserver?code=temperature&vocab=oceanography</gmd:URL>
                </mcp:vocabularyTermURL>
                <mcp:vocabularyListURL>
                 <gmd:URL>http://www.imos.org.au/vocabserver?vocab=oceanography</gmd:URL>
                </mcp:vocabularyListURL>
                <mcp:vocabularyListVersion>
                  <gco:CharacterString>3.6</gco:CharacterString>
                </mcp:vocabularyListVersion>
              </mcp:DP_VocabularyRelationship>
            </mcp:vocabularyRelationship>
          </mcp:DP_Term>
-->
	
	<!-- Convert a concept to an mcp dataparameter term -->
	<xsl:template name="to-mcp-dataparameterterm">
		<mcp:DP_Term>
					<!-- Get thesaurus ID from keyword or from request parameter if no keyword found. -->
					<xsl:variable name="currentThesaurus" select="if (thesaurus/key) then thesaurus/key else /root/request/thesaurus"/>
					
					<!-- Loop on all keyword from the same thesaurus - should only be 1
					     in this case - use an Anchor to tie term id and term text
							 together for easy checking -->
					<xsl:for-each select="//keyword[thesaurus/key = $currentThesaurus]">
						<mcp:term>
							<gmx:Anchor xlink:href="{uri}">
								<xsl:value-of select="value"/>
							</gmx:Anchor>
						</mcp:term>
					</xsl:for-each>
					
          <mcp:type>
            <mcp:DP_TypeCode codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_TypeCode" codeListValue=""></mcp:DP_TypeCode>
          </mcp:type>

          <mcp:usedInDataset>
            <gco:Boolean>0</gco:Boolean>
          </mcp:usedInDataset>

					<xsl:if test="not(/root/request/keywordOnly)">
						<mcp:vocabularyRelationship>
							<mcp:DP_VocabularyRelationship>

								<!-- always an exactMatch in here for now -->
								<mcp:relationshipType>
								  <mcp:DP_RelationshipTypeCode codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_RelationshipTypeCode" codeListValue="skos:exactmatch">skos:exactmatch</mcp:DP_RelationshipTypeCode>
								</mcp:relationshipType>
				
								<!-- loop on thesaurus keys again but use url - should only be
								     1 -->
								<xsl:for-each select="//keyword[thesaurus/key = $currentThesaurus]">
									<mcp:vocabularyTermURL>
										<gmd:URL>
											<xsl:value-of select="uri"/>
										</gmd:URL>
									</mcp:vocabularyTermURL>
								</xsl:for-each>
							
								<!-- gn thesaurus download url is vocabulary list url -->
                <mcp:vocabularyListURL>
									<gmd:URL>
										<xsl:value-of select="/root/gui/thesaurus/thesauri/thesaurus[key = $currentThesaurus]/url"/>
									</gmd:URL>
                </mcp:vocabularyListURL>

								<!-- use date as thesaurus version -->
								<xsl:variable name="thesaurusDate" select="normalize-space(/root/gui/thesaurus/thesauri/thesaurus[key = $currentThesaurus]/date)"/>

                <mcp:vocabularyListVersion>
									<gco:CharacterString>
										<xsl:value-of select="$thesaurusDate"/>
									</gco:CharacterString>
                </mcp:vocabularyListVersion>
								
							</mcp:DP_VocabularyRelationship>
						</mcp:vocabularyRelationship>
					</xsl:if>
		</mcp:DP_Term>
	</xsl:template>
	
</xsl:stylesheet>
