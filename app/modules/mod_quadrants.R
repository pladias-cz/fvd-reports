mod_quadrants_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      includeMarkdown("texts/quadrants.md"),
      DT::dataTableOutput(ns("sql_quadrants_data"))
    )
  )
}

mod_quadrants_server <- function(input, output, session) {
  ns <- session$ns

  sql_quadrants_result <- reactive({
    conn <- get_connection()
    on.exit(dbDisconnect(conn), add = TRUE)
    query <- read_file("sql/quadrants.sql")
    dbGetQuery(conn, query)
  })

  output$sql_quadrants_data <- DT::renderDataTable({
      DT::datatable(sql_quadrants_result(),
       options = list(
        paging = FALSE,
        dom = 'Bt',
        buttons = c('copy', 'csv', 'excel')
      ), extensions = 'Buttons', rownames = FALSE)
    })

}
