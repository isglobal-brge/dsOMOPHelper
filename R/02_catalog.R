#' Retrieve Tables from OMOP CDM Database
#' @name OMOPCDMHelper-tables
#'
#' @description Fetches a comprehensive list of all tables present in the OMOP CDM database
#' across all connected DataSHIELD servers. This function provides a catalog view of the 
#' available data tables in the OMOP CDM schema.
#'
#' @details This method queries the underlying OMOPCDMDatabase object to retrieve table names
#' from all connected servers. It is useful for:
#' * Exploring available data tables in the OMOP CDM database
#' * Validating table existence before operations
#' * Understanding the database structure
#'
#' @return A named list where:
#' * Names are the server identifiers
#' * Values are character vectors containing table names available on that server
#'
#' @examples
#' \dontrun{
#' # Get all available tables
#' tables <- helper$tables()
#' 
#' # Print tables from first server
#' print(tables[[1]])
#' 
#' # Check if specific table exists
#' if ("person" %in% unlist(tables)) {
#'   print("Person table is available")
#' }
#' }
#'
#' @seealso 
#' * [OMOPCDMHelper-columns] for retrieving column information
#' * [OMOPCDMHelper-concepts] for concept dictionary access
#' 
OMOPCDMHelper$set("public", "tables", function() {
  self$OMOPCDMDatabase$tables()
})

#' Retrieve Column Information from OMOP CDM Database
#' @name OMOPCDMHelper-columns
#'
#' @description Provides detailed column information for specified tables (or all tables if none specified)
#' from the OMOP CDM database across all connected DataSHIELD servers. This function enables
#' exploration and validation of table structures.
#'
#' @details The function performs the following steps:
#' 1. Validates input tables or defaults to all available tables
#' 2. Retrieves unique table names across all servers
#' 3. Iteratively fetches column information for each table
#' 4. Organizes results by server and table
#' 5. Handles errors gracefully for missing tables
#'
#' @param tables Optional character vector of table names to query. If NULL (default),
#'        retrieves columns for all available tables.
#' 
#' @return A nested list structure where:
#' * Top level: Server identifiers
#' * Second level: Table names
#' * Values: Character vectors of column names for each table
#'
#' @examples
#' \dontrun{
#' # Get columns for all tables
#' all_columns <- helper$columns()
#' 
#' # Get columns for specific tables
#' selected_columns <- helper$columns(
#'   tables = c("person", "observation")
#' )
#' 
#' # Access columns for a specific table on first server
#' person_cols <- all_columns[[1]][["person"]]
#' }
#'
#' @seealso 
#' * [OMOPCDMHelper-tables] for listing available tables
#' * [OMOPCDMHelper-concepts] for concept dictionary access
#' 
OMOPCDMHelper$set("public", "columns", function(tables = NULL) {
  # Step 1: Initialize with all tables if none specified
  if (is.null(tables)) {
    tables <- self$tables()
  }
  
  # Step 2: Extract unique table names across servers
  uniqueTables <- unique(unlist(unname(tables)))
  
  # Step 3: Initialize results container
  columnsList <- list()
  
  # Step 4: Iterate through tables and collect column information
  for (tableName in uniqueTables) {
    tryCatch({
      # Query columns for current table across all servers
      tableColumns <- self$OMOPCDMDatabase$columns(tableName)
      
      # Process results for each server
      for (server in names(tableColumns)) {
        if (!is.null(tableColumns[[server]])) {
          # Initialize server list if needed
          if (!is.list(columnsList[[server]])) {
            columnsList[[server]] <- list()
          }
          # Store column information
          columnsList[[server]][[tableName]] <- tableColumns[[server]]
        }
      }
    },
    error = function(error) {
      # Silently skip tables that don't exist or have errors
    })
  }
  
  # Step 5: Validate results
  if (length(columnsList) == 0) {
    stop(crayon::red("The requested tables could not be found in any of the servers!"))
  }
  
  return(columnsList)
})

