mod_squares_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      includeMarkdown("texts/squares.md"),
      downloadButton(ns("download_squares_xlsx"), "Download XLSX"),
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
    result <- dbGetQuery(conn, query)

    # Debug výstup do logu
    print("=== sql_squares_result ===")
    print(str(result))
    print(head(result))

    result
  })

  output$sql_squares_data <- DT::renderDataTable({
                               DT::datatable(sql_squares_result(), options = list(
                                 pageLength = 10,
                                 dom = 'Bfrtip',
                                 buttons = c('copy', 'csv', 'excel')
                               ), extensions = 'Buttons')
                             })

  output$download_squares_xlsx <- downloadHandler(
    filename = function() {
      paste0("squares_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      write_xlsx(sql_squares_result(), path = file)
    },
    contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  )
}
