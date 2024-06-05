---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->




```r

  library(envReport)
  library(envImport)
  library(magrittr)
```

# envImport

<!-- badges: start -->
<!-- badges: end -->

The goal of envImport is to obtain, and assemble, environmental data from disparate data sources, for a geographic area of interest. As little filtering as possible occurs when obtaining data and envImport does _not_ aim to clean, filter or tidy the data (see [envClean](https://acanthiza.github.io/envClean/) for help there). Usually the end result of an envImport workflow is a single object that contains all records from all the data sources. Sourcing and assembling environmental rasters for the area of interest is also in scope, but poorly implemented / documented currently.

## Installation

You can install the development version of envImport from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Acanthiza/envImport")
```

## Supported data sources

`data_name` = 'data source'. Data sources are (usually) obvious sources of data. Examples are the Global Biodiversity Infrastructure Facility ([GBIF](https://www.gbif.org/)) or Terrestrial Ecosystems Network ([TERN](https://www.tern.org.au/)). The 10 data sources currently supported or with plans for development are (also see `envImport::data_map`):

* bdbsa: Biological databases of South Australia
* egis: Occurrence datasets from the environmental databases of South Australia (e.g. supertables)
* havplot: Harmonised Australian Vegetation Plot dataset (HAVPlot)
* tern: Terrestrial ecosystem network
* alis: Arid lands information systems
* nvb: DEW Native Vegetation Branch
* bcm: Bushland condition monitoring
* other: Other private datasets: SA Bird Atlas (UOA/Birds SA), Birdlife Australia Birdata portal, MLR Extra Bandicoot data, KI Post Fire Bird Monitoring, Cherry Gardens Post-fire Heath Bird Monitoring
* ptp: Paddock tree project
* gbif: Global biodiversity information facility

## General workflow

### `data_map`

The data_map (see table @ref(tab:dataMap)) provides a mapping from original data sources to the desired columns in the assembled data set.


```r

  knitr::kable(data_map
               , caption = "Data map of desired columns in the assembled data (columns) and names of columns in the original data (rows)"
               )
```



Table: Data map of desired columns in the assembled data (columns) and names of columns in the original data (rows)

|data_name | order| epsg|site        |date             |lat             |long             |original_name            |common           |nsx          |occ_derivation   |quantity         |survey_nr |survey     |ind                        |rel_metres                    |sens         |lifeform  |lifespan |cover            |cover_code      |height |quad_x       |quad_y       |epbc_status     |npw_status       |method           |obs            |desc                                                                                                                                                                                            |data_name_use |
|:---------|-----:|----:|:-----------|:----------------|:---------------|:----------------|:------------------------|:----------------|:------------|:----------------|:----------------|:---------|:----------|:--------------------------|:-----------------------------|:------------|:---------|:--------|:----------------|:---------------|:------|:------------|:------------|:---------------|:----------------|:----------------|:--------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|
|bdbsa     |     1| 7844|PATCHID     |OBSDATE          |LATITUDE        |LONGITUDE        |SPECIES                  |COMNAME1         |NSXCODE      |NUMOBSERVED      |NUMOBSERVED      |SURVEYNR  |SURVEYNAME |ISINDIGENOUS               |rel_metres                    |NA           |MUIRCODE  |LIFESPAN |COVER            |COVCODE         |NA     |VEGQUADSIZE1 |VEGQUADSIZE2 |ESACTSTATUSCODE |NPWACTSTATUSCODE |METHODDESC       |observer       |Biological databases of South Australia                                                                                                                                                         |BDBSA         |
|egis      |     2| 7844|EGISCODE    |SIGHTINGDATE     |LATITUDE        |LONGITUDE        |SPECIES                  |COMNAME          |NSXCODE      |NUMOBSERVED      |NUMOBSERVED      |SURVEYNR  |SURVEYNAME |ISINDIGENOUSFLAG           |rel_metres                    |DISTRIBNDESC |NA        |NA       |NA               |NA              |NA     |NA           |NA           |ESACTSTATUSCODE |NPWACTSTATUSCODE |METHODDESC       |OBSERVER       |Occurrence datasets from the environmental databases of South Australia (e.g. supertables)                                                                                                      |EGIS          |
|havplot   |     3| 4326|plotName    |obsStartDate     |decimalLatitude |decimalLongitude |scientificName           |NA               |NA           |abundanceUnits   |abundanceValue   |NA        |projectID  |NA                         |coordinateUncertaintyInMeters |NA           |NA        |NA       |cover            |NA              |NA     |length       |width        |NA              |NA               |abundanceMethod  |individualName |Harmonised Australian Vegetation Plot dataset (HAVPlot)                                                                                                                                         |HAVPLOT       |
|tern      |     4| 4326|site_unique |visit_start_date |latitude        |longitude        |species                  |NA               |NA           |NA               |NA               |NA        |NA         |NA                         |NA                            |NA           |lifeform  |NA       |cover            |NA              |height |quadX        |quadY        |NA              |NA               |NA               |observer_veg   |Terrestrial ecosystem network                                                                                                                                                                   |TERN          |
|alis      |     5| 4326|SITENUMBER  |SurveyDate       |LATITUDE        |LONGITUDE        |LegacyName               |NA               |NSXCode      |NA               |NA               |NA        |LandSystem |NA                         |NA                            |NA           |Lifeform  |NA       |Cover            |NA              |NA     |NA           |NA           |NA              |NA               |NA               |observer       |Arid lands information systems                                                                                                                                                                  |ALIS          |
|nvb       |     5| 4326|path        |date             |lat             |lon              |Spp                      |NA               |NA           |NA               |NA               |NA        |NA         |NA                         |NA                            |NA           |NA        |NA       |NA               |NA              |NA     |NA           |NA           |NA              |NA               |NA               |assessor       |DEW Native Vegetation Branch                                                                                                                                                                    |NVB           |
|bcm       |     7| 4326|SITE_ID     |ASSESSMENT_DATE  |LATITUDE        |LONGITUDE        |Species                  |Common1          |Old_NSX_Code |NA               |NA               |NA        |NA         |isIndigenous               |NA                            |NA           |NA        |LIFESPAN |NA               |NA              |NA     |X_DIM        |Y_DIM        |NA              |NA               |NA               |assessor       |Bushland condition monitoring                                                                                                                                                                   |BCM           |
|other     |     8| 4326|Site        |SIGHTINGDATE     |LATITUDE        |LONGITUDE        |SPECIES                  |NA               |NA           |NUMOBSERVED      |NUMOBSERVED      |SURVEYNR  |SURVEYNAME |NA                         |maxDist                       |NA           |NA        |NA       |NA               |NA              |NA     |NA           |NA           |NA              |NA               |METHODDESC       |observer       |Other private datasets: SA Bird Atlas (UOA/Birds SA), Birdlife Australia Birdata portal, MLR Extra Bandicoot data, KI Post Fire Bird Monitoring, Cherry Gardens Post-fire Heath Bird Monitoring |OTHER         |
|ptp       |     9| 4326|PlantDataID |Obs_Date         |LATITUDE        |LONGITUDE        |Scientific_name_original |Common_name_orig |NSXCODE      |NA               |NA               |NA        |NA         |Native_Introduced_original |NA                            |NA           |Life_form |NA       |NA               |Cover_abundance |NA     |NA           |NA           |NA              |NA               |NA               |Observers      |Paddock tree project                                                                                                                                                                            |PTP           |
|gbif      |    10| 4326|gbifID      |eventDate        |decimalLatitude |decimalLongitude |species                  |NA               |organismID   |occurrenceStatus |organismQuantity |NA        |NA         |NA                         |coordinateUncertaintyInMeters |NA           |NA        |NA       |organismQuantity |NA              |NA     |NA           |NA           |NA              |NA               |samplingProtocol |recordedBy     |Global biodiversity information facility                                                                                                                                                        |GBIF          |



### `get_x`

`get_x` functions get data from the data source `x`. Results are always saved to disk (as getting data can be slow). When run again, they load from the saved file by default. If available, `get_x` functions use any R packages and functions provided by the data source (e.g. GBIF provides `rgbif` [@R-rgbif;@rgbif2017] and TERN provides `ausplotsR` [@R-ausplotsR]). The first arguments to `get_x` functions are always:

* `aoi`: an area of interest, provided as simple feature. `get_x` will turn any `aoi` into a bounding box and convert to coordinates appropriate for data source `x`. [Ed: is `aoi` always required?]
* `save_dir`: a directory to save the results to. The default (`NULL`) leads to the file `here::here("out", "ds", "x.rds")` being created and used as `save_file`. `ds` is for 'data source'. While the saved file is usually `x.rds`, in some instances it follows the format and naming of the download from `x` (e.g. GBIF data comes in a `.zip` file named by the corresponding download key).
* `get_new`: an override to force `get_x` to requery the data source, even if save_file already exists
* `...`: the dots are passed to any underlying 'native' function, such as `rgbif::occ_download()` or `ausplotsR::get_ausplots()`

Many of the `get_x` functions will only work within `DEW`.

### `make_x`

`make_x` functions take the results from `get_x` functions and prepare them for assembly. This usually involves:

* selecting columns (this is really just aesthetic and helps with debugging when there are tens of columns returned)
* munging a column or two to align with the data_map. For example, the raw TERN plant data obtained via get_tern is point intercept data. The `make_tern` function transforms the raw data into projected foliage cover data (making use of the `ausplotsR::species_table()` function)

### Assemble


