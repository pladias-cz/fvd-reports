source("modules/mod_squares.R")
source("modules/mod_map.R")

shinyUI <- navbarPage("FVD reports",
    header = head_tags,
  tabPanel("Info",
    fluidPage(
      includeMarkdown("texts/intro.md")
    )
  ),

  tabPanel("Squares overview",
    mod_squares_ui("table1")
  )

#   ,tabPanel("Map",
#     mod_map_ui("map1")
#   )
)