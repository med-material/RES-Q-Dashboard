rowmaker_Num_UI <- function(id, QI_title) {
  ns <- NS(id)
  
  fixedRow(
    column(2, h6(textOutput(ns("QIName")), title = QI_title, align = "left")),
    column(1, h6(textOutput(ns("QIM1")), align = "center")),
    column(1, h6(textOutput(ns("QIM2")), align = "center")),
    column(7, plotlyOutput(ns("vis"), width = "500px", height = "80px"), align = "center"),
    column(1, align = "center", actionButton((ns("action")), label = NULL, icon = icon("play")))
  )
}

rowmaker_Num <- function(id, QI, df) {
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
      title <- df$INDICATOR[index]
      #browser()
      
      output$title <- renderText({
        title
      })
      
      if (dataType == "Quantitative") {
        row_df <- dataHandlerQI(numVars, dataType, QI_col, hospital, country, aggType)
      }
      
      else {
        row_df <- dataHandlerQI(catVars, dataType, QI_col, hospital, country, aggType)
      }
      
      output$QIM1 <- renderText({
        as.character(round(row_df$Hospital[4], 1))
      })

      output$QIM2 <- renderText({
        as.character(round(row_df$Country[4], 1))
      })
      
      output$vis <- renderPlotly({
        
        plot_df <- row_df
        
        #Rounding numbers for the plot on mouse-over
        plot_df$Hospital <- round(plot_df$Hospital, 1)
        plot_df$Country <- round(plot_df$Country, 1)
        
        plot <- ggplot(plot_df, aes(x = YQ))  + 
        geom_point(aes(y = Country, group = 1), color = "gray") + geom_line(aes(y = Country, group = 1), color = "gray") + 
        geom_line(aes(y = Hospital, group = 1)) + geom_point(aes(y = Hospital, group = 1, color = Flag)) +
          
        #Set flag colors here  
        scale_color_manual(values = c("#005a80",
                                        "#ff7434",
                                        "#353436",
                                        "#02e302")) +
        #Set theme here
        theme(axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.y = element_blank(),
              axis.text.y = element_blank(),
              axis.title.y = element_blank(),
              panel.grid.major = element_blank(), 
              panel.grid.minor = element_blank(),
              panel.background = element_blank(),
              legend.position = "none")
        ggplotly(plot) %>% config(displayModeBar = FALSE)
      })
      
    }
  )
}
