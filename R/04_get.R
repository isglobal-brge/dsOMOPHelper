#' Retrieve and Process Tables from OMOP CDM Database
#' @name OMOPCDMHelper-get
#'
#' @description Retrieves and processes specified tables from an OMOP CDM database, applying
#' optional filters and transformations before assigning to the DataSHIELD environment. This
#' method provides flexible data access with built-in filtering capabilities for concepts,
#' columns, and person-level data.
#'
#' @details This function performs several key operations:
#' 1. Validates and retrieves the requested table from the OMOP CDM database
#' 2. Applies specified filters (concepts, columns, persons) if provided
#' 3. Performs optional merging operations with other tables
#' 4. Handles missing data through configurable NA dropping
#' 5. Assigns the processed table to the DataSHIELD environment
#'
#' The function is particularly useful for:
#' * Extracting specific subsets of OMOP CDM data
#' * Filtering data based on concept vocabularies
#' * Merging related tables using common identifiers
#' * Managing memory usage through column selection
#'
#' @param table A string specifying the name of the table to be retrieved.
#'        Must be a valid table name in the OMOP CDM schema.
#' @param symbol An optional string specifying the symbol name for table assignment
#'        in the DataSHIELD environment. If NULL, defaults to the table name.
#' @param columnFilter An optional character vector specifying which columns to retain.
#'        Useful for reducing memory usage and focusing on relevant variables.
#' @param conceptFilter An optional numeric vector of concept IDs for filtering rows.
#'        Used to subset data to specific medical concepts of interest.
#' @param personFilter An optional string specifying a symbol name in the environment
#'        containing person IDs to filter by. Enables cohort-based analyses.
#' @param mergeColumn An optional string specifying the column name for merging operations.
#'        Defaults to "person_id" if not specified. Must exist in both tables for merging.
#' @param dropNA A logical indicating whether to remove columns containing only NAs.
#'        Default is FALSE. Set to TRUE to automatically clean empty columns.
#' @param ... Additional parameters passed to the underlying database get method.
#'        See OMOPCDMDatabase documentation for details.
#'
#' @return No direct return value. The function assigns the processed table to the
#'         DataSHIELD environment under the specified symbol name.
#'
#' @examples
#' \dontrun{
#' # Basic table retrieval
#' helper$get("person")
#'
#' # Retrieve specific columns from condition table
#' helper$get("condition_occurrence",
#'           symbol = "conditions",
#'           columnFilter = c("condition_concept_id", "condition_start_date"))
#'
#' # Filter drug exposures by concept IDs
#' helper$get("drug_exposure",
#'           conceptFilter = c(1124300, 1124301),
#'           dropNA = TRUE)
#'
#' # Merge with existing person cohort
#' helper$get("observation",
#'           personFilter = "cohort",
#'           mergeColumn = "person_id")
#' }
#'
#' @seealso
#' * [OMOPCDMHelper-tables] for listing available tables
#' * [OMOPCDMHelper-concepts] for concept lookups
#' * [OMOPCDMHelper-columns] for exploring table structures
#'
OMOPCDMHelper$set("public", "get", function(table,
                                           symbol = NULL,
                                           columnFilter = NULL,
                                           conceptFilter = NULL,
                                           personFilter = NULL,
                                           mergeColumn = NULL,
                                           dropNA = FALSE,
                                           ...) {
  # Delegate table retrieval and processing to the underlying database object
  # This maintains separation of concerns while providing a consistent interface
  self$OMOPCDMDatabase$get(
    table = table,
    symbol = symbol,
    columnFilter = columnFilter,
    conceptFilter = conceptFilter,
    personFilter = personFilter,
    mergeColumn = mergeColumn,
    dropNA = dropNA,
    ...
  )
})
