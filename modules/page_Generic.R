page_Generic_UI <- function(id) {
  ns <- NS(id)
  fluidPage(
    fixedRow(
      QI_Section_UI(ns("QISection")),
      plot_Expanded_UI(ns("VisSection"), mtcars)
      
    )
  )
}

page_Generic <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      QI_Section("QISection")
      plot_Expanded("VisSection", mtcars)
    }
  )
}