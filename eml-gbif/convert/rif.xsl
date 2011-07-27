<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								 xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xmlns:dc="http://purl.org/dc/terms/"  
                 xmlns="http://ands.org.au/standards/rif-cs/registryObjects"
                 xmlns:genId="java:org.fao.geonet.util.Sha1Encoder">

<!-- 
     Stylesheet to convert eml-gbif metadata response to RIF-CS/RIF
     Adapted and extended from ISO to RIFCS stylesheet 
		 (originally by Scott Yeadon, ANDS)
		 by Simon Pigot, CSIRO, 2011-07-26 

		 TODO: 
		   - eml project field - need to be mapped to activity registry object -
			                       not finished yet
			 - eml citation links
-->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="root">
    <xsl:apply-templates/>
</xsl:template>

<!-- the originating source --> 
<xsl:variable name="origSource" select="/root/env/siteURL"/>
        
<!-- the registry object group -->
<xsl:variable name="group" select="concat(/root/env/siteName,'|',/root/env/siteURL)"/>

<xsl:template match="eml:eml">
	<xsl:element name="registryObjects">
		<xsl:attribute name="xsi:schemaLocation">
        	<xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates mode="collection" select="."/>
		<xsl:if test="dataset/project">
			<xsl:apply-templates mode="activity" select="."/>
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template mode="genId" match="*">
	<!-- Encode string in element using sha1 in java method encodeString (class
	     org.fao.geonet.utils.Sha1Encoder - see genId namespace above) - this is
			 so that identifiers can be generated that are global eg. when creating
			 a relatedObject describing an organisation, the eml organizationName
			 element is passed to this template, then encoded as a sha1 string 
			 to produce an identifier. If this organizationName has already been 
			 used in a previous metadata emk record then it will already be present 
			 in the ANDS repository with this identifier - this saves duplication of 
			 parties (organizations and individuals) in the ANDS repository -->
	<xsl:value-of select="genId:encodeString(.)"/>
</xsl:template>

<xsl:template match="distribution">
	<xsl:element name="location">
		<xsl:element name="address">
			<xsl:element name="electronic">
				<xsl:attribute name="type">
					<xsl:text>url</xsl:text>
				</xsl:attribute>
				<xsl:element name="value">
					<xsl:value-of select="online/url"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
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
    <xsl:when test='contains(calendarDate, "T")'>
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(calendarDate, 'T00:00:00Z')"/> 
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="endDate">
  <xsl:choose>
    <xsl:when test='contains(calendarDate, "T")'>
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(calendarDate, 'T00:00:00Z')"/> 
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="organizationName|positionName">
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

<xsl:template match="boundingCoordinates">
	<xsl:element name="spatial">
		<xsl:attribute name="type">
			<xsl:text>iso19139dcmiBox</xsl:text>
		</xsl:attribute>
		<xsl:value-of select="concat('northlimit=',northBoundingCoordinate,'; southlimit=',southBoundingCoordinate,'; westlimit=',westBoundingCoordinate,'; eastLimit=',eastBoundingCoordinate)"/>
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

<xsl:template match="taxonomicCoverage">
	<xsl:for-each select="generalTaxonomicCoverage|taxonomicClassification/*">
  	<xsl:element name="subject">
			<!-- unfortunately the content in the taxonomic coverage elements 
			     used in eml-gbif is unlikely to be registered with the library of 
					 congress source codes for subjects so we have to use local
					 here - see 
 http://services.ands.org.au/documentation/rifcs/guidelines/rif-cs.html#subject
       -->
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

<!-- CREATE ACTIVITY Registry OBJECT -->

<xsl:template match="eml:eml" mode="activity">

	<!-- create an activity registry object from the dataset and
	     dataset/project element -->
	<xsl:element name="registryObject">
		<xsl:attribute name="group">
			<xsl:value-of select="$group"/>
		</xsl:attribute>

		<xsl:element name="key"> <!-- first alternateIdentifier -->
			<xsl:value-of select="dataset/alternateIdentifier[1]"/>
		</xsl:element>

  	<xsl:variable name="originatingSource" select="dataset/creator/onlineUrl"/>

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

		<xsl:element name="activity">
			<xsl:attribute name="type">
				<!-- from rifcs vocabs - piece of work that is undertaken or attempted
				     with a start date and end date plus defined objectives -->
				<xsl:value-of select="'project'"/>
			</xsl:attribute>

			<!-- identifier of activity object comes from project title -->
			<xsl:element name="identifier">
				<xsl:attribute name="type">
					<xsl:text>local</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="genId" select="dataset/project/title[1]"/>
			</xsl:element>
			
			<!-- name of activity object -->
			<xsl:element name="name">
				<xsl:attribute name="type">
					<xsl:text>primary</xsl:text>
				</xsl:attribute>
				<xsl:element name="namePart">
					<xsl:apply-templates select="dataset/project/title[1]"/>
				</xsl:element>
			</xsl:element>

			<!-- collection is an output of the project -->
			<xsl:element name="relatedObject">
				<xsl:element name="key">
					<xsl:value-of select="ancestor::eml:eml/dataset/alternateIdentifier[1]"/>
				</xsl:element>
				<xsl:element name="relation">
					<xsl:attribute name="type">
						<xsl:value-of select="'hasOutput'"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>

			<!-- TODO: project personnel need to be extracted and related -->

      <!-- TODO: create description elements from the studyAreaDescriptor,
			           designDescription and funding(?) elements -->
		</xsl:element>
	</xsl:element>
