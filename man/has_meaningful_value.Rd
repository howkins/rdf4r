% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc.R
\name{has_meaningful_value}
\alias{has_meaningful_value}
\title{Check whether supplied text argument has a meaningful value}
\usage{
has_meaningful_value(text_value)
}
\arguments{
\item{text_value}{object to check for a meaningful value}
}
\value{
FALSE, if the value is not meaningful; TRUE, otherwise
}
\description{
Meaningful value means:
}
\details{
\itemize{
  \item{is not NULL}
  \item{is not an atomic type}
  \item{is not of length 0}
  \item{is not NA}
  \item{is not an empty string or just spaces}
}
}
\examples{
has_meaningful_value("Hohn")
has_meaningful_value(1)
has_meaningful_value(list())
has_meaningful_value(list(1, "one"))
has_meaningful_value(c(1, "one"))
has_meaningful_value("              ")
has_meaningful_value("")
}
