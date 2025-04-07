library(shiny)
library(DBI)
library(RPostgres)
library(leaflet)
library(sf)
library(yaml)

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

generate_fake_sql_data <- function() {
  data.frame(
    id = sample(1:100, 10),
    name = sample(c("John", "Jane", "Alex", "Samantha"), 10, replace = TRUE),
    age = sample(18:80, 10, replace = TRUE),
    stringsAsFactors = FALSE
  )
}

# Fake data pro PostGIS mapu
generate_fake_map_data <- function() {
  st_as_sf(data.frame(
    id = 1:10,
    name = sample(c("Point A", "Point B", "Point C"), 10, replace = TRUE),
    lat = runif(10, min = 48.5, max = 50.5),
    lon = runif(10, min = 14.5, max = 16.5)
  ), coords = c("lon", "lat"), crs = 4326)
}

# Specify the application port
options(shiny.host = "0.0.0.0")
options(shiny.port = 8180)

ui <- navbarPage("Moje aplikace",

  tabPanel("Úvod",
    fluidPage(
      h2("Vítej!"),
      p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    )
  ),

  tabPanel("Data z SQL pohledu",
    fluidPage(
      h2("Výpis z pohledu"),
      tableOutput("sql_data")
    )
  ),

  tabPanel("Mapa",
    fluidPage(
      h2("Mapa s PostGIS daty"),
      leafletOutput("mapa", height = "600px")
    )
  )
)

server <- function(input, output, session) {
  # Výpis dat z pohledu
#   output$sql_data <- renderTable({
#     conn <- get_connection()
#     on.exit(dbDisconnect(conn), add = TRUE)
#
#     query <- sprintf("SELECT * FROM %s LIMIT 100", config$database$view)
#     dbGetQuery(conn, query)
#   })

   output$sql_data <- renderTable({
      # Fake SQL data místo reálné databáze
      generate_fake_sql_data()
    })

  # Zobrazení dat na mapě
  output$mapa <- renderLeaflet({
#     conn <- get_connection()
#     on.exit(dbDisconnect(conn), add = TRUE)
#
#     query <- sprintf("SELECT * FROM %s", config$database$postgis_table)
#     sf_data <- st_read(conn, query = query)
    sf_data <- generate_fake_map_data()
    leaflet(sf_data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        radius = 5,
        color = "blue",
        popup = ~as.character(sf_data[[config$database$popup_column]])
      )
  })
}

shinyApp(ui = ui, server = server)