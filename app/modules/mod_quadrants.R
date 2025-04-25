mod_quadrants_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      includeMarkdown("texts/quadrants.md"),
      downloadButton(ns("download_quadrants_xlsx"), "Download XLSX"),
      tableOutput(ns("sql_quadrants_data"))
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

  output$sql_quadrants_data <- renderTable({
    sql_quadrants_result()
  })

  output$download_quadrants_xlsx <- downloadHandler(
    filename = function() {
      paste0("quadrants", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      write_xlsx(sql_quadrants_result(), path = file)
    },
    contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  )
}
