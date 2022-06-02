QI_HO_UI <- function(id, database) {
  ns <- NS(id)
  
  column(
    6,
    fixedRow(
      column(
        2,
        h4("QI", align = 'center', title = "hovertext")
      ),
      column(
        1,
        h4("Metric 1", align = 'center')
      ),
      column(
        1,
        h4("Metric 2", align = 'center')
      ),
      column(
        4,
        h4("Visual 1", align = 'center')
      ),
      column(
        3,
        h4("Visual 2", align = 'center')
      ),
      column(
        1,
        h4("More", align = 'center')
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

QI_HO <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}