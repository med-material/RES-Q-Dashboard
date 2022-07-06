QI_Section_Cat_UI <- function(id, pageName) {
  ns <- NS(id)
  QI_List <- QI_db %>% filter(TAB == pageName & NEW_DASHBOARD_VIS == "stacked_bargraph")
  box(width = 12,
  uiOutput(ns("header_cat")),
  if (nrow(QI_List) != 0) {
    lapply(1:nrow(QI_List), function(i) {
      rowmaker_Cat_UI(ns(QI_List$ABBREVIATION[i]), QI_List$INDICATOR[i])
    })
  }
  )
}

QI_Section_Cat <- function(id, pageName) {
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
      
      QI_List <- QI_db %>% filter(TAB == pageName & NEW_DASHBOARD_VIS == "stacked_bargraph")
      if (nrow(QI_List) != 0) {
        lapply(1:nrow(QI_List), function(i) {
          rowmaker_Cat(QI_List$ABBREVIATION[i], QI_List$ABBREVIATION[i], QI_List)
        })
      }
    }        
  )
}