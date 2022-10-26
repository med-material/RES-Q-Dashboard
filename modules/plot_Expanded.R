# This module takes as input its id as well as what database it should use for e.g column selection dropdowns etc.
plot_Expanded_UI <- function(id, database) {
  ns <- NS(id)

  # Storing the plot under this variable
  plot_UI <- tagList(
    plotlyOutput(
      outputId = ns("plot")
    ),

    # Define a row containing dropdown menus to select variables & tickboxes for more plot options.

    fixedRow(
      column(
        6,
        align = "center",
        # Checkbox/tickbox definition.
        checkboxInput(
          inputId = ns("smooth_line"),
          label = "Add smoothing",
          value = FALSE
         )
       ),
       column(
         6,
         align = "center",
         # Checkbox/tickbox definition.
         checkboxInput(
           inputId = ns("comp_country"),
           label = "Show country mean",
           value = FALSE
         )
       )
     )
   )
#   # Storing the datatable output under this variable
   table_UI <- dataTableOutput(outputId = ns("table"))
# 
#   # Here we select to output the plot and table under a tabsetPanel format, where the user can choose to look at either the plot or the underlying datatable
   tabsetPanel(
     type = "tabs",
     tabPanel("Plot", plot_UI),
     tabPanel("Table", table_UI)
   )
 }
# 
 plot_Expanded <- function(id, QI) {
   moduleServer(
     id,
     function(input, output, session) {
       
       #validate(need(df(), "Waiting for data..."), errorClass = character(0))
       #QI_data <- df
       #browser()
#       # Here we see the interactive plot. It selects from the database the chosen columns via input$variableName and generates a plot for it.
       output$plot <- renderPlotly({
         if(!is.null(QI_name())) {
         QI_data <- numVars %>% filter(QI == QI_name()) %>% na.omit()

         #plot <- ggplot(database, aes(x = .data[[input$selected_col]], y = .data[[input$selected_col2]])) +
         #geom_point()
         plot <- ggplot(QI_data, aes(x = YQ)) +
           geom_point(aes(y = Value, group = 1)) +
# 
#         # Checks if line smoothing has been selected by the user.
         if (input$smooth_line == TRUE) {
           plot <- plot + geom_smooth(se = FALSE)
         }
         ggplotly(plot)
         }
       })
      
# 
#       # This will define how the dataTable will look, here we chose a list pagelength of 5 and it takes it displays the chosen variables from the dropdown.
       #output$table <- DT::renderDataTable(QI_data %>% select(YQ, Value), options = list(pageLength = 5))
        
     }
   )
 }
