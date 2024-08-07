% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/03_auto.R
\name{OMOPCDMHelper-auto}
\alias{OMOPCDMHelper-auto}
\title{Auto-append function for OMOP CDM Helper}
\arguments{
\item{tables}{Optional; a vector of table names to include in the operation.
If NULL, all person-related tables are considered except 'person' and 'concept'.}

\item{columns}{Optional; a vector of column names to include in the operation.}

\item{concepts}{Optional; a list of concept IDs to filter the data by.}

\item{silent}{Optional; a boolean indicating whether to suppress warnings.}

\item{...}{Additional arguments to pass to the append method.}
}
\description{
This function automatically appends data from specified or all tables in the OMOP CDM database
to a base table, with options to filter by columns and concepts. It excludes 'person' and 'concept'
tables by default and warns if no filters are provided, potentially impacting performance.
}
