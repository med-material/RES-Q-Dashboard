rowmaker_UI <- function(id) {
  ns <- NS(id)
  fixedRow(
    column(2, h4(textOutput(ns("QIName")), align = "center")),
    column(1, h4(63, align = "center")),
    column(1, h4(42, align = "center")),
    column(4, h4("vis1", align = "center")),
    column(3, h4("vis2", align = "center")),
    column(1, align = "center", actionButton((ns("action")), label = NULL, icon = icon("play")))
  )
}

rowmaker <- function(id, QI) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      output$QIName <- renderText({
        QI
      })
    }
  )
}
