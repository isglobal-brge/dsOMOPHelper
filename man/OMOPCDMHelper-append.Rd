% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01_append.R
\name{OMOPCDMHelper-append}
\alias{OMOPCDMHelper-append}
\title{Append a table to the base table}
\arguments{
\item{table}{A character string specifying the name of the OMOP CDM table to append data from (e.g., "condition_occurrence", "drug_exposure").}

\item{columns}{Optional; a character vector of column names to include from the target table. If NULL (default), all columns are included.}

\item{concepts}{Optional; a list of concept IDs to filter the target table data by. If NULL (default), no concept filtering is applied.}

\item{merge.x}{Optional; a character string specifying the column name in the base table to merge on. Defaults to "person_id" if both merge parameters are NULL.}

\item{merge.y}{Optional; a character string specifying the column name in the target table to merge on. Defaults to "person_id" if both merge parameters are NULL.}

\item{...}{Additional parameters passed to the underlying get method for retrieving data.}
}
\value{
The function modifies the database state by appending data to the specified table. It does not return a value.
}
\description{
This function appends data from a specified OMOP CDM table to the base table. It provides flexible options for
filtering columns, applying concept filters, and specifying merge conditions. The function performs a left join operation,
keeping all records from the base table while adding matching records from the target table.
}
\details{
The function performs the following steps:
\enumerate{
\item Generates a temporary table symbol for intermediate operations
\item Validates merge column specifications
\item Retrieves and filters the target table data
\item Performs a left join with the base table
\item Cleans up temporary objects
}

The merge operation preserves all records from the base table (left join) and adds matching records
from the target table. Duplicate column names are handled by adding ".x" and ".y" suffixes.
}
\examples{
\dontrun{
# Basic usage - append all condition occurrences
helper$append("condition_occurrence")

# Append specific columns from drug exposure table
helper$append("drug_exposure", 
             columns = c("drug_concept_id", "drug_exposure_start_date"))
             
# Append with custom merge columns
helper$append("observation", 
             merge.x = "visit_occurrence_id",
             merge.y = "visit_occurrence_id")
}

}
\seealso{
\code{\link{OMOPCDMHelper-get}} for the underlying data retrieval method
}
