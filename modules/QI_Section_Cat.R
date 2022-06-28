QI_Section_Cat_UI <- function(id) {
  ns <- NS(id)
  QI_List <- c("gender", "stroke_type")
  box(width = 12,
  uiOutput(ns("header_cat")),
   lapply(1:length(QI_List), function(i) {
     rowmaker_Cat_UI(ns(QI_List[i]))
   })
  )
}

QI_Section_Cat <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$header_cat <- renderUI({
        fixedRow(
          column(2, h6("QI", align = 'center')),
          column(9, h6("Visual", align = 'center')),
          column(1, h6("More", align = 'center'))
        )
      })
      
      QI_List <- c("gender", "stroke_type")
      lapply(1:length(QI_List), function(i) {
        rowmaker_Cat(QI_List[i], QI_List[i])
      })
    }        
  )
}