OMOPCDMHelper <- R6::R6Class("OMOPCDMHelper",
  public = list(
    OMOPCDMDatabase = NULL,
    symbol = NULL,
    initialize = function(connections, resource, symbol, personColumns = NULL, personFilter = NULL) {
      self$OMOPCDMDatabase <- dsOMOPClient::ds.omop(connections, resource)
      self$symbol <- symbol

      # Retrieves the person table as the base table
      self$OMOPCDMDatabase$get("person",
        symbol = symbol,
        columnFilter = personColumns,
        personFilter = personFilter,
        dropNA = TRUE
      )
    }
  )
)


#' @export
ds.omop.helper <- function(connections, resource, symbol, personColumns = NULL, personFilter = NULL) {
  OMOPCDMHelper$new(connections, resource, symbol, personColumns, personFilter)
}
