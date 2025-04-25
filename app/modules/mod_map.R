mod_map_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    h2("Mapa s PostGIS daty"),
    leafletOutput(ns("mapa"), height = "600px")
  )
}

mod_map_server <- function(input, output, session) {
  ns <- session$ns

  generate_fake_map_data <- function() {
    st_as_sf(data.frame(
      id = 1:10,
      name = sample(c("Point A", "Point B", "Point C"), 10, replace = TRUE),
      lat = runif(10, min = 48.5, max = 50.5),
      lon = runif(10, min = 14.5, max = 16.5)
    ), coords = c("lon", "lat"), crs = 4326)
  }

  output$mapa <- renderLeaflet({
    sf_data <- generate_fake_map_data()
    leaflet(sf_data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        radius = 5,
        color = "blue",
        popup = ~as.character(sf_data$name)
      )
  })
}