% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_gbif.r
\name{get_gbif}
\alias{get_gbif}
\title{Get an occurrence record set from GBIF}
\usage{
get_gbif(
  aoi = NULL,
  save_dir = NULL,
  get_new = FALSE,
  data_map = NULL,
  predicates = NULL,
  request_wait = 20,
  name = "gbif",
  filter_inconsistent = TRUE,
  filter_NA_date = TRUE,
  occ_char = TRUE,
  adj_spa_rel = TRUE,
  previous_key = NULL,
  ...
)
}
\arguments{
\item{aoi}{sf defining area of interest.}

\item{save_dir}{Character. File path into which to save outputs. If \code{null}
results will be saved to \code{fs::path("out", "ds", "gbif")} as file
\code{gbif.rds}.}

\item{get_new}{Logical. If \code{FALSE} will attempt to load data from previously
saved results.}

\item{data_map}{Dataframe or \code{NULL.} Mapping of fields to retrieve. See example
\code{envImport::data_map}}

\item{predicates}{List. Any number of \href{https://docs.ropensci.org/rgbif/articles/getting_occurrence_data.html#occ_download}{gbif predicates}}

\item{request_wait}{Integer. Time in seconds to wait between
\code{rgbif::occ_download_meta()} requests. Used by \code{rgbif::occ_download_wait()}
\code{status_ping} argument.}

\item{name}{Character or \code{NULL}. \code{data_name} value in \code{envImport::data_map}
(or other \code{data_map}). Required if \code{data_map} is not \code{NULL}}

\item{filter_inconsistent}{Logical. If \code{TRUE} inconsistencies between the
\code{occurrenceStatus} column and either \code{organismQuantity} or \code{individualCount}
are removed. e.g. a record with \code{occurrenceStatus == "ABSENT"} but
\code{individualCount == 1} would be filtered.}

\item{filter_NA_date}{Logical. Filter if \code{is.na(eventDate)}.}

\item{occ_char}{Logical. If true, occ_derivation will be coerced to character
(to match other data sources).}

\item{adj_spa_rel}{Logical. If true, an attempt will be made to check
\code{coordinateUncertaintyInMeters} against: information in \code{informationWithheld.} If
\code{informationWithheld} contains "Coordinate uncertainty increased to",
\code{readr::parse_number()} is used to retrieve that number, which is then used
to replace any value in \code{coordinateUncertaintyInMeters}; and if the column
\code{issue} contains \code{COORDINATE_UNCERTAINTY_METERS_INVALID},
\code{coordinateUncertaintyInMeters} is limited to 10000 or greater.}

\item{previous_key}{Character. e.g. \code{0092123-240506114902167}. If provided,
an attempt will be made to load (or download) a previous query of occurrence
data.}

\item{...}{Passed to \code{envImport::file_prep()}}
}
\value{
Dataframe of occurrences, full download (as key.zip) in \code{save_dir}
and file saved to \code{save_dir} as \code{gbif.parquet}.
}
\description{
Get new occurrence record set from GBIF and save as \code{.rds}. GBIF is the
\href{https://www.gbif.org/}{Global Biodiversity Information Facility}.
}
\details{
Uses various \href{https://docs.ropensci.org/rgbif/index.html}{\code{rgbif}} functions
to return a dataframe of occurence records. Requires
\href{https://docs.ropensci.org/rgbif/articles/gbif_credentials.html}{gbif credentials}.

Any arguments to \code{rgbif::occ_download()} can be passed via \code{extra_prediates}.
For convenience, \code{aoi} can also be passed directly and internally it is
converted to a bounding box in appropriate lat/long and passed to
\code{rgbif::pred_within()} in WKT format.
}
\examples{

  # setup -------
  library("envImport")

  # no aoi ------
  out_dir <- file.path(system.file(package = "envImport"), "examples", "get_gbif_ex")

  gbif_data <- get_gbif(save_dir = out_dir
                        , get_new = FALSE
                        #, data_map = envImport::data_map
                        , predicates = rgbif::pred_and(rgbif::pred("taxonKey", 2474903)
                                                       , rgbif::pred("year", 2000)
                                                       )
                        , previous_key = "0057516-240626123714530"
                        )

  # 667 records 2024-08-09
  nrow(gbif_data)
  head(gbif_data)

  # with aoi
  out_dir <- file.path(system.file(package = "envImport"), "examples", "get_gbif_aoi_ex")

  gbif_data <- get_gbif(save_dir = out_dir
                        , aoi = envClean::aoi
                        , data_map = envImport::data_map
                        , get_new = FALSE
                        , predicates = rgbif::pred("year", 2000)
                        )

  # 107 records 2024-08-09
  nrow(gbif_data)

  # .bib created
  readr::read_lines(fs::path(out_dir, "gbif", "gbif.bib"))
}
