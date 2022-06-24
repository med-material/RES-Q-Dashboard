QI_Section_UI <- function(id) {
  ns <- NS(id)
  QI_List <- c("QI1", "QI2")
  column(6, uiOutput(ns("header")), 
         lapply(1:length(QI_List), function(i) {
           rowmaker_UI(ns(QI_List[i]))
         })
  )
}

QI_Section <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      output$header <- renderUI({
        fixedRow(
          column(2, h4("QI", align = 'center')),
          column(1, h4("Metric 1", align = 'center')),
          column(1, h4("Metric 2", align = 'center')),
          column(4, h4("Visual 1", align = 'center')),
          column(3, h4("Visual 2", align = 'center')),
          column(1, h4("More", align = 'center'))
        )
      })
      
      QI_List <- c("QI1", "QI2")
      lapply(1:length(QI_List), function(i) {
        rowmaker(QI_List[i], QI_List[i])
      })
    }        
  )
}