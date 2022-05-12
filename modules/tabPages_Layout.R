tabPages <- function(tab_id, tab_df) {
  fluidPage(
    fluidRow(
      column(
        5,
        h1("Quality Indicators"),
        tags$hr(),
        tags$p("First Item in list"),
        tags$hr(),
        tags$p("Second Item"),
        tags$hr(),
        tags$p("Third Item"),
        tags$hr(),
        tags$p("Fourth Item"),
        tags$hr(),
        tags$p("Fifth Item"),
        tags$hr(),
        tags$p("Sixth Item")
      ),
      column(
        7,
        h1("Visualization"),
        tabsetPanel(type = "tabs",
                    tabPanel("Plot", scatterPlot_UI(id = tab_id, database = tab_df)),
                    tabPanel("Table", scatterPlot_Table(id = tab_id))
        )
      )
    )
  )
}

