#' @title Append a table to the base table
#' @name OMOPCDMHelper-append
#' 
#' @description This function appends a specified table from the OMOP CDM database to the base table, with options to filter
#' columns, apply concept filters, and specify merge conditions.
#'
#' @param table A character string specifying the name of the table to append data to.
#' @param columns Optional; a vector of column names to include in the operation.
#' @param concepts Optional; a list of concept IDs to filter the data by.
#' @param merge.x Optional; a character string specifying the column name in the base table to merge on.
#' @param merge.y Optional; a character string specifying the column name in the target table to merge on.
#' @param ... Additional parameters to be passed to the underlying get method.
#'
#' @return The function does not return a value but modifies the database by appending data to the specified table.
#'
OMOPCDMHelper$set("public", "append", function(table, 
                                               columns = NULL, 
                                               concepts = NULL, 
                                               merge.x = NULL, 
                                               merge.y = NULL, 
                                               ...) {  
  # Generates a random string to use as the table symbol (it will be removed after the operation is done)
  generatedString <- paste0(sample(c(0:9, letters, LETTERS), 4, replace = TRUE), collapse = "")
  tableSymbol <- paste0("dsOH.", generatedString)

  # Checks if the merge variables are valid  
  if (is.null(merge.x) && !is.null(merge.y) || !is.null(merge.x) && is.null(merge.y)) {
    stop("Both merge.x and merge.y must be provided or both must be NULL.")
  } else if (is.null(merge.x) && is.null(merge.y)) {
    merge.x <- "person_id"
    merge.y <- "person_id"
  }

  # Retrieves the target table from the database, applying the filters
  self$get(
    table = table,
    symbol = tableSymbol,
    columnFilter = columns,
    conceptFilter = concepts,
    personFilter = self$symbol,
    mergeColumn = merge.y,
    dropNA = TRUE,
    ...
  ) # This may return an error if filtering leaves the table empty

  tryCatch(
    {
      dsBaseClient::ds.merge(
        x.name = self$symbol,
        y.name = tableSymbol,
        by.x.names = merge.x,
        by.y.names = merge.y,
        all.x = TRUE,
        all.y = FALSE,
        sort = FALSE,
        suffixes = c(".x", ".y"),
        no.dups = TRUE,
        newobj = self$symbol,
        datasources = self$OMOPCDMDatabase$connections
      )
    }, error = function(error) {
      # If an error occurs, removes the temporary table and propagates the error
      DSI::datashield.rm(self$OMOPCDMDatabase$connections, tableSymbol)
      stop(error$message)
    }
  )
  # Removes the temporary table
  DSI::datashield.rm(self$OMOPCDMDatabase$connections, tableSymbol)
})