#' Retrieve Concept Dictionary from OMOP CDM Database
#' @name OMOPCDMHelper-concepts
#'
#' @description Fetches and processes the concept dictionary for specified tables (or all tables
#' if none specified) from the OMOP CDM database. This function provides access to standardized
#' vocabulary and terminology used in the OMOP CDM.
#'
#' @details The function performs these operations:
#' 1. Validates input tables or defaults to all available tables
#' 2. Retrieves concepts for each table across all servers
#' 3. Combines concept information within each server
#' 4. Processes concept names to maintain readable lengths
#' 5. Handles missing data and errors gracefully
#'
#' @param tables Optional character vector of table names to query concepts from.
#'        If NULL (default), retrieves concepts from all available tables.
#' @param max_length Optional integer specifying maximum length for concept names.
#'        Names longer than this will be truncated with "...". Default is 60 characters.
#' 
#' @return A list where:
#' * Names are server identifiers
#' * Values are data frames containing concept information with columns:
#'   - concept_id: Unique identifier for the concept
#'   - concept_name: Human-readable concept description (truncated if specified)
#'
#' @examples
#' \dontrun{
#' # Get concepts for all tables
#' all_concepts <- helper$concepts()
#' 
#' # Get concepts for specific tables with custom name length
#' selected_concepts <- helper$concepts(
#'   tables = c("condition_occurrence", "drug_exposure"),
#'   max_length = 40
#' )
#' 
#' # Access concepts from first server
#' server1_concepts <- all_concepts[[1]]
#' }
#'
#' @seealso 
#' * [OMOPCDMHelper-tables] for listing available tables
#' * [OMOPCDMHelper-columns] for column information
#' 
OMOPCDMHelper$set("public", "concepts", function(tables = NULL, max_length = 60) {
  # Step 1: Initialize with all tables if none specified
  if (is.null(tables)) {
    tables <- self$tables()
  }
  
  # Step 2: Extract unique table names across servers
  uniqueTables <- unique(unlist(unname(tables)))
  
  # Step 3: Initialize results container
  conceptsList <- list()
  
  # Step 4: Collect concept information for each table
  for (tableName in uniqueTables) {
    tryCatch({
      # Query concepts for current table
      tableConcepts <- self$OMOPCDMDatabase$concepts(tableName)
      
      # Process results for each server
      for (server in names(tableConcepts)) {
        if (!is.null(tableConcepts[[server]])) {
          # Initialize server list if needed
          if (!is.list(conceptsList[[server]])) {
            conceptsList[[server]] <- list()
          }
          # Store concept information
          conceptsList[[server]][[tableName]] <- tableConcepts[[server]]
        }
      }
    },
    error = function(error) {
      # Silently skip tables that don't exist or have errors
    })
  }
  
  # Step 5: Combine concept data frames for each server
  for (server in names(conceptsList)) {
    conceptsList[[server]] <- do.call(rbind, conceptsList[[server]])
  }
  
  # Step 6: Validate results
  if (length(conceptsList) == 0) {
    stop(crayon::red("No concepts could be found for the requested tables in any of the servers!"))
  }
  
  # Step 7: Clean up row names
  for (i in seq_along(conceptsList)) {
    row.names(conceptsList[[i]]) <- NULL
  }
  
  # Step 8: Process concept names if length limit specified
  # Truncate concept names if max_length is specified
  if (!is.null(max_length)) {
    # Process each server's concept list
    for (i in seq_along(conceptsList)) {
      # Check if concept_name column exists
      if ("concept_name" %in% colnames(conceptsList[[i]])) {
        # Transform concept names, truncating if longer than max_length
        conceptsList[[i]]$concept_name <- sapply(
          conceptsList[[i]]$concept_name,
          function(name) {
            # Skip NA values
            if (is.na(name)) return(name)
            
            # Truncate long names and add ellipsis
            if (nchar(name) > max_length) {
              truncated <- substr(name, 1, max_length - 3)
              return(paste0(truncated, "..."))
            }
            
            # Return unchanged name if within length limit
            return(name)
          }
        )
      }
    }
  }
  
  return(conceptsList)
})
