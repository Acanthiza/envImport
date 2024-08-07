% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{data_map_class}
\alias{data_map_class}
\title{Lookup for field classes and use in final 'bio_all'}
\format{
A data frame with 31 rows and 3
variables:
\describe{
\item{col}{Character. One row for each name in \code{envImport::data_map}}
\item{class}{Character. What \code{base::class()} should each column be in final
bio_all?}
\item{bio_all}{Logical. Should this col be in the final bio_all?}
...
}
}
\usage{
data_map_class
}
\description{
Lookup for field classes and use in final 'bio_all'
}
\keyword{datasets}
