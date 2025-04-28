library(shiny)
library(DBI)
library(RPostgres)
library(leaflet)
library(sf)
library(yaml)
library(readr)
library(writexl)
library(markdown)
library(DT)
library(sf)

base_path <- Sys.getenv("BASE_PATH", unset = "/data/")

head_tags <- if (base_path != "/") {
  tags$head(tags$base(href = base_path))
} else {
  NULL
}

config <- yaml::read_yaml("config.yaml")

get_connection <- function() {
  dbConnect(
    RPostgres::Postgres(),
    dbname = config$database$dbname,
    host = config$database$host,
    port = config$database$port,
    user = config$database$user,
    password = config$database$password
  )
}