</xsl:template>

<!-- CREATE COLLECTION Registry OBJECT -->

<xsl:template match="eml:eml" mode="collection">

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

	<!-- create a collection registry object from the dataset element -->
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

			<!-- identifier of collection object comes from dataset identifier -->
			<xsl:element name="identifier">
				<xsl:attribute name="type">
					<xsl:text>local</xsl:text>
				</xsl:attribute>
				<!-- first alternateIdentifier -->
				<xsl:value-of select="dataset/alternateIdentifier[1]"/>
			</xsl:element>
			
			<!-- name of collection object -->
			<xsl:element name="name">
				<xsl:attribute name="type">
					<xsl:text>primary</xsl:text>
				</xsl:attribute>
				<xsl:element name="namePart">
					<xsl:apply-templates select="dataset/title[1]"/>
				</xsl:element>
			</xsl:element>

			<!-- location of metadata record -->
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

			<!-- location of any online resources related to dataset -->
			<xsl:apply-templates select="dataset/distribution"/>

			<!-- bounding coordinates and date range -->
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

			<!-- parties generated here - individuals first -->
			<xsl:for-each-group select="dataset/*[individualName]" group-by="individualName">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:apply-templates mode="genId" select="individualName"/>
					</xsl:element>	
					<xsl:for-each select="current-group()">
						<xsl:call-template name="createRelationFromRoleForCollection">
							<xsl:with-param name="role">
								<xsl:choose>
									<xsl:when test="role!=''">
										<xsl:value-of select="role"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="name(.)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>

			<!-- parties generated here - individuals with a position name only -->
			<xsl:for-each-group select="dataset/*[not(individualName) and positionName]" group-by="positionName">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:apply-templates mode="genId" select="positionName"/>
					</xsl:element>	
					<xsl:for-each select="current-group()">
						<xsl:call-template name="createRelationFromRoleForCollection">
							<xsl:with-param name="role">
								<xsl:choose>
									<xsl:when test="role!=''">
										<xsl:value-of select="role"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="name(.)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>

			<!-- parties generated here - now organizations -->
			<xsl:for-each-group select="dataset/*[organizationName!='']" group-by="organizationName">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:apply-templates mode="genId" select="organizationName"/>
					</xsl:element>
					<xsl:for-each select="current-group()">
						<xsl:call-template name="createRelationFromRoleForCollection">
							<xsl:with-param name="role">
								<xsl:choose>
									<xsl:when test="role!=''">
										<xsl:value-of select="role"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="name(.)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>
		
			<!-- create relatedObject that points to the project with
			     relation type isOutputOf -->
			<xsl:for-each select="dataset/project">
				<xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:apply-templates mode="genId" select="title[1]"/>
					</xsl:element>
					<xsl:element name="relation">
						<xsl:attribute name="type">
							<xsl:value-of select="'isOutputOf'"/>
						</xsl:attribute>
						<xsl:element name="description">
							Derived from eml element <xsl:value-of select="name(.)"/> 
							<xsl:value-of select="title"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>

      <!-- for keywords: thesaurus and taxonomic elements -->
      <xsl:apply-templates select="dataset/keywordSet"/>
      <xsl:apply-templates select="dataset/coverage/taxonomicCoverage"/>

      <!-- for abstract -->
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

      <!-- for temporal range -->
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

	<!-- create party objects for associatedParty, metadataCreator, contact etc
	     with an individualName defined -->
	<xsl:for-each-group select="dataset/*[individualName]" group-by="individualName">
		<xsl:element name="registryObject">
			<xsl:call-template name="createPartyRegistryObject">
				<xsl:with-param name="group" select="$group"/>
				<xsl:with-param name="originatingSource" select="$originatingSource"/>
				<xsl:with-param name="origSource" select="$origSource"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:for-each-group>

	<!-- create party objects for associatedParty, metadataCreator, contact etc
	     without an individualName but with a positionName defined -->
	<xsl:for-each-group select="dataset/*[not(individualName) and positionName]" group-by="positionName">
		<xsl:element name="registryObject">
			<xsl:call-template name="createPartyRegistryObject">
				<xsl:with-param name="group" select="$group"/>
				<xsl:with-param name="originatingSource" select="$originatingSource"/>
				<xsl:with-param name="origSource" select="$origSource"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:for-each-group>

	<!-- Create party objects for all organisations -->
	<xsl:for-each-group select="dataset/*[organizationName!='']" group-by="organizationName">
		<xsl:element name="registryObject">
			<xsl:call-template name="createPartyRegistryObject">
				<xsl:with-param name="group" select="$group"/>
				<xsl:with-param name="originatingSource" select="$originatingSource"/>
				<xsl:with-param name="origSource" select="$origSource"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:for-each-group>

