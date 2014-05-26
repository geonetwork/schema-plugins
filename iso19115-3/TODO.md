# Need more work

## Translations

* Translate codelists at least in French and English
* Translate labels at least in French and English

## Associated resources

* Rework GetRelation to be more schema agnostic. See https://github.com/geonetwork/core-geonetwork/blob/develop/services/src/main/java/org/fao/geonet/guiservices/metadata/GetRelated.java#L208
 * eg. parent are not extracted properly for the time being.
* Rework set/Unset thumbnail to work only on URL or filename and not on type. This will allow to have more than 2 thumbnails.


## Templates

* Template general en vector, raster, map

## Conversions

* ISO19139 to ISO19115-3
 * metadataStandard force to ISO19115-3 ?
 * codeList anyUriRef ?

* ISO19115-3 to ISO19139

## CSW support

* A schema plugin should define what outputSchema could be used and define the conversion to apply. http://www.isotc211.org/2005/mdb/1.0/2013-06-24 should be added to the list.

