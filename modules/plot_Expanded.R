plot_Expanded_UI <- function(id, database) {
  ns <- NS(id)

  plot_UI <- tagList(
    plotlyOutput(
      outputId = ns("plot")
    ),
    fixedRow(
      column(
        6,
        align = "center",
        selectInput(
          inputId = ns("selected_col"),
          label = "Select column",
          choices = colnames(database),
          selected = colnames(database)[1]
        )
      ),
      column(
        6,
        align = "center",
        selectInput(
          inputId = ns("selected_col2"),
          label = "Select column",
          choices = colnames(database),
          selected = colnames(database)[2]
        )
      )
    ),
    fixedRow(
      column(
        6,
        align = "center",
        checkboxInput(
          inputId = ns("smooth_line"),
          label = "Add smoothing",
          value = FALSE
        )
      ),
      column(
        6,
        align = "center",
        checkboxInput(
          inputId = ns("comp_country"),
          label = "Show country mean",
          value = FALSE
        )
      )
    )
  )

  table_UI <- dataTableOutput(outputId = ns("table"))

  column(
    6,
    tabsetPanel(
      type = "tabs",
      tabPanel("Plot", plot_UI),
      tabPanel("Table", table_UI)
    )
  )
}

plot_Expanded <- function(id, database) {
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
