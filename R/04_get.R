#' @title Get Table from OMOP CDM Database
#' @name OMOPCDMHelper-get
#'
#' @description This method retrieves a specified table by name from an OMOP CDM database and assigns it to the DataSHIELD environment.
#' It allows the user to specify filters for concepts, columns, and persons, as well as options for merging and dropping empty columns.
#'
#' @param table A string specifying the name of the table to be retrieved.
#' @param symbol An optional string specifying the symbol for the table assignment in the DataSHIELD environment.
#' @param columnFilter An optional string vector specifying column names to filter (select) in the table.
#' @param conceptFilter An optional numeric vector specifying concept IDs to filter the table by.
#' @param personFilter An optional string specifying the symbol in the environment of a table from which to obtain person IDs.
#' @param mergeColumn An optional string specifying the column name for merging operations with other tables.
#'                    Defaults to "person_id" if not specified.
#' @param dropNA An optional boolean indicating whether to drop empty columns. Defaults to FALSE.
#'
#' @return Assigns the specified table to the DataSHIELD environment, optionally filtered and merged.
#' 
OMOPCDMHelper$set("public", "get", function(table, 
                                            symbol = NULL, 
                                            columnFilter = NULL, 
                                            conceptFilter = NULL, 
                                            personFilter = NULL, 
                                            mergeColumn = NULL, 
                                            dropNA = FALSE) {
    self$OMOPCDMDatabase$get(
    table = table,
    symbol = symbol,
    columnFilter = columnFilter,
    conceptFilter = conceptFilter,
    personFilter = personFilter,
    mergeColumn = mergeColumn,
    dropNA = dropNA
  )
})
