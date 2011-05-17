<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								 xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xmlns:dc="http://purl.org/dc/terms/"  
                 xmlns="http://ands.org.au/standards/rif-cs/registryObjects">

<!-- Stylesheet to convert eml-gbif metadata response to RIF-CS 
     Adapted from ISO stylesheet by Simon Pigot, CSIRO, 2001 
		 TODO: add taxonomic coverage info as keywords -->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="root">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="eml:eml">
	<xsl:element name="registryObjects">
		<xsl:attribute name="xsi:schemaLocation">
        	<xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates select="." mode="collection"/>
	</xsl:element>
</xsl:template>

<xsl:template match="phone">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>voice</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="concat('tel:',translate(translate(.,'+',''),' ','-'))"/>
		</xsl:element>
	</xsl:element>
</xsl:template>


<xsl:template match="electronicMailAddress">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>email</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="onlineUrl">
	<xsl:element name="electronic">
		<xsl:attribute name="type">
			<xsl:text>url</xsl:text>
		</xsl:attribute>
		<xsl:element name="value">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:element>
</xsl:template>



<xsl:template match="beginDate">
    <xsl:choose>
        <xsl:when test='contains(., "T")'>
            <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(., 'T00:00:00Z')"/> 
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="endDate">
    <xsl:choose>
        <xsl:when test='contains(., "T")'>
            <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(., 'T00:00:00Z')"/> 
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template match="organizationName">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>locationDescriptor</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="deliveryPoint">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>addressLine</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="city">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>suburbOrPlaceOrLocality</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="administrativeArea">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>stateOrTerritory</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="postalCode">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>postCode</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="country">
	<xsl:element name="addressPart">
		<xsl:attribute name="type">
			<xsl:text>country</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="title">
	<xsl:value-of select="."/>
</xsl:template>


<xsl:template match="geographicCoverage">
	<xsl:element name="spatial">
		<xsl:attribute name="type">
			<xsl:text>iso19139dcmiBox</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="concat('northlimit=',boundingCoordinates/northBoundingCoordinate,'; southlimit=',boundingCoordinates/southBoundingCoordinate,'; westlimit=',boundingCoordinates/westBoundingCoordinate,'; eastLimit=',boundingCoordinates/eastBoundingCoordinate)"/>
		<xsl:text>; projection=WGS84</xsl:text>
	</xsl:element>
</xsl:template>


<xsl:template match="geographicDescription">
	<xsl:element name="spatial">
		<xsl:attribute name="type">
			<xsl:text>text</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>


<xsl:template match="keywordSet">
	<xsl:for-each select="keyword">
  	<xsl:element name="subject">
			<xsl:attribute name="type">
				<xsl:text>local</xsl:text>
			</xsl:attribute>
			<xsl:value-of select="."/>
  	</xsl:element>
	</xsl:for-each>
</xsl:template>


<xsl:template match="abstract">
	<xsl:element name="description">
		<xsl:attribute name="type">
			<xsl:text>brief</xsl:text>
		</xsl:attribute>
	    <xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<!--
	CREATE COLLECTION OBJECT
