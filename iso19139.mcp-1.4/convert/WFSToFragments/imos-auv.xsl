<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:helpers="helpers"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    version="2.0">
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <records>
            <xsl:apply-templates select="*"/>
        </records>
    </xsl:template>
    
    <xsl:template match="gml:featureMembers">
        <xsl:apply-templates select="helpers:auv_track_md"/>
    </xsl:template>
    
    <xsl:template match="helpers:auv_track_md">
        <xsl:variable name="metadata_uuid" select="helpers:metadata_uuid"/>
        <xsl:variable name="facility_code" select="helpers:facility_code"/>
        <xsl:variable name="campaign_code" select="helpers:campaign_code"/>
        <xsl:variable name="metadata_campaign" select="helpers:metadata_campaign"/>
        <xsl:variable name="site_code" select="helpers:site_code"/>
        <xsl:variable name="abstract" select="helpers:abstract"/>
        <xsl:variable name="platform_code" select="helpers:platform_code"/>
        <xsl:variable name="dive_number" select="helpers:dive_number"/>
        <xsl:variable name="dive_code_name" select="helpers:dive_code_name"/>
        <xsl:variable name="number_of_images" select="helpers:number_of_images"/>
        <xsl:variable name="distance" select="helpers:distance"/>
        <xsl:variable name="dive_report" select="helpers:dive_report"/>
        <xsl:variable name="kml" select="helpers:kml"/>
        <xsl:variable name="geospatial_lat_min" select="helpers:geospatial_lat_min"/>
        <xsl:variable name="geospatial_lon_min" select="helpers:geospatial_lon_min"/>
        <xsl:variable name="geospatial_lat_max" select="helpers:geospatial_lat_max"/>
        <xsl:variable name="geospatial_lon_max" select="helpers:geospatial_lon_max"/>
        <xsl:variable name="time_coverage_start" select="helpers:time_coverage_start"/>
        <xsl:variable name="time_coverage_end" select="helpers:time_coverage_end"/>
        <xsl:variable name="time_coverage_start_utc" select="adjust-dateTime-to-timezone(xs:dateTime($time_coverage_start),xs:dayTimeDuration('PT0H'))"/>
        <xsl:variable name="time_coverage_end_utc" select="adjust-dateTime-to-timezone(xs:dateTime($time_coverage_end),xs:dayTimeDuration('PT0H'))"/>
        
        <xsl:variable name="dive_date" select="format-dateTime($time_coverage_start_utc,'[D01,2] [MNn,*-3] [Y01,4]')"/>
        
        <record uuid="{$metadata_uuid}">
            
            <!-- title -->
            
            <fragment id="imos.title" uuid="{@gml:id}_title" title="imos.title">
                <gmd:title>
                    <gco:CharacterString><xsl:value-of select="concat('IMOS AUV Campaign ',$campaign_code, ', Dive number ',$dive_number, ', ',$dive_code_name,', ',$dive_date)"/></gco:CharacterString>
                </gmd:title>
            </fragment>
            
            <!-- abstract -->
            
            <fragment id="imos.abstract" uuid="{@gml:id}_abstract" title="imos.abstract">
                <gmd:abstract>
                    <gco:CharacterString><xsl:value-of select="concat($facility_code,' ',$platform_code)"/> (IMOS Platform code: <xsl:value-of select="$platform_code"/>) 
effectued a series of dives during the <xsl:value-of select="$campaign_code"/> campaign.
Dive Abstract: <xsl:value-of select="$abstract"/>.

The AUV group launched an AUV robot at latitude:<xsl:value-of select="$geospatial_lat_min"/>, longitude: <xsl:value-of select="$geospatial_lon_min"/> from <xsl:value-of select="$time_coverage_start"/> to <xsl:value-of select="$time_coverage_end"/>. 
The robot,capable of undertaking high resolution survey work, took <xsl:value-of select="$number_of_images"/>, stereo pairs images (only the right ones are available for download) over <xsl:value-of select="$distance"/> meters. Engineering data (roll, pitch, heading) as well as scientific data such as sea water temperature, sea water salinity, chlorophyll concentration, backscattering ratio, colored dissolved organic matter ; have been recorded in both CSV and netCDF files. The dive name <xsl:value-of select="$site_code"/> follows the following convention name  rYYYYMMDD_HHMMSS_SITE_NumberDive_...

A Dive report in PDF is available for download : <xsl:value-of select="$dive_report"/>
The different data, as explained underneath, are stored by eMII and are accessible and downloadable at https://df.arcs.org.au/ARCS/projects/IMOS/public/<xsl:value-of select="$facility_code"/>/<xsl:value-of select="$campaign_code"/>/<xsl:value-of select="$site_code"/>

More informations about the AUV facility can be available on the IMOS 
website: http://imos.org.au/auv.html


