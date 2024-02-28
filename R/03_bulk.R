#' @export
OMOPCDMHelper$set("public", "bulk", function(tables, columns = NULL, concepts = NULL) {
  if (is.null(tables) || length(tables) == 0) {
    stop("The 'tables' parameter cannot be NULL or empty.")
  }

  # If no column filter has been provided, warns the user
  if (is.null(columns)) {
    warning(paste(
      crayon::yellow("A column filter has not been provided."),
      crayon::red("This can significantly slow down operations!")
    ), immediate. = TRUE)
  }
  
  # TODO: Smart table selector

  # Eliminates duplicates in 'tables', case-insensitive
  tables <- unique(tolower(tables))

  # Excludes "person" and "concept" tables from the list, case-insensitive
  tables <- tables[!tolower(tables) %in% c("person", "concept")]
  
  # Initializes the list to store the results
  bulkResults <- list()
  
  for (tableName in tables) {
    
    # TODO: Generate table-specific column names

    # Attempts to append the data for each specified table
    tryCatch(
      {
        self$append(
          table = tableName,
          columns = columns,
          concepts = concepts
        )
      },
      error = function(error) {
        # If a table fails to append, skips it
      }
    )
  }
})
