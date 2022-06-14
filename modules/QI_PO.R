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
    QI_rowmaker(id, "DECOM", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "CRTD.IMG", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "CRTD.I70", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "END.70", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "ANTP", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "INS", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "SCRN.DYS", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "PHSIO", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "PHSIO.T", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "SWLW", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "NO.IVT", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "AFIB", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "TEST.DYS", 50, 60, "V1.png", "p2")
  )
}

QI_PO <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}