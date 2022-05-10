library(shiny)
library(tidyverse)
library(plotly)

options(shiny.fullstacktrace = TRUE)

source("modules/Layout_UI.R", local = T)

ui <- fluidPage(
  fluidRow(
  titlePanel("Car data visualisation app"),
  #Primary Side Panel layout
  Sidebar_Explorer(),
  
  #Primary Main panel layout,
  mainPanel_Explorer()
  ),
  
  tags$hr(),
  
  #Secondary panel showing distribution per chosen variable
  fluidRow(
  titlePanel("Variable distribution visualisation"),
  sidebar_Distribution(),
  mainpanel_Distribution()
  )
)