#' OMOP CDM Helper
#'
#' @description This class facilitates the creation of tables from a connection to an OMOP CDM database.
#'
#' @field OMOPCDMDatabase An object representing the connection to the OMOP CDM database.
#' @field symbol A symbol used to reference the retrieved data in the DataSHIELD environment.
#'
OMOPCDMHelper <- R6::R6Class("OMOPCDMHelper",
  public = list(
    OMOPCDMDatabase = NULL,
    symbol = NULL,

    #' Constructor for OMOP CDM Helper
    #'
    #' @param connections Connection object to the DataSHIELD server.
    #' @param resource Either an identifier or a named list of identifiers for the specific resource(s) within the DataSHIELD server(s).
    #' If a named list, the name of each resource identifier should correspond to the server name in the connections.
    #' @param symbol A character string representing the symbol to which the resource will be assigned.
    #' @param personColumns Optional; a vector of column names to filter from the person table.
    #' @param personFilter Optional; a character string representing another object in the DataSHIELD environment whose person IDs will be 
    #' used to filter the processed data (this speeds up the processing of the data if not all the person IDs are needed).
    #' @param ... Additional parameters to be passed to the underlying get method.
    #'
    #' @return An object of class OMOPCDMHelper.
    #' 
    initialize = function(connections, resource, symbol, personColumns = NULL, personFilter = NULL, ...) {
      self$OMOPCDMDatabase <- dsOMOPClient::ds.omop(connections, resource)
      self$symbol <- symbol

      # Retrieves the person table as the base table
      self$OMOPCDMDatabase$get("person",
        symbol = symbol,
        columnFilter = personColumns,
        personFilter = personFilter,
        dropNA = TRUE,
        ...
      )
    }
  )
)


#' Factory function for OMOP CDM Helper
#'
#' This function creates a new instance of the OMOPCDMHelper class, allowing
#' for interaction with an OMOP CDM database through the DataSHIELD environment.
#'
#' @param connections Connection object to the DataSHIELD server.
#' @param resource Either an identifier or a named list of identifiers for the specific resource(s) within the DataSHIELD server(s).
#' If a named list, the name of each resource identifier should correspond to the server name in the connections.
#' @param symbol A character string representing the symbol to which the resource will be assigned.
#' @param personColumns Optional; a vector of column names to filter from the person table.
#' @param personFilter Optional; a character string representing another object in the DataSHIELD environment whose person IDs will be 
#' used to filter the processed data (this speeds up the processing of the data if not all the person IDs are needed).
#' @param ... Additional parameters to be passed to the underlying get method.
#'
#' @return A new instance of the OMOPCDMHelper class.
#'
#' @export
#' 
ds.omop.helper <- function(connections, resource, symbol, personColumns = NULL, personFilter = NULL, ...) {
  OMOPCDMHelper$new(connections, resource, symbol, personColumns, personFilter, ...)
}
