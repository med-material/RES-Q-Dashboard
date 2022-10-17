#This module is very similar structurally to rowmaker_Num, but they had to be separate as the rows they produce have different header structures.
#For more in detail comments about the logic, check rowmaker_Num the only real big difference here is the visualisation output$vis.

rowmaker_Cat_UI <- function(id, QI_title) {
  ns <- NS(id)
  fixedRow(
    column(2, h6(textOutput(ns("QIName")), title = QI_title, align = "left")),
    column(9, plotlyOutput(ns("cat_vis"), width = "600px", height = "100"), align = "center"),
    column(1, align = "center", actionButton((inputId = ns("action")), label = NULL, icon = icon("play")))
  )
}


rowmaker_Cat <- function(id, QI, df) {
  moduleServer(
    id,
    function(input, output, session) {
      #rendering QI name
      output$QIName <- renderText({
        QI
      })
      
      index <- match(QI, df$INDICATOR)
      dataType <- df$ATTRIBUTE_TYPE[index]
      QI_col <- df$COLUMN[index]
      aggType <- df$SUMMARIZE_BY[index]
      
      #Just picking a hospital and country from the dataset. Feel free to change these, however they must match those of rowmaker_Num.
      hospital <- "uggeebfixudwdhb"
      country <- "vrprkigsxydwgni"

      
      row_df <- dataHandlerQI(catVars, dataType, QI_col, hospital, country, aggType)
      
      latest <- max(row_df$YQ)
      
      #Categorical data is only considered in the latest hospital quarter.
      row_df <- row_df %>% filter(YQ == latest)
      
      #Set the transparency of Country bar
      row_df$alphascope <- as.factor(ifelse(row_df$Scope == "Country", 0.4, 1))
      
      output$vis <- renderPlotly({
        
        #Check if the data is missing for the hospital, if so it will simply show white space. This is done to prevent errors on dashboard.
        isNAHospital <- row_df %>% filter(Scope == "Hospital")
        
        if (all(is.na(isNAHospital$Category)) == F) {
          #Define the plot using ggplot functions, note coord_flip is what allows the bargraph to be shown horizontally.
          plot <- ggplot(row_df, aes(x = Scope, fill = Category, alpha = factor(alphascope))) + 
            geom_bar(position ="fill", width = 0.5) + coord_flip() + 
            
            #Tell ggplot to parse the alpha/transparency defined in row_df$alphascope. 
            #This line needs to be changed accordingly whenever the other one is and vice versa.
            scale_alpha_manual(values = c("0.4"=0.4, "1"=1), guide='none') +
            
            #Set theme here
            theme(axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.title.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  legend.position = "none",
                  axis.title.y = element_blank(),
                  panel.grid.major = element_blank(), 
                  panel.grid.minor = element_blank(),
                  panel.background = element_blank())
          
          #Remove the on hover options from the plotly plot.
          ggplotly(plot) %>% config(displayModeBar = FALSE)
        }
      })
      
      #shinyjs::click(id = "action")
      
      return(
        list(
          #action_btn = reactive(input$action),
          xvar = row_df$YQ,
          yvar = row_df$Hospital
        )
      )
      
    }
  )
}