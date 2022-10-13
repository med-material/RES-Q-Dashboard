#This will generate the numerical QI section of the QI section. Note what determines what QI goes in this tab is based on the pageNanme & 
#the visual has to be a trend. This is because some categorical data actually ends up being displayed in trendline.

QI_Section_Num_UI <- function(id, pageName) {
  ns <- NS(id)
  QI_List <- QI_db %>% filter(ONEPAGE == pageName & NEW_DASHBOARD_VIS == "trend")
  box(width = 12,
  
  #Render the ui from the severside with the title "header_num"
  uiOutput(ns("header_num")),
  
  #Check the list has dimension before calling the rowmaker modules
  if (nrow(QI_List) != 0) {
    
    #lapply is short for list apply, it applies a function to every element in a list. 
    #Note we pass to rowmaker an ID as well as the full indicator from QI_Info
   lapply(1:nrow(QI_List), function(i) {
     rowmaker_Num_UI(ns("test"), QI_List$INDICATOR[i])
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
          column(7, h6("Visual", align = 'center')),
          column(1, h6("Hospital", align = 'center')),
          column(1, h6("National", align = 'center')),
          column(1, h6("More", align = 'center'))
        )
      })
      
      #Same logic as the UI side, only difference being rowmaker_Num takes an extra paremeter, the QI info list itself.
      #Note the QI list is generated twice because the UI and server side are at different scopes. 
      QI_List <- QI_db %>% filter(ONEPAGE == pageName & NEW_DASHBOARD_VIS == "trend")
      if (nrow(QI_List) != 0) {
        lapply(1:nrow(QI_List), function(i) {
          rowmaker_Num(QI_List$INDICATOR[i], QI_List$INDICATOR[i], QI_List)
          #rowmaker_Num(QI_List$ABBREVIATION[i], QI_List$ABBREVIATION[i], QI_List)
        })
      }
    }        
  )
}