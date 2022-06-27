rowmaker_UI <- function(id) {
  ns <- NS(id)
  fixedRow(
    column(2, h4(textOutput(ns("QIName")), align = "center")),
    column(1, h4(textOutput(ns("QIM1")), align = "center")),
    column(1, h4(textOutput(ns("QIM2")), align = "center")),
    column(4, plotOutput(ns("vis1"), width = "200px", height = "50"), align = "center"),
    column(3, plotOutput(ns("vis2"), width = "200px", height = "50"), align = "center"),
    column(1, align = "center", actionButton((ns("action")), label = NULL, icon = icon("play")))
  )
}

rowmaker <- function(id, QI) {
  moduleServer(
    id,
    function(input, output, session) {
      output$QIName <- renderText({
        QI
      })
      
      row_df <- dataHandlerQI(numVars, QI, "uggeebfixudwdhb", "vrprkigsxydwgni", "mean")
      
      output$QIM1 <- renderText({
        as.character(round(row_df$Value[4], 1))
      })

      output$QIM2 <- renderText({
        as.character(round(row_df$CValue[4], 1))
      })
      
      output$vis1 <- renderPlot({
        plot <- ggplot(row_df, aes(x = YQ, y = Value, group = 1)) + geom_point() + geom_line() +
        theme(axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.y = element_blank(),
              axis.text.y = element_blank(),
              axis.title.y = element_blank(),
              panel.grid.major = element_blank(), 
              panel.grid.minor = element_blank(),
              panel.background = element_blank())
        plot
      })
      
      output$vis2 <- renderPlot({
        plot <- ggplot(row_df, aes(x = YQ, y = Value, group = 1)) + geom_point() + geom_line() +
          theme(axis.ticks.x = element_blank(),
                axis.text.x = element_blank(),
                axis.title.x = element_blank(),
                axis.ticks.y = element_blank(),
                axis.text.y = element_blank(),
                axis.title.y = element_blank(),
                panel.grid.major = element_blank(), 
                panel.grid.minor = element_blank(),
                panel.background = element_blank())
        plot
      })
      
    }
  )
}
