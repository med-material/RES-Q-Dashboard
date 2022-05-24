QI_Layout_HO <- function(id, database) {
  ns <- NS(id)
  
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    tags$hr(),
    QI_rowmaker(id, "DTN", 100, 55, "DTN_vis1", "DTN_vis2"),
    tags$hr(),
    QI_rowmaker(id, "IVT", 314, 2.79, "plot3", "plot4")
    # fixedRow(
    #   plotlyOutput(
    #   outputId = ns("DTN_vis1")
    #   )
    # )
  )
}

QI_Layout_PC <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    QI_rowmaker(id, "Age", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "Gender", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "NIHSS", 50, 60, "p1", "p2")
  )
}

QI_Layout_Bleeding <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    QI_rowmaker(id, "QI1", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI2", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI3", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI4", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI5", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI6", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI7", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI8", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI9", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI10", 50, 60, "p1", "p2")
  )
}

QI_Layout_Imaging <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    QI_rowmaker(id, "QI1", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI2", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI3", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI4", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI5", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI6", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI7", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI8", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI9", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI10", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI11", 50, 60, "p1", "p2")
  )
}

QI_Layout_Treatment <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    QI_rowmaker(id, "QI1", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI2", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI3", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI4", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI5", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI6", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI7", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI8", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI9", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI10", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI11", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI12", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI13", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI14", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI15", 50, 60, "p1", "p2")
  )
}


QI_Layout_PO <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    QI_rowmaker(id, "QI1", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI2", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI3", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI4", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI5", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI6", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI7", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI8", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI9", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI10", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI11", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI12", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI13", 50, 60, "p1", "p2")
  )
}

QI_Layout_Discharge <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    h1("Quality Indicators", align = 'center'),
    fixedRow(
      column(
        2,
        h3("QI", align = 'center')
      ),
      column(
        2,
        h3("Metric 1", align = 'center')
      ),
      column(
        2,
        h3("Metric 2", align = 'center')
      ),
      column(
        3,
        h3("Visual 1", align = 'center')
      ),
      column(
        3,
        h3("Visual 2", align = 'center')
      )
    ),
    QI_rowmaker(id, "QI1", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI2", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI3", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI4", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI5", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI6", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI7", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI8", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI9", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI10", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI11", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI12", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI13", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI14", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI15", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI16", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI17", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI18", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI19", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI20", 50, 60, "p1", "p2"),
    QI_rowmaker(id, "QI21", 50, 60, "p1", "p2")
  )
}

QI_rowmaker <- function(id, QI, m1, m2, v1id, v2id) {
  ns <- NS(id)

  fixedRow(
    column(
      2,
      h4(QI, align = 'center')
    ),
    column(
      2,
      h4(as.character(m1), align = 'center')
    ),
    column(
      2,
      h4(as.character(m2), align = 'center')
    ),
    column(
      3,
      align = 'center',
      h6("+30"),
      tags$img(src = "testplot.png", width = "100px", height = "30px"),
    ),
    column(
      3,
      align = 'center'
          # plotlyOutput(
          #   outputId = ns(v1id)
          # )
    )
  )
}

QI_server <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
      output$DTN_vis1 <- renderPlotly({
        plot <- ggplot(database, aes(x = x, y = y)) + geom_point(size = 2, color = "blue") + geom_line(size = 1) +  
          theme(plot.margin=unit(c(20,20,20,20), 'pt'), axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.text.y = element_blank(),
                axis.ticks.y = element_blank(),  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                panel.background = element_blank(), axis.line = element_blank(), axis.title.x = element_blank(),
                axis.title.y = element_blank()) + annotate("text", x = 5.5, y = 3, color = "green", label = "+30", size = 2) #+ 
          #(aes(x0 = 2, y0 = 2, r = 3, fill = "green"), inherit.aes = FALSE) + coord_fixed()
        plot <- ggplotly(plot) %>% config(displayModeBar = FALSE)
        plot
      })
      
      output$DTN_vis2 <- renderPlotly({
        fig <- plot_ly(
          type = "indicator",
          mode = "number+gauge+delta",
          value = 220,
          domain = list(x = c(0, 1), y= c(0, 1)),
          delta = list(reference = 200),
          gauge = list(
            shape = "bullet",
            axis = list(range = list(NULL, 300)),
            threshold = list(
              line = list(color = "red", width = 2),
              thickness = 0.75,
              value = 280),
            steps = list(
              list(range = c(0, 150), color = "lightgray"),
              list(range = c(150, 250), color = "gray"))),
          height = 150, width = 600) 
        fig <- fig %>%
           layout(margin = list(l= 100, r= 10))
        fig <- fig %>%
          config(displayModeBar = FALSE)
        fig
      })
      
    }
  )
}


