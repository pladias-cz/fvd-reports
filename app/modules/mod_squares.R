mod_squares_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      includeMarkdown("texts/squares.md"),
        DT::dataTableOutput(ns("sql_squares_data"))
        )
  )
}

mod_squares_server <- function(input, output, session) {
  ns <- session$ns

  sql_squares_result <- reactive({
    conn <- get_connection()
    on.exit(dbDisconnect(conn), add = TRUE)
    query <- read_file("sql/squares.sql")
    dbGetQuery(conn, query)
  })

  output$sql_squares_data <- DT::renderDataTable({
                               DT::datatable(sql_squares_result(),
                                options = list(
                                 paging = FALSE,
                                 dom = 'Bt',
                                 buttons = c('copy', 'csv', 'excel')
                               ), extensions = 'Buttons', rownames = FALSE)
                             })
}
