% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/db-access-low-level.R
\name{api_triplestore_access}
\alias{api_triplestore_access}
\title{API Triplestore Access}
\usage{
api_triplestore_access(server_url, repository = NA, api_key = "",
  api_secret = "")
}
\arguments{
\item{server_url}{character. The URL of the triplestore.}

\item{repository}{character. The ID of the repository to which you want to connect to.}

\item{api_key}{a string, the API key used for API-style authentication.}

\item{secret}{a string, the secret string corresponding to the API key
needed for API-style authentication.}
}
\value{
list. Contains the server access options.
}
\description{
Create an object with the access options for a triple-store. If successful it also outputs to the screen the protocol version. If unsuccessful it raises an error. Uses API authentication.
}
\examples{
graphdb3 = api_triplestore_access(server_url = "https://rdf.ontotext.com/4135593934/openbiodiv", repository = "test", api_key = "s4bb1d43uc52", api_secret = "d7h7eg4e263ghss")

}
\seealso{
\code{api_triplestore_access}
}
