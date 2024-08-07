
  library(magrittr)

  data_map <- tibble::tibble(
    data_name = c("havplot", "alis", "bcm", "bdbsa", "egis", "nvb", "ptp", "tern", "gbif", "galah", "other"),
    order = c(3, 5, 7, 1, 2, 5, 9, 4, 11, 10, 8),
    epsg = c(4326, 4326, 4326, 7844, 7844, 4326, 4326, 4326, 4326, 4326, 4326),
    site = c("plotName", "SITENUMBER", "SITE_ID", "PATCHID", "EGISCODE", "path", "PlantDataID", "site_unique", "gbifID", "locationID", "Site"),
    date = c("obsStartDate", "SurveyDate", "ASSESSMENT_DATE", "OBSDATE", "SIGHTINGDATE", "date", "Obs_Date", "visit_start_date", "eventDate", "eventDate", "SIGHTINGDATE"),
    lat = c("decimalLatitude", "LATITUDE", "LATITUDE", "LATITUDE", "LATITUDE", "lat", "LATITUDE", "latitude", "decimalLatitude", "decimalLatitude", "LATITUDE"),
    long = c("decimalLongitude", "LONGITUDE", "LONGITUDE", "LONGITUDE", "LONGITUDE", "lon", "LONGITUDE", "longitude", "decimalLongitude", "decimalLongitude", "LONGITUDE"),
    original_name = c("scientificName", "CONCATNAMAUTH", "CONCATNAMAUTH", "CONCATNAMAUTH", "SPECIES", "Spp", "CONCATNAMAUTH", "species", "scientificName", "scientificName", "SPECIES"),
    common = c(NA, "COMNAME1", "COMNAME1", "COMNAME1", "COMNAME", NA, "COMNAME1", NA, NA, "vernacularName", NA),
    nsx = c(NA, "NSXCode", "species", "NSXCODE", "NSXCODE", NA, "NSXCODE", NA, "organismID", "organismID", NA),
    occ_derivation = c("abundanceValue", NA, NA, "NUMOBSERVED", "NUMOBSERVED", NA, NA, NA, "occurrenceStatus", "occurrenceStatus", "NUMOBSERVED"),
    quantity = c("abundanceValue", NA, NA, "NUMOBSERVED", "NUMOBSERVED", NA, NA, NA, "organismQuantity", "organismQuantity", "NUMOBSERVED"),
    survey_nr = c(NA, NA, NA, "SURVEYNR", "SURVEYNR", NA, NA, NA, NA, NA, "SURVEYNR"),
    survey = c("projectID", "LandSystem", NA, "SURVEYNAME", "SURVEYNAME", NA, NA, NA, NA, "datasetName", "SURVEYNAME"),
    ind = c(NA, "ISINDIGENOUS", "ISINDIGENOUS", "ISINDIGENOUS", "ISINDIGENOUSFLAG", NA, "ISINDIGENOUS", NA, NA, NA, NA),
    rel_metres = c("coordinateUncertaintyInMetres", NA, NA, "rel_metres", "rel_metres", NA, NA, NA, "coordinateUncertaintyInMeters", "coordinateUncertaintyInMeters", "maxDist"),
    sens = c(NA, NA, NA, NA, "DISTRIBNDESC", NA, NA, NA, NA, NA, NA),
    lifeform = c(NA, "Lifeform", NA, "MUIRCODE", NA, NA, "Life_form", "lifeform", NA, NA, NA),
    lifespan = c(NA, "LIFESPAN", "LIFESPAN", "LIFESPAN", NA, NA, "LIFESPAN", NA, NA, NA, NA),
    cover = c("cover", "Cover", NA, "COVER", NA, NA, NA, "cover", NA, NA, NA),
    cover_code = c(NA, NA, NA, "COVCODE", NA, NA, "Cover_abundance", NA, NA, NA, NA),
    height = c(NA, NA, NA, NA, NA, NA, NA, "height", NA, NA, NA),
    quad_x = c("length", NA, "X_DIM", "VEGQUADSIZE1", NA, NA, NA, "quadX", NA, NA, NA),
    quad_y = c("width", NA, "Y_DIM", "VEGQUADSIZE2", NA, NA, NA, "quadY", NA, NA, NA),
    quad_metres = c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
    epbc_status = c(NA, "ESACTSTATUSCODE", "ESACTSTATUSCODE", "ESACTSTATUSCODE", "ESACTSTATUSCODE", NA, NA, NA, NA, NA, NA),
    npw_status = c(NA, "NPWACTSTATUSCODE", "NPWACTSTATUSCODE", "NPWACTSTATUSCODE", "NPWACTSTATUSCODE", NA, NA, NA, NA, NA, NA),
    method = c("abundanceMethod", NA, NA, "METHODDESC", "METHODDESC", NA, NA, NA, "samplingProtocol", "samplingProtocol", "METHODDESC"),
    obs = c("individualName", "observer", "assessor", "observer", "OBSERVER", "assessor", "Observers", "observer_veg", "recordedBy", "recordedBy", "observer"),
    denatured = c(NA, NA, NA, NA, NA, NA, NA, NA, "informationWithheld", "generalisationInMetres", NA),
    desc = c("Harmonised Australian Vegetation Plot dataset (HAVPlot)"
             , "Arid lands information systems"
             , "Bushland condition monitoring"
             , "Biological databases of South Australia"
             , "Occurrence datasets from the environmental databases of South Australia (e.g. supertables)"
             , "DEW Native Vegetation Branch"
             , "Paddock tree project"
             , "Terrestrial ecosystem network"
             , "Global biodiversity information facility"
             , "Atlas of Living Australia"
             , "Other private datasets: SA Bird Atlas (UOA/Birds SA), Birdlife Australia Birdata portal, MLR Extra Bandicoot data, KI Post Fire Bird Monitoring, SA Seed Conservation Centre"
             )
    ) %>%
    dplyr::mutate(kingdom = "kingdom"
                  , data_name = forcats::fct_reorder(data_name
                                                   , order
                                                   )
                  , data_name_use = dplyr::case_when(data_name == "havplot" ~ "HAVPlot",
                                                     data_name == "other" ~ "Other",
                                                     data_name == "galah" ~ "ALA",
                                                     TRUE ~ toupper(data_name)
                                                     )
                  ) %>%
    dplyr::arrange(order)

  data_map_class <- tibble::tribble(
    ~col, ~class, ~bio_all,
    "data_name", "character", TRUE,
    "order", "numeric", FALSE,
    "epsg", "numeric", FALSE,
    "site", "character", TRUE,
    "date", "Date", TRUE,
    "lat", "numeric", TRUE,
    "long", "numeric", TRUE,
    "original_name", "character", TRUE,
    "common", "character", TRUE,
    "nsx", "character", TRUE,
    "occ_derivation", "character", TRUE,
    "quantity", "character", TRUE,
    "survey_nr", "character", TRUE,
    "survey", "character", TRUE,
    "ind", "character", TRUE,
    "rel_metres", "character", TRUE,
    "sens", "logical", TRUE,
    "lifeform", "character", TRUE,
    "lifespan", "character", TRUE,
    "cover", "numeric", TRUE,
    "cover_code", "character", TRUE,
    "height", "numeric", TRUE,
    "quad_x", "character", FALSE,
    "quad_y", "character", FALSE,
    "quad_metres", "numeric", TRUE,
    "epbc_status", "character", TRUE,
    "npw_status", "character", TRUE,
    "method", "character", TRUE,
    "obs", "character", TRUE,
    "denatured", "character", FALSE,
    "desc", "character", FALSE
    )
