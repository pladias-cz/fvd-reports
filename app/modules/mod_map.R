mod_map_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    includeMarkdown("texts/map1.md"),
    leafletOutput(ns("map1"), height = "600px")
  )
}

mod_map_server <- function(input, output, session) {
  ns <- session$ns

    conn <- get_connection()
    query <- read_file("sql/map1.sql")
    data <- dbGetQuery(conn, query)
  sf_data <- st_as_sf(data, wkt = "wkt_geom", crs = 4326)


  output$mapa <- renderLeaflet({
      pal <- colorNumeric(
        palette = "Reds",
        domain = sf_data$pocet
      )

      leaflet(sf_data) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(
          fillColor = ~pal(pocet),
          weight = 1,
          opacity = 1,
          color = "black",
          fillOpacity = 0.7,
          popup = ~paste0("taxa diff: ", pocet)
        ) %>%
        addLegend(
          pal = pal,
          values = sf_data$pocet,
          title = "taxa_diff",
          opacity = 1
        )
    })
}