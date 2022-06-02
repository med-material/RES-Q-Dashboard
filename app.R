library(tidyverse)
library(shiny)
library(plotly)
library(styler)
library(lintr)
library(shinylogs)
library(DT)
library(shinydashboard)
library(ggforce)

#Pages
source("modules/page_HO.R", local = T)
source("modules/page_PC.R", local = T)
source("modules/page_Bleeding.R", local = T)
source("modules/page_Imaging.R", local = T)
source("modules/page_Treatment.R", local = T)
source("modules/page_PO.R", local = T)
source("modules/page_Discharge.R", local = T)

#Utils
source("utils/rowmaker.R", local = T)

#Element modules
source("modules/plot_Visualization.R", local = T)
source("modules/QI_HO.R", local = T)
source("modules/QI_PC.R", local = T)
source("modules/QI_Bleeding.R", local = T)
source("modules/QI_Imaging.R", local = T)
source("modules/QI_Treatment.R", local = T)
source("modules/QI_PO.R", local = T)
source("modules/QI_Discharge.R", local = T)


#If you want to have the logs folder prompted on application stop
#onStop(function() {
#  browseURL(url = "logs")
#})

ui <- navbarPage(
  "Res Q Dashboard",
  tabPanel(
    "Hospital Overview",
    page_HO(id = "HO", df = mtcars)
  ),
  tabPanel(
    "Patient Profiles",
    page_PC(id = "PC", df = iris)
  ),
  tabPanel(
    "Bleeding",
    page_Bleeding(id = "Bleeding", df = ToothGrowth)
  ),
  tabPanel(
    "Imaging",
    page_Imaging(id = "Imaging", df = PlantGrowth)
  ),
  tabPanel(
    "Treatment",
    page_Treatment(id = "Treatment", df = USArrests)
  ),
  tabPanel(
    "Phase One",
    page_PO(id = "PO", df = swiss)
  ),
  tabPanel(
    "Discharge",
    page_Discharge(id = "Discharge", df = iris)
  )
)

server <- function(input, output, session) {
  # Store JSON with logs in the logs dir
  track_usage(
    storage_mode = store_null()
  )
  
  plot_Visualization(id = "HO", mtcars)
  plot_Visualization(id = "PC", iris)
  plot_Visualization(id = "Bleeding", ToothGrowth)
  plot_Visualization(id = "Imaging", PlantGrowth)
  plot_Visualization(id = "Treatment", USArrests)
  plot_Visualization(id = "PO", swiss)
  plot_Visualization(id = "Discharge", iris)
  
  df_col1 = c(1,2,3,4,5)
  df_col2 = c(1,3,5,3,4)
  df = data.frame(df_col1, df_col2)
  colnames(df) <- c("x", "y")
  
  QI_HO(id = "HO", df)
  QI_PC(id = "PC", df)
  QI_Bleeding(id = "Bleeding", df)
  QI_Imaging(id = "Imaging", df)
  QI_Treatment(id = "Treatment", df)
  QI_PO(id = "PO", df)
  QI_Discharge(id = "Discharge", df)
  
}

shinyApp(ui = ui, server = server)
