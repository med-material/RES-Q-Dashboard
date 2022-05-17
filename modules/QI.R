QI_Layout <- function(id, database) {
  ns <- NS(id)
  column(
    5,
    h1("Quality Indicators"),
    getDependency('sparkline'),
    dataTableOutput(
      outputId = ns("QI")
    )
  )
}

QI_server <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
      staticRender_cb <- JS('function(){debugger;HTMLWidgets.staticRender();}') 
      sparkline_column <- spk_chr(
        c(5, 6, 7, 9, 9, 5, 3, 2, 2, 4, 6, 7),
        type = "line",
        fillColor = FALSE
      )
      sparkline_col2 <- spk_chr(
        c(10,12,12,9,7), 
        type = "bullet"
      )
      df <- data.frame(database, sparkline_column, sparkline_col2)
      colnames(df) <- c("Metric 1", "Metric 2", "Visual 1", "Visual 2")
      rownames(df) <- c("QI 1")
      output$QI <- DT::renderDataTable(df, escape = FALSE, options = list(
        dom = "tir",
        drawCallback = staticRender_cb,
        columnDefs = list(list(className = 'dt-center', targets = "_all"))
      ))
    }
  )
}
