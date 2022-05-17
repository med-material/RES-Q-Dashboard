library(tidyverse)
library(shiny)
library(plotly)
library(styler)
library(lintr)
library(shinylogs)
library(DT)
library(shinydashboard)
library(sparkline)
library(htmlwidgets)

source("modules/Visualization.R", local = T)
source("modules/tabPages_Layout.R", local = T)
source("modules/QI.R", local = T)

#If you want to have the logs folder prompted on application stop
#onStop(function() {
#  browseURL(url = "logs")
#})

ui <- navbarPage(
  "Res Q Dashboard",
  tabPanel(
    "Hospital Overview",
    tabPages(tab_id = "tab1", tab_df = mtcars)
  ),
  tabPanel(
    "Patient Profiles",
    tabPages(tab_id = "tab2", tab_df = iris)
  ),
  tabPanel(
    "Bleeding",
    tabPages(tab_id = "tab3", tab_df = ToothGrowth)
  ),
  tabPanel(
    "Imaging",
    tabPages(tab_id = "tab4", tab_df = PlantGrowth)
  ),
  tabPanel(
    "Treatment",
    tabPages(tab_id = "tab5", tab_df = USArrests)
  ),
  tabPanel("Phase One"),
  tabPanel("Discharge")
)

server <- function(input, output, session) {
  # Store JSON with logs in the logs dir
  track_usage(
    storage_mode = store_null()
  )
  
  scatterPlot_server(id = "tab1", mtcars)
  scatterPlot_server(id = "tab2", iris)
  scatterPlot_server(id = "tab3", ToothGrowth)
  scatterPlot_server(id = "tab4", PlantGrowth)
  scatterPlot_server(id = "tab5", USArrests)
  
  df_col1 = c(1)
  df_col2 = c(2)
  df = data.frame(df_col1, df_col2)
  
  QI_server(id = "tab1", df)
  QI_server(id = "tab2", df)
  QI_server(id = "tab3", df)
  QI_server(id = "tab4", df)
  QI_server(id = "tab5", df)
  
}

shinyApp(ui = ui, server = server)
