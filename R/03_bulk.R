#' @export
OMOPCDMHelper$set("public", "bulk", function(tables = NULL, columns = NULL, concepts = NULL, silent = FALSE) {
  # If no column filter has been provided, warns the user
  if (is.null(columns) && !silent) {
    warning(paste(
      crayon::yellow("WARNING: A 'column' filter has not been provided."),
      crayon::red("This can significantly slow down operations!")
    ), immediate. = TRUE)
  }

  # If no concept filter has been provided, warns the user
  if (is.null(concepts) && !silent) {
    warning(paste0(
      crayon::yellow("WARNING: A 'concept' filter has not been provided. "),
      crayon::red("This can significantly slow down operations if you do not intend to work with all available concepts!\n"),
      crayon::yellow("If you are unsure about the available concepts, use the "),
      crayon::green("`concepts()`"), crayon::yellow(" function to explore the available concepts.")
    ), immediate. = TRUE)
  }
  
  # If no tables are selected, assumes all person-related tables
  if (is.null(tables) && !silent) {
    # Warns the user about the potential performance impact
    warning(paste0(
      crayon::yellow("WARNING: No 'tables' have been specified. "),
      crayon::red("This may slow down operations and append data you do not intend to use!\n"),
      crayon::blue("The "), crayon::green("smart table selector"),
      crayon::blue(" will locate all tables linkable to the 'person' table...")
    ), immediate. = TRUE)

    # Retrieves the available tables from the server
    tables <- unique(tolower(unlist(unname(self$tables()))))
  }

  # Eliminates duplicates in the list, case-insensitive
  tables <- unique(tolower(tables))

  # Excludes 'person' and 'concept' tables from the list
  tables <- tables[!tolower(tables) %in% c("person", "concept")]
  
  # Initializes the list to store the results
  bulkResults <- list()
  
  for (tableName in tables) {
    # Generates the column names based on the table name
    tableColumns <- generateTableColumns(tableName, columns)

    # Attempts to append the data for each specified table
    tryCatch(
      {
        # Retrieves the available columns for the table
        availableColumns <- unique(tolower(unlist(unname(self$columns(tableName)))))

        # If the 'person_id' column is available, appends the table
        if ("person_id" %in% availableColumns) {
          self$append(
            table = tableName,
            columns = tableColumns,
            concepts = concepts
          )
        }
      },
      error = function(error) {
        # If a table fails to append, skips it
      }
    )
  }
})


generateTableColumns <- function(tableName, columnNames) {
  # If no column names are provided, it will not generate the prefixed column names
  if (is.null(columnNames)) {
    return(NULL)
  }

  tableName <- tolower(tableName) # Converts the table name to lowercase
  tableName <- gsub("_occurrence", "", tableName) # Removes the "_occurrence" suffix

  # Generates the column names with the table name as a prefix
  columnsWithPrefix <- sapply(columnNames, function(columnName) {
    paste(tableName, columnName, sep = "_")
  })

  # Combines the original column names with the prefixed column names
  combinedColumns <- c(columnNames, columnsWithPrefix)

  # Removes duplicates from the combined list
  combinedColumns <- unique(combinedColumns)

  return(combinedColumns)
}
