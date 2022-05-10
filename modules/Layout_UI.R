Sidebar_Explorer <- function() {
  sidebarPanel(
    selectInput("x", "Choose your variable", c("Miles per gallon" = "mpg", "Number of Cylinders" = "cyl", "Displacement" = "disp", "Horsepower" = "hp", "Rear axle ratio" = "drat", "Weight (lb tons)" = "wt", "Quarter mile time" = "qsec", "Engine type" = "vs", "Transmission" = "am", "Number of gears" = "gear", "Number of carburetors" = "carb"), selected = "mpg"),
    selectInput("y", "Choose your variable", c("Miles per gallon" = "mpg", "Number of Cylinders" = "cyl", "Displacement" = "disp", "Horsepower" = "hp", "Rear axle ratio" = "drat", "Weight (lb tons)" = "wt", "Quarter mile time" = "qsec", "Engine type" = "vs", "Transmission" = "am", "Number of gears" = "gear", "Number of carburetors" = "carb"), selected = "cyl"),
    selectInput("color", "Choose the color variable", c("Miles per gallon" = "mpg", "Number of Cylinders" = "cyl", "Displacement" = "disp", "Horsepower" = "hp", "Rear axle ratio" = "drat", "Weight (lb tons)" = "wt", "Quarter mile time" = "qsec", "Engine type" = "vs", "Transmission" = "am", "Number of gears" = "gear", "Number of carburetors" = "carb"), selected = "disp"),
    checkboxInput(inputId = "choice_smooth", label = "Smoother line", value = FALSE),
    checkboxInput(inputId = "choice_eb", label = "Error Bars", value = FALSE)
  )
}

mainPanel_Explorer <- function() {
  mainPanel(  
    tabsetPanel(
      tabPanel("Plot", plotlyOutput("scatter")),
      tabPanel("Table", dataTableOutput("table"))
    )
  )
}

sidebar_Distribution <- function() {
  sidebarPanel(
    selectInput("var_Distribution", "Choose your variable", c("Miles per gallon" = "mpg", "Number of Cylinders" = "cyl", "Displacement" = "disp", "Horsepower" = "hp", "Rear axle ratio" = "drat", "Weight (lb tons)" = "wt", "Quarter mile time" = "qsec", "Engine type" = "vs", "Transmission" = "am", "Number of gears" = "gear", "Number of carburetors" = "carb"), selected = "mpg"),
    sliderInput(inputId = "slider", label = "Number of samples", min = 0, max = 32, value = 16)
  )
}

mainpanel_Distribution <- function() {
  mainPanel(plotlyOutput("hist"))
}