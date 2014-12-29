<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Schematron validation for ISO 19115-1:2014 standard</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">Règles de validation pour le standard ISO 19115-1:2014</sch:title>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <sch:ns prefix="srv" uri="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"/>
  <sch:ns prefix="mds" uri="http://www.isotc211.org/namespace/mds/1.0/2014-07-11"/>
  <sch:ns prefix="mdb" uri="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"/>
  <sch:ns prefix="mcc" uri="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"/>
  <sch:ns prefix="mri" uri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"/>
  <sch:ns prefix="mrs" uri="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"/>
  <sch:ns prefix="mrd" uri="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"/>
  <sch:ns prefix="mco" uri="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"/>
  <sch:ns prefix="msr" uri="http://www.isotc211.org/namespace/msr/1.0/2014-07-11"/>
  <sch:ns prefix="mrc" uri="http://www.isotc211.org/namespace/mrc/1.0/2014-07-11"/>
  <sch:ns prefix="mrl" uri="http://www.isotc211.org/namespace/mrl/1.0/2014-07-11"/>
  <sch:ns prefix="lan" uri="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"/>
  <sch:ns prefix="gcx" uri="http://www.isotc211.org/namespace/gcx/1.0/2014-07-11"/>
  <sch:ns prefix="gex" uri="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"/>
  <sch:ns prefix="mex" uri="http://www.isotc211.org/namespace/mex/1.0/2014-07-11"/>
  <sch:ns prefix="dqm" uri="http://www.isotc211.org/namespace/dqm/1.0/2014-07-11"/>
  <sch:ns prefix="cit" uri="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"/>
  <sch:ns prefix="mmi" uri="http://www.isotc211.org/namespace/mmi/1.0/2014-07-11"/>
  <sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema"/>
  <sch:diagnostics>
    <sch:diagnostic id="conf.metadata-base-instance.root-element-failure-en" xml:lang="en">The root element must be MD_Metadata.</sch:diagnostic>
    <sch:diagnostic id="conf.metadata-base-instance.root-element-failure-fr" xml:lang="fr">Modifier l'élément racine du document pour que ce soit un élément MD_Metadata.</sch:diagnostic>

    <sch:diagnostic id="conf.metadata-base-instance.root-element-success-en" xml:lang="en">
      <sch:value-of select="$numberOfMD_MetadataElement"/> root element MD_Metadata found.</sch:diagnostic>
    <sch:diagnostic id="conf.metadata-base-instance.root-element-success-fr" xml:lang="fr">
      <sch:value-of select="$numberOfMD_MetadataElement"/> élément(s) racine(s) MD_Metadata identifié(s).</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern id="conf.metadata-base-instance.root-element">
    <sch:title xml:lang="en">Metadata document root element</sch:title>
    <sch:title xml:lang="fr">Élément racine du document</sch:title>
    <sch:p xml:lang="en">A metadata instance document conforming to
      this specification SHALL have a root MD_Metadata element
      defined in the http://www.isotc211.org/2005/mdb/1.0 namespace.</sch:p>
    <sch:p xml:lang="fr">Une fiche de métadonnées conforme au standard
      ISO19115-1 DOIT avoir un élément racine MD_Metadata (défini dans l'espace
      de nommage http://www.isotc211.org/2005/mdb/1.0).</sch:p>
    <sch:rule context="/">
      <sch:let name="numberOfMD_MetadataElement" value="count(/mdb:MD_Metadata)"/>

      <sch:assert test="$numberOfMD_MetadataElement = 1"
                  diagnostics="conf.metadata-base-instance.root-element-failure-en                     conf.metadata-base-instance.root-element-failure-fr"/>

      <sch:report test="$numberOfMD_MetadataElement = 1"
                  diagnostics="conf.metadata-base-instance.root-element-success-en                       conf.metadata-base-instance.root-element-success-fr"/>
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <sch:diagnostic id="conf.metadata-base-instance.scope-name-failure-en" xml:lang="en">Specify a name for the metadata scope
      (required if the scope code is not "dataset").</sch:diagnostic>
    <sch:diagnostic id="conf.metadata-base-instance.scope-name-failure-fr" xml:lang="fr">Préciser la description du domaine d'application
      (car le document décrit une ressource qui n'est pas un "jeu de données").</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern id="conf.metadata-base-instance.scope-name">
    <sch:title xml:lang="en">Scope Name</sch:title>
    <sch:title xml:lang="fr">Description du domaine d'application</sch:title>
    <sch:p xml:lang="en">If a MD_MetadataScope element is present,
      the name property MUST have a value if resourceScope is not equal to "dataset"</sch:p>
    <sch:p xml:lang="fr">Si un élément domaine d'application (MD_MetadataScope)
      est défini, sa description (name) DOIT avoir une valeur
      si se domaine n'est pas "jeu de données" (ie. "dataset").</sch:p>
    <sch:rule context="//mdb:MD_MetadataScope/mdb:resourceScope/                           mcc:MD_ScopeCode[not(@codeListValue ='dataset')]">
      <sch:assert test="(count(../../mdb:name)=1)"
                  diagnostics="conf.metadata-base-instance.scope-name-failure-en                      conf.metadata-base-instance.scope-name-failure-fr"/>
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <sch:diagnostic id="conf.metadata-base-instance.create-date-failure-en" xml:lang="en">Specify a creation date for the metadata record
      (MD_Metadata/dateInfo... with CI_DateTypeCode/@codeListValue='creation').</sch:diagnostic>
    <sch:diagnostic id="conf.metadata-base-instance.create-date-failure-fr" xml:lang="fr">Specify a creation date for the metadata record
      (MD_Metadata/dateInfo... with CI_DateTypeCode/@codeListValue='creation').</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern id="conf.metadata-base-instance.create-date">
    <sch:title xml:lang="en">Metadata create date</sch:title>
    <sch:title xml:lang="fr">Date de création du document</sch:title>
    <sch:p xml:lang="en">A dateInfo property value with data type = "creation"
      MUST be present in every MD_Metadata instance.</sch:p>
    <sch:p xml:lang="fr">Tout document DOIT avoir une date de création
      définie (en utilisant un élément dateInfo avec un type "creation").</sch:p>
    <sch:rule context="mdb:MD_Metadata">
      <sch:assert test="count(./mdb:dateInfo/cit:CI_Date/         cit:dateType/cit:CI_DateTypeCode[@codeListValue='creation']) &gt; 0"
                  diagnostics="conf.metadata-base-instance.create-date-failure-en                      conf.metadata-base-instance.create-date-failure-fr"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>Spatial Respresentation Requirements</sch:title>
    <sch:p>There are no specific schematron rules for the msr namespace, but the core.sch rules apply.</sch:p>
  </sch:pattern>
  <sch:pattern id="conf.constraints-xml.schematron-rules">
    <sch:title>Constraint Requirements</sch:title>
    <sch:p>Constraints for elements in the mco namespace</sch:p>
    <sch:rule context="//mco:MD_LegalConstraints">
      <sch:assert test="(count(./mco:accessConstraints) +          count(./mco:useConstraints) +         count(./mco:otherConstraints) +         count(./mco:useLimitation) +          count(./mco:releasability)) &gt; 0">Specify either mco:accessConstraints, mco:useConstraints, mco:otherConstraint, mco:useLimitation or mco:releasability for each mco:MD_LegalConstraints.</sch:assert>
    </sch:rule>
    <sch:rule context="//mco:otherConstraints/gco:CharacterString">
      <sch:assert test="(count(../../mco:accessConstraints[mco:MD_RestrictionCode='otherRestrictions']) +         count(../../mco:accessConstraints[mco:MD_RestrictionCode/@codeListValue='otherRestrictions']) +         count(../../mco:useConstraints[mco:MD_RestrictionCode='otherRestrictions']) +         count(../../mco:useConstraints[mco:MD_RestrictionCode/@codeListValue='otherRestrictions'])) &gt; 0">Specify mco:otherConstraints only if accessConstraints or useConstraints = 'otherRestrictions'.</sch:assert>
    </sch:rule>
    <sch:rule context="//mco:MD_Releasability">
      <sch:assert test="(count(./mco:addressee) +          count(./mco:statement/gco:CharacterString)) &gt; 0">Specify either mco:addressee or mco:statement for each mco:MD_MD_Releasability.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>Application Schema Requirements</sch:title>
    <sch:p>There are no specific schematron rules for the mas namespace, but the core.sch rules apply.</sch:p>
  </sch:pattern>
  <sch:pattern>
    <sch:title>Geospatial Extension Requirements</sch:title>
    <sch:p>There are no specific schematron rules for the gcx namespace, but the core.sch rules apply.</sch:p>
  </sch:pattern>
  <sch:pattern id="conf.geospatial-extent-xml.schematron-rules">
    <sch:title>Extent Requirements</sch:title>
    <sch:p>Constraints for elements in the gex namespace</sch:p>
    <sch:rule context="//gex:EX_Extent">
      <sch:assert test="(count(./gex:description) +          count(./gex:geographicElement) +         count(./gex:temporalElement) +         count(./gex:verticalElement)) &gt; 0">Specify either gex:description, gex:geographicElement, gex:temporalElement or gex:verticalElement for each gex:EX_Extent.</sch:assert>
    </sch:rule>
    <sch:rule context="//gex:EX_VerticalExtent">
      <sch:assert test="(count(./gex:verticalCRS) +          count(./gex:verticalCRSId)) &gt; 0">Specify either gex:verticalCRS or gex:verticalCRSId for each gex:EX_Extent.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="conf.constraints-xml.schematron-rules">
    <sch:title>Constraints Requirements</sch:title>
    <sch:p>Every MD_LegalConstraints must include accessConstraints, useConstraints, otherConstraint, useLimitation or releasability</sch:p>
    <sch:rule context="//mco:MD_LegalConstraints">
      <sch:assert test="(count(./mco:accessConstraints/mco:MD_RestrictionCode) +          count(./mco:useConstraints/mco:MD_RestrictionCode) +         count(./mco:otherConstraints/gco:CharacterString) +         count(./mco:useLimitation/gco:CharacterString) +          count(./mco:releasability/gco:CharacterString)) &gt; 0">Specify either mco:accessConstraints, mco:useConstraints, mco:otherConstraint, mco:useLimitation or mco:releasability for each mco:MD_LegalConstraints.</sch:assert>
    </sch:rule>
    <sch:rule context="//mco:otherConstraints/gco:CharacterString">
      <sch:assert test="(count(../../mco:accessConstraints[mco:MD_RestrictionCode='otherRestrictions']) +         count(../../mco:accessConstraints[mco:MD_RestrictionCode/@codeListValue='otherRestrictions']) +         count(../../mco:useConstraints[mco:MD_RestrictionCode='otherRestrictions']) +         count(../../mco:useConstraints[mco:MD_RestrictionCode/@codeListValue='otherRestrictions'])) &gt; 0">Specify mco:otherConstraints only if accessConstraints or useConstraints = 'otherRestrictions'.</sch:assert>
    </sch:rule>
    <sch:rule context="//mco:MD_Releasability">
      <sch:assert test="(count(./mco:addressee) +          count(./mco:statement/gco:CharacterString)) &gt; 0">Specify either mco:addressee or mco:statement for each mco:MD_MD_Releasability.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               id="conf.resource-content-xml.schematron-rules">
    <sch:title>Content Requirements</sch:title>
    <sch:p>Constraints for elements in the mrc namespace. No check is doe to ensure that MD_Band/units is a unit of length.</sch:p>
    <sch:rule context="//mrc:MD_FeatureCatalogue">
      <sch:assert test="contains(/*/@xsi:schemaLocation,'http://www.isotc211.org/2005/gfc')">The Feature Catalog schema location must be defined for the MD_FeatureCatalog.</sch:assert>
    </sch:rule>
    <sch:rule context="//mrc:MD_FeatureCatalogueDescription">
      <sch:assert test="(./mrc:includedWithDataset[gco:Boolean='true'] | ./mrc:featureCatalogueCitation | ../mrc:MD_FeatureCatalogue)">The Feature Catalog must be included eith the data, cited, or included in the metadata record</sch:assert>
    </sch:rule>
    <sch:rule context="//mrc:attribute/mrc:MD_SampleDimension">
      <sch:report test="(mrc:minValue | mrc:maxValue | mrc:meanValue) and not(mrc:units)">Specify mrc:units if mrc:minValue, mrc:maxValue or mrc:meanValue exists.</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="conf.resource-identification-xml.schematron-rules">
    <sch:title>Resource Identification metadata Requirements</sch:title>
    <sch:p>If a MD_AssociatedResource element is instantiated, then a value for either the name or metadataReference property MUST be provided.</sch:p>
    <sch:rule context="//mri:MD_AssociatedResource">
      <sch:assert test="(count(./mri:name)  + count(./mri:metadataReference)) &gt; 0">Specify either a name for the associated resource, or provide a metadataReference to a
        metadata record that describes the resource</sch:assert>
    </sch:rule>

  </sch:pattern>
  <sch:pattern id="conf.citation-xml.schematron-rules">
    <sch:title>Citation Requirements</sch:title>
    <sch:p>Every CI_Individual must include a cit:name or cit:positionName value and Every CI_Organization must include a cit:name or cit:positionName value</sch:p>
    <sch:rule context="//cit:CI_Individual">
      <sch:assert test="(count(./cit:name/gco:CharacterString) + count(./cit:positionName/gco:CharacterString)) &gt; 0">Specify either cit:individualName, cit:positionName for each cit:CI_Individual.</sch:assert>
    </sch:rule>
    <sch:rule context="//cit:CI_Organisation">
      <sch:assert test="(count(./cit:name/gco:CharacterString) + count(./cit:logo/mcc:MD_BrowseGraphic/mcc:fileName/gco:CharacterString)) &gt; 0">Specify either cit:name, cit:logo for each cit:CI_Organization.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="conf.language.schematron-rules">
    <sch:title>Language Requirements</sch:title>
    <sch:p>There are no specific schematron rules for the lan namespace, but the core.sch rules apply.</sch:p>
  </sch:pattern>
  <sch:pattern id="conf.resource-distribution-xml.schematron-rules">
    <sch:title>Distribution Requirements</sch:title>
    <sch:p>Constraints for elements in the mrd namespace</sch:p>
    <sch:rule context="//mrd:MD_Medium">
      <sch:report test="(mrd:density and not(mrd:densityUnits))">Specify units for the density.</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="conf.service-metadata-xml.schematron-rules">
    <sch:title>Service metadata Requirements</sch:title>
    <sch:p>1. A SV_ServiceIdentification instance MUST have a value for either the containsChain or
      the containsOperation property.</sch:p>
    <sch:p>3. A SV_ServiceIdentification instance MUST NOT contain values for both the operatesOn
      and operatedDataset properties.</sch:p>
    <sch:rule context="//srv:SV_ServiceIdentification">
      <sch:report test="(count(./srv:containsChain)  + count(./srv:containsOperations)) = 0">Specify
        either a containsChain or containsOperation property for the service identified. </sch:report>
      <sch:report test="((count(./srv:containsChain) &gt; 0) and (count(./srv:containsOperations) &gt; 0))">Specify only one of
        containsChain OR containsOperation for the service identified. </sch:report>
      <sch:report test="((count(./srv:operatesOn) &gt; 0)  and (count(./srv:operatedDataset) &gt; 0))">Specify only one of
        operatesOn OR operatedDataset for the service identified. </sch:report>
    </sch:rule>

    <sch:p>2. If the coupledResource property has a value, then the couplingType property MUST have
      a value</sch:p>
    <sch:rule context="//srv:coupledResource">
      <!-- couplingType is 0..1, so only one value may be present -->
      <sch:assert test="(count(../srv:couplingType)) = 1">Specify a couplingType for the coupledResource.
      </sch:assert>
    </sch:rule>

    <sch:p>If a SV_CoupledResource element is instantiated, then either the resourceReference or the
      resource property MUST have a value. A SV_CoupledResource instance MUST NOT contain values for
      both the resource and resourceReference properties.</sch:p>
    <sch:rule context="//srv:SV_CoupledResource">
      <sch:assert test="(count(./srv:resource) + count(./srv:resourceReference) &gt; 0)">Specify a resource or resourceReference for the coupledResource instance</sch:assert>
      <sch:report test="(count(./srv:resource) &gt; 0) and (count(./srv:resourceReference) &gt; 0)">Specify only one of resoure OR
        resourceReference for the coupledResource. </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>Portrayal Catalog Requirements</sch:title>
    <sch:p>There are no specific schematron rules for the mpc namespace, but the core.sch rules apply.</sch:p>
  </sch:pattern>
  <sch:pattern id="conf.lineage-xml.schematron-rules">
    <sch:title>Lineage Metadata Requirements</sch:title>
    <sch:p>If a LI_Lineage element is instantiated and no value is provided for the LI_Lineage.statement property, then at least one of processStep or source MUST have a value.
      and
      If a LI_Source element is instantiated, then either the description or scope property MUST have a value.</sch:p>
    <sch:rule context="//mrl:LI_Lineage">
      <sch:assert test="(count(./mrl:statement)  + count(./mrl:source | ./mrl:processStep)) &gt; 0">Specify either a lineage statement (mrl:statement), or one of (mrl:processStep or mrl:source)
      </sch:assert>
    </sch:rule>
    <sch:rule context="//mrl:LI_Source">
      <sch:assert test="(count(./mrl:description)  + count(./mrl:scope)) &gt; 0">Specify a mrl:description or mrl:scope property in each LI_Source element.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="elementContent">
    <sch:title>Element Content</sch:title>
    <sch:rule context="*">
      <sch:assert test="./gco:CharacterString | ./@gco:nilReason | ./@indeterminatePosition | ./@xlink:href | @uuidref | ./@codeListValue | ./child::node()">Element must have content or one of the following attributes: nilReason, xlink:href or uuidref. </sch:assert>
      <sch:assert test="contains('missing inapplicable template unknown withheld', ./@gco:nilReason)">'<sch:value-of select="./@gco:nilReason"/>' is not an accepted value. gco:nilReason attribute may only contain: missing, inapplicable, template, unknown, or withheld for element: <sch:name path="."/>
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>Reference System Requirements</sch:title>
    <sch:p>There are no specific schematron rules for the mrs namespace, but the core.sch rules apply.</sch:p>
  </sch:pattern>
  <sch:pattern id="conf.geospatial-extent-xml.schematron-rules">
    <sch:title>Maintenance Information Requirements</sch:title>
    <sch:p>Constraints for elements in the mmi namespace</sch:p>
    <sch:rule context="//mmi:MD_MaintenanceInformation">
      <sch:assert test="(count(./mmi:maintenanceAndUpdateFrequency) +          count(./mmi:userDefinedMaintenanceFrequency)) &gt; 0">Specify either mmi:MD_MaintenanceInformation or mmi:userDefinedMaintenanceFrequency for each mmi:MD_MaintenanceInformation.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>