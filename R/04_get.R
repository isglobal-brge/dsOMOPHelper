#' @export
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
