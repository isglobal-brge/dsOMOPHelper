#' @title Append a table to the base table
#' @name OMOPCDMHelper-append
#' 
#' @description This function appends data from a specified OMOP CDM table to the base table. It provides flexible options for 
#' filtering columns, applying concept filters, and specifying merge conditions. The function performs a left join operation,
#' keeping all records from the base table while adding matching records from the target table.
#'
#' @param table A character string specifying the name of the OMOP CDM table to append data from (e.g., "condition_occurrence", "drug_exposure").
#' @param columns Optional; a character vector of column names to include from the target table. If NULL (default), all columns are included.
#' @param concepts Optional; a list of concept IDs to filter the target table data by. If NULL (default), no concept filtering is applied.
#' @param merge.x Optional; a character string specifying the column name in the base table to merge on. Defaults to "person_id" if both merge parameters are NULL.
#' @param merge.y Optional; a character string specifying the column name in the target table to merge on. Defaults to "person_id" if both merge parameters are NULL.
#' @param ... Additional parameters passed to the underlying get method for retrieving data.
#'
#' @details The function performs the following steps:
#' 1. Generates a temporary table symbol for intermediate operations
#' 2. Validates merge column specifications
#' 3. Retrieves and filters the target table data
#' 4. Performs a left join with the base table
#' 5. Cleans up temporary objects
#'
#' The merge operation preserves all records from the base table (left join) and adds matching records
#' from the target table. Duplicate column names are handled by adding ".x" and ".y" suffixes.
#'
#' @return The function modifies the database state by appending data to the specified table. It does not return a value.
#'
#' @examples
#' \dontrun{
#' # Basic usage - append all condition occurrences
#' helper$append("condition_occurrence")
#'
#' # Append specific columns from drug exposure table
#' helper$append("drug_exposure", 
#'              columns = c("drug_concept_id", "drug_exposure_start_date"))
#'              
#' # Append with custom merge columns
#' helper$append("observation", 
#'              merge.x = "visit_occurrence_id",
#'              merge.y = "visit_occurrence_id")
#' }
#'
#' @seealso 
#' \code{\link{OMOPCDMHelper-get}} for the underlying data retrieval method
#'
OMOPCDMHelper$set("public", "append", function(table, 
                                              columns = NULL, 
                                              concepts = NULL, 
                                              merge.x = NULL, 
                                              merge.y = NULL, 
                                              ...) {
  # Generate a random 4-character string for temporary table identification
  # This helps avoid naming conflicts in the database environment
  generatedString <- paste0(sample(c(0:9, letters, LETTERS), 4, replace = TRUE), collapse = "")
  tableSymbol <- paste0("dsOH.", generatedString)

  # Validate merge column specifications
  # Both merge columns must be either specified or NULL together
  if (is.null(merge.x) && !is.null(merge.y) || !is.null(merge.x) && is.null(merge.y)) {
    stop("Both merge.x and merge.y must be provided or both must be NULL.")
  } else if (is.null(merge.x) && is.null(merge.y)) {
    # Default to person_id if no merge columns specified
    merge.x <- "person_id"
    merge.y <- "person_id"
  }

  # Retrieve and filter the target table data
  # The get method handles column filtering, concept filtering, and person filtering
  self$get(
    table = table,
    symbol = tableSymbol,
    columnFilter = columns,
    conceptFilter = concepts,
    personFilter = self$symbol,
    mergeColumn = merge.y,
    dropNA = TRUE,
    ...
  ) # Note: This operation may fail if filtering results in an empty table

  # Perform the merge operation within a error-handling block
  tryCatch(
    {
      # Merge the base table with the retrieved target table
      dsBaseClient::ds.merge(
        x.name = self$symbol,          # Base table
        y.name = tableSymbol,          # Target table
        by.x.names = merge.x,          # Base table merge column
        by.y.names = merge.y,          # Target table merge column
        all.x = TRUE,                  # Keep all base table records (left join)
        all.y = FALSE,                 # Only keep matching target table records
        sort = FALSE,                  # No sorting needed
        suffixes = c(".x", ".y"),      # Suffix for duplicate column names
        no.dups = TRUE,                # Remove duplicate columns
        newobj = self$symbol,          # Store result in base table
        datasources = self$OMOPCDMDatabase$connections
      )
    }, 
    error = function(error) {
      # Clean up temporary table if merge fails
      DSI::datashield.rm(self$OMOPCDMDatabase$connections, tableSymbol)
      stop(error$message)
    }
  )
  
  # Clean up: remove the temporary table after successful merge
  DSI::datashield.rm(self$OMOPCDMDatabase$connections, tableSymbol)
})
