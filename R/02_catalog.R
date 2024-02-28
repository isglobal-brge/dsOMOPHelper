#' @export
OMOPCDMHelper$set("public", "tables", function() {
  self$OMOPCDMDatabase$tables()
})


#' @export
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


#' @export
OMOPCDMHelper$set("public", "concepts", function(tables = NULL) {
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
  
  return(conceptsList)
})
