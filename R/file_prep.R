
#' Prepare saving location in get functions
#'
#' @param save_dir Character. Name of directory to save results into.
#' @param name Character. Usually `data_name` from a data map (e.g. see
#' `envImport::data_map`)
#' @param out_type Character. File type to save (anything accepted by
#' `rio::export()`)
#' @param sub_dir Character or `NULL`. Save to `fs::path(save_dir, sub_dir)`?
#' @param ... Not used
#'
#' @return Character. Name of file to save, usually within `get_x` functions.
#' @export
#' @keywords internal
#'
#' @examples
#' file_prep(here::here(), name = "galah", create_dir = FALSE)
  file_prep <- function(save_dir = NULL
                        , name
                        , out_type = ".parquet"
                        , sub_dir = NULL
                        , create_dir = TRUE
                        , ...
                        ) {

    args <- as.list(environment())

    if(is.null(args$save_dir)) {

      save_dir <- here::here("out"
                             , "ds"
                             )

    }

    save_file <- fs::path(args$save_dir
                          , if(!is.null(args$sub_dir)) args$sub_dir else args$name
                          , paste0(args$name
                                   , args$out_type
                                   )
                          )

    if(create_dir) fs::dir_create(dirname(save_file))

    message("save_file will be ", save_file)

    return(save_file)

  }
