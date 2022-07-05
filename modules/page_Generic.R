page_Generic_UI <- function(id, pageName) {
  ns <- NS(id)
  fluidPage(
    fixedRow(
      box(width = 6, background = "navy",
        QI_Section_Num_UI(ns("QISection_Num"), pageName), 
        br(),
        br(),
        br(),
        QI_Section_Cat_UI(ns("QISection_Cat"))
      ),
      column(6,
        plot_Expanded_UI(ns("VisSection"), mtcars)
      )
    )
  )
}

page_Generic <- function(id, pageName) {
  moduleServer(
    id,
    function(input, output, session) {
      QI_Section_Num("QISection_Num", pageName)
      QI_Section_Cat("QISection_Cat")
      plot_Expanded("VisSection", mtcars)
    }
  )
}