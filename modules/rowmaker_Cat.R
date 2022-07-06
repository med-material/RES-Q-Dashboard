rowmaker_Cat_UI <- function(id, QI_title) {
  ns <- NS(id)
  fixedRow(
    column(2, h6(textOutput(ns("QIName")), title = QI_title, align = "left")),
    column(9, plotlyOutput(ns("vis"), width = "600px", height = "80"), align = "center"),
    column(1, align = "center", actionButton((ns("action")), label = NULL, icon = icon("play")))
  )
}

rowmaker_Cat <- function(id, QI, df) {
  moduleServer(
    id,
    function(input, output, session) {
      output$QIName <- renderText({
        QI
      })
      
      index <- match(QI, df$ABBREVIATION)
      dataType <- df$ATTRIBUTE_TYPE[index]
      QI_col <- df$COLUMN[index]
      hospital <- "uggeebfixudwdhb"
      country <- "vrprkigsxydwgni"
      aggType <- df$SUMMARIZE_BY[index]
      
      row_df <- dataHandlerQI(catVars, dataType, QI_col, hospital, country, aggType)
      
      latest <- max(row_df$YQ)
      
      row_df <- row_df %>% filter(YQ == latest)
      
      #Set the transparency of Country bar
      row_df$alphascope <- as.factor(ifelse(row_df$Scope == "Country", 0.4, 1))
      
      output$vis <- renderPlotly({
        isNAHospital <- row_df %>% filter(Scope == "Hospital")
        
        if (all(is.na(isNAHospital$Category)) == F) {
          plot <- ggplot(row_df, aes(x = Scope, fill = Category, alpha = factor(alphascope))) + 
            geom_bar(position ="fill", width = 0.5) + coord_flip() + 
            scale_alpha_manual(values = c("0.4"=0.4, "1"=1), guide='none') +
            theme(axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.title.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  legend.position = "none",
                  axis.title.y = element_blank(),
                  panel.grid.major = element_blank(), 
                  panel.grid.minor = element_blank(),
                  panel.background = element_blank())
          
          ggplotly(plot) %>% config(displayModeBar = FALSE)
        }
      })
      
    }
  )
}