QI_PO_UI <- function(id, database) {
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

QI_PO <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}