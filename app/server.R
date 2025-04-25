source("modules/mod_squares.R", local = TRUE)
source("modules/mod_quadrants.R", local = TRUE)
source("modules/mod_map.R", local = TRUE)

shinyServer(function(input, output, session) {
  callModule(mod_squares_server, "table1")
  callModule(mod_quadrants_server, "table2")
  callModule(mod_map_server, "map1")
})
