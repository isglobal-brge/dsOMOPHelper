#' @title Auto-append function for OMOP CDM Helper
#' @name OMOPCDMHelper-auto
#' 
#' @description This function automatically appends data from specified or all tables in the OMOP CDM database
#' to a base table. It provides flexible filtering options through columns and concepts while implementing
#' safeguards against performance issues. The function intelligently handles table selection, excluding
#' 'person' and 'concept' tables by default to prevent data duplication.
#'
#' @details The function performs the following key operations:
#' 1. Validates and processes input tables, defaulting to all available tables if none specified
#' 2. Provides warning messages for potentially resource-intensive operations
#' 3. Excludes 'person' and 'concept' tables to prevent data duplication
#' 4. Attempts to append data from each valid table with error handling
#' 5. Automatically generates prefixed column names for clarity
#'
#' @param tables Optional; character vector of table names to include in the operation.
#'              If NULL, all person-related tables are considered except 'person' and 'concept'.
#'              Tables are case-insensitive.
#' @param columns Optional; character vector of column names to include in the operation.
#'               These columns will be retrieved from each specified table.
#' @param concepts Optional; list of concept IDs to filter the data by.
#'                Used to restrict data to specific medical concepts.
#' @param silent Optional; logical indicating whether to suppress warnings (default: FALSE).
#'              Set to TRUE to disable performance-related warnings.
#' @param ... Additional arguments passed to the append method.
#'
#' @return No return value. Function operates through side effects, appending data to the base table.
#'
#' @examples
#' \dontrun{
#' # Initialize helper
#' helper <- OMOPCDMHelper$new(connection)
#'
#' # Append specific tables with column filtering
#' helper$auto(
#'   tables = c("drug_exposure", "condition_occurrence"),
#'   columns = c("start_date", "end_date"),
#'   concepts = c(1234, 5678)
#' )
#'
#' # Append all available tables (with warning)
#' helper$auto()
#' }
#' 
#' @seealso 
#' \code{\link{OMOPCDMHelper}} for the main class documentation
#' \code{\link{generateTableColumns}} for column name generation details
#' 
OMOPCDMHelper$set("public", "auto", function(tables = NULL, columns = NULL, concepts = NULL, silent = FALSE, ...) {
  # Step 1: Handle table selection and validate inputs
  if (is.null(tables) && !silent) {
    warning("No `tables` have been specified. This can significantly slow down operations and include unnecessary data.", 
            immediate. = TRUE)
    # Retrieve all available tables from the database
    tables <- unique(tolower(unlist(unname(self$tables()))))
  }
  
  # Step 2: Provide warnings for potential performance issues
  if (is.null(columns) && !silent) {
    warning("A `column` filter has not been provided. This can significantly slow down operations.", 
            immediate. = TRUE)
  }

  if (is.null(concepts) && !silent) {
    warning("A `concept` filter has not been provided. This can significantly slow down operations and include unnecessary data.", 
            immediate. = TRUE)
  }

  # Step 3: Process and sanitize table names
  tables <- unique(tolower(tables))  # Ensure unique, case-insensitive table names
  tables <- tables[!tolower(tables) %in% c("person", "concept")]  # Exclude system tables
  
  # Step 4: Process each table
  for (tableName in tables) {
    # Generate appropriate column names for the current table
    tableColumns <- generateTableColumns(tableName, columns)

    # Attempt to append data with error handling
    tryCatch(
      {
        # Check available columns in the current table
        availableColumns <- unique(tolower(unlist(unname(self$columns(tableName)))))

        # Only process tables with person_id column (ensures relational integrity)
        if ("person_id" %in% availableColumns) {
          self$append(
            table = tableName,
            columns = tableColumns,
            concepts = concepts,
            ...
          )
        }
      },
      error = function(error) {
        # Silently skip tables that fail to append
        # This ensures the process continues even if individual tables fail
      }
    )
  }
})

#' Generate table column names with prefixes
#'
#' @description
#' Creates a standardized set of column names for OMOP CDM tables, optionally adding table name prefixes
#' to prevent naming conflicts. The function handles special cases like exposure and occurrence tables
#' by removing these suffixes before generating prefixed names.
#'
#' @details
#' The function performs the following operations:
#' 1. Validates input column names
#' 2. Standardizes table names by removing specific suffixes
#' 3. Generates prefixed versions of column names
#' 4. Combines original and prefixed names
#' 5. Removes any duplicates from the final list
#'
#' @param tableName A character string specifying the name of the table.
#'                 Case-insensitive and automatically standardized.
#' @param columnNames An optional character vector of column names to process.
#'                   If NULL, the function returns NULL without processing.
#'
#' @return A character vector containing both original and prefixed column names,
#'         or NULL if no column names were provided.
#'
#' @examples
#' # Basic usage
#' generateTableColumns("drug_exposure", c("start_date", "end_date"))
#' # Returns: c("start_date", "end_date", "drug_start_date", "drug_end_date")
#'
#' # Handling special table names
#' generateTableColumns("condition_occurrence", c("condition_date"))
#' # Returns: c("condition_date", "condition_condition_date")
#'
#' # NULL input handling
#' generateTableColumns("drug_exposure", NULL)
#' # Returns: NULL
#'
generateTableColumns <- function(tableName, columnNames) {
  # Early return if no column names provided
  if (is.null(columnNames)) {
    return(NULL)
  }

  # Standardize table name
  tableName <- tolower(tableName)  # Ensure case consistency
  tableName <- gsub("_occurrence", "", tableName)  # Remove standard suffixes
  tableName <- gsub("_exposure", "", tableName)
  
  # Generate prefixed column names
  columnsWithPrefix <- sapply(columnNames, function(columnName) {
    paste(tableName, columnName, sep = "_")
  })

  # Combine and deduplicate column names
  combinedColumns <- unique(c(columnNames, columnsWithPrefix))

  return(combinedColumns)
}
