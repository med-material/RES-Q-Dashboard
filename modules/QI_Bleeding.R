QI_Bleeding_UI <- function(id, database) {
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
    QI_rowmaker(id, "ICH.V", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "INF.BLD", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "SRC.F", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "ICH.S", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "INT.BLD", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "ICH.NS", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "SAH.NS", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "BLD.C", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "ICH.DVT", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "HH", 50, 60, "V1.png", "p2")
  )
}

QI_Bleeding <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}