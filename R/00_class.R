#' OMOP CDM Helper Class
#'
#' @description This R6 class facilitates the creation and management of tables from an OMOP Common Data Model (CDM) database
#' through a DataSHIELD connection. It provides an interface to interact with OMOP CDM data in a secure and standardized way.
#'
#' @details The OMOPCDMHelper class is designed to:
#' * Establish and maintain a connection to an OMOP CDM database
#' * Retrieve and filter person-level data
#' * Manage data symbols in the DataSHIELD environment
#' * Support distributed computing through DataSHIELD's infrastructure
#'
#' The class automatically initializes with the person table as the base table, which can be filtered
#' by specific columns or person IDs to optimize performance.
#'
#' @field OMOPCDMDatabase An object representing the active connection to the OMOP CDM database.
#' @field symbol A character string symbol used to reference the retrieved data in the DataSHIELD environment.
#'
#' @examples
#' \dontrun{
#' # Create a new helper instance
#' helper <- OMOPCDMHelper$new(
#'   connections = datashield.connections,
#'   resource = "study_database",
#'   symbol = "study_data",
#'   personColumns = c("person_id", "year_of_birth", "gender_concept_id")
#' )
#' }
#'
OMOPCDMHelper <- R6::R6Class("OMOPCDMHelper",
  public = list(
    OMOPCDMDatabase = NULL,
    symbol = NULL,

    #' Initialize a new OMOP CDM Helper instance
    #'
    #' @description Creates a new instance of the OMOPCDMHelper class and establishes the initial
    #' connection to the OMOP CDM database. The initialization process includes setting up the
    #' database connection and retrieving the base person table.
    #'
    #' @param connections A DataSHIELD connection object representing the connection(s) to the DataSHIELD server(s).
    #' @param resource Either a single identifier string or a named list of identifiers for the database resource(s).
    #'        For multiple servers, provide a named list where names match the server names in connections.
    #' @param symbol A character string that will be used as the reference name for the retrieved data
    #'        in the DataSHIELD environment.
    #' @param personColumns Optional character vector specifying which columns to include from the person table.
    #'        If NULL, all columns will be retrieved.
    #' @param personFilter Optional character string referring to an existing object in the DataSHIELD
    #'        environment containing person IDs to filter the data. This can significantly improve
    #'        performance when working with a subset of the population.
    #' @param ... Additional arguments passed to the underlying ds.omop get method.
    #'
    #' @return A new initialized instance of the OMOPCDMHelper class.
    #' 
    #' @examples
    #' \dontrun{
    #' # Basic initialization
    #' helper <- OMOPCDMHelper$new(
    #'   connections = datashield.connections,
    #'   resource = "cdm_database",
    #'   symbol = "study_cohort"
    #' )
    #'
    #' # Initialize with specific person columns and filters
    #' helper <- OMOPCDMHelper$new(
    #'   connections = datashield.connections,
    #'   resource = "cdm_database",
    #'   symbol = "filtered_cohort",
    #'   personColumns = c("person_id", "gender_concept_id"),
    #'   personFilter = "existing_cohort"
    #' )
    #' }
    #'
    initialize = function(connections, resource, symbol, personColumns = NULL, personFilter = NULL, ...) {
      # Step 1: Establish database connection
      self$OMOPCDMDatabase <- dsOMOPClient::ds.omop(connections, resource)
      
      # Step 2: Store the symbol reference
      self$symbol <- symbol
      
      # Step 3: Retrieve and set up the person table as the base table
      self$OMOPCDMDatabase$get(
        table = "person",
        symbol = symbol,
        columnFilter = personColumns,
        personFilter = personFilter,
        dropNA = TRUE,  # Remove rows with NA values for cleaner data
        ...
      )
    }
  )
)

#' Create a new OMOP CDM Helper instance
#'
#' @description Factory function that creates and returns a new instance of the OMOPCDMHelper class.
#' This function provides a more R-like interface for creating OMOPCDMHelper objects compared to
#' using the R6 class constructor directly.
#'
#' @param connections A DataSHIELD connection object representing the connection(s) to the DataSHIELD server(s).
#' @param resource Either a single identifier string or a named list of identifiers for the database resource(s).
#'        For multiple servers, provide a named list where names match the server names in connections.
#' @param symbol A character string that will be used as the reference name for the retrieved data
#'        in the DataSHIELD environment.
#' @param personColumns Optional character vector specifying which columns to include from the person table.
#'        If NULL, all columns will be retrieved.
#' @param personFilter Optional character string referring to an existing object in the DataSHIELD
#'        environment containing person IDs to filter the data.
#' @param ... Additional arguments passed to the underlying ds.omop get method.
#'
#' @return A new instance of the OMOPCDMHelper class.
#'
#' @examples
#' \dontrun{
#' # Create a basic helper instance
#' helper <- ds.omop.helper(
#'   connections = datashield.connections,
#'   resource = "cdm_database",
#'   symbol = "study_data"
#' )
#'
#' # Create helper with filtered columns
#' helper <- ds.omop.helper(
#'   connections = datashield.connections,
#'   resource = "cdm_database",
#'   symbol = "filtered_data",
#'   personColumns = c("person_id", "birth_datetime", "gender_concept_id"),
#'   personFilter = "existing_cohort"
#' )
#' }
#'
#' @seealso 
#' * [dsOMOPClient::ds.omop()] for the underlying database connection
#' * [R6::R6Class()] for details about the R6 class system
#'
#' @export
#' 
ds.omop.helper <- function(connections, resource, symbol, personColumns = NULL, personFilter = NULL, ...) {
  OMOPCDMHelper$new(connections, resource, symbol, personColumns, personFilter, ...)
}
