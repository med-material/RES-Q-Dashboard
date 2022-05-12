library(tidyverse)
library(shiny)
library(plotly)
library(styler)
library(lintr)
library(shinylogs)

source("modules/scatterPlot.R", local = T)
source("modules/tabPages_Layout.R", local = T)

#If you want to have the logs folder prompted on application stop
#onStop(function() {
#  browseURL(url = "logs")
#})

ui <- navbarPage(
  "Res Q Dashboard",
  tabPanel(
    "Hospital Overview",
    tabPages(tab_id = "module_1", tab_df = mtcars)
  ),
  tabPanel(
    "Patient Profiles",
    tabPages(tab_id = "module_2", tab_df = iris)
  ),
  tabPanel(
    "Bleeding",
    tabPages(tab_id = "module_3", tab_df = ToothGrowth)
  ),
  tabPanel(
    "Imaging",
    tabPages(tab_id = "module_4", tab_df = PlantGrowth)
  ),
  tabPanel(
    "Treatment",
    tabPages(tab_id = "module_5", tab_df = USArrests)
  ),
  tabPanel("Phase One"),
  tabPanel("Discharge")
)

server <- function(input, output, session) {
  # Store JSON with logs in the logs dir
  track_usage(
    storage_mode = store_null()
  )
  
  scatterPlot_server(id = "module_1", mtcars)
  scatterPlot_server(id = "module_2", iris)
  scatterPlot_server(id = "module_3", ToothGrowth)
  scatterPlot_server(id = "module_4", PlantGrowth)
  scatterPlot_server(id = "module_5", USArrests)
}

shinyApp(ui = ui, server = server)