-->
<xsl:template match="eml:eml" mode="collection">


	<!-- the originating source --> 
  <xsl:param name="origSource" select="/root/env/siteURL"/>
        
  <!-- the registry object group -->
  <xsl:param name="group" select="/root/env/siteName"/>

  <xsl:variable name="originatingSource" select="dataset/creator/onlineUrl"/>
	<xsl:variable name="ge" select="dataset/coverage/geographicCoverage"/>
	<xsl:variable name="te" select="dataset/coverage/temporalCoverage"/>
	
  <xsl:variable name="formattedFrom">
		<xsl:choose>
			<xsl:when test="$te[1]/rangeOfDates/beginDate">
				<xsl:apply-templates select="$te[1]/rangeOfDates/beginDate"/>
			</xsl:when>
			<xsl:when test="$te[1]/singleDateTime">
				<xsl:apply-templates select="$te[1]/singleDateTime"/>
			</xsl:when>
		</xsl:choose>					
	</xsl:variable>
			
	<xsl:variable name="formattedTo">
		<xsl:if test="$te[1]/rangeOfDates/endDate">
			<xsl:apply-templates select="$te[1]/rangeOfDates/endDate"/>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="from" select="$formattedFrom"/>
			
	<xsl:variable name="to" select="$formattedTo"/>

	<xsl:element name="registryObject">
		<xsl:attribute name="group">
			<xsl:value-of select="$group"/>
		</xsl:attribute>
		<xsl:element name="key"> <!-- first alternateIdentifier -->
			<xsl:value-of select="dataset/alternateIdentifier[1]"/>
		</xsl:element>
		<xsl:element name="originatingSource">
            <xsl:choose>
                <xsl:when test="not($originatingSource)">
                    <xsl:value-of select="$origSource"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$originatingSource"/>
                </xsl:otherwise>
            </xsl:choose>
		</xsl:element>
		<xsl:element name="collection">
			<xsl:attribute name="type">
				<xsl:value-of select="'dataset'"/>
			</xsl:attribute>
			<xsl:element name="identifier">
				<xsl:attribute name="type">
					<xsl:text>local</xsl:text>
				</xsl:attribute>
				<!-- first alternateIdentifier -->
				<xsl:value-of select="dataset/alternateIdentifier[1]"/>
			</xsl:element>
			
			<xsl:element name="name">
				<xsl:attribute name="type">
					<xsl:text>primary</xsl:text>
				</xsl:attribute>
				<xsl:element name="namePart">
					<xsl:attribute name="type">
						<xsl:text>full</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates select="dataset/title[1]"/>
				</xsl:element>
			</xsl:element>

			<xsl:element name="location">
				<xsl:element name="address">
					<xsl:element name="electronic">
						<xsl:attribute name="type">
							<xsl:text>url</xsl:text>
						</xsl:attribute>
						<xsl:element name="value">
							<xsl:value-of select="concat($origSource,'/metadata.show?uuid=',/root/env/uuid)"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:if test="$ge/boundingCoordinates">
				<xsl:element name="location">
					<xsl:attribute name="type">
						<xsl:text>coverage</xsl:text>
					</xsl:attribute>
					<!-- date time -->
					<xsl:if test="not($formattedFrom='')">
						<xsl:attribute name="dateFrom">
							<xsl:value-of select="$formattedFrom"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="not($formattedTo='')">
						<xsl:attribute name="dateTo">
							<xsl:value-of select="$formattedTo"/>
						</xsl:attribute>						
					</xsl:if>

					<xsl:apply-templates select="$ge/boundingCoordinates"/>
					
				</xsl:element>
			</xsl:if>

			<!-- parties generated here -->
			<xsl:for-each-group select="dataset/*[(individualName/surName!='' or positionName!='' or organizationName!='') and not(role='')]"  group-by="role">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
                    <xsl:choose>                        
                        <xsl:when test="individualName">
													<xsl:apply-templates select="individualName"/>
                        </xsl:when>                        
                        <xsl:when test="string(positionName)">
                            <xsl:value-of select="positionName"/>
                        </xsl:when>
                        <xsl:otherwise>                            
                            <xsl:value-of select="organizationName"/>
                        </xsl:otherwise>
                    </xsl:choose>
					</xsl:element>	
					<xsl:for-each select="role">
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>

			<xsl:for-each-group select="dataset/*[organizationName != '' and not(role='') and not(individualName)]" group-by="organizationName">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="current-grouping-key()"/>
					</xsl:element>
					<xsl:for-each select="role">
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:element>		
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>
			
			<xsl:for-each select="dataset/*[(individualName/surName!='' or positionName!='' or organizationName!='') and (name()='creator' or name()='metadataProvider')]" >
				<xsl:element name="relatedObject">
					<xsl:element name="key">
                    <xsl:choose>                        
                        <xsl:when test="individualName">
													<xsl:apply-templates select="individualName"/>
                        </xsl:when>                        
                        <xsl:when test="string(positionName)">
                            <xsl:value-of select="positionName"/>
                        </xsl:when>
                        <xsl:otherwise>                            
                            <xsl:value-of select="organizationName"/>
                        </xsl:otherwise>
                    </xsl:choose>
					</xsl:element>
					<xsl:element name="relation">
						<xsl:attribute name="type">
							<xsl:value-of select="name(.)"/>
						</xsl:attribute>
					</xsl:element>		
				</xsl:element>
			</xsl:for-each>
			
      <xsl:apply-templates select="dataset/keywordSet"/>
			<xsl:apply-templates select="dataset/abstract"/>


      <!-- for intellectualRights -->
      <xsl:for-each select="dataset/intellectualRights/para">
        <xsl:element name="description">
        	<xsl:attribute name="type">
          	<xsl:text>rights</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:for-each>

			<xsl:if test="$te/rangeOfDates">
				<xsl:if test="not($from='') and $formattedFrom=''">
					<xsl:element name="description">
						<xsl:attribute name="type">
							<xsl:text>temporal</xsl:text>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$from = $to or $to=''">
								<xsl:text>Time period: </xsl:text>
								<xsl:value-of select="$from"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Time period: </xsl:text>
								<xsl:value-of select="concat($from, ' to ', $to)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
			</xsl:if>		

		</xsl:element>
	</xsl:element>

	<xsl:for-each-group select="//dataset/*[(individualName!='' or positionName!='' or organizationName!='') and not(role='')]" group-by="role">
		<xsl:element name="registryObject">
			<xsl:attribute name="group">
				<xsl:value-of select="$group"/>
			</xsl:attribute>
      <xsl:element name="key">
        <xsl:choose>
        	<xsl:when test="individualName">
						<xsl:apply-templates select="individualName"/>
          </xsl:when>
          <xsl:when test="string(positionName)">
          	<xsl:value-of select="positionName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="organizationName"/>
          </xsl:otherwise>
        </xsl:choose>
				<!--<xsl:value-of select="current-grouping-key()"/> -->
			</xsl:element>
			<xsl:element name="originatingSource">
        <xsl:choose>
          <xsl:when test="not($originatingSource)">
            <xsl:value-of select="$origSource"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$originatingSource"/>
          </xsl:otherwise>
        </xsl:choose>
			</xsl:element>
			<xsl:element name="party">
				<xsl:attribute name="type">
         <xsl:choose>
           <xsl:when test="individualName">
           	<xsl:value-of select="'person'" />                        
           </xsl:when>
           <xsl:when test="string(positionName)">
           	<xsl:value-of select="'person'"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="'group'"/>
           </xsl:otherwise>
         </xsl:choose>
					<!--<xsl:text>person</xsl:text>-->
				</xsl:attribute>
				<xsl:element name="name">
					<xsl:attribute name="type">
						<xsl:text>primary</xsl:text>
					</xsl:attribute>
					<xsl:element name="namePart">
						<xsl:attribute name="type">
							<xsl:text>full</xsl:text>
						</xsl:attribute>
            <xsl:choose>
               <xsl:when test="individualName">
								<xsl:apply-templates select="individualName"/>
               </xsl:when>
               <xsl:when test="string(positionName)">
                <xsl:value-of select="positionName"/>
               </xsl:when>
               <xsl:otherwise>
                <xsl:value-of select="organizationName"/>
               </xsl:otherwise>
            </xsl:choose>
						<!--<xsl:value-of select="current-grouping-key()"/>-->
					</xsl:element>
				</xsl:element>
				
				<!-- to normalise parties within a single record we group them -->
				<xsl:for-each select="current-group()">
					<xsl:sort select="count(address/child::*) + count(phone)" data-type="number" order="descending"/>
					<xsl:choose>
						<xsl:when test="position()=1">
							<xsl:if test="organizationName!='' or address/city or phone">
								<xsl:element name="location">
									<xsl:element name="address">
										<xsl:element name="physical">
											<xsl:attribute name="type">
												<xsl:text>streetAddress</xsl:text>
											</xsl:attribute>
											<xsl:apply-templates select="organizationName"/>
											<xsl:apply-templates select="address/deliveryPoint"/>
											<xsl:apply-templates select="address/city"/>
											<xsl:apply-templates select="address/administrativeArea"/>
											<xsl:apply-templates select="address/postalCode"/>
											<xsl:apply-templates select="address/country"/>
										</xsl:element>
									</xsl:element>
								  <xsl:if test="phone or electronicMailAddress or onlineUrl">
                                        <xsl:if test="phone">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="phone"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="electronicMailAddress">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="electronicMailAddress"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="onlineUrl">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="onlineUrl"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:element>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>

          <xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="ancestor::eml:eml/dataset/alternateIdentifier[1]"/>
					</xsl:element>	

					<xsl:for-each select="role">
						<xsl:variable name="code">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:variable>
						
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="$code"/>
							</xsl:attribute>
						</xsl:element>		
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:for-each-group>

	<xsl:for-each-group select="//dataset/*[(individualName!='' or positionName!='' or organizationName!='') and (name()='creator' or name()='metadataProvider')]" group-by="name()">
		<xsl:element name="registryObject">
			<xsl:attribute name="group">
				<xsl:value-of select="$group"/>
			</xsl:attribute>
      <xsl:element name="key">
        <xsl:choose>
        	<xsl:when test="individualName">
						<xsl:apply-templates select="individualName"/>
          </xsl:when>
          <xsl:when test="string(positionName)">
          	<xsl:value-of select="positionName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="organizationName"/>
          </xsl:otherwise>
        </xsl:choose>
				<!--<xsl:value-of select="current-grouping-key()"/> -->
			</xsl:element>
			<xsl:element name="originatingSource">
        <xsl:choose>
          <xsl:when test="not($originatingSource)">
            <xsl:value-of select="$origSource"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$originatingSource"/>
          </xsl:otherwise>
        </xsl:choose>
			</xsl:element>
			<xsl:element name="party">
				<xsl:attribute name="type">
         <xsl:choose>
           <xsl:when test="individualName">
           	<xsl:value-of select="'person'" />                        
           </xsl:when>
           <xsl:when test="string(positionName)">
           	<xsl:value-of select="'person'"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="'group'"/>
           </xsl:otherwise>
         </xsl:choose>
					<!--<xsl:text>person</xsl:text>-->
				</xsl:attribute>
				<xsl:element name="name">
					<xsl:attribute name="type">
						<xsl:text>primary</xsl:text>
					</xsl:attribute>
					<xsl:element name="namePart">
						<xsl:attribute name="type">
							<xsl:text>full</xsl:text>
						</xsl:attribute>
            <xsl:choose>
               <xsl:when test="individualName">
								<xsl:apply-templates select="individualName"/>
               </xsl:when>
               <xsl:when test="string(positionName)">
                <xsl:value-of select="positionName"/>
               </xsl:when>
               <xsl:otherwise>
                <xsl:value-of select="organizationName"/>
               </xsl:otherwise>
            </xsl:choose>
						<!--<xsl:value-of select="current-grouping-key()"/>-->
					</xsl:element>
				</xsl:element>
				
				<!-- to normalise parties within a single record we group them -->
				<xsl:for-each select="current-group()">
					<xsl:sort select="count(address/child::*) + count(phone)" data-type="number" order="descending"/>
					<xsl:choose>
						<xsl:when test="position()=1">
							<xsl:if test="organizationName!='' or address/city or phone">
								<xsl:element name="location">
									<xsl:element name="address">
										<xsl:element name="physical">
											<xsl:attribute name="type">
												<xsl:text>streetAddress</xsl:text>
											</xsl:attribute>
											<xsl:apply-templates select="organizationName"/>
											<xsl:apply-templates select="address/deliveryPoint"/>
											<xsl:apply-templates select="address/city"/>
											<xsl:apply-templates select="address/administrativeArea"/>
											<xsl:apply-templates select="address/postalCode"/>
											<xsl:apply-templates select="address/country"/>
										</xsl:element>
									</xsl:element>
								  <xsl:if test="phone or electronicMailAddress or onlineUrl">
                                        <xsl:if test="phone">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="phone"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="electronicMailAddress">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="electronicMailAddress"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="onlineUrl">
                                            <xsl:element name="address">
                                                <xsl:apply-templates select="onlineUrl"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:element>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>

          <xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="ancestor::eml:eml/dataset/alternateIdentifier[1]"/>
					</xsl:element>	

					<xsl:variable name="code">
						<xsl:value-of select="current-grouping-key()"/>
					</xsl:variable>
						
					<xsl:element name="relation">
						<xsl:attribute name="type">
							<xsl:value-of select="$code"/>
						</xsl:attribute>
					</xsl:element>		
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:for-each-group>

	<!-- Create all the associated party objects for organisations -->
	<xsl:for-each-group select="//dataset/*[not(individualName) and organizationName!='' and not(role='')]" group-by="organizationName">
		<xsl:element name="registryObject">
			<xsl:attribute name="group">
				<xsl:value-of select="$group"/>
			</xsl:attribute>
			<xsl:element name="key">
				<xsl:value-of select="current-grouping-key()"/>
			</xsl:element>
			<xsl:element name="originatingSource">
                <xsl:choose>
                    <xsl:when test="not($originatingSource)">
                        <xsl:value-of select="$origSource"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$originatingSource"/>
                    </xsl:otherwise>
                </xsl:choose>
			</xsl:element>
			<xsl:element name="party">
				<xsl:attribute name="type">
					<xsl:text>person</xsl:text>
				</xsl:attribute>
				<xsl:element name="name">
					<xsl:attribute name="type">
						<xsl:text>primary</xsl:text>
					</xsl:attribute>
					<xsl:element name="namePart">
						<xsl:attribute name="type">
							<xsl:text>full</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="current-grouping-key()"/>
					</xsl:element>
				</xsl:element>
				
				<!-- to normalise parties within a single record we need to group them, obtain the fragment for each party with the most information, and at the same time cope with rubbish data. In the end the only way to cope is to ensure at least an organisation name, city, phone or fax exists (sigh) -->
				<xsl:for-each select="current-group()">
					<xsl:sort select="count(address/child::*) + count(phone)" data-type="number" order="descending"/>
					<xsl:choose>
						<xsl:when test="position()=1">
							<xsl:if test="organizationName[text()!=''] or address/city or phone">
								<xsl:element name="location">
									<xsl:element name="address">
										<xsl:apply-templates select="phone[text()!='']"/>
										<xsl:element name="physical">
											<xsl:attribute name="type">
												<xsl:text>streetAddress</xsl:text>
											</xsl:attribute>
											<xsl:apply-templates select="organizationName"/>
											<xsl:apply-templates select="address/deliveryPoint"/>
											<xsl:apply-templates select="address/city"/>
											<xsl:apply-templates select="address/administrativeArea[text()!='']"/>
											<xsl:apply-templates select="address/postalCode[text()!='']"/>
											<xsl:apply-templates select="address/country"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:if>
                        </xsl:when>
					</xsl:choose>
				</xsl:for-each>
		
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="ancestor::eml:eml/dataset/alternateIdentifier[1]"/>
					</xsl:element>	

					<xsl:for-each select="role">
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:element>		
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:for-each-group>

</xsl:template>

<xsl:template match="individualName">
	<xsl:choose>
		<xsl:when test="givenName">
       <xsl:value-of select="concat(givenName,' ',surName)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="surName"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="node()"/>

</xsl:stylesheet>
