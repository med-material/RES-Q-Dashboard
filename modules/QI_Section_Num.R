QI_Section_Num_UI <- function(id, pageName) {
  ns <- NS(id)
  QI_List <- QI_db %>% filter(TAB == pageName & NEW_DASHBOARD_VIS == "trend")
  box(width = 12,
  uiOutput(ns("header_num")),
  if (nrow(QI_List) != 0) {
   lapply(1:nrow(QI_List), function(i) {
     rowmaker_Num_UI(ns(QI_List$ABBREVIATION[i]))
   })
  }
  )
}

QI_Section_Num <- function(id, pageName) {
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
      
      QI_List <- QI_db %>% filter(TAB == pageName & NEW_DASHBOARD_VIS == "trend")
      if (nrow(QI_List) != 0) {
        lapply(1:nrow(QI_List), function(i) {
          rowmaker_Num(QI_List$ABBREVIATION[i], QI_List$ABBREVIATION[i], QI_List)
        })
      }
    }        
  )
}