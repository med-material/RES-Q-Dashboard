library(tidyverse)
library(shiny)
library(plotly)
library(styler)
library(lintr)
library(shinylogs)
library(DT)
library(shinydashboard)
library(ggforce)
library(bslib)


#Structure
source("modules/dashboard_Structure.R", local = T)

#Pages
source("modules/page_HO.R", local = T)
source("modules/page_PC.R", local = T)
source("modules/page_Generic.R", local = T)

#Utils
source("utils/datawrangling.R", local = T)
source("utils/dataHandlerQI.R", local = T)
source("utils/dataLoader.R", local = T)

#Element modules
source("modules/plot_Expanded.R", local = T)
source("modules/QI_Section_Num.R", local = T)
source("modules/QI_Section_Cat.R", local = T)
source("modules/rowmaker_Num.R", local = T)
source("modules/rowmaker_Cat.R", local = T)

#If you want to have the logs folder prompted on application stop
#onStop(function() {
#  browseURL(url = "logs")
#})

#db <- dataLoader()

ui <- fluidPage(theme = bs_theme(version = 4, bootswatch = "minty"),
  dashboard_Structure_UI("Dashboard")
)

server <- function(input, output, session) {
  # Store JSON with logs in the logs dir
  track_usage(
    storage_mode = store_null()
  )
  
  dashboard_Structure("Dashboard")
  db <- dataLoader()
  numVars <- db$numVars
  catVars <- db$catVars
}

shinyApp(ui = ui, server = server)