--------------------------------------------------------------------

The files in this folder form part of the data 'product'
from the IMOS AUV Facility Sirius AUV operated by the
University of Sydney's Australian Centre for Field
Robotics.

The directory contains a number of different file types. These
are listed below. The 'product' from each dive is contained in
it's own named folder.


*../all_reports folder:-
This folder contains the PDF short dive report files, one
for each of the dives. These contain some summary graphs and
sample images.

*per_dive folder:-
-&gt; i*_gtif (contains geotif versions of all images).
-&gt; i*_subsampN (subsampled geotif images (one in N, and a csv of 
locations).
-&gt; hydro_netcdf (*.nc files, netcdf files containing CT and ecopuck data).
-&gt; track_files  (dive track in csv, kml and arcgis shape file format).
-&gt; mesh (3D reconstuction of the dive, needs OSG viewer software).
-&gt; multibeam (a number of different versions of the multibeam product).
*.gsf: Navigated and automatically cleaned swath bathymetry with raw intensity data.Format specification 
121 (SAIC Generic Sensor Format) in mbsystem.
*.grd: Gridded bathymetry.  NetCDF format as used
with GMT.  Use grdinfo to determine resolution
and projection.
*.grd.pdf: Plotted gridded bathymetry (local northings and eastings)
acrobat PDF format.</gco:CharacterString>
</gmd:abstract>
            </fragment>
            
            <!-- extent -->
            
            <fragment id="imos.extent" uuid="{@gml:id}_extent" title="imos.extent">
                <gmd:extent>
                    <gmd:EX_Extent>
                        <gmd:geographicElement>
                            <gmd:EX_GeographicBoundingBox>
                                <gmd:westBoundLongitude>
                                    <gco:Decimal><xsl:value-of select="$geospatial_lon_min"/></gco:Decimal>
                                </gmd:westBoundLongitude>
                                <gmd:eastBoundLongitude>
                                    <gco:Decimal><xsl:value-of select="$geospatial_lon_max"/></gco:Decimal>
                                </gmd:eastBoundLongitude>
                                <gmd:southBoundLatitude>
                                    <gco:Decimal><xsl:value-of select="$geospatial_lat_min"/></gco:Decimal>
                                </gmd:southBoundLatitude>
                                <gmd:northBoundLatitude>
                                    <gco:Decimal><xsl:value-of select="$geospatial_lat_max"/></gco:Decimal>
                                </gmd:northBoundLatitude>
                            </gmd:EX_GeographicBoundingBox>
                        </gmd:geographicElement>
                        <gmd:temporalElement>
                            <gmd:EX_TemporalExtent>
                                <gmd:extent>
                                    <gml:TimePeriod gml:id="{@gml:id}_timeperiod">
                                        <gml:beginPosition><xsl:value-of select="$time_coverage_start_utc"/></gml:beginPosition>
                                        <gml:endPosition><xsl:value-of select="$time_coverage_end_utc"/></gml:endPosition>
                                    </gml:TimePeriod>
                                </gmd:extent>
                            </gmd:EX_TemporalExtent>
                        </gmd:temporalElement>
                    </gmd:EX_Extent>
                </gmd:extent>
            </fragment>
            
            <!-- dive report -->
            
            <fragment id="imos.dive_report" uuid="{@gml:id}_dive_report" title="imos.dive_report">
                <gmd:URL><xsl:value-of select="$dive_report"/></gmd:URL>
            </fragment>
            
            <!-- kml -->
            
            <fragment id="imos.kml" uuid="{@gml:id}_kml" title="imos.kml">
                <gmd:URL><xsl:value-of select="$kml"/></gmd:URL>
            </fragment>
            
            <!-- opendap -->
            
            <fragment id="imos.opendap" uuid="{@gml:id}_opendap" title="imos.opendap">
                <gmd:URL><xsl:value-of select="concat('http://thredds.aodn.org.au/thredds/dodsC/IMOS/AUV/',$campaign_code,'/',$site_code,'/catalog.html')"/></gmd:URL>
            </fragment>
            
            <!-- data fabric -->
            
            <fragment id="imos.df" uuid="{@gml:id}_df" title="imos.df">
                <gmd:URL><xsl:value-of select="concat('http://data.aodn.org.au/IMOS/public/AUV/',$campaign_code,'/',$site_code)"/></gmd:URL>
            </fragment>

            <!-- parent campaign -->

            <fragment id="imos.metadata_campaign" uuid="{@gml.id}_metadata_campaign" title="imos.metadata_campaign">
                <gmd:parentIdentifier>
                    <gco:CharacterString><xsl:value-of select="$metadata_campaign"/></gco:CharacterString>
                </gmd:parentIdentifier>
            </fragment>
            
        </record>
    </xsl:template>
    
</xsl:stylesheet>
