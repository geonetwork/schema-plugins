# core.sch

status: done

**conformance class** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-core-instance

**conformance dependencies:** NONE

**test:** /req/metadata-core-instance/property-type-content

*requirements:*

A property element instance MUST have exactly one of:

1. inline content (by-value) that is a schema-valid XML Class instance, or 
1. an xlink:href attribute (by-reference value), or 
1. a gco:nilReason attribute (nil value). 

#mcc:  Metadata common classes

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

No schematron tests required for this class (but there is a dependency on cit)

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-core-instance
- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml


note the circular dependencies between conf/common-classes-xml and conf/citation-xml.  Essentially one schematron will need to test both of these conformance classes in order to avoid circular imports.

#cit.sch
status: done

**conformance class:**  http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-core-instance

note the circular dependencies between conf/common-classes-xml and conf/citation-xml.  Essentially one schematron will need to test both of these conformance classes in order to avoid circular imports.

**test:** /conf/citation-xml/schematron-rules

*requirements:* 

1. /req/citation/individual-name: 
Any instance of CI_Individual MUST have either a name property value or a positionName property value
2. /req/citation/organisation-name: 
Any instance of CI_Organisation MUST have either a name property value or a logo property value

#lan:  Language localization

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/language-localization-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml

note that citation-xml has a depencency on common-classes-xml 

no schematron validation required

#mas.sch: Application schema 
**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/application-schema-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

No schematron rules required to validate this class

#mco.sch: Constraints
status:done

**conformance class:**  http://www.isotc211.org/spec/19115-3/1.0/conf/constraints-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**test:** /conf/constraints-xml/schematron-rules

*requirements:*

1. /req/constraints-instance/legal-constraints: If a MD_LegalConstraints elements is instantiated, then it MUST have a property value for at least one of accessConstraints, useConstraints, otherConstraints, useLimitation, or releasability.
1. /req/constraints-instance/other-restrictions: A value may be provided for the otherConstraints property ONLY if the code value of an accessConstraints or useConstraints property is equal to "otherRestrictions".
1. /req/constraints-instance/releasability: If a MD_Releasability element is instantiated, then it MUST have a property value for at least one of addressee or statement.

#gex.sch: Geospatial extent 
status: done

**conformance class:**  http://www.isotc211.org/spec/19115-3/1.0/conf/geospatial-extent-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/reference-system-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**test:** /conf/geospatial-extent-xml/schematron-rules

*requirements:*

1. /req/geospatial-extent-instance/value-required: If an EX_Extent element is instantiated, then a value for either description, geographicElement, temporalElement or verticalElement MUST be present.
1. /req/geospatial-extent-instance/vertical-crs:  If an EX_VerticalExtent element is instantiated, then a value for either verticalCRSid or verticalCRS MUST be present.

#mmi.sch: Maintenance information
status:done

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/maintenance-information-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**test:** /conf/maintenance-information-xml/schematron-rules

*requirements:*

1. /req/maintenance-information/frequency: If a MD_MaintenanceInformation element is instantiated, then a value for either the maintenanceAndUpdateFrequency or userDefinedMaintenanceFrequency property must be present.

#mpc.sch: Portrayal catalogue
**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/portrayal-catalogue-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

no schematron rules required for validation

#mrc.sch: Resource content 

status:done

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/resource-content-xml

**Conformance Dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/language-localization-xml

note that language-localization-xml has dependency on citation-xml, so should only need to include lan.sch

**test:**/conf/resource-content-xml/schematron-rules

*requirements:*

1. /req/resource-content-instance/feature-catalogue
If a MD_FeatureCatalogueDescription is instantiated, then either the value for includedWithDataset MUST be 'true', or a well formed and valid MD_FeatureCatalogue instance must be included in the metadata record, or a value MUST be provided for featureCatalogueCitation. 
1. /req/resource-content-instance/inline-feature-catalogue
If a MD_FeatureCatalogue instance is included with an inline featureCatalogue, the XML schema for the  http://www.isotc211.org/2005/gfc namespace must be imported in the instance document.
1. /req/resource-content-instance/dimension-units
If a MD_SampleDimension element is instantiated and at least one of the maxValue, minValue or meanValue properties has a value, then a value MUST be provided for the units property. 
1. /req/resource-content-instance/band-dimension-units
If a MD_Band element is instantiated , then the value of the units property MUST be a unit of length.

#mrd.sch: Resource distribution 
status:done

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/resource-distribution-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**test:** /conf/resource-distribution-xml/schematron-rules

*requirements:*

1. /req/resource-distribution/medium-density: If a MD_Medium element is instantiated and a value for the density property is present, then a value for the densityUnits property MUST be provided

#mri.sch: Resource identification 

status: done

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/resource-identification-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**test:** /conf/resource-identification-xml/schematron-rules

