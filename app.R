library(tidyverse)
library(shiny)
library(plotly)
library(styler)
library(lintr)
library(shinylogs)

source("modules/scatterPlot.R", local = T)

#If you want to have the logs folder prompted on application stop
onStop(function() {
  browseURL(url = "logs/")
})

ui <- navbarPage(
  "Res Q Dashboard",
  tabPanel(
    "Hospital Overview",
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
                      tabPanel("Plot", scatterPlot_UI(id = "module_1", database = mtcars)),
                      tabPanel("Table", scatterPlot_Table(id = "module_1"))
          )
        )
      )
    )
  ),
  tabPanel("Patient Profiles"),
  tabPanel("Bleeding"),
  tabPanel("Imaging"),
  tabPanel("Treatment"),
  tabPanel("Phase One"),
  tabPanel("Discharge")
)

server <- function(input, output, session) {
  # Store JSON with logs in the logs dir
  track_usage(
    storage_mode = store_json(path = "logs/")
  )
  
  scatterPlot_server(id = "module_1", mtcars)
}

shinyApp(ui = ui, server = server)
