rowmaker_Cat_UI <- function(id) {
  ns <- NS(id)
  fixedRow(
    column(2, h6(textOutput(ns("QIName")), align = "left")),
    column(9, plotlyOutput(ns("vis"), width = "600px", height = "80"), align = "center"),
    column(1, align = "center", actionButton((ns("action")), label = NULL, icon = icon("play")))
  )
}

rowmaker_Cat <- function(id, QI) {
  moduleServer(
    id,
    function(input, output, session) {
      output$QIName <- renderText({
        QI
      })
      
      row_df <- dataHandlerQI(catVars, QI, "uggeebfixudwdhb", "vrprkigsxydwgni", "cat")
      
      latest <- min(row_df$YQ)
      
      row_df <- row_df %>% filter(YQ == latest)
      row_df$alphascope <- as.factor(ifelse(row_df$Scope == "Country", 0.4, 1))
      
      output$vis <- renderPlotly({
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
      })
      
    }
  )
}