*requirements:*

1. /req/resource-identification-instance/associated-resource
If a MD_AssociatedResource element is instantiated, then a value for either the name or metadataReference property MUST be provided. 

*Recommendation:* If the resource described by a metadata instance contains textual information, then a value SHOULD be provided for MD_DataIdentification defaultLocale.

#mrl.sch: Resource lineage

status: done

**conformance class:**  http://www.isotc211.org/spec/19115-3/1.0/conf/lineage-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/resource-identification-xml

**test:** /conf/lineage-xml/schematron-rules

*Requirements:*

1. /req/lineage-instance/lineage-content: If a LI_Lineage element is instantiated and no value is provided for the LI_Lineage.statement property, then at least one of processStep or source MUST have a value.
2. /req/lineage-instance/source: If a LI_Source element is instantiated, then either the description or scope property MUST have a value.

#mrs.sch: Resource reference system

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/reference-system-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

No schematron rules specific to this package

#msr.sch: Spatial representation 

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/spatial-representation-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

No schematron rules specific to this package.


#srv.sch: Service metadata
status:done

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/service-metadata-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/resource-distribution-xml

**test:** /conf/service-metadata-xml/schematron-rules

*requirements:*

1. /req/service-metadata-instance/chain-or-operation: A `SV_ServiceIdentification` instance MUST have a value for either the `containsChain` or the `containsOperations` property. 
1. /req/service-metadata-instance/coupled-resource-exists: If the `coupledResource` property has a value, then the `couplingType` property MUST have a value
1. /req/service-metadata-instance/operated-or-operates-on: A `SV_ServiceIdentification` instance MUST NOT contain values for both the `operatesOn` and `operatedDataset` properties. 
1. /req/service-metadata-instance/coupled-resource-defined: If a `SV_CoupledResource` element is instantiated, then either the `resourceReference` or the `resource` property MUST have a value.
1. /req/service-metadata-instance/coupled-resource-linkage: A `SV_CoupledResource` instance MUST NOT contain values for both the `resource` and `resourceReference` properties.

NOTE: the 19115-1 spec (FDIS, N3558) has a constraint "If coupledResource exists then count (coupledResource) > 0". this seems self evident, so not schematron rule is implemented. 


*recommendation:* /req/service-metadata-instance/service-keyword: If the value of `MD_Metadata.metadataScope.MD_MetadataScope.resourceScope` property is equal to "service", then one instance of `MD_Keyword` MUST have a `keyword` property value that is a term from the the service taxonomy defined in ISO 19119, 8.3, Table 9.


#mex.sch: Metadata extension 

**conformance class:**  http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-extension-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**test:** /conf/metadata-extension-xml/schematron-rules

/req/metadata-extension-instance/cardinality
/req/metadata-extension-instance/conditional-condition
/req/metadata-extension-instance/code-mandatory
/req/metadata-extension-instance/conceptname-mandatory 
/req/metadata-extension-instance/name-proscribed

1. /req/metadata-extension-instance/cardinality: Values for the obligation, maximumOccurrence and domainValue properties in instances of  MD_ExtendedElementInformation MUST be provided,  EXCEPT when the dataType property code value is one of {codelist, enumeration, codelistElement}. 
1. /req/metadata-extension-instance/conditional-condition: A value for the condition property MUST be provided when the code value of the obligation property is equal to 'conditional'. 
1. /req/metadata-extension-instance/code-mandatory: If the code value of the dataType property is one of {codelist, enumeration, codelistElement} then a value MUST be provided for the code property
1. /req/metadata-extension-instance/conceptname-mandatory: If the code value of the dataType property is one of {codelist, enumeration, codelistElement} then a value MUST be provided for the conceptName property 
1. /req/metadata-extension-instance/name-proscribed
If the code value of the dataType property is one of {codelist, enumeration, codelistElement} the name property must be a nil value with a nilReason = 'notApplicable' attribute value.

#gcx.sch Geospatial common extended 

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/extended-types-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

No schematron rules are specific to this class.

--------------------------------------------------------

#Conformance tests for interchange documents

#metadata-base.sch: Metadata base instance document
status:done

**Conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-base-instance

**Conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml

**Test:** /conf/metadata-base-instance/root-element

1. /req/metadata-base-instance/root-element: A metadata instance document conforming to this specification SHALL have a root MD_Metadata element defined in the http://www.isotc211.org/2005/mdb/1.0 namespace.

**Test:** /conf/metadata-base-instance/language

1. /req/metadata-base-instance/language: If the language of the metadata content is not the defined default value (English, see Clause 8.3), then a value must be provided for defaultLocale language property consistent with the language content of the metadata instance.  There is no way to test with Schematron.

**Test:** /conf/metadata-base-instance/character-encoding

