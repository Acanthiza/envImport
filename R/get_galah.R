

#' Get data using `galah::atlas_occurrences()`
#'
#'
#'
#' @param aoi Optional simple feature (sf). Used to limit the occurrences
#' returned via `galah::galah_geolocate()`
#' @param save_dir Character. Path to directory into which to save outputs. If
#' `NULL` results will be saved to `here::here("out", "ds", "galah")`. File will be
#' named `galah.parquet`
#' @param get_new Logical. If FALSE, will attempt to load from existing
#' `save_dir`.
#' @param name Character. `data_name` value in `envImport::data_map`
#' (or other `data_map`)
#' @param data_map Dataframe or NULL. Mapping of fields to retrieve. See example
#' `envImport::data_map`
#' @param node Character. Name of atlas to use (see `galah::atlas_occurrences()`).
#' Doesn't seem to work with node = "GBIF" and untested on other nodes.
#' @param qry `NULL` or an object of class data_request, created using
#' `galah::galah_call()`
#' @param ... Passed to `envImport::file_prep()`
#'
#' @return Dataframe of occurrences and file saved to `save_dir`. .bib created
#' when `download_reason_id != 10.`
#' @export
#'
#' @example inst/examples/get_data_ex.R
  get_galah <- function(aoi = NULL
                        , save_dir = NULL
                        , get_new = FALSE
                        , name = "galah"
                        , data_map = NULL
                        , node = "ALA"
                        , qry = NULL
                        , ...
                        ) {

    # save file -------
    save_file <- file_prep(save_dir, name, ...)

    # run the qry ---------
    get_new <- if(!file.exists(save_file)) TRUE else get_new

    if(get_new) {

      # atlas -------
      old_atlas <- galah::galah_config()$atlas$region
      galah::galah_config(atlas = node)
      on.exit(galah::galah_config(atlas = old_atlas))

      # qry -------
      ## initiate-------
      if(is.null(qry)) {

        qry <- galah::galah_call()

      }

      ## aoi------
      if(!is.null(aoi)) qry <- qry %>%
          galah::galah_geolocate(aoi)


      ## check records--------
      records <- qry %>%
        galah::atlas_counts()

      if(records > 50000000) {

        stop("Returned records ("
             , records
             , ") would exceed limit of 50 million"
             )

      }

      message(records
              , " records available from galah via "
              , galah::galah_config()$atlas$acronym
              , " node"
              )

      ## select-------
      if(is.null(data_map)) {

          qry <- qry %>%
            galah::galah_select(group = c("basic", "event", "taxonomy"))

      } else {

        select_names <- data_map %>%
          dplyr::filter(data_name == name) %>%
          dplyr::mutate(dplyr::across(tidyselect::everything(), \(x) as.character(x))) %>%
          tidyr::pivot_longer(tidyselect::everything()) %>%
          stats::na.omit() %>%
          dplyr::filter(value %in% galah::show_all("fields")$id)

        qry <- qry %>%
          galah::select(recordID # inc recordID here: see https://github.com/AtlasOfLivingAustralia/galah-R/issues/239
                        , select_names$value
                        )

      }

      make_doi <- galah::galah_config()$user$download_reason_id != 10

      ## retrieve ------
      temp <- qry %>%
        galah::atlas_occurrences(mint_doi = make_doi)

      # bib -------
      if(make_doi) {

        doi <- attr(temp, "doi")

        if(is.character(doi)) {

          bib <- bibentry(bibtype = "MISC"
                          , key = "galah"
                          , title = "Occurrence download data"
                          , author = utils::person("Atlas Of Living Australia")
                          , publisher = "Atlas Of Living Australia"
                          , year = base::format(base::Sys.Date(), "%Y")
                          , doi = fs::path(basename(dirname(doi)), basename(doi))
                          ) %>%
            utils::toBibtex()

          readr::write_lines(bib
                             , file = fs::path(dirname(save_file)
                                               , paste0(basename(dirname(save_file)), ".bib")
                                               )
                             , append = TRUE
                             )

        } else {

          message("problem with doi: galah entry not written to .bib")

        }

      }

      # remap ------
      temp <- remap_data_names(this_name = name
                               , df_to_remap = temp
                               , data_map = data_map
                               , out_file = save_file
                               , previous = "move"
                               , ...
                               )

    } else {

      temp <- rio::import(save_file
                          , setclass = "tibble"
                          )

    }

    return(temp)

  }