</xsl:template>

<xsl:template name="addAddressAndRelatedObjects">
	<!-- to normalise address info and related objects we group them -->
	<xsl:for-each select="current-group()">
		<xsl:sort select="count(address/child::*) + count(phone)" data-type="number" order="descending"/>
		<xsl:if test="position()=1">
			<xsl:call-template name="fillOutAddress"/>		
		</xsl:if>
		<xsl:element name="relatedObject">
			<xsl:element name="key">
				<xsl:value-of select="ancestor::eml:eml/dataset/alternateIdentifier[1]"/>
			</xsl:element>	
			<xsl:call-template name="createRelationFromRoleForParty">
				<xsl:with-param name="role">
					<xsl:choose>
						<xsl:when test="string(role)!=''">
							<xsl:value-of select="role"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name(.)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:for-each>
</xsl:template>

<xsl:template name="createRelationFromRoleForCollection">
		<xsl:param name="role" select="string(role)"/>

		<xsl:element name="relation">
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="$role='owner' or $role='creator' or 
					                $role='custodian'">
						<xsl:value-of select="'isOwnedBy'"/>
					</xsl:when>
					<xsl:when test="$role='resourceProvider' or $role='contact'">
						<xsl:value-of select="'isManagedBy'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'hasAssociationWith'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="description">
				Derived from eml element <xsl:value-of select="name(.)"/> 
				<xsl:if test="individualName">
					<xsl:value-of select="concat(' with ',individualName/givenName,' ',individualName/surName)"/>
				</xsl:if>
				<xsl:if test="positionName!=''">
					<xsl:value-of select="concat(', ',positionName)"/>
				</xsl:if>
				<xsl:if test="organizationName!=''">
					<xsl:value-of select="concat(', ',organizationName)"/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
</xsl:template>

<xsl:template name="createRelationFromRoleForParty">
		<xsl:param name="role" select="string(role)"/>

		<xsl:element name="relation">
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="$role='owner' or $role='creator' or
					                $role='custodian'">
						<xsl:value-of select="'isOwnerOf'"/>
					</xsl:when>
					<xsl:when test="$role='resourceProvider' or $role='contact'">
						<xsl:value-of select="'isManagerOf'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'hasAssociationWith'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="description">
				Derived from eml element <xsl:value-of select="name(.)"/> 
				<xsl:if test="individualName">
					<xsl:value-of select="concat(' with ',individualName/givenName,' ',individualName/surName)"/>
				</xsl:if>
				<xsl:if test="positionName!=''">
					<xsl:value-of select="concat(', ',positionName)"/>
				</xsl:if>
				<xsl:if test="organizationName!=''">
					<xsl:value-of select="concat(', ',organizationName)"/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
</xsl:template>

<xsl:template name="createPartyRegistryObject">
	<xsl:param name="group"/>
	<xsl:param name="originatingSource"/>
	<xsl:param name="origSource"/>

	<xsl:attribute name="group">
		<xsl:value-of select="$group"/>
	</xsl:attribute>
  <xsl:element name="key">
    <xsl:choose>
      <xsl:when test="individualName">
				<xsl:apply-templates mode="genId" select="individualName"/>
      </xsl:when>
      <xsl:when test="positionName">
				<xsl:apply-templates mode="genId" select="positionName"/>
      </xsl:when>
      <xsl:otherwise>
				<xsl:apply-templates mode="genId" select="organizationName"/>
      </xsl:otherwise>
    </xsl:choose>
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
        <xsl:when test="positionName">
          <xsl:value-of select="'person'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'group'"/>
        </xsl:otherwise>
      </xsl:choose>
		</xsl:attribute>
		<xsl:element name="name">
			<xsl:attribute name="type">
				<xsl:text>primary</xsl:text>
			</xsl:attribute>
			<xsl:element name="namePart">
        <xsl:choose>
          <xsl:when test="individualName">
						<xsl:apply-templates select="individualName"/>
          </xsl:when>
          <xsl:when test="positionName">
            <xsl:value-of select="positionName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="organizationName"/>
          </xsl:otherwise>
        </xsl:choose>
			</xsl:element>
		</xsl:element>
		<xsl:call-template name="addAddressAndRelatedObjects"/>
	</xsl:element>
</xsl:template>

<xsl:template name="fillOutAddress">	
	<xsl:element name="location">
		<xsl:if test="organizationName or address">
			<xsl:element name="address">
				<xsl:element name="physical">
					<xsl:attribute name="type">
						<xsl:text>streetAddress</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates select="positionName"/>
					<xsl:apply-templates select="organizationName"/>
					<xsl:apply-templates select="address/deliveryPoint"/>
					<xsl:apply-templates select="address/city"/>
					<xsl:apply-templates select="address/administrativeArea"/>
					<xsl:apply-templates select="address/postalCode"/>
					<xsl:apply-templates select="address/country"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
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
</xsl:template>

<xsl:template match="node()"/>

</xsl:stylesheet>
