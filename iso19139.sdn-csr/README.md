
# Schema plugin for Cruise Summary Report (CSR).

This is the schema plugin for Cruise Summary Report ISO19139 profil for GeoNetwork. 


"Cruise Summary Reports (CSR = former ROSCOPs) are the usual means for reporting on cruises or field experiments at sea. Traditionally, it is the Chief Scientist's obligation to submit a CSR to his/her National Oceanographic Data Centre (NODC) not later than two weeks after the cruise. This provides a first level inventory of measurements and samples collected at sea. Currently, the Cruise Summary Reports directory covers cruises from 1873 till today from more than 2.000 research vessels: a total of nearly 53.000 cruises, in all European waters and global oceans. This also includes historic CSRs from European countries, that have been loaded from the ICES database from 1960 onwards."


More information and official schema for CSR can be found here: http://www.seadatanet.org/Metadata/CSR


### Note about the implementation: 

* CSR is based on ISO19139-2 and include GML 3.2.0 instead of GML 3.2.1 in the official ISO XSDs
* Indexing: the complete record is indexed as full text. 
 * There is no custom indexing on the acquisition information section. This could be improved in index-fields.xsl.
 * There is no indexing on MultiCurve geometry (https://github.com/geonetwork/core-geonetwork/issues/321). This could be improved in extract-gml.xsl
 * sdn:SDN_WaterBodyCode, sdn:SDN_MarsdenCode
* Relation: List of related record not supported (alignement to latest GeoNetwork recommended to use https://github.com/geonetwork/core-geonetwork/pull/285)

### Known limitations:


* LineString are not indexed and not displayed properly

```
<gmd:polygon>
   <gml:MultiCurve gml:id="mc01">
       <gml:curveMember>
          <gml:LineString gml:id="ls001">
             <gml:description>This is line 1</gml:description>
             <gml:name codeSpace="http://www.seadatanet.org/urnurl/"
                >line1</gml:name>
             <gml:posList>-68.548849 73.889864 -61.408617 72.824456 -58.026401
                68.136664 -56.523193 62.38344 -49.007153 59.400296</gml:posList>
          </gml:LineString>
````


![multicurve-display](https://f.cloud.github.com/assets/1701393/1705005/6fb7f1bc-60d5-11e3-850e-db7c06d87728.png)


* xlink:href may interact with XLink resolver but usually they are local link (in the document)

```
<gmi:significantEvent xlink:href="event-instrument-1-B90-532"/>
```



