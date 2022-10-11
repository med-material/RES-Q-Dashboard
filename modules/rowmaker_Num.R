#Here we see why we passed the full QI indicator name, it's to pass it as a parameter so that on hover you will see the full indicator name for each QI.
rowmaker_Num_UI <- function(id, QI_title) {
  ns <- NS(id)
  
  #The aligning can be changed via here as well as the visualisation size.
  fixedRow(
    column(2, h6(textOutput(ns("QIName")), title = QI_title, align = "left")),
    column(7, plotlyOutput(ns("vis"), width = "500px", height = "100px"), align = "center"),
    column(1, h6(textOutput(ns("QIM1")), align = "center")),
    column(1, h6(textOutput(ns("QIM2")), align = "center")),
    #The below column produces the buttons under the "More" column, these have no functionality yet but are supposed to connect the QI section to the expanded view.
    column(1, align = "center", actionButton((ns("action")), label = NULL, icon = icon("play")))
  )
}

rowmaker_Num <- function(id, QI, df) {
  moduleServer(
    id,
    function(input, output, session) {
      #Rendering the QI name
      output$QIName <- renderText({
        QI
      })
      
      #Generating the values that need to be passed to dataHandlerQI
      #index: at what QI row are we looking at
      index <- match(QI, df$INDICATOR)
      dataType <- df$ATTRIBUTE_TYPE[index]
      QI_col <- df$COLUMN[index]
      aggType <- df$SUMMARIZE_BY[index]
      
      #For these two fields, I assigned hand-picked hospital with its matching country from the anonymised hospital data. 
      #Feel free to pick another hospital and country combination that might be interesting.
      hospital <- "uggeebfixudwdhb"
      country <- "vrprkigsxydwgni"
      

      
      #If you want to see the values of these fields when running the app, un-comment the line below. It will stop run-time there.
      #browser()
      
      if (dataType == "Quantitative") {
        row_df <- dataHandlerQI(numVars, dataType, QI_col, hospital, country, aggType)
      }
      
      else {
        row_df <- dataHandlerQI(catVars, dataType, QI_col, hospital, country, aggType)
      }
      
      output$QIM1 <- renderText({
        if (dataType != "Quantitative" & aggType == "%") {
          #For binary categorical data with % aggType, the output is always a percentage so this adds the percentage sign to the metrics.
          paste(as.character(round(row_df$Hospital[4], 1)),"%", sep = "")
        }
        
        else {
          #This selects the latest hospital entree for the QI. It uses [4] as the scope for the QI section is last 4 quarters.
          #Can be changed to a dynamic variable depending on user interaction (they might be interested in last 6,8,10 quarters)
          as.character(round(row_df$Hospital[4], 1))
        }
      })

      output$QIM2 <- renderText({
        if (dataType != "Quantitative" & aggType == "%") {
          paste(as.character(round(row_df$Country[4], 1)),"%", sep = "")
        }
        
        else {
          as.character(round(row_df$Country[4], 1))
        }
      })
      
      
      ### CHANGE CODE BELOW TO CHANGE THE VISUALISATIONS IN THE TRENDLINE QI SECTION
      output$vis <- renderPlotly({
        
        plot_df <- row_df
        
        #Rounding numbers for the plot on mouse-over
        plot_df$Hospital <- round(plot_df$Hospital, 1)
        plot_df$Country <- round(plot_df$Country, 1)
        
        #Define the plot using ggplot
        plot <- ggplot(plot_df, aes(x = YQ))  + 
        geom_point(aes(y = Country, group = 1), color = "gray") + geom_line(aes(y = Country, group = 1), color = "gray") + 
        geom_line(aes(y = Hospital, group = 1)) + geom_point(aes(y = Hospital, group = 1, color = Flag)) +
          
        #Set flag colors here, there should be one for every possible flag. 
        #As of now there is only one for Good (data is present) and Missing (data is missing). 
        #Potential flag ideas are best score this year, all time, etc where best needs to be defined as either highest = good or lowest = good.
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
        
        #Remove the plotly on hover options
        ggplotly(plot) %>% config(displayModeBar = FALSE)
      })
    }
  )
}