1. /req/metadata-base-instance/character-encoding
If the character encoding of the metadata content is not the defined default value (UTF-8, see Clause 8.3), then a value must be provided for defaultLocale characterEncoding property consistent with the character encoding of the metadata instance. There is no way to test with schematron.

**Test:** /conf/metadata-base-instance/metadata-scope-name

1. /req/metadata-base-instance/metadata-scope-name
If a MD_MetadataScope element is present, the name property MUST have a value if resourceScope is not equal to "dataset"

**Test:** /conf/metadata-base-instance/metadata-creation-date

1. /req/metadata-base-instance/metadata-creation-date
A dateInfo property value with data type = "creation" MUST be present in every MD_Metadata instance.


# ??.sch Minimal metadata document

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-minimal-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-base-instance
- http://www.isotc211.org/spec/19115-3/1.0/conf/common-classes-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/citation-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/resource-identification-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/language-localization-xml

**test:**  /conf/metadata-minimal-xml/schematron-rules

*requirements*

1. /req/resource-identification-instance/dataset-extent
If no value for the MD_Metadata.metadataScope property is provided, or if the value of MD_Metadata.metadataScope.MD_MetadataScope. resourceScope property is equal to "dataset", then an instance of at least one of EX_GeographicBoundingBox or EX_GeographicDescription MUST be present in the metadata instance.
1. /req/resource-identification-instance/topic-category
If no value for the MD_Metadata.metadataScope property is provided, or if the value of MD_Metadata.metadataScope.MD_MetadataScope. resourceScope property is equal to "dataset" or equal to "series", then a value for topicCategory MUST be provided.


# Complete metadata record

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-full-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-minimal-xml
- http://www.isotc211.org/spec/19115-3/1.0/req/application-schema-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/constraint-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/lineage-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/geospatial-extent-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/resource-content-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/resource-distribution-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/maintenance-information-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/portrayal-catalogue-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/reference-system-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/service-metadata-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/spatial-representation-xml

Test is schema validation using mds.xsd. No additional schematron rules required.

#Metadata using geospatial common extended types

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-extended-types-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-full-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/extended-types-xml

Validate with md1.xsd. No additional schematron tests required.


#extended-metadata.sch: Extended metadata record

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/extended-metadata-xml 

Note that any profile that extends the base schema will need to include schema imports for the extension namespace, as well as any other ISO19115-3 components that are needed, and will need to specify schema locations for the extension namespaces in all instance documents (see tests below).  

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-minimal-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-extension-xml

**Tests:**

1. /conf/extended-metadata/validation: Verify that a MD_Metadata XML instance that includes child elements not defined by this specification include at least one MD_MetadataExtensionInformation element that is valid against the XML schema for the http://www.isotc211.org/2005/mex/1.0 namespace. [This needs to be tested by schematron,since we don't know what the root element of the extened metadata will be].
1. /conf/extended-metadata-xml/new-section: Verify that if a MD_Metadata XML instance includes child elements not defined by this specification, those elements are namespace-qualified with a namespace URI different from namespaces defined by this specification
1. /conf/extended-metadata-xml/validation: Verify that a MD_Metadata XML instance that includes child elements not defined by this specification can be validated using an XML schema validation engine; all namespaces must be associated with working schema locations. [Schematron test should look for schema locations associated with each namespace? We don't know a priori what the extended namespace URIs will be].
1. /conf/extended-metadata-xml/new-codelist: Verify that any codelists utilized in the extended metadata con-tent are implemented following the rules in clause 8.5.5 of ISO 19139. [I don't know how we're going to test this with schematron?]
1. /conf/extended-metadata-xml/new-element: Verify that any new XML elements utilized in the extended metadata content are implemented as subclasses of existing ISO19100-series classes following guidelines in clause 8.5.3 of ISO 19139. [is schematron test possible?-- maybe just report the elements?]
1. /conf/extended-metadata-xml/iso-type: Verify that any new XML elements utilized in the extended metadata content includes an isoType attribute with a value that is the name of an existing ISO 19100-series class. [If namespace not in 19115-3 namespace collection, then isoType attribute is mandatory?]

Many of the tests for this conformance class are 'by inspection' kinds of things.

# Catalogue instance 

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/catalogue-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-core-instance
- http://www.isotc211.org/spec/19115-3/1.0/conf/language-localization-xml

No additional schematron rules required for this class

# Metadata application

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-application-xml

**conformance dependencies:**

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-full-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/extended-types-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/extended-metadata-xml

No additional schematron rules required for this class

# Metadata for data transfer

**conformance class:** http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-data-transfer-xml

**conformance dependencies:** 

- http://www.isotc211.org/spec/19115-3/1.0/conf/metadata-application-xml
- http://www.isotc211.org/spec/19115-3/1.0/conf/extended-types-xml

No additional schematron rules required for this class
