mod_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      h2("Squares"),
      downloadButton(ns("download_squares_xlsx"), "Download XLSX"),
      tableOutput(ns("sql_squares_data"))
    )
  )
}

mod_table_server <- function(input, output, session) {
  ns <- session$ns

  sql_squares_result <- reactive({
    conn <- get_connection()
    on.exit(dbDisconnect(conn), add = TRUE)
    query <- read_file("sql/squares.sql")
    dbGetQuery(conn, query)
  })

  output$sql_squares_data <- renderTable({
    sql_squares_result()
  })

  output$download_xlsx <- downloadHandler(
    filename = function() {
      paste0("squares_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      write_xlsx(sql_squares_result(), path = file)
    },
    contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  )
}
