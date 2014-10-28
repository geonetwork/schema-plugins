# On going

## Translations

* Some elements are missing, use the editor to identify missing one (eg. mri:MD_AssociatedResource, mri:className). Cf tous les messages dans les logs:
```
gn-fn-metadata:getLabel | missing translation in schema iso19115-3 for mri:MD_AssociatedResource.
gn-fn-metadata:getLabel | missing translation in schema iso19115-3 for mri:name.
```

## Schematron

* Collect schema/**/*.sch for ISO validation level
* Add French translation to it (using sch:diagnostic ?)
* Convert iso19139 INSPIRE schematron to iso19115-3

## Associated resources

* Rework set/Unset thumbnail to work only on URL or filename and not on type. This will allow to have more than 2 thumbnails.

## Editor

* Configure multilingual element exclusion list https://github.com/geonetwork/schema-plugins/blob/master/iso19115-3/layout/config-editor.xml#L121

## Subtemplates

## Conversions

* ISO19139 to ISO19115-3
 * metadataStandard force to ISO19115-3 ?
 * codeList anyUriRef ?
* ISO19115-3 to ISO19139


# Nice to have

## CSW support

* A schema plugin should define what outputSchema could be used and define the conversion to apply. http://www.isotc211.org/namespace/mdb/1.0/2014-07-11 should be added to the list.

