library(shiny)
library(tidyverse)
library(plotly)

options(shiny.fullstacktrace = TRUE)

server <- function(input, output) {
  dataset = as_tibble(mtcars)
  dataScatter <- reactive({
    df <- dataset %>% select(input$x, input$y, input$color)
  })
  output$scatter <- renderPlotly({
    plot <- ggplot(data = dataScatter()) + geom_point(mapping = aes_string(x = input$x, y = input$y, color = input$color))
    if (input$choice_smooth == TRUE) {plot <- plot + geom_smooth(mapping = aes_string(x = input$x, y = input$y), se = FALSE)}
    #if (any(input$choices) == "choice_eb") {plot <- plot + geom}
    ggplotly(plot)
  })
  output$table <- renderDataTable(dataScatter(), options = list(pageLength = 5))
  
  dataDist <- reactive({
    df <- dataset %>% select(input$var_Distribution)
    df <- head(df, input$slider)
  })
  
  output$hist <- renderPlotly({
    data_dist = dataDist()
    p <- ggplot(data_dist, aes_string(input$var_Distribution)) + geom_histogram() + xlab("Number of Samples") + ylab("Frequency")
    ggplotly(p)
    })
  
}
