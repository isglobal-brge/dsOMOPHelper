% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/02_catalog.R
\name{OMOPCDMHelper-columns}
\alias{OMOPCDMHelper-columns}
\title{Retrieve Column Information from OMOP CDM Database}
\arguments{
\item{tables}{Optional character vector of table names to query. If NULL (default),
retrieves columns for all available tables.}
}
\value{
A nested list structure where:
\itemize{
\item Top level: Server identifiers
\item Second level: Table names
\item Values: Character vectors of column names for each table
}
}
\description{
Provides detailed column information for specified tables (or all tables if none specified)
from the OMOP CDM database across all connected DataSHIELD servers. This function enables
exploration and validation of table structures.
}
\details{
The function performs the following steps:
\enumerate{
\item Validates input tables or defaults to all available tables
\item Retrieves unique table names across all servers
\item Iteratively fetches column information for each table
\item Organizes results by server and table
\item Handles errors gracefully for missing tables
}
}
\examples{
\dontrun{
# Get columns for all tables
all_columns <- helper$columns()

# Get columns for specific tables
selected_columns <- helper$columns(
  tables = c("person", "observation")
)

# Access columns for a specific table on first server
person_cols <- all_columns[[1]][["person"]]
}

}
\seealso{
\itemize{
\item \link{OMOPCDMHelper-tables} for listing available tables
\item \link{OMOPCDMHelper-concepts} for concept dictionary access
}
}
