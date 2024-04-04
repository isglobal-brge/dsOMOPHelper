#' @title Retrieve Tables from OMOP CDM Database
#' @name OMOPCDMHelper-tables
#' 
#' @description This function fetches a list of all tables present in the OMOP CDM database.
#' across all connected servers. It leverages the underlying OMOPCDMDatabase class
#' to query the database and fetch the catalog of tables.
#'
#' @return A list containing the names of all tables available in the OMOP CDM database.
#' 
OMOPCDMHelper$set("public", "tables", function() {
  self$OMOPCDMDatabase$tables()
})


#' @title Retrieve Columns from OMOP CDM Database
#' @name OMOPCDMHelper-columns
#'
#' @description This method fetches a comprehensive list of columns from specified or all tables within the OMOP CDM database.
#' across all connected servers. It leverages the underlying OMOPCDMDatabase class
#' to query the database and fetch the catalog of columns.
#'
#' @param tables Optional; a vector of table names to include in the operation. If NULL, all tables are considered.
#' 
#' @return A list containing the names of all columns available in the specified tables of the OMOP CDM database.
#' 
OMOPCDMHelper$set("public", "columns", function(tables = NULL) {
  # If no tables are selected, assumes all tables
  if (is.null(tables)) {
    tables <- self$tables()
  }
  
  # Gets the unique table names across all servers
  uniqueTables <- unique(unlist(unname(tables)))
  
  columnsList <- list()
  for (tableName in uniqueTables) {
    tryCatch(
      {
        # Attempts to retrieve the columns for the table in all servers
        tableColumns <- self$OMOPCDMDatabase$columns(tableName)
        # If the table exists in that server, adds its columns to that server's list
        for (server in names(tableColumns)) {
          if (!is.null(tableColumns[[server]])) { # If the table exists in that server
            if (!is.list(columnsList[[server]])) { # and the server's list does not exist yet
              columnsList[[server]] <- list() # Creates the server's list
            }
            # Adds the table's columns to the server's list
            columnsList[[server]][[tableName]] <- tableColumns[[server]]
          }
        }
      },
      error = function(error) {
        # If an error occurs (e.g., table does not exist), skips that table
      }
    )
  }
  
  # If the columns list is empty, throws an error
  if (length(columnsList) == 0) {
    stop(crayon::red("The requested tables could not be found in any of the servers!"))
  }
  
  return(columnsList)
})


#' @title Retrieve Concepts Dictionary from OMOP CDM Database
#' @name OMOPCDMHelper-concepts
#' 
#' @description This function fetches the dictionary of concepts from specified or all tables within the OMOP CDM database.
#' across all connected servers. It leverages the underlying OMOPCDMDatabase class
#' to query the database and fetch the catalog of concepts.
#'
#' @param tables Optional; a vector of table names to include in the operation. If NULL, all tables are considered.
#' @param max_length Optional; an integer specifying the maximum length of the concept names. If NULL, no truncation is performed.
#' 
#' @return A list containing the concepts available in the specified tables of the OMOP CDM database.
#' 
OMOPCDMHelper$set("public", "concepts", function(tables = NULL, max_length = NULL) {
  # If no tables are selected, assumes all tables
  if (is.null(tables)) {
    tables <- self$tables()
  }
  
  # Gets the unique table names across all servers
  uniqueTables <- unique(unlist(unname(tables)))

  conceptsList <- list()
  for (tableName in uniqueTables) {
    tryCatch(
      {
        # Attempts to retrieve the concepts for the table in all servers
        tableConcepts <- self$OMOPCDMDatabase$concepts(tableName)
        # If the table exists in that server, adds its concepts to that server's list
        for (server in names(tableConcepts)) {
          if (!is.null(tableConcepts[[server]])) { # If the table exists in that server
            if (!is.list(conceptsList[[server]])) { # and the server's list does not exist yet
              conceptsList[[server]] <- list() # Creates the server's list
            }
            # Adds the table's concepts to the server's list
            conceptsList[[server]][[tableName]] <- tableConcepts[[server]]
          }
        }
      },
      error = function(error) {
        # If an error occurs (e.g., table does not exist), skips that table
      }
    )
  }
  
  # Combines the concepts data frames for each server
  for (server in names(conceptsList)) {
    conceptsList[[server]] <- do.call(rbind, conceptsList[[server]])
  }

  # If the columns list is empty, throws an error
  if (length(conceptsList) == 0) {
    stop(crayon::red("No concepts could be found for the requested tables in any of the servers!"))
  }

  # Remove row names for all elements in the conceptsList
  for (i in seq_along(conceptsList)) {
    row.names(conceptsList[[i]]) <- NULL
  }

  # Truncate concept names if max_length is specified
  if (!is.null(max_length)) {
    for (i in seq_along(conceptsList)) {
      if ("concept_name" %in% colnames(conceptsList[[i]])) {
        conceptsList[[i]]$concept_name <- sapply(conceptsList[[i]]$concept_name, function(name) {
          if (nchar(name) > max_length) {
            return(paste0(substr(name, 1, max_length - 3), "..."))
          } else {
            return(name)
          }
        })
      }
    }
  }
  
  return(conceptsList)
})
