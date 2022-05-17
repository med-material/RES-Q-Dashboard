visualization_Layout <- function(id, database) {
  column(
    7,
    h1("Visualization"),
    tabsetPanel(type = "tabs",
                tabPanel("Plot", scatterPlot_UI(id, database)),
                tabPanel("Table", scatterPlot_Table(id))
    )
  )
}

scatterPlot_UI <- function(id, database) {
  ns <- NS(id)

  tagList(
    plotlyOutput(
      outputId = ns("plot")
    ),
    selectInput(
      inputId = ns("selected_col"),
      label = "Select column",
      choices = colnames(database),
      selected = colnames(database)[1]
    ),
    selectInput(
      inputId = ns("selected_col2"),
      label = "Select column",
      choices = colnames(database),
      selected = colnames(database)[2]
    ),
    checkboxInput(
      inputId = ns("smooth_line"),
      label = "Add smoothing",
      value = FALSE
    ),
    checkboxInput(
      inputId = ns("comp_country"),
      label = "Show country mean",
      value = FALSE
    )
  )
}

scatterPlot_Table <- function(id) {
  ns <- NS(id)
  dataTableOutput(
    outputId = ns("table")
  )
}

scatterPlot_server <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
      output$plot <- renderPlotly({
        plot <- ggplot(database, aes(x = .data[[input$selected_col]], y = .data[[input$selected_col2]])) +
          geom_point()
        if (input$smooth_line == TRUE) {
          plot <- plot + geom_smooth(se = FALSE)
        }
        ggplotly(plot)
      })
      output$table <- DT::renderDataTable(database %>% select(input$selected_col, input$selected_col2), options = list(pageLength = 5))
    }
  )
}
