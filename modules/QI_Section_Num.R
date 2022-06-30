QI_Section_Num_UI <- function(id) {
  ns <- NS(id)
  QI_List <- c("age", "nihss_score")
  box(width = 12,
  uiOutput(ns("header_num")),
   lapply(1:length(QI_List), function(i) {
     rowmaker_Num_UI(ns(QI_List[i]))
   })
  )
}

QI_Section_Num <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$header_num <- renderUI({
        fixedRow(
          column(2, h6("QI", align = 'center')),
          column(1, h6("Hospital", align = 'center')),
          column(1, h6("National", align = 'center')),
          column(7, h6("Visual", align = 'center')),
          column(1, h6("More", align = 'center'))
        )
      })
      
      QI_List <- c("age", "nihss_score")
      lapply(1:length(QI_List), function(i) {
        rowmaker_Num(QI_List[i], QI_List[i])
      })
    }        
  )
}