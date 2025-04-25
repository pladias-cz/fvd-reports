source("modules/mod_table.R", local = TRUE)
source("modules/mod_map.R", local = TRUE)

shinyServer(function(input, output, session) {
  callModule(mod_table_server, "table1")
  callModule(mod_map_server, "map1")
})
