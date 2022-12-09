#' Get data
#'
#' Import data, running 'get_dataname' to requery original data source,
#' if 'lgl'. Data is saved to (and imported from)
#' `file.path("out","ds","paste0(data_name,".csv"))`
#'
#' @param data_name Character. Name of home data source. e.g. 'BDBSA' or 'GBIF'.
#' This is used to generate file location.
#' @param lgl Logical. Usually generated by get_new_data
#' @param ... Passed to `get_DATA` where `DATA` is `data_name`.
#'
#' @return Data from `out/ds/data_name.csv`. If new data is queried,
#' `out/ds/data_name.csv` will be created, overwriting if necessary.
#' @family Help with combining data sources
#' @export
#'
#' @examples
  get_data <- function(data_name
                       , lgl
                       , data_map
                       , ...
                       ) {


    .data_map = data_map

    ds_file <- base::file.path("out","ds",paste0(data_name,".csv"))

    if(lgl) {

      temp <- R.utils::doCall(paste0("get_",data_name)
                              , out_file = ds_file
                              , data_map = .data_map
                              , args = ...
                              )

    } else {

      temp <- rio::import(ds_file)

    }

    return(temp)

  }