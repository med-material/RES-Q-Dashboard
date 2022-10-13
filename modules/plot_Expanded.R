#This module takes as input its id as well as what database it should use for e.g column selection dropdowns etc.
plot_Expanded_UI <- function(id) {
  ns <- NS(id)
  
  #Storing the plot under this variable
   plot_UI <- tagList(
    plotlyOutput(
      outputId = ns("plot")
    )
   )

  #   #Define a row containing dropdown menus to select variables & tickboxes for more plot options.
  #   fixedRow(
  #     column(
  #       6,
  #       align = "center",
  #       selectInput(
  #         inputId = ns("selected_col"),
  #         label = "Select column",
  #         #By using choices = colnames(db) we give the user a choice of what variables to plot.
  #         #Can also use a subset of colnames if some variables should not be able to be chosen.
  #         choices = colnames(database),
  #         selected = colnames(database)[1]
  #       )
  #     ),
  #     column(
  #       6,
  #       align = "center",
  #       selectInput(
  #         inputId = ns("selected_col2"),
  #         label = "Select column",
  #         choices = colnames(database),
  #         selected = colnames(database)[2]
  #       )
  #     )
  #   ),
  #   fixedRow(
  #     column(
  #       6,
  #       align = "center",
  #       #Checkbox/tickbox definition.
  #       checkboxInput(
  #         inputId = ns("smooth_line"),
  #         label = "Add smoothing",
  #         value = FALSE
  #       )
  #     ),
  #     column(
  #       6,
  #       align = "center",
  #       #Checkbox/tickbox definition.
  #       checkboxInput(
  #         inputId = ns("comp_country"),
  #         label = "Show country mean",
  #         value = FALSE
  #       )
  #     )
  #   )
  # )
  # #Storing the datatable output under this variable
  # table_UI <- dataTableOutput(outputId = ns("table"))
  # 
  # #Here we select to output the plot and table under a tabsetPanel format, where the user can choose to look at either the plot or the underlying datatable
  # tabsetPanel(
  #   type = "tabs",
  #   tabPanel("Plot", plot_UI),
  #   tabPanel("Table", table_UI)
  #  )
}
  

plot_Expanded <- function(id, dataset, numericvars) {
  moduleServer(
    id,
    function(input, output, session) {

      browser()
      #inputBtn <- eventReactive(action_button())
      
      #Here we see the interactive plot. It selects from the database the chosen columns via input$variableName and generates a plot for it.
      expandPlot_obj <- reactive({
        plot <- ggplot(dataset, aes(x = numericvars$xvar()))  + 
                geom_line(aes(y = numericvars$yvar(), group = 1)) +
                geom_point(aes(y = numericvars$yvar(), group = 1, color = Flag)) +
                
                #Set flag colors here, there's one for every possible flag. 
                #As of now there is only one for Good (data is present) and Missing (data is missing). 
                #Potential flag ideas are best score this year, all time, etc where best needs to be defined as either highest = good or lowest = good.
                scale_color_manual(values = c("#005a80",
                                              "#ff7434",
                                              "#353436",
                                              "#02e302")) +
                #Set theme here
                theme(axis.ticks.x = element_blank(),
                      axis.text.x = element_blank(),
                      axis.title.x = element_blank(),
                      axis.ticks.y = element_blank(),
                      axis.text.y = element_blank(),
                      axis.title.y = element_blank(),
                      panel.grid.major = element_blank(), 
                      panel.grid.minor = element_blank(),
                      panel.background = element_blank(),
                      legend.position = "none") + 
                
        #Run plot and remove the on hover options for plotly
        
        return(plot)         
      
      #%>% config(displayModeBar = FALSE)
      })
      
      output$expandPlot <- renderPlot({
        expandPlot_obj()
    })
  })
}


# plot_Expanded <- function(id, database) {
#   moduleServer(
#     id,
#     function(input, output, session) {
#       
#       #Here we see the interactive plot. It selects from the database the chosen columns via input$variableName and generates a plot for it.
#       output$plot <- renderPlotly({
#         plot <- ggplot(database, aes(x = .data[[input$selected_col]], y = .data[[input$selected_col2]])) +
#           geom_point()
#         
#         #Checks if line smoothing has been selected by the user.
#         if (input$smooth_line == TRUE) {
#           plot <- plot + geom_smooth(se = FALSE)
#         }
#         ggplotly(plot)
#       })
#       
#       #This will define how the dataTable will look, here we chose a list pagelength of 5 and it takes it displays the chosen variables from the dropdown.
#       output$table <- DT::renderDataTable(database %>% select(input$selected_col, input$selected_col2), options = list(pageLength = 5))
#     }
#   )
# }
